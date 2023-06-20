#######################################################################
#  Project           : Automatic Testbench Ceator
# 
#  File Name         : wrapper_generate.py
# 
#  Author            : Jose Iuri B. de Brito (XMEN LAB), Matheus Maciel de Sousa (XMEN LAB)
# 
#  Purpose           : This File is used to generate the wrappers that
#                      converts a module from interface level to signal
#                      level.
#######################################################################

import os
import sys
from colorama import Fore
import pathlib as path
import pandas as pd

def wrapper_generate(author, module, interface, interface_path, test, tb_path, passive, rtl_path):
    
    wrapper = """module {MODULE}_wrapper ({INTERFACE}_if bus);


    {MODULE} {MODULE}_sv (""".format(MODULE=module, INTERFACE=interface)

    df = pd.read_csv(interface_path)

    df = df.replace(['s', 'u','I','O'], ['signed', '', 'input', 'output'])

    for index, row in df.iterrows():
        wrapper = wrapper + """
        .{SINAL}(bus.{SINAL}),""".format(SINAL=row['Sinal'])

    wrapper = wrapper[:-1] + """);

endmodule"""

    file = tb_path / """{MODULE}_wrapper.sv""".format(MODULE=module)
    file1 = open(file,"a+")
    file1.write(wrapper)
    file1.close() 
