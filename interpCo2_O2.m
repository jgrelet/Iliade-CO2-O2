function [co2] = interpCo2_O2(co2, o2)

    PARA = {'OXYGEN_RAW', 'OXYGEN_SATURATION', 'OXYGEN_TEMPERATURE'};
    % Conversion of the date in serial date
    format = 'dd/mm/yyyy HH:MM:SS';
    co2.DAYD = datenum(co2.DATE_TIME, format);
    for par = PARA
        par = char(par);
        
        switch par
            case 'OXYGEN_RAW'
                defaultPARA = -999;
            case 'OXYGEN_SATURATION'
                defaultPARA = -999;
            case 'OXYGEN_TEMPERATURE'
                defaultPARA = -999;
            otherwise
                disp('Nom de variable inconnu');
                return;
        end
        
        co2.(par)    = defaultPARA * ones(size(co2.DAYD));
        
        % Definition of time borders for the interpCo2_O2olation of co2 and o2 data
        % We are looking for o2.DAYD(1) < co2.DAYD < o2.DAYD(end)
        indmin = 1;
        if co2.DAYD(1) < o2.DAYD(1)
            A = find( co2.DAYD > o2.DAYD(1) );
            if ~isempty(A)
                indmin = A(1);
            end
        end

        indmax = size(co2.DAYD,1);
        if co2.DAYD(end) > o2.DAYD(end)
            A = find( co2.DAYD < o2.DAYD(end) );
            if ~isempty(A)
                indmax = A(end);
            end
        end
        
        co2.(par)(indmin:indmax) = interp1(o2.DAYD, o2.(par), co2.DAYD(indmin:indmax));
        
    end % end for
end