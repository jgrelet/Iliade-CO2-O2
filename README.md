# Iliade-CO2-O2 evolution version

Integration of O2 and CO2 measurements

## USAGE

The application is made of two phases:

* CO2 and TSG interpolation
* CO2 interpolated and O2

First, you have to run

```matlab
>> interpTSG_CO2
```

* The first file you have to choose is the CO2 file
* The second is the .tsgqc file : the thermosalinograph output file
* The program will produce 8 figures and ask you where you want to save the TSG/CO2 interpolation

When it's done, you can then run

```bash
>> interpAll
```

* The first file you have to choose is the previous interpolation result
* The second is the .oxy file : the optode output file
* The program will ask you where you want to save the CO2/TSG/O2 interpolation

interpAll will internally call interpCo2_O2 and correctO2Data

## UNIT TESTS

You can run all the tests from the project folder with

```matlab
>> runtests('tests')
```

For more details about them, move yourself to the tests folder by running the following command in the command prompt:

```matlab
>> cd tests
```

then, run

```matlab
>> ls
```

The following file should be there :

* TestFiles.m
* TestO2Compensation.m
* TestInterpolation.m


### Reading module : TestFiles

This file test the following functions

* readAsciiO2
* readInterpTSG_CO2
* writeInterpolation (WIP)

You can run all testFiles tests with :

```matlab
>> runtests('TestFiles')
```

or a specific test of the file :

```matlab
>> runtests('TestFiles','ProcedureName','readCo2')
```

the results is :

```text
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
```

### Interpolation module

This fie test the following function

* interpCo2_O2

Note that it's highly recommended to run the previous test before running this one as it use readinterpTSC_CO2 and readAsciiO2

```matlab
>> runtests('testFiles')
```

You can run all testFiles tests with :

```matlab
>> runtests('testInterpolation')
```

the results is :

```text
Running TestInterpolation
Test with ../exemple/CSLO1902/cslo1902.oxy and ../exemple/CSLO1902/cslo1902.csv
Test with ../exemple/CSLO2001/cslo2001.oxy and ../exemple/CSLO2001/cslo2001.csv
.
Done TestInterpolation
__________


ans =

  TestResult with properties:

          Name: 'TestInterpolation/interpolationTest'
        Passed: 1
        Failed: 0
    Incomplete: 0
      Duration: 3.4632
        Details: [1×1 struct]

Totals:
    1 Passed, 0 Failed, 0 Incomplete.
    3.4632 seconds testing time.
```

### O2 compensation module

(WIP)
