all:: strtotime.c
	python setup.py build

clean::
	rm -rf *.so build/ dist/

install:: strtotime.c
	python setup.py build install

dist:: strtotime.c lib/parse_date.c
	python setup.py build sdist bdist_wheel

lib/parse_date.c: lib/parse_date.re
	re2c -d -b -o lib/parse_date.c lib/parse_date.re

%.c: %.pyx
	cython --directive language_level=3 $< -o $@
