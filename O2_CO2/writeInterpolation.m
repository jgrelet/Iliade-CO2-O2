function interpFile = writeInterpolation(co2)

    disp("Choose the location of the result file");
    [FileOut,PathOut] = uiputfile('*.csv','Choose the location of the result file');
    interpFile = strcat(PathOut, FileOut);
    fidOut = fopen( [PathOut FileOut], 'w' );


    if fidOut == -1
        msg_error = ['Open file error : ' FileOut];
        warndlg( msg_error, 'ASCII error dialog');
    else
        struct2csv(co2,interpFile);
        fclose(fidOut);
    end
    disp("writeInterpolation : OK");
end