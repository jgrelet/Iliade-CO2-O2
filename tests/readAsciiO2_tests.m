function readAsciiO2_Test
% Here, we will test that the data from the oxygen file is correctly read.

% We choose the line 1909 in order to test
% prefix e_ is for expected values.

%% SETUP

% EXPECTED VALUES
%file = "C:\Users\Proprietaire\Documents\MATLAB\Iliade-CO2-O2\exemple\CSLO2001\cslo2001.oxy";
file = "[your path to the project]\Iliade-CO2-O2\exemple\CSLO2001\cslo2001.oxy";

e_year = 2020;
e_month = 1;
e_day = 10;
e_hour = 9;
e_minute = 5;
e_second = 16;

e_dayd = datenum(e_year, e_month, e_day, e_hour, e_minute, e_second);

e_oxygen = 273.85;
e_saturation = 93.02;
e_temperature = 18.15;

e_line_number = 5468;

testCase = matlab.unittest.TestCase.forInteractiveUse;
%%

[o2, ok] = readAsciiO2(file);

%% Basic test : the function execute properly
assertTrue(testCase,ok);

%% Number of lines = number of element in the DATE field
sz = size(o2.DATE, 1);
assertEqual(testCase, sz, e_line_number);

%%
o2 = struct2cell(o2);

%% Serial date test
dayd = o2{2};
assertEqual(testCase, e_dayd, dayd(1909));

%% Oxygen data test
oxygen = o2{3};
assertEqual(testCase, oxygen(1909), e_oxygen);
%% Saturation data test
saturation = o2{4};
assertEqual(testCase, saturation(1909), e_saturation);
%% Temperature data test
temperature = o2{5};
assertEqual(testCase, temperature(1909), e_temperature);



