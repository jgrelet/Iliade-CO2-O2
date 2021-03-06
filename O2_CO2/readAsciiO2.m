function o2 = readAsciiO2(fileIn)
    % Read O2 from an ASCII file 
    %
    % Input :
    % * fileIn : File to read
    % Output
    % * o2     : Structure with the relevant o2 data
    
    disp("... Reading data from oxygen file");
    % CONSTANT
    fieldNumber = 25;
    header = ["yearmonthday", "hourminutesecond", ...
        "measurement", "sensor_number", "serial_number",...
        "oxygen", "oxygen_val",...
        "saturation", "saturation_val",...
        "temperature", "temperature_val",...
        "DPhase", "DPhase_val",...
        "BPhase", "BPhase_val",...
        "RPhase", "RPhase_val",...
        "BAmp", "BAmp_val",...
        "BPot", "BPot_val",...
        "RAmp", "RAmp_val",...
        "RawTem", "RawTem_val",...
        ];

    % ouverture du fichier
    % --------------------
    fid    = fopen( fileIn, 'r' );

    % Check file
    % -----------
    if(fid == -1)
        error('File not found');
    end

    % We can put the format in the toml file
    % it will allow to update the data input in case of equipment changes

    % Build of the header

    format = '';
    for i = 1 : fieldNumber
        format = [format ' %s'];
    end

    % Read the file
    cellData = textscan( fid, format);
    % Transform the cells into a structure
    s = cell2struct(cellData, header, 2);

    % handle of the date so we will be able to compare with CO2 data
    [year, monthday] = strtok(s.yearmonthday, '-');
    [month, day] = strtok(monthday, '-');
    day = erase(day, '-');

    [hour, minutesecond] = strtok(s.hourminutesecond, ':');
    [minute, second] = strtok(minutesecond, ':');
    second = erase(second, ':');

    %o2.DATE = [year month day hour minute second];

    %Convert the date to the date format
    year = str2double(year);
    month = str2double(month);
    day = str2double(day);

    hour = str2double(hour);
    minute = str2double(minute);
    second = str2double(second);

    o2.DAYD = datenum(year, month, day, hour, minute, second);

    o2.OXYGEN_RAW = str2double(s.oxygen_val);
    o2.OXYGEN_SATURATION = str2double(s.saturation_val);
    o2.OXYGEN_TEMPERATURE = str2double(s.temperature_val);

    % Close the file
    % --------------
    fclose( fid );
    
    disp("... readAsciiO2 : DONE");

end
