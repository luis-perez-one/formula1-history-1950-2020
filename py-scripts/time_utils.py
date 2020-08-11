from datetime import datetime
from numpy import timedelta64
from math import trunc


def hms_str_to_pg_interval(time_string):
    timeUnitDelimeterQty = time_string.count(':')
    rfindEndPosition = len(time_string)
    separatorDict = {   0 : 'S',
                        1 : 'M',
                        2 : 'H',
                        3 : 'D'
                            }
    for ocurrence in range (0, timeUnitDelimeterQty):
        ocurrencePosition = time_string.rfind(':', 0, rfindEndPosition)
        time_string = time_string[:ocurrencePosition] + separatorDict[ocurrence] + time_string[ocurrencePosition + 1:]
        rfindEndPosition = ocurrencePosition -1
    
    firstChar = separatorDict[timeUnitDelimeterQty]
    time_string = firstChar + time_string

    return time_string



def hms_str_to_miliseconds(time_string):
        time_string = str(time_string)
        
        if time_string is None or time_string == '<NA>':
            return None

        timeUnitDelimeterQty = time_string.count(':')
        assert timeUnitDelimeterQty<=2, 'Invalid time string.'

        formatD = { 0:"%S.%f",
                1:"%M:%S.%f",
                2:"%H:%M:%S.%f"
                }

        time = datetime.strptime(time_string, formatD[timeUnitDelimeterQty])
        miliseconds = time.microsecond / 1000
        miliseconds += time.second * 1000
        miliseconds += time.minute * 60 * 1000
        miliseconds += time.hour * 60 * 60 *1000
        miliseconds = int(miliseconds)
        return miliseconds



def miliseconds_to_np_timedelta(miliseconds):
    delta = timedelta64(0, 'ms')
    
    if miliseconds >= 3600000:
        hours = trunc(miliseconds / 3600000)
        delta += timedelta64(hours, 'h')
        miliseconds -= hours * 3600000
    
    if miliseconds < 3600000 and miliseconds >= 60000:
        minutes = trunc(miliseconds / 60000)
        delta += timedelta64(minutes, 'm')
        miliseconds -= minutes * 60000

    if miliseconds < 60000 and miliseconds >= 1000:
        seconds = trunc(miliseconds / 1000)
        delta += timedelta64(minutes, 's')
        miliseconds -= seconds * 1000

    if miliseconds < 1000 and miliseconds >= 0:
        delta += timedelta64(miliseconds, 'ms')
    
    return(delta)