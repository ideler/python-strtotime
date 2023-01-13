#!/bin/bash

/opt/python/cp35-cp35m/bin/pip wheel . -w dist
/opt/python/cp36-cp36m/bin/pip wheel . -w dist
/opt/python/cp37-cp37m/bin/pip wheel . -w dist
/opt/python/cp38-cp38/bin/pip wheel . -w dist
/opt/python/cp39-cp39/bin/pip wheel . -w dist

find dist -type f -iname *whl -exec auditwheel repair {} -w dist \;
