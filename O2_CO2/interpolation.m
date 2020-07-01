function [co2] = interpolation(co2, o2)
    % Interpolation of the CO2 and O2 data at the CO2 dates
    % Input : 
    % * co2                 : CO2 structure
    % * o2                  : O2 structure
    % Output the co2 structure with new columns :
    % * OXYGEN_RAW          : The raw concentration of oxygen in  \muM
    % * OXYGEN_SATURATION   : The oxygen saturation in %
    % * OXYGEN_TEMPERATURE  : The temperature measured

    disp("... Interpolation of CO2 and O2 data");
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
                disp('Unknow variable');
                return;
        end
        
        co2.(par)    = defaultPARA * ones(size(co2.DAYD));
        
        % Definition of time borders for the interpCo2_O2olation of co2 and o2 data
        % We are looking for co2.DAYD(1) < o2.DAYD < co2.DAYD(end)
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
    disp("... interpolation : DONE");
end