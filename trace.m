function trace(o2Co2File)

    addpath("TSG_CO2");
    addpath("O2_CO2");
    
    traceCO2;
    traceO2(o2Co2File);

    rmpath("TSG_CO2");
    rmpath("O2_CO2");

end