#!/usr/bin/env python


from distutils.core import setup

setup(
	name='fwuart',
	version='0.0.1',
	description="Featherweight UART",
	author='Matthew Ballance',
	author_email='matt.ballance@gmail.com',
	url='http://github.com/featherweight-ip/fwuart',
	data_files=[('rtl', ['rtl/*'])]
)



