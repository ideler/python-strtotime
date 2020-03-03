Fork of: https://github.com/pediapress/timelib/

Usage
=====

strtotime is a short wrapper around php's internal timelib module.
It currently only provides a few functions:

strtotime.strtodatetime:

>>> strtotime.strtodatetime('today')
datetime.datetime(2009, 6, 23, 0, 0)
>>> strtotime.strtodatetime('today')
datetime.datetime(2009, 6, 23, 0, 0)
>>> strtotime.strtodatetime('next friday')
datetime.datetime(2009, 6, 26, 0, 0)
>>> strtotime.strtodatetime('29 feb 2008 -108 years')
datetime.datetime(1900, 3, 1, 0, 0)

strtotime.strtotime:

>>> import time, strtotime
>>> time.ctime(strtotime.strtotime("now"))
'Tue Jun 23 15:17:32 2009'
>>> time.ctime(strtotime.strtotime("4 hours ago"))
'Tue Jun 23 11:17:38 2009'
>>> time.ctime(strtotime.strtotime("20080229 -1 year"))
'Thu Mar  1 01:00:00 2007'

License
=======
lib contains unmodified sources from the php source
distribution. These are distributed under the `php license`_, version
3.01.

The remaining part is distributed under the zlib/libpng license:

Copyright (c) 2009-2011 PediaPress GmbH

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

3. This notice may not be removed or altered from any source
   distribution.


.. _php license: http://www.php.net/license/3_01.txt
