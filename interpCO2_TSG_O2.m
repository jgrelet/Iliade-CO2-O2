function interpCO2_TSG_O2(co2File, tsgFile, o2File)
    % With this function, you will be able to run all interpolations
    % Input files :
    % 1. co2 => .csv
    % 2. tsg => .tsgqc
    % 3. o2  => .oxy
    
    % If there is no input parameter, the user will have to get them
    if nargin == 0
        % CO2 file
        disp("Select the CO2 file");
        [FileIn, PathIn] = uigetfile( '*i.csv', 'Select the CO2 file', 'MultiSelect','off');
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

        USER_PATH_FILE = PathIn;
        
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