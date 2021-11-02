'''
Created on Nov 1, 2021

@author: mballance
'''
import cocotb
import pybfms
from rv_bfms.rv_data_out_bfm import ReadyValidDataOutBFM
from uart_bfms.uart_bfm import UartBfm

class TestTxSmoke(object):
    
    async def init(self):
        await pybfms.init()
        self.u_uart : UartBfm = pybfms.find_bfm(".*u_uart_bfm")
        self.u_rv : ReadyValidDataOutBFM = pybfms.find_bfm(".*u_rv_bfm")
        
        pass
    
    async def run(self):
        await cocotb.triggers.Timer(10, "us")
        self.u_uart.set_divisor(7)
        
        for i in range(10):
            await self.u_rv.send(0x55+i)
            data = await self.u_uart.recv()
            
            print("data: 0x%02x" % data)
            if data != ((0x55+i) & 0xFF):
                raise Exception("Expecting 0x%02x ; received 0x%02x" % (
                    ((0x55+i) & 0xFF), data))
                
        await cocotb.triggers.Timer(10, "us")
        pass
    
@cocotb.test()
async def entry(dut):
    t = TestTxSmoke()
    await t.init()
    await t.run()
    