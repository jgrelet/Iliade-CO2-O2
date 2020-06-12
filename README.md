# Iliade-CO2-O2 evolution version

Integration of O2 and CO2 measurements

## USAGE

In order to run the program, you will need the following files:

* co2 data file with .csv format
* tsg data file with .tsgqc format
* o2 data file with .oxy format

The program will run two different phases:

* CO2 and TSG interpolation in TSG_CO2 folder
* CO2/TSG and O2 interpolation in O2_CO2 folder

There one function that rule them all : main which is at the root of the project
So if you want to run both interpolation at once, you can run the following command:

If you know the path to files, then run :

```matlab
>> main co2FilePath tsgFilePath o2FilePath
```

else :

```matlab
>> main
```

At the begining of the execution, the program will ask you to choose files:

* The first is the .csv file : the output of TSGQC program
* The second is the .tsgqc file : the thermosalinograph output file
* The third file is the .oxy file : the optode output file

### TSG CO2 Interpolation

If you want to run the TSG CO2 interpolation, move to the correct folder:

```matlab
>> cd TSG_CO2
```

Once there, you will have to run the interpolation.

If you know the path to files, then run :

```matlab
>> interpTSG_CO2 TSG_CO2FilePath o2FilePath
```

else :

```matlab
>> interpTSG_CO2
```

at the begining of the execution, the program will ask you to choose files:

* The first is the .csv file : the output of TSGQC program
* The second is the .tsgqc file : the thermosalinograph output file

### O2 CO2 Interpolation

If you want to run the O2 CO2 interpolation, move to the correct folder:

```matlab
>> cd O2_CO2
```

**Note that you need the TSg/CO2 interpolation file for this one.**

If you know the path to files, then run :

```matlab
>> interpO2_CO2 TSG_CO2FilePath o2FilePath
```

else :

```matlab
>> interpO2_CO2
```

* The first file you have to choose is the previous interpolation result
* The second is the .oxy file : the optode output file
* The program will ask you where you want to save the CO2/TSG/O2 interpolation

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

The following files will be there :

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
