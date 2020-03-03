
import time, datetime

version = "0.2.4"
version_info = (0, 2, 4)

cdef extern from "timelib.h":
    ctypedef struct timelib_rel_time:
        int y, m, d           # /* Years, Months and Days */
        int h, i, s           # /* Hours, mInutes and Seconds */

        int weekday           # /* Stores the day in 'next monday' */
        int weekday_behavior  # /* 0: the current day should *not* be counted when advancing forwards; 1: the current day *should* be counted */

    ctypedef struct timelib_time:
        int y, m, d, h, i, s
        timelib_rel_time relative
        long sse

    ctypedef struct timelib_tzdb:
        pass

    ctypedef struct timelib_error_message:
        char *message
        int position
        int character

    ctypedef struct timelib_error_container:
        int error_count
        timelib_error_message *error_messages

    ctypedef struct timelib_tzinfo:
        pass

    long timelib_date_to_int(timelib_time *d, int *error)

    void timelib_time_dtor(timelib_time* t)
    void timelib_error_container_dtor(timelib_error_container *)
    timelib_tzinfo *timelib_parse_tzfile(char *timezone, const timelib_tzdb *tzdb, int *error_code)
    ctypedef timelib_tzinfo* (*timelib_tz_get_wrapper)(char *tzname, const timelib_tzdb *tzdb, int *error_code)

    timelib_time *timelib_strtotime(char *s, int len, timelib_error_container **errors, timelib_tzdb *tzdb, timelib_tz_get_wrapper tz_get_wrapper)

    timelib_tzdb *timelib_builtin_db()

    void timelib_update_ts(timelib_time*, timelib_tzinfo* tzi)
    void timelib_fill_holes(timelib_time *parsed, timelib_time *now, int options)
    void timelib_update_from_sse(timelib_time *tm)
    timelib_time * timelib_time_ctor()

    void timelib_dump_date(timelib_time *, int)
    void timelib_unixtime2gmt(timelib_time *tm, long ts)
    void timelib_unixtime2local(timelib_time *tm, long ts)


def _raise_error(description):
    raise ValueError(description)

cdef timelib_time *strtotimelib_time(char *s, now=None) except NULL:
    cdef timelib_time *t = NULL
    cdef timelib_time *tm_now = NULL
    cdef timelib_error_container *error = NULL

    t = timelib_strtotime(s, len(s), &error, timelib_builtin_db(), timelib_parse_tzfile)

    if error and error.error_count:
        timelib_time_dtor(t)

        msg = str(error.error_messages[0].message)
        msg += " (while parsing date %r)" % (s, )

        _raise_error(msg)
        timelib_error_container_dtor(error)
        return NULL

    if error:  # warnings we don't care about
        timelib_error_container_dtor(error)
        error = NULL

    if now is None:
        now = int(time.time())
    else:
        now = int(now)

    tm_now = timelib_time_ctor()

    # tm_now.sse = now
    # timelib_update_from_sse(tm_now)

    timelib_unixtime2gmt(tm_now, now)
    # timelib_unixtime2local(tm_now, now)

    timelib_fill_holes(t, tm_now, 0)

    timelib_update_ts(t, NULL)
    timelib_time_dtor(tm_now)
    return t

from cpython.version cimport PY_MAJOR_VERSION

cdef bytes _bytes(s):
    if type(s) is unicode:
        return (<unicode>s).encode('utf-8')
    elif PY_MAJOR_VERSION < 3 and isinstance(s, bytes):
        return <bytes>s
    elif isinstance(s, unicode):
        return unicode(s).encode('utf-8')
    else:
        raise TypeError("Could not convert to unicode.")


def strtodatetime(s, now=None):
    import datetime
    cdef timelib_time *t
    t = strtotimelib_time(_bytes(s), now)

    retval = datetime.datetime(t.y, t.m, t.d, t.h, t.i, t.s)
    if t:
        timelib_time_dtor(t)

    return retval


def strtotime(s, now=None):
    cdef timelib_time *t
    t = strtotimelib_time(_bytes(s), now)
    retval = t.sse
    timelib_time_dtor(t)
    return retval
