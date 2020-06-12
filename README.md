# Iliade-CO2-O2 evolution version

Integration of O2 and CO2 measurements

## USAGE

In order to run the program, you will need the following files:

* co2 data file with .csv format
* tsg data file with .tsgqc format
* o2 data file with .oxy format

There is two parts in the program:

* CO2 and TSG interpolation, in TSG_CO2 folder
* CO2/TSG and O2 interpolation, in O2_CO2 folder

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

This will test the following functions:

* readAsciiO2
* readInterpTSG_CO2
* writeInterpolation (WIP)
* interpCo2_O2
* correctO2Data

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

the result is :

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

TestInterpolation test the following function

* interpCo2_O2

Note that it's highly recommended to run the previous test before running this one as it use readinterpTSC_CO2 and readAsciiO2

```matlab
>> runtests('testFiles')
```

the result is :

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

TestO2Compensation test the following function

* correctO2Data

Note that it's highly recommended to run the previous test before running this one as it use readinterpTSC_CO2 and readAsciiO2

```matlab
>> runtests('TestO2Compensation')
```

the results is :

```matlab
>> runtests('testInterpolation')
```

the result is :

```text
Running TestO2Compensation
Computing scaled temperature ...
Computing solubility ...
Computing salinity compensation ...
Computing pressure compensation ...
Computing o2 concentration ...
Computing O2 Saturation ...
Writing data to structure ...
        OXYGEN_RAW: [278 131.2700 131.6100 131.3500 132.1700 245.0700 244.9200 244.7700 245.1900 245.4000]
              SSJT: [20 20.4110 20.4120 20.4270 20.4290 21.3920 21.4810 21.5640 21.5870 21.5770]
              SSPS: [0 35 35 35 35 36.5160 36.6140 36.7160 36.7550 36.7590]
          LICOR_P: [1.0133e+03 1.0195e+03 1.0194e+03 1.0192e+03 1.0191e+03 1.0140e+03 1.0141e+03 1.0141e+03 1.0143e+03 1.0141e+03]
    OXYGEN_ADJ_muM: [278 106.8229 107.0997 106.8906 107.5582 197.9599 197.7528 197.5395 197.8405 198.0022]
    OXYGEN_ADJ_MLL: [6.2311 2.3943 2.4005 2.3958 2.4108 4.4371 4.4324 4.4276 4.4344 4.4380]
OXYGEN_SATURATION: [6.9439 3.2662 3.2748 3.2690 3.2897 6.1303 6.1263 6.1220 6.1314 6.1377]

.
Done TestO2Compensation
__________


ans =

TestResult with properties:

      Name: 'TestO2Compensation/compensationTest'
    Passed: 1
    Failed: 0
Incomplete: 0
  Duration: 0.0739
    Details: [1×1 struct]

Totals:
1 Passed, 0 Failed, 0 Incomplete.
0.073924 seconds testing time.
```
