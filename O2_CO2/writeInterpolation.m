function interpFile = writeInterpolation(co2)
    disp("... Choose the location for the result file interpolation O2/CO2 ");
    [FileOut,PathOut] = uiputfile('*.csv','O2 CO2 interpolation result file');
    interpFile = strcat(PathOut, FileOut);
    fidOut = fopen( [PathOut FileOut], 'w' );


    if fidOut == -1
        msg_error = ['Open file error : ' FileOut];
        warndlg( msg_error, 'ASCII error dialog');
    else
        disp(strcat("... Writing results in : ", interpFile, " Please wait ..."));
        % We remove the DAYD field
        co2 = rmfield(co2, 'DAYD');
        % We create an additonnal field to sort the data by the date
        % (some data were not sorted correctly)
        co2.TEMP_DATETIME = datetime(co2.DATE_TIME,'InputFormat','dd/MM/yyyy HH:mm:ss');
        
        % In order to sort, we need a table
        T = struct2table(co2);
        sortedT = sortrows(T, 'TEMP_DATETIME');
        
        % We go back to a structure
        co2 = table2struct(sortedT,'ToScalar',true);
        % we remove the temp field
        co2 = rmfield(co2, 'TEMP_DATETIME');
        
        % Wrting data to the file
        struct2csv(co2,interpFile);
        fclose(fidOut);
    end
    disp("... writeInterpolation : DONE");
end