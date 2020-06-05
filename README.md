# Iliade-CO2-O2 evolution version
Integration of O2 and CO2 measurements


## UNIT TESTS

In order to run the tests, move yourself to the tests folder by running the following command in the command prompt:
>> cd tests

then, run
>> ls

The following file should be there :
* TestFiles.m
* TFigureProperties.m



You can run each test file. For example :

>> runtests('TestFiles')

or a specific test of the file : 

>> runtests('TestFiles','ProcedureName','readCo2')

You can also choose to run all tests files of the folder :
>> runtests

the results is :

    Running TFigureProperties
    ..
    Done TFigureProperties
    __________
    
    Running TestFiles
    Check if the tests files are found
    ../exemple/CSLO1902/cslo1902.oxy
    ../exemple/CSLO2001/cslo2001.oxy
    ../exemple/CSLO1902/cslo1902.csv
    ../exemple/CSLO2001/cslo2001.csv
    ../exemple/CSLO1902/cslo1902.bad
    ../exemple/CSLO2001/cslo2001.bad
    .Check the number of lines read
    .Check if we correctly read the data from o2 file
    .Check if we correctly read the data from co2 file
    .
    Done TestFiles
    __________
    
    ans = 
    
      1×6 TestResult array with properties:
    
        Name
        Passed
        Failed
        Incomplete
        Duration
        Details
    
    Totals:
       6 Passed, 0 Failed, 0 Incomplete.
       6.8135 seconds testing time.
