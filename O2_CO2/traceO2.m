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
    
    colors = colormap(jet);
    % Get only the real data
    data = real(co2.OXYGEN_ADJ_muM);
    %disp(co2);
    maxVal = max(data);
    ind = data > 0;
    data = data(ind);
    step = maxVal / size(colors,1);
    
    disp("... Printing map");
    margin = 10;
    maxLat = max(co2.LATX);
    minLat = min(co2.LATX);
    
    maxLon = max(co2.LONX);
    minLon = min(co2.LONX);
    map = figure('Name','map','NumberTitle','off');
    m_proj('Mercator','longitudes', [minLon - margin maxLon + margin],...
        'latitudes',[minLat - margin maxLat + margin]);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid;
    
    % Colorbar
    m_contfbar( [.3 .7],.98, data,[-300:1210],...
            'axfrac',.02,'endpiece','no','levels','match','edgecolor','none'); 
    % Trip of the boat
    m_line(co2.LONX, co2.LATX, 'color', 'black');
    
    for i = 1:size(colors)
        ids = find(round((data ./ step), 0) == i);
        m_line(co2.LONX(ids), co2.LATX(ids),'LineStyle', 'none', 'marker', 'o', 'markersize', 1 ,'color', colors(i,:));
    end
    % we close the fig one which is opened by m_proj
    close Figure 1
    
    % OXYGEN µM
    clear ind
    clear dates
    ind = co2.OXYGEN_ADJ_muM > 0;
    dates = co2.DATE_TIME(ind);
    dates = datetime(dates, 'Format', 'dd/MM/yyyy HH:mm:SS');

    muM = figure('Name','Oxygen Compensated µM','NumberTitle','off');

    plot(dates, co2.OXYGEN_ADJ_muM(ind), 'color','black');
    title('Oxygen Compensated µM')
    xlabel('Date')
    ylabel('µM');
    
    % OXYGEN ml/l
    clear ind
    clear dates
    ind = co2.OXYGEN_ADJ_MLL > 0;
    dates = co2.DATE_TIME(ind);
    dates = datetime(dates, 'Format', 'dd/MM/yyyy HH:mm:SS');
    
    mll = figure('Name','Oxygen Compensated ml/l','NumberTitle','off');
    plot(dates, co2.OXYGEN_ADJ_MLL(ind), 'color','black');
    title('Oxygen Compensated ml/l')
    xlabel('Date')
    ylabel('ml/l');
    
    figure(map);
end