'''
Created on Nov 1, 2021

@author: mballance
'''
import cocotb
import pybfms
from uart_bfms.uart_bfm import UartBfm
from rv_bfms.rv_data_in_bfm import ReadyValidDataInBFM
from rv_bfms.rv_data_out_bfm import ReadyValidDataOutBFM

class TestBack2BackRv(object):
    
    async def init(self):
        await pybfms.init()
        self.u_rv_tx : ReadyValidDataOutBFM = pybfms.find_bfm(".*u_tx_bfm")
        self.u_rv_rx : ReadyValidDataInBFM  = pybfms.find_bfm(".*u_rx_bfm")
    
    async def run(self):
        await cocotb.triggers.Timer(10, "us")
        
        have_data = False
        data = 0x0
        
        def recv_cb(dat):
            nonlocal have_data, data
            have_data = True
            data = dat
        
        self.u_rv_rx.add_recv_cb(recv_cb)
        
        for i in range(10):
            have_data = False
            data = 0x0
            await self.u_rv_tx.send(0x55+i)

            # Explicitly await data if it hasn't yet arrived            
            if not have_data:
                data = await self.u_rv_rx.recv()
            
            print("data: 0x%02x" % data)
            if data != ((0x55+i) & 0xFF):
                raise Exception("Expecting 0x%02x ; received 0x%02x" % (
                    ((0x55+i) & 0xFF), data))
                
        await cocotb.triggers.Timer(10, "us")
        pass
    
@cocotb.test()
async def entry(dut):
    t = TestBack2BackRv()
    await t.init()
    await t.run()
    