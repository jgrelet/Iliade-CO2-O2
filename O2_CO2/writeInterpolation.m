function interpFile = writeInterpolation(co2)
    disp("... Choose the location for the result file interpolation O2/CO2 ");
    [FileOut,PathOut] = uiputfile('*.csv','O2 CO2 interpolation result file');
    interpFile = strcat(PathOut, FileOut);
    fidOut = fopen( [PathOut FileOut], 'w' );


    if fidOut == -1
        msg_error = ['Open file error : ' FileOut];
        warndlg( msg_error, 'ASCII error dialog');
    else
        disp(strcat("... Writing results in : ", interpFile));
        % We remove the DAYD field
        co2 = rmfield(co2, 'DAYD');
        struct2csv(co2,interpFile);
        fclose(fidOut);
    end
    disp("... writeInterpolation : DONE");
end