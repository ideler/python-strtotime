#! /usr/bin/env python

import os

try:
    from setuptools import setup, Extension

    extra = dict(zip_safe=False)
except ImportError:
    from distutils.core import setup
    from distutils.extension import Extension

    extra = dict()

from distutils import sysconfig

if sysconfig.get_config_var("LIBM") == "-lm":
    libraries = ["m"]
else:
    libraries = []

sources = [
    "lib/astro.c",
    "lib/dow.c",
    "lib/parse_date.c",
    "lib/parse_tz.c",
    "lib/timelib.c",
    "lib/tm2unixtime.c",
    "lib/unixtime2tm.c",
    "timelib.c",
]

extra_compile_args = sysconfig.get_config_var("CFLAGS").split()
extra_compile_args += [
    "-Wno-expansion-to-defined",
    "-Wno-nullability-completeness",
    "-Wno-unreachable-code",
]

if not os.path.exists("timelib.c"):
    os.system("cython --directive language_level=3 timelib.pyx")

setup(
    name="strtotime",
    version="1.0.0",
    description="wrapper for timelib",
    author="Ideler IT-Service GmbH",
    author_email="hosting@ideler.de",
    url="https://github.com/ideler/python-strtotime/",
    ext_modules=[
        Extension(
            "timelib",
            sources=sources,
            libraries=libraries,
            extra_compile_args=extra_compile_args,
            define_macros=[("HAVE_STRING_H", 1)],
        )
    ],
    include_dirs=[".", "lib"],
    long_description=open("README.rst").read(),
    license="zlib/php",
    **extra
)
