classdef TestO2Compensation < matlab.unittest.TestCase
    % tests results are based on TD280 Oxygen Optode Calculations.xls
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
            % O2 Concentration
            co2.OXYGEN_RAW  = [278.0, 131.27, 131.61, 131.35, 132.17...
                245.07, 244.92, 244.77, 245.19, 245.40]; 
            
            % Temperature
            co2.SSJT        = [20, 20.411, 20.412, 20.427, 20.429...
                21.392, 21.481, 21.564, 21.587, 21.577];
            
            % Salinity
            co2.SSPS        = [0, 35.000, 35.000, 35.000, 35.000...
                36.516, 36.614, 36.716, 36.755, 36.759]; 
            
            % Air pressure
            co2.LICOR_P     = [1013.25, 1019.46, 1019.42, 1019.21, 1019.13...
                1014.03, 1014.06, 1014.14, 1014.32, 1014.15]; 
            
            exp.OXYGEN_ADJ_muM = [278.00, 106.82, 107.10, 106.89, 107.56...
                197.96, 197.75, 197.54, 197.84, 198.00];
            exp.OXYGEN_ADJ_MLL = [6.23, 2.39, 2.40, 2.40, 2.41...
                4.44, 4.43, 4.45, 4.43, 4.44];
            exp.OXYGEN_SATURATION = [97.92, 46.33, 46.46, 46.39, 46.68...
                88.66, 88.75, 94.04, 89.01, 89.09];
            
            actual = correctO2Data(co2,0,0);
            
            testCase.verifyEqual(round(actual.OXYGEN_ADJ_muM, 2), exp.OXYGEN_ADJ_muM);
            
        end
    end
end

