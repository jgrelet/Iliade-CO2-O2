function interpFile = interpCO2_O2(tsg_co2InterpFile, o2File)
    %
    % Interpolation of O2 measure at co2 dates.
    % At the end, the following columns will be add to the .csv:
    % OXYGEN_RAW
    % OXYGEN_SATURATION
    % OXYGEN_TEMPERATURE
    % OXYGEN_ADJ_muM
    % OXYGEN_ADJ_MLL;
    %
    % Input :
    % 1 - .csv file from function "interpTSG_CO2"
    % 2 - .oxy file : ASCII file with O2 data


    % Get the location of this file
    fileName = mfilename;
    fulFilename = mfilename('fullpath');
    expr = strcat(fileName, '$');
    DEFAULT_PATH_FILE =  regexprep(fulFilename, expr, '');
    
    % Adding local path
    addpath(strcat(DEFAULT_PATH_FILE,filesep,"TSG_CO2"));
    addpath(strcat(DEFAULT_PATH_FILE,filesep,"O2_CO2"));
    
    disp("O2 CO2 interpolation ...");
    
    % Check if files are present
    if nargin ~=2
        disp("... Select the TSG/CO2 interpolation file");
        [tsg_co2InterpFile, pathIn] = uigetfile( '*.csv', 'Select the TSG/CO2 interpolation file', 'MultiSelect','off');
        
        tsg_co2InterpFile = char([pathIn tsg_co2InterpFile]);
        disp(char(tsg_co2InterpFile))
        disp("... Select the O2 data file");
        [o2File, o2FileIn] = uigetfile( '*.oxy', 'Select the O2 data file', 'MultiSelect','off', pathIn);
        
        o2File = char([o2FileIn o2File]);
        disp(char(o2File))
    end

    % Get the CO2 data
    co2 = readInterpTSG_CO2(tsg_co2InterpFile);
    
    % Get the O2 data
    o2 = readAsciiO2(o2File);
    
    % Interpolate the CO2 and O2 data
    co2 = interpolation(co2,o2);
    
    % Adjusting O2 DATA
    % default salinity setting is 0
    co2 = correctO2Data(co2, 0);
    
    interpFile = writeInterpolation(co2);
    disp(">> interpCO2_O2 : DONE <<");
    
    % Removing the local path
    rmpath(strcat(DEFAULT_PATH_FILE,filesep,"TSG_CO2"));
    rmpath(strcat(DEFAULT_PATH_FILE,filesep,"O2_CO2"));
end

    

