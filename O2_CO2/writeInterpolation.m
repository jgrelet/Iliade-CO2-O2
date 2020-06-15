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

    formatOut = ['%02d/%02d/%4d %02d:%02d:%02d;'... % DATE_TIME
                '%s; %s; %d;%.4f;%.4f;'... % GPS_TIME TYPE ERROR LATX LONX
                '%.4f;%.4f;'... % LATX_INT LONX_INT;
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'... % EQU_T STD CO2_RAW CO2_PHYS H2O_RAW H2O_PHYS
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'... % LICOR_T LICOR_P ATM_P EQU_P H2O_FLOW LICOR_FLOW
                '%.2f;%.2f;%.2f;%.2f;%.2f;'... % EQU_PUMP VENT_FLOW COND_T COND_ATM COND_EQU
                '%.2f;%.2f;%.2f;%.2f;'... % DRIP_1 DRIP_2 DRY_BOX_T DECK_BOX_T 
                '%.3f;%.0f;%.3f;%.0f;%.2f;%.2f;' ... %SSPS SSPS_QC SSJT SSJT_QC SSJT_COR EQU_T_COR 
                '%.2f;%.2f;%.2f;%.2f;%.2f;'... %OXYGEN_RAW OXYGEN_ADJ_muM OXYGEN_ADJ_MLL OXYGEN_SATURATION OXYGEN_TEMPERATURE
                '\n'];
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