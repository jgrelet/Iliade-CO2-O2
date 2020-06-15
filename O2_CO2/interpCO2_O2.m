function interpFile = interpCO2_O2(co2interpCo2_O2File, o2File, varargin)
    %
    % interpCo2_O2olation of O2 measure at co2 dates.
    % At the end, we will add the following columns to the .csv:
    % O2_RAW      oxygen raw values
    % O2_ADJ      oxygen values adjusted
    % SATURATION  saturation
    %
    % Input :
    % 1 - .csv file from function "interpCo2_O2TSG_CO2"
    %     data is read with read interpCo2_O2
    % 2 - Fichier ASCII de mesures TSG
    %     Le fichier est ouvert via la fonction "readAsciiTsgCO2"
    %
    % External function call :
    % readAsciiO2 readInterpTSG_CO2 interpCo2_O2
    %
    % Internal functions :


    % Reading of the CO2 and TSG interpCo2_O2olation
    if nargin ~=2
        disp("Select the TSG/CO2 interpolation file");
        [co2interpCo2_O2File, co2FileIn] = uigetfile( '*.csv', 'Select the TSG/CO2 interpolation file', 'MultiSelect','off', '../tests/exemple');
        
        co2interpCo2_O2File = char([co2FileIn co2interpCo2_O2File]);
        disp(char(co2interpCo2_O2File))
        disp("Select the O2 data file");
        [o2File, o2FileIn] = uigetfile( '*.oxy', 'Select the O2 data file', 'MultiSelect','off', '../tests/exemple');
        
        o2File = char([o2FileIn o2File]);
        disp(char(o2File))
    end
    % Get the co2 struct from the interpCo2_O2olation file
    [co2, ok] = readInterpTSG_CO2(co2interpCo2_O2File);
    
    
    if ~ok
        error('readinterpCo2_O2TSG_CO2');
    end
    
    % Get the o2 data
    % o2 is a struct with the following data :
    % DATE % Has been removed because it is useless
    % DAYD
    % OXYGEN_RAW
    % OXYGEN_SATURATION
    % OXYGEN_TEMPERATURE
    [o2, ok] = readAsciiO2(o2File);
    
    if ~ok
        return
    end
    
    disp("CO2 O2 interpolation...");
    [co2] = interpolation(co2,o2);
    
    % Adjusting O2 DATA
    % default salinity setting is 0
    disp("Correcting O2 Data...");
    [co2] = correctO2Data(co2, 0);
    
    interpFile = writeInterpolation(co2);
end

    

