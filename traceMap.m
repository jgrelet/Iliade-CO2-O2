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

    data = readCO2_O2(fileIn);

    %% Map parameters
    % Allow a projection a bit bigger than the area in the file
    margin = 10;

    % Get the min and max latitudes
    maxLat = max(data.LATX);
    minLat = min(data.LATX);
    % Get the min and max longitudes
    maxLon = max(data.LONX);
    minLon = min(data.LONX);
    
        
    %% O2 Map
    colorsO2 = m_colmap('jet');
    
    % Get only the real data
    o2 = real(data.OXYGEN_ADJ_muM);
    
    % We select the o2 > 0. The rest is the default data
    ind = o2 > 0;
    o2 = o2(ind);
    maxVal = max(o2); % maximum value of O2
    step = maxVal / size(colorsO2,1);

    disp("... Printing map");

    % Creating the figure for the map
    figure('Name','02 map','NumberTitle','off',...
    'Position',[1000 300 500 600]);

    % Use of the M_MAP library
    m_proj('Mercator','longitudes', [minLon - margin maxLon + margin],...
    'latitudes',[minLat - margin maxLat + margin]);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid;
    title("O2 \muM concentration during the trip",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','tex');

    % Colorbar
    % [posX posY] height, o2, [gap]
    h = m_contfbar( [.3 .7],-.085, o2,(0:maxVal),...
        'axfrac',.02,'endpiece','no','edgecolor','none',...
        'levels', step); 
    title(h,"O2 \muM concentration",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','tex');

    % Trip of the boat
    m_line(data.LONX, data.LATX, 'color', 'black');

    for i = 1:size(colorsO2)
    % Select of the color depending on the value of O2 µM
    ids = find(round((o2 ./ step), 0) == i);
    m_line(data.LONX(ids), data.LATX(ids),'LineStyle', 'none',...
        'marker', '.', 'markersize', 5 ,'color', colorsO2(i,:));
    end
    
    
    %% CO2 Map
    colorsCO2 = m_colmap('jet');
    % Get only the real data
    co2 = real(data.CO2_PHYS);
    type = data.TYPE;

    % We select the co2 == 'EQU'. The rest is the default data
    ind = strcmp(type,'EQU');
    co2 = co2(ind);
%     i = find(co2 > 1000);
%     for j=1:size(i) 
%       fprintf(1, '%d  %f\n',i(j), co2(i(j)));
%     end
%    maxVal = max(co2); % maximum value of O2
    minVal = 300;
    maxVal = 800;
    step = maxVal / size(colorsCO2,1);

    disp("... Printing map");

    % Creating the figure for the map
    figure('Name','CO2 Map','NumberTitle','off',...
    'Position',[400 300 500 600]);

    % Use of the M_MAP library
    m_proj('Mercator','longitudes', [minLon - margin maxLon + margin],...
    'latitudes',[minLat - margin maxLat + margin]);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid;
    title("CO2 concentration during the trip",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','none');

    % Colorbar
    % [posX posY] height, co2, [gap]
    h = m_contfbar( [.3 .7],-.085, co2,(minVal:maxVal),...
        'axfrac',.02,'endpiece','no','edgecolor','none',...
        'levels', step); 
    title(h,"CO2 concentration",  'fontsize',10,...
    'fontweight', 'bold', 'interpreter','none');

    % Trip of the boat
    m_line(data.LONX, data.LATX, 'color', 'black');

    for i = 1:size(colorsCO2)
    % Select of the color depending on the value of O2 uM
    ids = find(round((co2 ./ step), 0) == i);
    m_line(data.LONX(ids), data.LATX(ids),'LineStyle', 'none',...
        'marker', '.', 'markersize', 5 ,'color', colorsCO2(i,:));
    end
    

end