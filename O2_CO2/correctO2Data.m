function [co2] = correctO2Data(co2, salinity)
    % Correct the co2 data. This function is called by "interpCO2_O2" function
    % Input :
    % co2       : the co2 structure
    % salinity  : salinity setting (default is 0)
    % Output the co2 structure with new columns :
    % * OXYGEN_ADJ_muM      : The oxygen concentration in \muM
    % * OXYGEN_ADJ_MLL      : The oxygen concentration in ml/l
    % * OXYGEN_SATURATION   : The oxygen saturation in %

    disp("... Correcting O2 data");
    depth = 0;
    S = co2.SSPS; % salinity
    T = co2.SSJT; % temperature
    P = co2.LICOR_P; % pressure
    O2 = co2.OXYGEN_RAW; % raw oxygen
    
    % It is useless to proceed to the computation if the oxygen data is not
    % here. So we take all the data different from the default value
    ind = find(co2.OXYGEN_RAW ~= -999);
    
    CpC = 0.032; % Coeficient for pressure compensation
    % Solubility compensation coeficient
    A0 = 2.00856;
    A1 = 3.22400;
    A2 = 3.99063;
    A3 = 4.80299;
    A4 = 9.78188e-1;
    A5 = 1.71069;
    
    % Salinity compensation coeficient
    B0 = -6.24097e-3;
    B1 = -6.93498e-3;
    B2 = -6.90358e-3;
    B3 = -4.29155e-3;
    
    C0 = -3.11680e-7;


    x = 298.15-T(ind);
    y = 273.15+T(ind);
    
    disp("... Computing scaled temperature");
    scaledTemperature = log( x ./ y );
    
    disp("... Computing solubility");
    solubility = (P(ind)./1013.25) .* 44.659 .* ...
        exp( ...
        A0 + ...
        A1 .* scaledTemperature +...
        A2 .* scaledTemperature.^2+...
        A3 .* scaledTemperature.^3+...
        A4 .* scaledTemperature.^4+...
        A5 .* scaledTemperature.^5+...
        S(ind) .* (B0 + ...
        B1 .* scaledTemperature + ...
        B2 .* scaledTemperature.^2 + ...
        B3 .* scaledTemperature.^3 ) + ...
        C0*S(ind).^2 ...
        );
    
    disp("... Computing salinity compensation");
    salinityCompensation = exp((S(ind) - salinity) .* ...
        (B0 + ...
        B1 .* scaledTemperature + ...
        B2 .* scaledTemperature.^2 + ...
        B3 .* scaledTemperature.^3) + ...
        C0 .* (S(ind).^2 - salinity.^2)...
        );
    
    %depthCompensation = O2(ind) .* (1 + (0.032*depth)/1000);
    disp("... Computing pressure compensation");
    pressureCompensation = ((abs(depth) ./1000) * CpC) +1;
    
    disp("... Computing o2 concentration");
    o2Concentration_muM = O2(ind).*salinityCompensation .* pressureCompensation;
    o2Concentration_MLL = o2Concentration_muM./44.615;
    
    disp("... Computing O2 Saturation");
    o2Saturation = 100 .* o2Concentration_muM ./ solubility;
    
    disp("... Writing data to structure");
    % Default value is -999 which is an unreachable value for these data
    co2.OXYGEN_ADJ_muM = -999 * ones(size(co2.SSJT)); % default value
    co2.OXYGEN_ADJ_MLL = -999 * ones(size(co2.SSJT)); % default value
    co2.OXYGEN_SATURATION = -999 * ones(size(co2.SSJT)); % default value
    
    disp("... Removing irrelevant data");
    
    o2Concentration_muM = real(o2Concentration_muM);
    co2.OXYGEN_ADJ_muM(ind) = o2Concentration_muM;
    
    o2Concentration_MLL = real(o2Concentration_MLL);
    co2.OXYGEN_ADJ_MLL(ind) = o2Concentration_MLL;
    
    o2Saturation = real(o2Saturation);
    co2.OXYGEN_SATURATION(ind) = o2Saturation;
    disp("... correctO2Data : DONE");
    
end
