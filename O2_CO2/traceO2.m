function traceO2(fileIn)
    % This function will show the quantity of O2 during a period of time
    
    %% Get data from file
    if nargin == 0
       [FileIn, PathIn] = uigetfile( '*.csv', 'Read CO2 file name', 'MultiSelect','off');
           fileIn = char([PathIn FileIn]);
    end
    
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
                'SSPS', 'SSPS_QC', 'SSJT', 'SSJT_QC', 'SSJT_COR', 'EQU_T_COR', ...
                'OXYGEN_RAW','OXYGEN_ADJ_muM','OXYGEN_ADJ_MLL','OXYGEN_SATURATION','OXYGEN_TEMPERATURE'} ;

    varTypes = {'char','char','char','single','double','double',...
                'double', 'double', ...
                'double', 'double', 'double', 'double', 'double', 'double', ...
                'double', 'double', 'double', 'double', 'double', 'double', ...
                'double', 'double', 'double', 'double', 'double', ...
                'double', 'double', 'double', 'double', ...
                'double', 'double', 'double', 'double', 'double', 'double', ...
                'double', 'double', 'double', 'double', 'double'
        } ;
    delimiter = ';';
    opts = delimitedTextImportOptions('VariableNames',varNames,...
                                    'VariableTypes',varTypes,...
                                    'Delimiter',delimiter);
    co2Data = readtable(fileIn, opts);
    % We suppress the header
    co2Data(1,:) = [];
    co2Data(:,41) = [];
    
    co2 = struct;
    % Manual conversion to structure
    % table2struct format do not produce a good structure
    for i = 1:size(varNames,2)
        co2.(char(varNames(i))) = co2Data.(char(varNames(i)));
    end
    
    %% Trace of the O2 Compensated data in µM
    % We are looking for the data that is not the default data
    ind = find(co2.OXYGEN_ADJ_muM >= 0);
    
    dates = co2.DATE_TIME(ind);
    dates = datetime(dates, 'Format', 'dd/MM/yyyy HH:mm:SS');
    
    figure('Name','Oxygen Compensated µM','NumberTitle','off');
    plot(dates, co2.OXYGEN_ADJ_muM(ind));
    

end