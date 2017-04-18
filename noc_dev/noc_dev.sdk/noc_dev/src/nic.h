#ifndef NIC_H
#define NIC_H

#include <stdint.h>
#include <stddef.h>

//#define NIC_FIFO_SIZE 1000 //1K enabled
#define NIC_FIFO_SIZE 4000 //4K enabled

struct nic {
	uint32_t tx_data;
	uint32_t rx_data;
	uint32_t tx_count;
	uint32_t rx_count;
	uint32_t tx_go;
};

/*
	Packet Structure:
		|<----------DST---------->|
		|<----------SRC---------->|
		|<----OP---->|<----SZ---->|
		|<--------PAYLOAD-------->|
		|<--------PAYLOAD-------->|
		|<--------PAYLOAD-------->|
		|<--------PAYLOAD-------->|
		|<--------PAYLOAD-------->|
*/

#define ADDR(x,y) (((x + 0UL) << 2 | y) << 28)
#define X(addr)   (addr >> 30)
#define Y(addr)   ((addr >> 28) & 3)

void nic_flush(struct nic *);
void nic_send(struct nic *, uint32_t *, size_t);
void nic_recv(struct nic *, uint32_t *, size_t);

#endif
