function interpFile = writeInterpolation(co2)
    % Ecriture
    HeaderOut = ['DATE_TIME;GPS_TIME;TYPE;ERROR;LATX;LONX;'...
                'LATX_INT;LONX_INT;'...
                'EQU_T;STD;CO2_RAW;CO2_PHYS;H2O_RAW;H2O_PHYS;'...
                'LICOR_T;LICOR_P;ATM_P;EQU_P;H2O_FLOW;LICOR_FLOW;'...
                'EQU_PUMP;VENT_FLOW;COND_T;COND_ATM;COND_EQU;'...
                'DRIP_1;DRIP_2;DRY_BOX_T;DECK_BOX_T;'...
                'SSPS;SSPS_QC;SSJT;SSJT_QC;SSJT_COR;EQU_T_COR;'...
                'OXYGEN_RAW;OXYGEN_ADJ_muM;OXYGEN_ADJ_MLL;OXYGEN_SATURATION;OXYGEN_TEMPERATURE;'...
                ];

    formatOut = ['%02d/%02d/%4d %02d:%02d:%02d;'...
                '%s; %s; %d;%.4f;%.4f;'...
                '%.4f;%.4f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '%.3f;%.0f;%.3f;%.0f;%.2f;%.2f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '\n'];
                
    [FileOut,PathOut] = uiputfile('*.csv','Fichier en écriture');
    interpFile = strcat(PathOut, FileOut);
    fidOut = fopen( [PathOut FileOut], 'w' );


    if fidOut == -1
        msg_error = ['Open file error : ' FileOut];
        warndlg( msg_error, 'ASCII error dialog');
    else
        co2.GPS_TIME = char(cellstr(co2.GPS_TIME));
        co2.TYPE = char(cellstr(co2.TYPE));

        c = struct2cell(co2);
        
        % Number of columns
        n = size(c, 1);
        % Number of line 
        m = size(c{1},1);
        
        % Data extraction of integers and reshape of the matrix
        x = cell2mat(c(5:n));
        x = reshape(x,m,n-4);
        
        [Y, M, D, H, MN, S] = datevec(c{1});
        date = [D,M,Y,H,MN,S];

        fprintf( fidOut,'%s\n', HeaderOut);
        for i=1:m
            fprintf( fidOut, formatOut, date(i,:), co2.GPS_TIME(i,:), co2.TYPE(i,:),x(i,:));
        end

        fclose(fidOut);
    end

end