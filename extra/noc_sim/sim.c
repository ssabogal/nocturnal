#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>

#define LEN_WRD 4                             /* bytes per word */
#define LEN_HDR (LEN_WRD * 3)                 /* bytes per header */
#define LEN_PKT (LEN_WRD * 8)                 /* bytes per packet */
#define NOD_X   3                             /* nodes x-axis */
#define NOD_Y   3                             /* nodes y-axis */
#define MAX_PKT 8                             /* packets per transaction */
#define MAX_INP 100                           /* max inputs */
#define MAX_MEM 128                           /* bytes per node */
#define MAX_NOD (NOD_X * NOD_Y)               /* max nodes */
#define MAX_FIFO 8                            /* packets per fifo */
#define MAX_ADD (MAX_NOD * MAX_MEM)           /* maximum address */
#define MAX_DAT (MAX_PKT * LEN_PKT - LEN_HDR) /* bytes per transaction */

#define NODE(x) ((x) / MAX_MEM)

#define OP_RQ '<'
#define OP_RS '='
#define OP_W  '>'
struct operation {
	char op;
	size_t time, src, dst, len;
	char buf[MAX_DAT];
};

#define RIGHT  0
#define UP     1
#define LEFT   2
#define DOWN   3
#define CENTER 4

static struct operation inputs[MAX_INP];
static size_t nr_inputs;

static size_t time;
static char data[MAX_ADD];

struct node {
	struct fifo {
		int neighbor;
		struct operation *outop, *inop;
		size_t outpass, inpass;
	} fifo[5];
};

static struct node nodes[MAX_NOD];

static int xy_route(int src, int dst)
{
	int dx = dst % NOD_X, dy = dst / NOD_X;
	int sx = src % NOD_X, sy = src / NOD_X;

	if (sx < dx)      return RIGHT;
	else if (sx > dx) return LEFT;
	else if (sy < dy) return UP;
	else if (sy > dy) return DOWN;
	else              return CENTER;
}

static int opposite(int dir)
{
	return CENTER == dir ? CENTER : (dir + 2) % 4;
}

static void logop(const char *s, struct operation *op)
{
	printf("%-4zu%s %zu\n", time, s, (size_t)(op - inputs));
}

static void sim_op(struct operation *op)
{
	logop("processed", op);
	switch (op->op) {
	case OP_RQ:
		memcpy(op->buf, data + op->dst, op->len);
		op->op = OP_RS;
		op->dst = op->src;
		op->time = time + 1;
		break;
	case OP_RS:
	case OP_W:
		memcpy(data + op->dst, op->buf, op->len);
		break;
	}
}

static void sim_node(int this)
{
	struct node *nd = nodes + this;

	for (size_t i = 0; i < 5; i++) {
		struct fifo *ff = nd->fifo + i;
		if (ff->inop) {
			struct fifo *fi = ff;
			struct fifo *fo = nd->fifo + xy_route(this, NODE(fi->inop->dst));
			if (!fi->inpass) {
				if (!fo->outop) {
					fo->outop = fi->inop;
					fi->inpass += LEN_HDR;
				}
			} else {
				fi->inpass += LEN_PKT;
				if (fi->inpass >= LEN_HDR + fi->inop->len) {
					logop("intake", fi->inop);
					fi->inop = 0;
					fi->inpass = 0;
				}
			}
		}
		if (ff->outop) {
			struct fifo *fo = ff;
			if (CENTER == i) {
				fo->outpass += LEN_PKT;
				if (fo->outpass >= LEN_HDR + fo->outop->len) {
					sim_op(fo->outop);
					fo->outop = 0;
					fo->outpass = 0;
				}
				continue;
			}
			struct fifo *fi = (nodes + ff->neighbor)->fifo + opposite(i);
			if (!fo->outpass) {
				if (!fi->inop) {
					fi->inop = fo->outop;
					fo->outpass += LEN_HDR;
				}
			} else {
				fo->outpass += LEN_PKT;
				if (fo->outpass >= LEN_HDR + fo->outop->len) {
					logop("outtake", fo->outop);
					fo->outop = 0;
					fo->outpass = 0;
				}
			}
		}
	}

	for (size_t i = 0; i < nr_inputs; i++) {
		struct operation *inp = inputs + i;
		if (inp->time != time || NODE(inp->src) != this)
			continue;
		struct fifo *ff = nd->fifo + CENTER;
		if (ff->inop) {
			inp->time++;
			continue;
		}
		ff->inop = inp;
		logop("begin", inp);
	}
}

