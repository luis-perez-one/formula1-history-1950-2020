import time_utils
import pandas as pd

file_name = 'results'
folder = '/home/lperez/Public/Formula 1 World Championship (1950 - 2020)/'


csvFilePathI = folder + file_name + '.csv'
with open (csvFilePathI, 'rb') as file:
    results = pd.read_csv(file, encoding = 'UTF-8',
                                    thousands = ',',
                                    decimal = '.',
                                    na_values=['\\N'],
                                    dtype = {
                                            'resultId':'string',
                                            'raceId':'string',
                                            'driverId':'string',
                                            'constructorId':'string',
                                            'number':'string',
                                            'grid':'string',
                                            'position':'string',
                                            'position_text':'string',
                                            'positionOrder':'string',
                                            'points':'string',
                                            'laps':'string',
                                            'time':'string',
                                            'milliseconds':'string',
                                            'fastestlap':'string',
                                            'rank':'string',
                                            'fastestLapTime':'string',
                                            'fastestLapSpeed':'string',
                                            'statusID':'string'}
                                )
    

results['fastest_lap_milliseconds'] = results['fastestLapTime'].apply(lambda x: time_utils.hms_str_to_miliseconds(x))


csvFilePathO = folder+ file_name + '_by_py.csv'
results.to_csv(csvFilePathO)