% Get the co2 data from the previous interpolation
function [co2, ok] = readInterpTSG_CO2(fileIn, varargin)

    if nargin ~= 1 || isempty(fileIn)
        [FileIn, PathIn] = uigetfile( '*.csv', 'Read file name', 'MultiSelect','off');
        fileIn = char([PathIn FileIn]);
    end
    
    % File opening check
    fid    = fopen( fileIn, 'r' );
    if(fid == -1)
        ok = false;
        error('File not found');
    end
    fclose( fid );
    
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
    delimiter = ';';
    opts = delimitedTextImportOptions('VariableNames',varNames,...
                                    'VariableTypes',varTypes,...
                                    'Delimiter',delimiter);
    co2Data = readtable(fileIn, opts);
    % We suppress the header
    co2Data(1,:) = [];
    co2Data(:,36) = [];
    
    co2 = struct;
    % Manual conversion to structure
    % table2struct format does not produce a good structure
    for i = 1:size(varNames,2)
        co2.(char(varNames(i))) = co2Data.(char(varNames(i)));
    end
    co2.DAYD = serialDate(co2);
    
    ok = true;
end