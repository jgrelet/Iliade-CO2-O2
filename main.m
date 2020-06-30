function main(co2File, tsgFile, o2File)
    % With this function, you will be able to run all interpolations
    % Input files :
    % co2 => .csv
    % tsg => .tsgqc
    % o2  => .oxy
    
    fileName = mfilename;
    fulFilename = mfilename('fullpath');
    expr = strcat(fileName, '$');
    DEFAULT_PATH_FILE =  regexprep(fulFilename, expr, '');
    
    addpath(strcat(DEFAULT_PATH_FILE,filesep,"TSG_CO2"));
    addpath(strcat(DEFAULT_PATH_FILE,filesep,"O2_CO2"));
    
    % If there is no input parameter, the user will have to get them
    if nargin == 0
        % CO2 file
        disp("Select the CO2 file");
        [FileIn, PathIn] = uigetfile( '*.csv', 'Select the CO2 file', 'MultiSelect','off');
        co2File = char([PathIn FileIn]);
        
        fid = fopen(co2File, 'r');
        if fid == -1
            error("File not found");
        end
        fclose(fid);
        
        USER_PATH_FILE = PathIn;

        % TSG file
        disp("Select the TSG file");
        [FileIn, PathIn] = uigetfile( '*.tsgqc', 'Select the TSG file', 'MultiSelect','off', USER_PATH_FILE);
        tsgFile = char([PathIn FileIn]);
        
        fid = fopen(tsgFile, 'r');
        if fid == -1
            error("File not found");
        end
        fclose(fid);
        
        % O2 file
        disp("Select the O2 file");
        [FileIn, PathIn] = uigetfile( '*.oxy', 'Select the O2 file', 'MultiSelect','off', USER_PATH_FILE);
        o2File = char([PathIn FileIn]);
        
        fid = fopen(o2File, 'r');
        if fid == -1
            error("File not found");
        end
        fclose(fid);
    end
    disp("=== Files ===");
    disp(char(co2File));
    disp(char(tsgFile));
    disp(char(o2File));
    disp("=============");
    
    disp(">> Interpolation of TSG and CO2 data");
    tsgCo2InterpFile = interpTSG_CO2(co2File, tsgFile);
    disp(">> Interpolation of O2 and CO2 data");
    o2Co2interpFile = interpCO2_O2(tsgCo2InterpFile , o2File);
    
    disp(strcat(">> TSG and CO2 interpolation saved in : ", tsgCo2InterpFile));
    disp(strcat(">> O2 and CO2 interpolation saved in : ", o2Co2interpFile));

end