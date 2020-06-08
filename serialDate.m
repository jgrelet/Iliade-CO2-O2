function dayd = serialDate(co2Data)
    % Convert the date in serial date format
    % dd/mm/yyyy hh:mm:ss
    dates = char(co2Data.DATE_TIME);
    %disp(dates);
    
    format = 'dd/mm/yyyy HH:MM:SS';
    dayd = datenum(dates, format);
    
end