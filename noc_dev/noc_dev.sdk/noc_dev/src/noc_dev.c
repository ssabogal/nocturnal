#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include "sleep.h"
#include "nic.h"
#include "xparameters.h"
#include "xtime_l.h"

#ifdef NDEBUG
#	error "assertions are disabled"
#endif

#define LEN(a) (sizeof a / sizeof*a)

struct nic *nics[3][3] = {
	{ (struct nic *)XPAR_AXI_NIC_00_BASEADDR, (struct nic *)XPAR_AXI_NIC_01_BASEADDR, (struct nic *)XPAR_AXI_NIC_02_BASEADDR },
	{ (struct nic *)XPAR_AXI_NIC_10_BASEADDR, (struct nic *)XPAR_AXI_NIC_11_BASEADDR, (struct nic *)XPAR_AXI_NIC_12_BASEADDR },
	{ (struct nic *)XPAR_AXI_NIC_20_BASEADDR, (struct nic *)XPAR_AXI_NIC_21_BASEADDR, (struct nic *)XPAR_AXI_NIC_22_BASEADDR }
};

void t0(size_t pkts, size_t n)
{
	XTime time;
	size_t x, y, i, k;
	uint32_t buf[3+n];

	if (pkts*LEN(buf) > NIC_FIFO_SIZE)
		return;

	printf("0,%zu,%zu,", pkts, n);

	for (i=0; i<pkts; i++)
		for (x=0; x<3; x++)
			for (y=0; y<3; y++) {
				buf[0+0] = ADDR((x+1)%3,(y+1)%3);
				buf[0+1] = ADDR(x,y);
				buf[0+2] = LEN(buf);
				for (k=0; k<n; k++)
					buf[3+k] = i;
				nic_send(nics[x][y], buf, LEN(buf));
			}

	for (i=0; i<9; i++)
			nic_flush(nics[i/3][i%3]);
	XTime_SetTime(0);

retry:
	for (x=0; x<3; x++)
		for (y=0; y<3; y++)
			if (nics[x][y]->rx_count != pkts*LEN(buf))
				goto retry;

	XTime_GetTime(&time);

	for (x=0; x<3; x++)
		for (y=0; y<3; y++)
			for (i=0; i<pkts; i++) {
				nic_recv(nics[x][y], buf, LEN(buf));
				assert(buf[2] == LEN(buf) && "bad size");
				for (k=0; k<n; k++)
					assert(buf[3+k] == i && "bad order");
			}

	for (i=0; i<9; i++)
			assert(!nics[i/3][i%3]->rx_count && "rx fifos not empty");

	printf("%f;\n", (double)time*1000/COUNTS_PER_SECOND);
}

void t1(size_t pkts, size_t n)
{
	XTime time;
	size_t h, i, j, k;
	uint32_t buf[3+n];
	struct nic *nic;

	if (n%2 || 9*pkts*LEN(buf) > NIC_FIFO_SIZE)
		return;

	printf("1,%zu,%zu,", pkts, n);

	XTime_SetTime(0);

	for (h=0; h<pkts; h++)
		for (i=0; i<9; i++)
			for (j=0; j<9; j++) {
				nic = nics[i/3][i%3];
				buf[0+0] = ADDR(j/3,j%3);
				buf[0+1] = ADDR(i/3,i%3);
				buf[0+2] = LEN(buf);
				for (k=0; k<n; k+=2) {
					buf[3+k+0] = j + k;
					buf[3+k+1] = i + k;
				}
				nic_send(nic, buf, LEN(buf));
			}

	for (i=0; i<9; i++)
		nic_flush(nics[i/3][i%3]);
	XTime_SetTime(0);

retry:
	for (i=0; i<9; i++)
		if (nics[i/3][i%3]->rx_count != 9*pkts*LEN(buf))
			goto retry;

	XTime_GetTime(&time);

	for (i=0; i<9; i++)
		for (j=0; j<9; j++)
			for (h=0; h<pkts; h++) {
				nic_recv(nics[i/3][i%3], buf, LEN(buf));
				assert(buf[2] == LEN(buf) && "bad size");
				assert(X(buf[0]) == buf[3+0]/3 && Y(buf[0]) == buf[3+0]%3 && "bad destination");
				assert(X(buf[1]) == buf[3+1]/3 && Y(buf[1]) == buf[3+1]%3 && "bad source");
				for (k=2; k<n; k+=2) {
					assert(buf[3+k+0] == buf[3+0] + k && "bad data");
					assert(buf[3+k+1] == buf[3+1] + k && "bad data");
				}
			}

	for (i=0; i<9; i++)
			assert(!nics[i/3][i%3]->rx_count && "rx fifos not empty");

	printf("%f;\n", (double)time*1000/COUNTS_PER_SECOND);
}


void t2(size_t pkts, size_t n)
{
	XTime time;
	size_t i, k;
	uint32_t buf[3+n];

	if (pkts*LEN(buf) > NIC_FIFO_SIZE)
		return;

	printf("2,%zu,%zu,", pkts, n);

	for (i=0; i<pkts; i++) {
		buf[0+0] = ADDR(2,2);
		buf[0+1] = ADDR(0,0);
		buf[0+2] = LEN(buf);
		for (k=0; k<n; k++)
			buf[3+k] = i;
		nic_send(nics[0][0], buf, LEN(buf));
	}

	nic_flush(nics[0][0]);
	XTime_SetTime(0);

	while (nics[2][2]->rx_count != pkts*LEN(buf));

	XTime_GetTime(&time);

	for (i=0; i<pkts; i++) {
		nic_recv(nics[2][2], buf, LEN(buf));
		assert(buf[2] == LEN(buf) && "bad size");
		for (k=0; k<n; k++)
			assert(buf[3+k] == i && "bad data");
	}

	assert(!nics[2][2]->rx_count && "rx fifos not empty");

	printf("%f;\n", (double)time*1000/COUNTS_PER_SECOND);
}

int main(void)
{
	setvbuf(stdout, 0, _IONBF, 0);
	printf("\nstart [Y/n] ");
	getchar();
	putchar('\n');
	puts("test-number, number-of-packets, number-of-words-per-packet, execution-time;\n");

	size_t test, pkts, n;
	for (test=0; test<=2; test++)
		for (pkts=1; pkts<=16; pkts*=4)
			for (n=2; n<=196; n+=2)
				(test==2 ? t2 : test==1 ? t1 : t0)(pkts, n);

	puts("done");
	return 0;
}
