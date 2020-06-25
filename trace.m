function trace(o2Co2File)

    fileName = mfilename;
    fulFilename = mfilename('fullpath');
    expr = strcat(fileName, '$');
    DEFAULT_PATH_FILE =  regexprep(fulFilename, expr, '');
    
    addpath(strcat(DEFAULT_PATH_FILE,filesep,"TSG_CO2"));
    addpath(strcat(DEFAULT_PATH_FILE,filesep,"O2_CO2"));
    
    traceCO2;
    traceO2(o2Co2File);

    rmpath(strcat(DEFAULT_PATH_FILE,filesep,"TSG_CO2"));
    rmpath(strcat(DEFAULT_PATH_FILE,filesep,"O2_CO2"));

end

function getStructure


end