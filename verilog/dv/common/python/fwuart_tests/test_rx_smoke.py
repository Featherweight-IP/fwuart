'''
Created on Nov 1, 2021

@author: mballance
'''
import cocotb
import pybfms
from uart_bfms.uart_bfm import UartBfm
from rv_bfms.rv_data_in_bfm import ReadyValidDataInBFM

class TestRxSmoke(object):
    
    async def init(self):
        await pybfms.init()
        self.u_uart : UartBfm = pybfms.find_bfm(".*u_uart_bfm")
        self.u_rv : ReadyValidDataInBFM = pybfms.find_bfm(".*u_rv_bfm")
        
        pass
    
    async def run(self):
        await cocotb.triggers.Timer(10, "us")
        self.u_uart.set_divisor(7)
        
        have_data = False
        data = 0x0
        
        def recv_cb(dat):
            nonlocal have_data, data
            have_data = True
            data = dat
        
        self.u_rv.add_recv_cb(recv_cb)
        
        for i in range(10):
            have_data = False
            data = 0x0
            await self.u_uart.xmit(0x55+i)

            # Explicitly await data if it hasn't yet arrived            
            if not have_data:
                data = await self.u_rv.recv()
            
            print("data: 0x%02x" % data)
            if data != ((0x55+i) & 0xFF):
                raise Exception("Expecting 0x%02x ; received 0x%02x" % (
                    ((0x55+i) & 0xFF), data))
                
        await cocotb.triggers.Timer(10, "us")
        pass
    
@cocotb.test()
async def entry(dut):
    t = TestRxSmoke()
    await t.init()
    await t.run()
    