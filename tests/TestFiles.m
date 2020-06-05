classdef TestFiles < matlab.unittest.TestCase
    % TestFiles an example test
    
    properties
        trueFiles = {'../exemple/CSLO1902/cslo1902.oxy',...
            '../exemple/CSLO2001/cslo2001.oxy', ...
            '../exemple/CSLO1902/cslo1902.csv', ...
            '../exemple/CSLO2001/cslo2001.csv' };
        badFiles = {'../exemple/CSLO1902/cslo1902.bad',...
            '../exemple/CSLO2001/cslo2001.bad' };
    end
    
    methods(TestMethodSetup)
        function pathHandling(testCase)
            addpath("../");
        end
    end
    
    methods(TestMethodTeardown)
        function deleteTests(testCase)
            delete('*.csv');
        end
    end
    
    methods(Test)
        
        function openFiles(testCase)
            % Check if the files are found
            
            for i = testCase.trueFiles
                disp(char(i));
                f = fopen(char(i));
                
                testCase.verifyNotEqual(f, -1)
            end
            
            for i = testCase.badFiles
                disp(char(i));
                f = fopen(char(i));
                
                testCase.verifyEqual(f, -1)
            end
        end   
        
        function lineNumber(testCase)
            % Check the number of lines read
            
            % cslo1902.oxy
            [data, ~] = readAsciiO2(testCase.trueFiles{1});
            testCase.verifyEqual(size(data.DAYD,1), 15354);
            
            % cslo2001.oxy
            [data, ~] = readAsciiO2(testCase.trueFiles{2});
            testCase.verifyEqual(size(data.DAYD,1), 5468);
            
            % cslo2001.csv
            [data, ~] = readInterpTSG_CO2(testCase.trueFiles{3});
            testCase.verifyEqual(size(data.DATE_TIME,1), 20126);
            
            % cslo2001.csv
            [data, ~] = readInterpTSG_CO2(testCase.trueFiles{4});
            testCase.verifyEqual(size(data.DATE_TIME,1), 21122);
        end   
        
        function readOxygen(testCase)
            % Check if we correctly read the data from o2 file
            first = 310.33;
            random = 0.02; % Line 8870
            last = 234.00;
            [data, ~] = readAsciiO2(testCase.trueFiles{1});
            testCase.verifyEqual(data.OXYGEN_RAW(1), first);
            testCase.verifyEqual(data.OXYGEN_RAW(8870), random);
            testCase.verifyEqual(data.OXYGEN_RAW(end), last);
            
            first = 308.18;
            random = 268.22; % Line 2142
            last = 232.56;
            [data, ~] = readAsciiO2(testCase.trueFiles{2});
             testCase.verifyEqual(data.OXYGEN_RAW(1), first);
            testCase.verifyEqual(data.OXYGEN_RAW(2142), random);
            testCase.verifyEqual(data.OXYGEN_RAW(end), last);
        end
        
        function readCo2(testCase)
            % Check if we correctly read the data from co2 file
            first = 14360600.00;
            random = 15043466.00; % Line 11886
            last = 14883855.00;
            [data, ~] = readInterpTSG_CO2(testCase.trueFiles{3});
            testCase.verifyEqual(data.CO2_RAW(1), first);
            testCase.verifyEqual(data.CO2_RAW(11885), random);
            testCase.verifyEqual(data.CO2_RAW(end), last);
            
            first = 13427429.00;
            random = 14268601.00; % Line 13847
            last = 14253565.00;
            [data, ~] = readInterpTSG_CO2(testCase.trueFiles{4});
            testCase.verifyEqual(data.CO2_RAW(1), first);
            testCase.verifyEqual(data.CO2_RAW(13846), random);
            testCase.verifyEqual(data.CO2_RAW(end), last);
        end
        
    end
    
end