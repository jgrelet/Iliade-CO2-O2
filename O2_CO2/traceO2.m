function traceO2(fileIn)
    % This function will show the quantity of O2 during a period of time
    
    % Get data from file
    if nargin ~= 1
        disp("Select the O2/CO2 interpolation file");
       [FileIn, PathIn] = uigetfile( '*.csv', 'Select the O2/CO2 interpolation file', 'MultiSelect','off', '../tests');
       fileIn = char([PathIn FileIn]);
       disp(fileIn);
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
    
    disp("... Getting min and max lat/lon");
    margin = 10;
    maxLat = max(co2.LATX);
    minLat = min(co2.LATX);
    
    maxLon = max(co2.LONX);
    minLon = min(co2.LONX);
    
    m_proj('mercator','longitudes', [minLon - margin, maxLon + margin],...
        'latitudes',[minLat - margin, maxLat + margin]);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid;
    
    disp("... Defining color for data");
    
    colors = colormap;
    % Get only the real data
    data = real(co2.OXYGEN_ADJ_muM);
    %disp(co2);
    maxVal = max(data);
    ind = find(data > 0);
    data = data(ind);
    step = maxVal / size(colors,1);
    idx = round((data ./ step), 0);
    rdx = idx ~= 0;
    cols = [ colors(idx(rdx), 1), colors(idx(rdx), 2), colors(idx(rdx), 3) ];
    %m_line(co2.LONX, co2.LATX, 'color',...
    %   cols );
end