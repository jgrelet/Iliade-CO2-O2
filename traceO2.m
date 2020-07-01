function traceO2(fileIn)
    % This function will show the quantity of O2 during a period of time
    
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
    
    %% Display of charts
    % OXYGEN µM
    clear ind
    clear dates
    ind = co2.OXYGEN_ADJ_muM > 0;
    dates = co2.DATE_TIME(ind);
    dates = datetime(dates, 'Format', 'dd/MM/yyyy HH:mm:SS');

    figure('Name','Oxygen Compensated µM','NumberTitle','off',...
        'Position',[200 150 500 350]);

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
    
    figure('Name','Oxygen Compensated ml/l','NumberTitle','off',...
        'Position',[700 150 500 350]);
    plot(dates, co2.OXYGEN_ADJ_MLL(ind), 'color','black');
    title('Oxygen Compensated ml/l')
    xlabel('Date')
    ylabel('ml/l');
    
    figure(map);
end