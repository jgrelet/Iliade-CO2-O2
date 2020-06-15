function interpFile = writeInterpolation(co2)
    [FileOut,PathOut] = uiputfile('*.csv','Fichier en écriture');
    interpFile = strcat(PathOut, FileOut);
    fidOut = fopen( [PathOut FileOut], 'w' );


    if fidOut == -1
        msg_error = ['Open file error : ' FileOut];
        warndlg( msg_error, 'ASCII error dialog');
    else
        struct2csv(co2,interpFile);
        fclose(fidOut);
    end

end