classdef TestFiles < matlab.unittest.TestCase
    % TestFiles I/O files tests
    
    properties
        trueFiles = {'exemple/CSLO1902/cslo1902.oxy',...
            'exemple/CSLO2001/cslo2001.oxy', ...
            'exemple/CSLO1902/cslo1902.csv', ...
            'exemple/CSLO2001/cslo2001.csv' };
        badFiles = {'exemple/CSLO1902/cslo1902.bad',...
            'exemple/CSLO2001/cslo2001.bad' };
        resFiles = {'exemple/resCO2_TSG.csv',...
            'exemple/resCO2_O2.csv'...
            };
    end
    
    methods(TestMethodSetup)
        function pathHandling(testCase)
            addpath("../O2_CO2");
            addpath("../TSG_CO2");
            addpath("../struct2csv");
        end
    end
    
    methods(TestMethodTeardown)
        function deleteTests(testCase)
            delete('*.csv');
        end
    end
    
    methods(Test)
        
        function openFiles(testCase)
            disp('Check if the tests files are found');
            
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
            disp('Check the number of lines read');
            
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
            disp(strcat("Check if we correctly read the data from ", testCase.trueFiles{1}));
            first = 310.33;
            random = 0.02; % Line 8870
            last = 234.00;
            [data, ~] = readAsciiO2(testCase.trueFiles{1});
            testCase.verifyEqual(data.OXYGEN_RAW(1), first);
            testCase.verifyEqual(data.OXYGEN_RAW(8870), random);
            testCase.verifyEqual(data.OXYGEN_RAW(end), last);
            disp(strcat("Check if we correctly read the data from ", testCase.trueFiles{2}));
            first = 308.18;
            random = 268.22; % Line 2142
            last = 232.56;
            [data, ~] = readAsciiO2(testCase.trueFiles{2});
             testCase.verifyEqual(data.OXYGEN_RAW(1), first);
            testCase.verifyEqual(data.OXYGEN_RAW(2142), random);
            testCase.verifyEqual(data.OXYGEN_RAW(end), last);
        end
        
        function readCo2(testCase)
            disp(strcat("Check if we correctly read the data from ", testCase.trueFiles{3}));
            first = 14360600.00;
            random = 15043466.00; % Line 11886
            last = 14883855.00;
            [data, ~] = readInterpTSG_CO2(testCase.trueFiles{3});
            testCase.verifyEqual(data.CO2_RAW(1), first);
            testCase.verifyEqual(data.CO2_RAW(11885), random);
            testCase.verifyEqual(data.CO2_RAW(end), last);
            
            disp(strcat("Check if we correctly read the data from ", testCase.trueFiles{3}));
            first = 13427429.00;
            random = 14268601.00; % Line 13847
            last = 14253565.00;
            [data, ~] = readInterpTSG_CO2(testCase.trueFiles{4});
            testCase.verifyEqual(data.CO2_RAW(1), first);
            testCase.verifyEqual(data.CO2_RAW(13846), random);
            testCase.verifyEqual(data.CO2_RAW(end), last);
        end
        
        function writeInterpTest(testCase)
            [co2, ~] = readInterpTSG_CO2(testCase.resFiles{1});
            [data, ~] = readAsciiO2(testCase.trueFiles{1});
            
            [co2] = interpolation(co2,data);

            [expected_co2] = correctO2Data(co2, 0);

            interpFile = writeInterpolation(expected_co2);
            
            % Get the data read in the file
            % Read the file
            varNames = {'DATE_TIME', 'GPS_TIME', 'TYPE', 'ERROR', 'LATX', 'LONX',...
                        'LATX_INT','LONX_INT',...
                        'EQU_T', 'STD', 'CO2_RAW', 'CO2_PHYS', 'H2O_RAW', 'H2O_PHYS', ...
                        'LICOR_T', 'LICOR_P', 'ATM_P', 'EQU_P', 'H2O_FLOW', 'LICOR_FLOW', ...
                        'EQU_PUMP', 'VENT_FLOW', 'COND_T', 'COND_ATM', 'COND_EQU', ...
                        'DRIP_1', 'DRIP_2', 'DRY_BOX_T', 'DECK_BOX_T', ...
                        'SSPS', 'SSPS_QC', 'SSJT', 'SSJT_QC', 'SSJT_COR', 'EQU_T_COR', ...
                        'OXYGEN_RAW', 'OXYGEN_ADJ_muM','OXYGEN_ADJ_MLL','OXYGEN_SATURATION','OXYGEN_TEMPERATURE'...
                        } ;

            varTypes = {'char','char','char','single','double','double',...
                        'double', 'double', ...
                        'double', 'double', 'double', 'double', 'double', 'double', ...
                        'double', 'double', 'double', 'double', 'double', 'double', ...
                        'double', 'double', 'double', 'double', 'double', ...
                        'double', 'double', 'double', 'double', ...
                        'double', 'double', 'double', 'double', 'double', 'double', ....
                        'double', 'double', 'double', 'double', 'double'
                } ;
            delimiter = ',';
            opts = delimitedTextImportOptions('VariableNames',varNames,...
                                            'VariableTypes',varTypes,...
                                            'Delimiter',delimiter);
            co2Data = readtable(interpFile, opts);
            % We suppress the header
            co2Data(1,:) = [];

            actual_co2 = struct;
            % Manual conversion to structure
            % table2struct format do not produce a good structure
            for i = 1:size(varNames,2)
                actual_co2.(char(varNames(i))) = co2Data.(char(varNames(i)));
            end
            % Comparison with the data before writing
            testCase.verifyEqual(expected_co2.CO2_RAW(1), actual_co2.CO2_RAW(1));
            testCase.verifyEqual(expected_co2.CO2_RAW(13846), actual_co2.CO2_RAW(13846));
            testCase.verifyEqual(expected_co2.CO2_RAW(end), actual_co2.CO2_RAW(end));
            
        end
        
    end
    
end