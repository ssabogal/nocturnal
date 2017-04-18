#include "nic.h"

#include <assert.h>
#include <stdio.h>
#include "sleep.h"

//#define DBG(x) printf(x "tx_cnt=%d rx_cnt=%d\n", (unsigned) nic->tx_count, (unsigned) nic->rx_count);
#define DBG(x)

void nic_flush(struct nic *nic)
{
	nic->tx_go = 1;
}

void nic_send(struct nic *nic, uint32_t *buf, size_t len)
{
	nic->tx_go = 0;

	DBG("ns0:");
	assert(NIC_FIFO_SIZE - nic->tx_count >= len && "tx fifo full");

	int i;
	for (i=0; i<len; i++)
		nic->tx_data = buf[i];

	DBG("ns1:");
}

void nic_recv(struct nic *nic, uint32_t *buf, size_t len)
{
	DBG("nr0:");
	assert(nic->rx_count >= len && "rx fifo is missing data");

	int i;
	for (i=0; i<len; i++)
		buf[i] = nic->rx_data;

	DBG("nr1:");
}
