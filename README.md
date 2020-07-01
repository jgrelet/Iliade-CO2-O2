# Iliade-CO2-O2

Integration of O2 and CO2 measurements

## INSTALLING

Follow these steps to install the project correctly :

* Download the project [here](https://github.com/jgrelet/Iliade-CO2-O2/tree/master)
* Open MATLAB
* Add the project to the path
* Download the m_map package [here](http://www.eos.ubc.ca/~rich/m_map1.4.zip)
* Download the [maps](https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhs/latest/)
* Unzip the maps and put them in the folder m_map/private
* Add the m_map package to the MATLAB path

## USAGE

In order to run the program, you will need the following data :

* co2 data : .csv file (result of the concatCO2 program)
* tsg data : .tsgqc file
* o2 data : .oxy file

Once you add the project to path, you can run it from where you want using the following command :

```matlab
>> interpCO2_TSG_O2
```

If you know the full path to your files, you can run the command with them in parameter :

```matlab
>> interpCO2_TSG_O2 path2co2 path2tsg path2o2
```

The result of the program will be two different files :

* CO2 and TSG interpolation
* Previous interpolation and O2 interpolation

Then, you can visualize all the data :

* CO2 data

```matlab
>> traceCO2
```

* Interpolated O2 data

```matlab
>> traceO2
```

* CO2 and O2 concentration on maps

```matlab
>> traceMap
```

You can also run interpolation separatly.
You have to start with the CO2/TSG interpolation because the result file is needed for the CO2/O2 :

* interpTSG_CO2(co2File, tsgFile)

```matlab
>> interpTSG_CO2
```

* interpCO2_O2(tsg_co2InterpFile, o2File)

```matlab
>> interpCO2_O2
```

## UNIT TESTS

You can run all the tests from the project folder with

```matlab
>> runtests('tests')
```

This will test the following functions:

* readAsciiO2
* readInterpTSG_CO2
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
