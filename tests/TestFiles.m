classdef TestFiles < matlab.unittest.TestCase
    % TestFiles an example test
    
    properties
        trueFiles = {'../exemple/CSLO1902/cslo1902.oxy',...
            '../exemple/CSLO2001/cslo2001.oxy', ...
            '../exemple/CSLO1902/cslo1902.csv', ...
            '../exemple/CSLO2001/cslo2001.oxy' };
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
        
    end
    
end