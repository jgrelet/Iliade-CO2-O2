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
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.RelativeTolerance
            % without depth
            % O2 Concentration
            co2.OXYGEN_RAW  = [219.26,0]; 
            
            % Temperature
            co2.SSJT        = [29.299,0];
            
            % Salinity
            co2.SSPS        = [34.87,0]; 
            
            % Air pressure
            co2.LICOR_P     = [1003.57,0]; 
            
            exp.OXYGEN_ADJ_muM = [278.00, 106.82, 107.10, 106.89, 107.56...
                197.96, 197.75, 197.54, 197.84, 198.00];
            exp.OXYGEN_ADJ_MLL = [6.23, 2.39, 2.40, 2.40, 2.41...
                4.44, 4.43, 4.43, 4.43, 4.44];
            exp.OXYGEN_SATURATION = [97.92, 46.33, 46.46, 46.39, 46.68...
                88.66, 88.75, 88.84, 89.01, 89.09];
            
            actual = correctO2Data(co2,0);
            disp(actual);
%             testCase.assertThat(round(actual.OXYGEN_ADJ_muM, 2), ...
%                 IsEqualTo(exp.OXYGEN_ADJ_muM, 'Within', ...
%                 RelativeTolerance(0.02)));
%             
%             testCase.assertThat(round(actual.OXYGEN_ADJ_MLL, 2), ...
%                 IsEqualTo(exp.OXYGEN_ADJ_MLL, 'Within', ...
%                 RelativeTolerance(0.02)));
%             
%             testCase.assertThat(round(actual.OXYGEN_SATURATION, 2), ...
%                 IsEqualTo(exp.OXYGEN_SATURATION, 'Within', ...
%                 RelativeTolerance(0.02)));
            
        end
    end
end

