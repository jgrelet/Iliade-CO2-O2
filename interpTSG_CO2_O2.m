function interpTSG_CO2_O2(co2InterpFile, o2File, varargin)
    %
    % Interpolation of O2 measure at co2 dates.
    % At the end, we will add the following columns to the .csv:
    % O2_RAW      oxygen raw values
    % O2_ADJ      oxygen values adjusted
    % SATURATION  saturation
    %
    % Input :
    % 1 - .csv file from function "interpTSG_CO2"
    %     data is read with read interp
    % 2 - Fichier ASCII de mesures TSG
    %     Le fichier est ouvert via la fonction "readAsciiTsgCO2"
    %
    % External function call :
    % readAsciiO2 readInterpTSG_CO2
    %
    % Internal functions :
    % serialDate


    % Reading of the CO2 and TSG interpolation
    if nargin ~=2
        
        [co2InterpFile, co2FileIn] = uigetfile( '*.csv', 'Read file name', 'MultiSelect','off');
        
        co2InterpFile = char([co2FileIn co2InterpFile]);
        disp(char(co2InterpFile))
        
        [o2File, o2FileIn] = uigetfile( '*.oxy', 'Read file name', 'MultiSelect','off');
        
        o2File = char([o2FileIn o2File]);
        disp(char(o2File))
    end
    % Get the co2 struct from the interpolation file
    [co2, ok] = readInterpTSG_CO2(co2InterpFile);
    
    
    if ~ok
        error('readInterpTSG_CO2');
    end
    
    % Get the o2 data
    % o2 is a struct with the following data :
    % DATE % Has been removed because it is useless
    % DAYD
    % OXYGEN_RAW
    % SATURATION
    % TEMPERATURE
    [o2, ok] = readAsciiO2(o2File);
    
    if ~ok
        return
    end
    [co2] = interp(co2,o2);
    
end
    
% Convert the date in serial date format
function dayd = serialDate(co2Data)
% dd/mm/yyyy hh:mm:ss
    dates = char(co2Data.DATE_TIME);
    %disp(dates);
    
    format = 'dd/mm/yyyy HH:MM:SS';
    dayd = datenum(dates, format);
    
end

function [co2] = interp(co2, o2)

    PARA = {'OXYGEN_RAW', 'SATURATION', 'TEMPERATURE'};
    % Conversion of the date in serial date
    dayd = serialDate(co2);
    for par = PARA
        par = char(par);
        co2.(par)    = ones(size(dayd));
        
        % Definition of time borders for the interpolation of co2 and o2 data
    
        indmin = 1;
        if dayd(1) < o2.DAYD(1)
            A = find( dayd > o2.DAYD(1) );
            if ~isempty(A)
                indmin = A(1);
            end
        end

        indmax = size(dayd,1);
        if dayd(end) > o2.DAYD(end)
            A = find( dayd < o2.DAYD(end) );
            if ~isempty(A)
                indmax = A(end);
            end
        end
        
        co2.(par)(indmin:indmax) = interp1(o2.DAYD, o2.(par), dayd(indmin:indmax));
        
    end % end for
    
    disp(co2.OXYGEN_RAW);
    
end
    
    

