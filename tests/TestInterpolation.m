classdef TestInterpolation < matlab.unittest.TestCase
    % Test
    
    properties
        files = {'exemple/CSLO1902/cslo1902.oxy',...
            'exemple/CSLO2001/cslo2001.oxy', ...
            'exemple/CSLO1902/cslo1902.csv', ...
            'exemple/CSLO2001/cslo2001.csv' };
    end
    
    methods(TestMethodSetup)
        function pathHandling(testCase)
            addpath("../O2_CO2");
            addpath("../TSG_CO2");
        end
    end
    
    methods(TestMethodTeardown)
        
    end
    
    methods(Test)
        
        function interpolationTest(testCase)
            %% Tests on cslo1902
            [co2, ~] = readInterpTSG_CO2(testCase.files{3});
            [o2, ~] = readAsciiO2(testCase.files{1});
            [co2] = interpolation(co2,o2);
            
            disp(strcat("Test with ", testCase.files{1}, " and ", testCase.files{3}));
            % co2 data starts at 2019-03-31 13:40:30 in cslo1902
            % oxy data starts at 2019-04-01 07:07:36 in cslo1902
            % co2 data ends at 2019-05-24 13:52:55 in cslo1902
            % oxy data ends at 2019-05-25 14:21:36 in cslo1902
            
            % first line should be the default value
            testCase.verifyEqual(co2.OXYGEN_RAW(1), -999);
            % there should be a data the 2019 04 01 around 7 am => extract
            % line 428 from co2
            testCase.verifyNotEqual(co2.OXYGEN_RAW(end), -999);
            % there should be a value at the last line
            testCase.verifyNotEqual(co2.OXYGEN_RAW(end), -999);
            
            %% Test on cslo2001
            disp(strcat("Test with ", testCase.files{2}, " and ", testCase.files{4}));
            [co2, ~] = readInterpTSG_CO2(testCase.files{4});
            [o2, ~] = readAsciiO2(testCase.files{2});
            [co2] = interpolation(co2,o2);
            % co2 data starts at 2020-01-03 17:40:27 in cslo2001
            % oxy data starts at 2020-01-03 18:05:24 in cslo2001
            % co2 data ends at 2020-02-26 08:52:06 in cslo2001
            % oxy data ends at 2020-02-03 11:40:34 in cslo2001
            
            % first line should be the default value
            testCase.verifyEqual(co2.OXYGEN_RAW(1), -999);
            % there should be data 2020 01 03 around 7 pm => extract line
            % 39 from co2
            testCase.verifyNotEqual(co2.OXYGEN_RAW(39), -999);
            % last line should be the default value
            testCase.verifyEqual(co2.OXYGEN_RAW(end), -999);
            
            testCase.verifyEqual(-1, -1);
        end
        
    end
end

