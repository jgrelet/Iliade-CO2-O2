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
    
    
    methods(Test)
        
        function openFiles(testCase)
            
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
            first = 310.33;
            random = 0.02; % Line 8870
            last = 234.00;
            [data, ~] = readAsciiO2(testCase.trueFiles{1});
            testCase.verifyEqual(data.RAW_OXYGEN(1), first);
            testCase.verifyEqual(data.RAW_OXYGEN(8870), random);
            testCase.verifyEqual(data.RAW_OXYGEN(end), last);
            
            first = 308.18;
            random = 268.22; % Line 2142
            last = 232.56;
            [data, ~] = readAsciiO2(testCase.trueFiles{2});
             testCase.verifyEqual(data.RAW_OXYGEN(1), first);
            testCase.verifyEqual(data.RAW_OXYGEN(2142), random);
            testCase.verifyEqual(data.RAW_OXYGEN(end), last);
        end
    end
    
end