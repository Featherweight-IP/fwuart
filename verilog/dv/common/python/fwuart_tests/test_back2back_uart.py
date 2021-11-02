'''
Created on Nov 1, 2021

@author: mballance
'''
import cocotb
import pybfms
from uart_bfms.uart_bfm import UartBfm
from rv_bfms.rv_data_in_bfm import ReadyValidDataInBFM
from rv_bfms.rv_data_out_bfm import ReadyValidDataOutBFM

class TestBack2BackUart(object):
    
    async def init(self):
        await pybfms.init()
        self.u_uart_bfm : UartBfm = pybfms.find_bfm(".*u_uart_bfm")
    
    async def run(self):
        await cocotb.triggers.Timer(10, "us")
        
        self.u_uart_bfm.set_divisor(7)
        
        have_data = False
        data = 0x0
        
        def recv_cb(dat):
            nonlocal have_data, data
            have_data = True
            data = dat
        
        for i in range(10):
            have_data = False
            data = 0x0
            await self.u_uart_bfm.xmit(0x55+i)
            data = await self.u_uart_bfm.recv()

            print("data: 0x%02x" % data)
            if data != ((0x55+i) & 0xFF):
                raise Exception("Expecting 0x%02x ; received 0x%02x" % (
                    ((0x55+i) & 0xFF), data))
                
        await cocotb.triggers.Timer(10, "us")
        pass
    
@cocotb.test()
async def entry(dut):
    t = TestBack2BackUart()
    await t.init()
    await t.run()
    