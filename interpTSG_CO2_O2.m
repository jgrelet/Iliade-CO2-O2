function interpTSG_CO2_O2(co2interpCo2_O2File, o2File, varargin)
    %
    % interpCo2_O2olation of O2 measure at co2 dates.
    % At the end, we will add the following columns to the .csv:
    % O2_RAW      oxygen raw values
    % O2_ADJ      oxygen values adjusted
    % SATURATION  saturation
    %
    % Input :
    % 1 - .csv file from function "interpCo2_O2TSG_CO2"
    %     data is read with read interpCo2_O2
    % 2 - Fichier ASCII de mesures TSG
    %     Le fichier est ouvert via la fonction "readAsciiTsgCO2"
    %
    % External function call :
    % readAsciiO2 readInterpTSG_CO2 interpCo2_O2
    %
    % Internal functions :


    % Reading of the CO2 and TSG interpCo2_O2olation
    if nargin ~=2
        
        [co2interpCo2_O2File, co2FileIn] = uigetfile( '*.csv', 'Read file name', 'MultiSelect','off');
        
        co2interpCo2_O2File = char([co2FileIn co2interpCo2_O2File]);
        disp(char(co2interpCo2_O2File))
        
        [o2File, o2FileIn] = uigetfile( '*.oxy', 'Read file name', 'MultiSelect','off');
        
        o2File = char([o2FileIn o2File]);
        disp(char(o2File))
    end
    % Get the co2 struct from the interpCo2_O2olation file
    [co2, ok] = readInterpTSG_CO2(co2interpCo2_O2File);
    
    
    if ~ok
        error('readinterpCo2_O2TSG_CO2');
    end
    
    % Get the o2 data
    % o2 is a struct with the following data :
    % DATE % Has been removed because it is useless
    % DAYD
    % OXYGEN_RAW
    % SATURATION
    % TEMPERATURE
    [o2, ok] = readAsciiO2(o2File);
    
    if ~ok
        return
    end
    [co2] = interpCo2_O2(co2,o2);
    
    % Adjusting O2 DATA
    
    % Figure ?
    
    % Ecriture
    HeaderOut = ['DATE_TIME;GPS_TIME;TYPE;ERROR;LATX;LONX;'...
                'LATX_INT;LONX_INT;'...
                'EQU_T;STD;CO2_RAW;CO2_PHYS;H2O_RAW;H2O_PHYS;'...
                'LICOR_T;LICOR_P;ATM_P;EQU_P;H2O_FLOW;LICOR_FLOW;'...
                'EQU_PUMP;VENT_FLOW;COND_T;COND_ATM;COND_EQU;'...
                'DRIP_1;DRIP_2;DRY_BOX_T;DECK_BOX_T;'...
                'SSPS;SSPS_QC;SSJT;SSJT_QC;SSJT_COR;EQU_T_COR;'...
                'OXYGEN_RAW;OXYGEN_ADJ;SATURATION;O2_TEMPERATURE;'...
                ];
            
    StrucOrder = {'DAYD';'DATE';'GPS_TIME';'TYPE';'ERROR';'LATX';'LONX';...
                'LATX_INT';'LONX_INT';...
                'EQU_T';'STD';'CO2_RAW';'CO2_PHYS';'H2O_RAW';'H2O_PHYS';...
                'LICOR_T';'LICOR_P';'ATM_P';'EQU_P';'H2O_FLOW';'LICOR_FLOW';...
                'EQU_PUMP';'VENT_FLOW';'COND_T';'COND_ATM';'COND_EQU';...
                'DRIP_1';'DRIP_2';'DRY_BOX_T';'DECK_BOX_T';...
                'SSPS';'SSPS_QC';'SSJT';'SSJT_QC';'SSJT_COR';'EQU_T_COR';...
                'OXYGEN_RAW';'OXYGEN_ADJ';'SATURATION';'O2_TEMPERATURE'...
                };
            
    formatOut = ['%02d/%02d/%4d %02d:%02d:%02d;'...
                '%s; %s; %d;%.4f;%.4f;'...
                '%.4f;%.4f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '%.3f;%.0f;%.3f;%.0f;%.2f;%.2f;'...
                '%.2f;%.2f;%.2f;%.2f;'...
                '\n'];
            
    
    [FileOut,PathOut] = uiputfile('*.csv','Fichier en écriture');
    fidOut = fopen( [PathOut FileOut], 'w' );
    
    
    if fidOut == -1
        msg_error = ['Open file error : ' FileOut];
        warndlg( msg_error, 'ASCII error dialog');
    else
        
        disp(class(co2));
        fclose(fidOut);
        return
        co2b = orderfields(co2, StrucOrder);

        c = struct2cell(co2b);
        % Number of columns
        n = size(c,1);
        % Number of line 
        m = size(c{1},1);

        x = cell2mat(c(5:n));
        y = reshape(x,m,n-4);

        [Y, M, D, H, MN, S] = datevec(c{1});
        date = [D,M,Y,H,MN,S];

        %fprintf( fidOut,'%s\n', HeaderOut);
        for i=1:m
        %    fprintf( fidOut, formatOut, date(i,:), co2.GPS_TIME(i,:), co2.TYPE(i,:),y(i,:));
        end
        
        fclose(fidOut);
    end
end


function [co2] = interpCo2_O2(co2, o2)

    PARA = {'OXYGEN_RAW', 'SATURATION', 'TEMPERATURE'};
    % Conversion of the date in serial date
    dayd = serialDate(co2);
    for par = PARA
        par = char(par);
        
        switch par
            case 'OXYGEN_RAW'
                defaultPARA = -1;
            case 'SATURATION'
                defaultPARA = -1;
            case 'TEMPERATURE'
                defaultPARA = -1;
            otherwise
                disp('Nom de variable inconnu');
                return;
        end
        
        co2.(par)    = defaultPARA * ones(size(dayd));
        
        % Definition of time borders for the interpCo2_O2olation of co2 and o2 data
        % We are looking for o2.DAYD(1) < co2.DAYD < o2.DAYD(end)
        indmin = 1;
        if dayd(1) < o2.DAYD(1)
            A = find( dayd > o2.DAYD(1) );
            if ~isempty(A)
                indmin = A(1);
            end
        end

        indmax = size(dayd,1);
        if dayd(end) > o2.DAYD(end)
            A = find( dayd < o2.DAYD(end) );
            if ~isempty(A)
                indmax = A(end);
            end
        end
        
        co2.(par)(indmin:indmax) = interp1(o2.DAYD, o2.(par), dayd(indmin:indmax));
        
    end % end for
end

function dayd = serialDate(co2Data)
    % Convert the date in serial date format
    % dd/mm/yyyy hh:mm:ss
    dates = char(co2Data.DATE_TIME);
    %disp(dates);
    
    format = 'dd/mm/yyyy HH:MM:SS';
    dayd = datenum(dates, format);
    
end
    

