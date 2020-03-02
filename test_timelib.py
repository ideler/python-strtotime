#!/usr/bin/env python3
# -*- coding=utf-8 -*-


import timelib, datetime


ts = timelib.strtotime("last sunday of last month noon".encode("utf-8"))
print(datetime.datetime.utcfromtimestamp(ts).strftime("%Y-%m-%d %H:%M:%S"))
