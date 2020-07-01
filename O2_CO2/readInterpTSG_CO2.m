function co2 = readInterpTSG_CO2(fileIn)
    % Get the co2 data from the previous interpolation
    % Input :
    % * fileIn  : the interpolation file produce by "interpTSG_CO2" function
    % Output :
    % * co2     : the structure extracted from the file
    disp("... Reading the data from TSG/CO2 interpolation");
    
    % File opening check
    fid    = fopen( fileIn, 'r' );
    if(fid == -1)
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
    
    % *1
    co2 = struct;
    % Manual conversion to structure
    % table2struct format do not produce a good structure
    for i = 1:size(varNames,2)
        co2.(char(varNames(i))) = co2Data.(char(varNames(i)));
    end

    % if this work, remove the code after *1 to this comment
    % co2 = table2struct(co2Data,'ToScalar',true);
    
    disp("... readInterpTSG_CO2 : DONE");
end