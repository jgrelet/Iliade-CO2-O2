classdef TestO2Compensation < matlab.unittest.TestCase
    % tests results are based on the the excel given
    properties
        files = {'../exemple/CSLO1902/cslo1902.oxy',...
            '../exemple/CSLO2001/cslo2001.oxy', ...
            '../exemple/CSLO1902/cslo1902.csv', ...
            '../exemple/CSLO2001/cslo2001.csv' };
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
        function compensationTest(testCase)
            % without depth
            co2.OXYGEN_RAW = [278.0];
            co2.SSPS = [0];
            co2.SSJT = [20];
            co2.LICOR_P = [1013.25];
            
            expected.OXYGEN_ADJ_muM = [278.00];
            expected.OXYGEN_ADJ_MLL = [6.23];
            expected.OXYGEN_SATURATION = [97.92];
            
            actual = correctO2Data(co2,0,0);
            
            testCase.verifyEqual(actual.OXYGEN_ADJ_muM, expected.OXYGEN_ADJ_muM);
        end
    end
end

