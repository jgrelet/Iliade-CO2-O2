# Iliade-CO2-O2 evolution version
Integration of O2 and CO2 measurements


## UNIT TESTS

In order to run the tests, move yourself to the tests folder by running the following command in the command prompt:
>> cd tests
then, run
>> ls
you should see:
	.                   ..                  open_files_tests.m  read_tests.m        run_all_tests.m 

then you can choose to run all the tests at once with the "run_all_tests" file:
>> run_all_tests
	../exemple/CSLO1902/cslo1902.oxy
	Assertion passed.
	../exemple/CSLO2001/cslo2001.oxy
	Assertion passed.
	../exemple/CSLO1902/cslo1902.oxy
	Assertion passed.
	Assertion passed.
	Assertion passed.
	Assertion passed.
	../exemple/CSLO2001/cslo2001.oxy
	Assertion passed.
	Assertion passed.
	Assertion passed.
	Assertion passed.

or run each tests one by one:
>> open_files_tests
	../exemple/CSLO1902/cslo1902.oxy
	Assertion passed.
	../exemple/CSLO2001/cslo2001.oxy
	Assertion passed.