function interpTSG_CO2_O2(co2InterpFile, varargin)
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
% readAsciiO2
%
% Internal functions :
% selectTSG, interp

% Reading of the CO2 and TSG interpolation
if nargin ~= 1 || isempty(co2InterpFile)
    [FileIn, PathIn] = uigetfile( '*.csv', 'Read file name', 'MultiSelect','off');
    if FileIn == 0
      msg_error = ['Open file error : ' FileIn];
      warndlg( msg_error, 'Open file');
      return;
    end
    fileIn = char([PathIn FileIn]);
    disp(char(fileIn))
else
    fileIn = co2InterpFile;
    [~,name,ext] = fileparts(fileIn);
    FileIn = char([name ext]);
    disp(char(fileIn))
end
    
% Read the file
varNames = {'DATE_TIME', 'GPS_TIME', 'TYPE', 'ERROR', 'LATX', 'LONX',...
            'LATX_INT','LONX_INT',...
            'EQU_T', 'STD', 'CO2_RAW', 'CO2_PHYS', 'H2O_RAW', 'H2O_PHYS', ...
            'LICOR_T', 'LICOR_P', 'ATM_P', 'EQU_P', 'H2O_FLOW', 'LICOR_FLOW', ...
            'EQU_PUMP', 'VENT_FLOW', 'COND_T', 'COND_ATM', 'COND_EQU', ...
            'DRIP_1', 'DRIP_2', 'DRY_BOX_T', 'DECK_BOX_T', ...
            'SSPS', 'SSPS_QC', 'SSJT', 'SSJT_QC', 'SSJT_COR', 'EQU_T_COR'} ;
        
varTypes = {'char','char','char','single','double','double',...
            'double', 'double', ...
            'double', 'double', 'double', 'double', 'double', 'double', ...
            'double', 'double', 'double', 'double', 'double', 'double', ...
            'double', 'double', 'double', 'double', 'double', ...
            'double', 'double', 'double', 'double', ...
            'double', 'double', 'double', 'double', 'double', 'double'
    } ;
delimiter = ';'
opts = delimitedTextImportOptions('VariableNames',varNames,...
                                'VariableTypes',varTypes,...
                                'Delimiter',delimiter);
co2Data = readtable(fileIn, opts);

