######################################################################
#  Project           : Automatic Testbench Ceator
# 
#  File Name         : setup.py
# 
#  Author            : Jose Iuri B. de Brito (XMEN LAB), Matheus Maciel de Sousa (XMEN LAB)
# 
#  Purpose           : Main file of the application. Used to call the
# 					   Other files and functions.	  
######################################################################

import os
import sys
from colorama import Fore
import pathlib as path
from generate import *
from doc_generate import *
from wrapper_generate import *

def display_title_bar():

	# Clears the terminal screen, and displays a title bar.
	os.system('clear')
	print(Fore.BLUE + "\t#################################################")
	print(Fore.BLUE + "\t#           ▀▄ ▄▀  █▀▄▀█  █▀▀▀  █▄  █           #")
	print(Fore.BLUE + "\t#             █    █ █ █  █▀▀▀  █ █ █           #")
	print(Fore.BLUE + "\t#           ▄▀ ▀▄  █   █  █▄▄▄  █  ▀█           #")
	print(Fore.BLUE + "\t#                                               #")
	print(Fore.BLUE + "\t#                █     █▀▀█  █▀▀█               #")
	print(Fore.BLUE + "\t#                █     █▄▄█  █▀▀▄               #")
	print(Fore.BLUE + "\t#                █▄▄█  █  █  █▄▄█               #")
	print(Fore.BLUE + "\t#################################################")
	print(Fore.WHITE + "\t#################################################")
	print(Fore.WHITE + "\t# This script is used to automate generation of #")
	print(Fore.WHITE + "\t# UVM Testbench Follow the steps to finish the  #")
	print(Fore.WHITE + "\t# generation.                                   #")
	print(Fore.WHITE + "\t#################################################")
	print("\t                                                 ")
	os.system("""bash -c 'read -s -n 1 -p "Press any key to continue..."'""")


def display_options():

	os.system('clear')

	print(Fore.WHITE + "Options:\n")
	print("[a] add the author name    (default = XMen Lab")
	print("[m] add the module name    (default = folder name)")
	print("[t] add the test name      (default = simple_test)")
	print("[i] add the interface name (default = module name)")
	print("[o] add the interface file" + Fore.RED + " NECESSÁRIO")
	print(Fore.WHITE + "[f] Use configuration file")
	print("[q] Quit.")

#run
choice = ''
author = 'XMen Lab'
module = path.Path.cwd().name
interface = module
interface_path = ''
test = 'simple_test'
verification_path = path.Path.cwd()
doc_path = path.Path.cwd()
passive = 0
rtl_path = ''

display_title_bar()
display_options()

#MENU SCREEN
while choice != 'q':
	print(Fore.WHITE + "\t\nCurrent Configurations:","\nAuthor: ", author, "\nModule: ", module, "\nInterface: ", interface, "\nTest: ", test, "\n\n")
	choice = input("What you like to do? (PRESS [g] TO COMPLETE GENERATION)\n")[:1]
	# Respond to the user's choice.
	if choice == 'a':
		author = input("\nInput the author name: \n")
		display_options()
	elif choice == 'm':
		module = input("\nInput the module name: \n")
		display_options()
	elif choice == 't':
		test = input("\nInput the test name: \n")
		display_options()
	elif choice == 'i':
		print("\n Aditional Options for Interface Library:\n")
		print(Fore.GREEN + "\taxi4lite_master\n")
		print(Fore.GREEN + "\taxi4lite_slave\n")
		print(Fore.RED + "\tapb_master (not functional)\n")
		print(Fore.RED + "\tapb_slave (not functional)\n")
		print(Fore.RED + "\ti2c_slave (not functional)\n")
		print(Fore.RED + "\tspi_master (not functional)\n")
		interface = input(Fore.WHITE + "\t\nInput the interface name: \n")
		display_options()
	elif choice == 'g':
		#Create PATHS and folders
		if module == path.Path.cwd().name:
			verification_path = verification_path / 'verification'
			os.mkdir(verification_path)
			doc_path = verification_path / 'docs'
			os.mkdir(doc_path)
			tb_path = verification_path / 'tb'
			os.mkdir(tb_path)

			os.mkdir(verification_path / 'logs')
			os.mkdir(verification_path / 'reports')
			os.mkdir(verification_path / 'scripts')

			os.mkdir(verification_path / 'scripts' / 'gatesim')
			os.mkdir(verification_path / 'scripts' / 'rtlsim')
			os.mkdir(verification_path / 'scripts' / 'verif_manager')

			os.mkdir(verification_path / 'src')
			os.mkdir(verification_path / 'vplan')
			os.mkdir(verification_path / 'workspace')

		else:
			verification_path = verification_path / module
			os.mkdir(verification_path)
			doc_path = verification_path / 'docs'
			os.mkdir(doc_path)
			verification_path = verification_path / 'verification'
			os.mkdir(verification_path)
			tb_path = verification_path / 'tb'
			os.mkdir(tb_path)

		generate(author, module, interface, interface_path, test, tb_path, passive, rtl_path);
		doc_generate(author, module, interface, interface_path, test, doc_path, passive, rtl_path)

		# Move necessary files for documentation to respective folders
		string_cp1 = os.path.dirname(os.path.realpath(__file__)) + '/' + 'resources' + '/' +'*.png'
		string_cp2 = os.path.dirname(os.path.realpath(__file__)) + '/' + 'resources' + '/' +'*.jpg'

		command = 'cp ' + string_cp1 + ' ' + string_cp2 + ' ' + doc_path.as_posix()
 
		os.system(command)

		os.system("pdflatex " + doc_path.as_posix() + "/" + module + ".tex")
		os.system("pdflatex " + doc_path.as_posix() + "/" + module + ".tex")

		os.system("mv " + module + "*" + " " + doc_path.as_posix())

		wrapper_generate(author, module, interface, interface_path, test, tb_path, passive, rtl_path);

		display_options()

	elif choice == 'o':
		interface_path = input(Fore.WHITE + "\t\nInput the interface csv file path: \n")

	elif choice == 'q':
		print("\nQuiting\n")
	else:
		print("\nI didn't understand that choice.\n")
os.system('reset')