static void sim()
{
	puts("Simulation Dump");
	for (; time < 100; time++)
		for (size_t j = 0; j < MAX_NOD; j++)
			sim_node(j);
}

static void init_node()
{
	for (size_t i = 0; i < MAX_NOD; i++) {
		struct node *nd = nodes + i;
		int x = i % NOD_X, y = i / NOD_X;
		nd->fifo[RIGHT].neighbor = (y + 0) * NOD_X + (x + 1);
		nd->fifo[UP].neighbor    = (y + 1) * NOD_X + (x + 0);
		nd->fifo[LEFT].neighbor  = (y + 0) * NOD_X + (x - 1);
		nd->fifo[DOWN].neighbor  = (y - 1) * NOD_X + (x + 0);
		nd->fifo[CENTER].neighbor= i;
	}
}

static void debug_output()
{
#define MAX_DISP 32
	puts("Memory Dump");
	for (size_t i = 0; i < MAX_NOD; i++) {
		struct node *n = nodes + i;
		for (size_t j = 0; j < MAX_MEM / MAX_DISP; j++) {
			size_t off = j * MAX_DISP + i * MAX_MEM;
			printf("%-2zu: %#-8zx", i, off);
			for (size_t k = 0; k < MAX_DISP; k++) {
				char c = data[k + off];
				printf("%c", c ? c : '_');
			}
			putchar('\n');
		}
	}
#undef MAX_DISP
}

static void debug_input()
{
	puts("Input Dump");
	for (size_t i = 0; i < nr_inputs; i++) {
		struct operation *inp = inputs + i;
		printf("%zu %zu %c %zu %zu:%.*s\n", inp->time, inp->src, inp->op, inp->dst, inp->len, (int)inp->len, inp->buf);
	}
}

static void init_input(const char *path)
{
	size_t line = 1;

	const char *msg = "missing fields";
	FILE *in = fopen(path, "r");
	if (!in) {
		msg = strerror(errno);
		goto err;
	}

	for (;; line++) {
		if (nr_inputs == MAX_INP) {
			msg = "too many operations";
			goto err;
		}

		struct operation *inp = inputs + nr_inputs;

		int r = fscanf(in, "%zu %zu %c %zu :", &inp->time, &inp->src, &inp->op, &inp->dst);
		if (EOF == r)
			break;
		if (r < 3)
			goto err;

		switch (inp->op) {
		case OP_RQ:
			if (fscanf(in, "%zu\n", &inp->len) != 1)
				goto err;
			break;
		case OP_W:
			if (fgets(inp->buf, sizeof inp->buf, in) != inp->buf)
				goto err;
			inp->len = strlen(inp->buf) - 1;
			inp->buf[inp->len] = 0;
			break;
		default:
			msg = "invalid operation";
			goto err;
		}

		if (NODE(inp->dst) >= MAX_NOD || NODE(inp->src) >= MAX_NOD) {
			msg = "node does not exist";
			goto err;
		}
		if (inp->len >= MAX_DAT) {
			msg = "data size is too large";
			goto err;
		}

		nr_inputs++;
	}

	fclose(in);
	return;
err:
	fprintf(stderr, "error: %s:%zu: %s\n", path, line, msg);
	exit(1);
}

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s FILE\n", *argv);
		return 1;
	}

	init_input(argv[1]);
	debug_input();
	init_node();
	sim();
	debug_output();
}
