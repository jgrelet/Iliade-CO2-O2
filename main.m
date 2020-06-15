function main(co2File, tsgFile, o2File)
    % With this function, you will be able to run all interpolations
    % Input files :
    % co2 => .csv
    % tsg => .tsgqc
    % o2  => .oxy
    
    
    addpath("TSG_CO2");
    addpath("O2_CO2");
    addpath("struct2csv");
    
    % If there is no input parameter, the user will have to get them
    if nargin == 0
        % CO2 file
        [FileIn, PathIn] = uigetfile( '*.csv', 'Read file name', 'MultiSelect','off', 'tests/exemple');
        co2File = char([PathIn FileIn]);
        disp(char(co2File));

        % TSG file
        [FileIn, PathIn] = uigetfile( '*.tsgqc', 'Read file name', 'MultiSelect','off', 'tests/exemple');
        tsgFile = char([PathIn FileIn]);
        disp(char(tsgFile));
        
        % O2 file
        [FileIn, PathIn] = uigetfile( '*.oxy', 'Read file name', 'MultiSelect','off', 'tests/exemple');
        o2File = char([PathIn FileIn]);
        disp(char(o2File));
    end
    
    if ~exist("figs", 'dir')
       mkdir("figs")
    end
    
    tsgCo2InterpFile = interpTSG_CO2(co2File, tsgFile);
    o2Co2interpFile = interpCO2_O2(tsgCo2InterpFile , o2File);
    
    disp(strcat("TSG and CO2 interpolation saved in : ", tsgCo2InterpFile));
    disp(strcat("O2 and CO2 interpolation saved in : ", o2Co2interpFile));

end