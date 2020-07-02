function traceMap(fileIn)
    % Print two maps with CO2 and O2 data
    % Input file : CO2 O2 result file from "interpCO2_O2" program
    % You need the m_map package to run this function


    % Get data from file
    if nargin ~= 1
        disp("Select the O2/CO2 interpolation file");
       [FileIn, PathIn] = uigetfile( '*.csv', 'Select the O2/CO2 interpolation file', 'MultiSelect','off');
       fileIn = char([PathIn FileIn]);
       disp(fileIn);
    end

    % File opening check
    fid    = fopen( fileIn, 'r' );
    if(fid == -1)
        error('File not found');
    end
    fclose( fid );

    co2 = readCO2_O2(fileIn);

    %% Map parameters
    % Allow a projection a bit bigger than the area in the file
    margin = 10;

    % Get the min and max latitudes
    maxLat = max(co2.LATX);
    minLat = min(co2.LATX);
    % Get the min and max longitudes
    maxLon = max(co2.LONX);
    minLon = min(co2.LONX);
    
        
    %% O2 Map
    colorsO2 = m_colmap('jet');
    
    maxVal = 300; % maximum value of O2
    
    % Get only the real data
    data = real(co2.OXYGEN_ADJ_muM);

    % We select the data > 0. The rest is the default data
    ind = data > 0;
    data = data(ind);
    step = maxVal / size(colorsO2,1);

    disp("... Printing map");

    % Creating the figure for the map
    map = figure('Name','map','NumberTitle','off',...
    'Position',[1000 300 500 600]);

    % Use of the M_MAP library
    m_proj('Mercator','longitudes', [minLon - margin maxLon + margin],...
    'latitudes',[minLat - margin maxLat + margin]);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid;
    title("O2 \muM concentration during the trip",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','none');

    % Colorbar
    % [posX posY] height, data, [gap]
    h = m_contfbar( [.3 .7],-.085, data,(0:maxVal),...
        'axfrac',.02,'endpiece','no','edgecolor','none',...
        'levels', step); 
    title(h,"O2 \muM concentration",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','none');

    % Trip of the boat
    m_line(co2.LONX, co2.LATX, 'color', 'black');

    for i = 1:size(colorsO2)
    % Select of the color depending on the value of O2 µM
    ids = find(round((data ./ step), 0) == i);
    m_line(co2.LONX(ids), co2.LATX(ids),'LineStyle', 'none',...
        'marker', '.', 'markersize', 5 ,'color', colorsO2(i,:));
    end
    
    %% CO2 Map
    maxVal = 300; % max value of CO2

    colorsCO2 = m_colmap('jet');
    % Get only the real data
    data = real(co2.CO2_PHYS);

    % We select the data > 0. The rest is the default data
    ind = data > 0;
    data = data(ind);
    step = maxVal / size(colorsCO2,1);

    disp("... Printing map");

    % Creating the figure for the map
    map2 = figure('Name','CO2 Map','NumberTitle','off',...
    'Position',[400 300 500 600]);

    % Use of the M_MAP library
    m_proj('Mercator','longitudes', [minLon - margin maxLon + margin],...
    'latitudes',[minLat - margin maxLat + margin]);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid;
    title("CO2 concentration during the trip",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','none');

    % Colorbar
    % [posX posY] height, data, [gap]
    h = m_contfbar( [.3 .7],-.085, data,(0:maxVal),...
        'axfrac',.02,'endpiece','no','edgecolor','none',...
        'levels', step); 
    title(h,"CO2 concentration",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','none');

    % Trip of the boat
    m_line(co2.LONX, co2.LATX, 'color', 'black');

    for i = 1:size(colorsCO2)
    % Select of the color depending on the value of O2 µM
    ids = find(round((data ./ step), 0) == i);
    m_line(co2.LONX(ids), co2.LATX(ids),'LineStyle', 'none',...
        'marker', '.', 'markersize', 5 ,'color', colorsCO2(i,:));
    end

    
    close Figure 1
end