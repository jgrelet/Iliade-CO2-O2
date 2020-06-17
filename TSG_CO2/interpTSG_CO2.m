function interpFile = interpTSG_CO2(co2File, tsgFile)
%
% Interpolation des mesures TSG � la date des mesures CO2.
% Par rapport au fichier *.csv qui est lu, les variables suivantes sont
% ajout�es au fichier final :
% SSPS      salinit� interpol�e
% SSPS_QC   code qualit� de la salinit�
% SSJT      temp�rature de cuve du TSG
% SSJT_QC   code qualit� de la temp�rature de cuve
% SSJT_COR  temp�rature de cuve corrig�e (-9 si pas de correction)
% EQU_T_COR temp�rature �quilibrateur corrig�e (-9 si pas de correction)
%
% En entr�e :
% 1 - Fichier au format *.csv concat�n� par le programme "concatCO2"
%     Le fichier est ouvert via la fonction "readConcatCO2"
% 2 - Fichier ASCII de mesures TSG
%     Le fichier est ouvert via la fonction "readAsciiTsgCO2"
%
% Fonctions externes appel�es :
% readConcatCO2, readAsciiTsgCO2
%
% Fonctions internes en fin de ce fichier :
% selectTSG, interp

disp("TSG CO2 interpolation ...");

% Lecture du fichier CO2
% ----------------------
[co2, co2File, error] = readConcatCO2(co2File);

if error
    
    % Lecture du fichier .ini
    % -----------------------
    [~, error1] = readIniCo2(co2File);
    
    if error1
        
        % Lecture du fichier TSG
        % ----------------------
        [tsg, error2] = readAsciiTsgCO2(tsgFile);
        
        if error2
            
%             figure( 'Name', 'PlotYY' )
%             [AX,H1,H2] = plotyy(tsg.DAYD, tsg.SSPS, co2.DAYD, co2.CO2_PHYS ); %#ok<PLOTYY>
%             datetick(AX(1), 'x', 'mmm-dd', 'keeplimits', 'keepticks')
%             datetick(AX(2), 'x', 'mmm-dd', 'keeplimits', 'keepticks')
%             set(H1, 'LineStyle', 'None', 'Marker', '.', 'MarkerEdgeColor', 'k');
%             set(H2, 'LineStyle', 'None', 'Marker', '.', 'MarkerEdgeColor', 'r');
%             legend('SSPS','CO2 PHYS', 'Location','SouthWest')
            
            % Selection des mesures TSG. On s�lectionne dans l'ordre :
            % 1 - les donn�es corrig�es (ADJUSTED) - Code qualit� 5
            % 2 - les donn�es non corrig�es mais ayant un code qualit� de 1 (GOOD) ou
            %     2 (PROBABLY GOOD)
            % 3 - les autres mesures de la s�rie TSG sont remplac�es par 35 pour la
            %     salinit� (SSPS) et -9 pour la temp�rature de cuve (SSJT). Dans ce cas
            %     le code qualit� est positionn� � 9 (MISSING VALUE).
            %
            % La fonction selectTSG se trouve en fin de fichier
            % -------------------------------------------------
            [tsg] = selectTS(tsg);
            
            % -------------------------------------------------------------------
            % INTERPOLATION
            % Attention : l'ordre dans lequel des fonctions d'interpolation est
            % important
            
            % Interpolation des donn�es TSG et traitement des cas particuliers
            % ----------------------------------------------------------------
            [co2] = interp(co2, tsg);
            
            % Interpolation des positions
            % ---------------------------
            [co2] = interp_POS(co2, tsg);
            
            % si un fichier .ini existe, effecuter les corrections et modifier le
            % format d'�criture
            % -------------------------------------------------------------------
            co2.SSJT_COR = -999 * ones(size(co2.SSJT));
            co2.EQU_T_COR = -999 * ones(size(co2.EQU_T));
            %       if ~isempty( ini )
            %
            %         % Correction temperature SSJT
            %         % ---------------------------
            %         if ini.dT_SSJT ~= 0
            %           co2.SSJT_COR = co2.SSJT;
            %           ind = find( co2.SSJT > -900 );
            %           co2.SSJT_COR(ind) = co2.SSJT(ind) + ini.dT_SSJT;
            % %           HeaderOut = [HeaderOut ';SSJT_COR'];
            % %           formatOut = [formatOut ';%.2f'];
            %         end
            %
            %         % Correction temperature �quilibrateur
            %         % ------------------------------------
            %         if ini.A_EQU_T ~= 1 || ini.B_EQU_T ~= 0
            %           co2.EQU_T_COR = ini.A_EQU_T * co2.EQU_T + ini.B_EQU_T;
            % %           HeaderOut = [HeaderOut ';EQU_T_COR'];
            % %           formatOut = [formatOut ';%.2f'];
            %         end
            %       end
            
            % Compl�ter le format d'�criture par un retour chariot
            % ----------------------------------------------------
            %       formatOut = [formatOut '\n'];
            
            % -------------------------------------------------------------------
            % TRACE
            % -------------------------------------------------------------------
            if ~exist("figs", 'dir')
               mkdir("figs")
            end
%             figure( 'Name', 'Latitude');
%             hold on;
%             plot( co2.DAYD, co2.LATX, 'b.');
%             plot( co2.DAYD, co2.LATX_INT, 'r.');
%             datetick('x', 'mmm-dd', 'keeplimits', 'keepticks');
%             legend('LATX','LATX_INT Interp', 'Location','SouthWest');
%             
%             figure( 'Name', 'Longitude');
%             hold on;
%             plot( co2.DAYD, co2.LONX, 'b.');
%             plot( co2.DAYD, co2.LONX_INT, 'r.');
%             datetick('x', 'mmm-dd', 'keeplimits', 'keepticks');
%             legend('LONX','LONX_INT Interp', 'Location','SouthWest');
%             
%             figure(  'Name', 'SSPS_et_co2_SSPS');
%             % plot( tsg.DAYD, tsg.SSPS_SEL, 'k.');
%             hold on;
%             plot( tsg.DAYD, tsg.SSPS_SEL, 'b.');
%             plot( co2.DAYD, co2.SSPS, 'r.');
%             datetick('x', 'mmm-dd', 'keeplimits', 'keepticks');
%             legend('SSPS','SSPS Interp', 'Location','SouthWest');
%             
%             % Sauvegarde la figure au format *.png
%             eval( ['print -dpng figs' filesep get(gcf, 'Name')]);
%             
%             figure(  'Name', 'SSPS_QC');
%             plot( co2.DAYD, co2.SSPS_QC, 'k.');
%             datetick('x', 'mmm-dd', 'keeplimits', 'keepticks');
%             legend('SSPS QC', 'Location','SouthWest');
%             
%             % Sauvegarde la figure au format *.png
%             eval( ['print -dpng figs' filesep get(gcf, 'Name')]);
%             
%             figure(  'Name', 'SSJT');
%             % plot( tsg.DAYD, tsg.SSJT_SEL, 'k.');
%             hold on;
%             plot( tsg.DAYD, tsg.SSJT_SEL, 'b.');
%             plot( co2.DAYD, co2.SSJT, 'r.');
%             datetick('x', 'mmm-dd', 'keeplimits', 'keepticks');
%             legend('SSJT','SSJT Interp', 'Location','SouthWest');
%             
%             % Sauvegarde la figure au format *.png
%             eval( ['print -dpng figs' filesep get(gcf, 'Name')]);
%             
%             figure(  'Name', 'SSJT_QC');
%             plot( co2.DAYD, co2.SSJT_QC, 'k.');
%             datetick('x', 'mmm-dd', 'keeplimits', 'keepticks');
%             legend('SSJT QC', 'Location','SouthWest');
%             
%             % Sauvegarde la figure au format *.png
%             eval( ['print -dpng figs' filesep  get(gcf, 'Name')]);
            
            % Ecriture
            % --------
            HeaderOut = ['DATE_TIME;GPS_TIME;TYPE;ERROR;LATX;LONX;'...
                'LATX_INT;LONX_INT;'...
                'EQU_T;STD;CO2_RAW;CO2_PHYS;H2O_RAW;H2O_PHYS;'...
                'LICOR_T;LICOR_P;ATM_P;EQU_P;H2O_FLOW;LICOR_FLOW;'...
                'EQU_PUMP;VENT_FLOW;COND_T;COND_ATM;COND_EQU;'...
                'DRIP_1;DRIP_2;DRY_BOX_T;DECK_BOX_T;'...
                'SSPS;SSPS_QC;SSJT;SSJT_QC;SSJT_COR;EQU_T_COR;'...
                ];
            
            % Ordre des champs de la structure co2. Les champs seront r�ordonn�s
            % dans l'ordre ci-dessous pour la pr�paration de l'�criture dans
            % un fichier
            % -------------------------------------------------------------------
            StrucOrder = {'DAYD';'DATE';'GPS_TIME';'TYPE';'ERROR';'LATX';'LONX';...
                'LATX_INT';'LONX_INT';...
                'EQU_T';'STD';'CO2_RAW';'CO2_PHYS';'H2O_RAW';'H2O_PHYS';...
                'LICOR_T';'LICOR_P';'ATM_P';'EQU_P';'H2O_FLOW';'LICOR_FLOW';...
                'EQU_PUMP';'VENT_FLOW';'COND_T';'COND_ATM';'COND_EQU';...
                'DRIP_1';'DRIP_2';'DRY_BOX_T';'DECK_BOX_T';...
                'SSPS';'SSPS_QC';'SSJT';'SSJT_QC';'SSJT_COR';'EQU_T_COR';...
                };
            
            % Format en �criture. Colonnes s�par�es par des ";" pour une
            % lecture sous Excel
            % Les colonnes Date et Time sont concat�n�es (plac�es entre 2 ";")
            % ---------------------------------------------------------------
            formatOut = ['%02d/%02d/%4d %02d:%02d:%02d;'...
                '%s; %s; %d;%.4f;%.4f;'...
                '%.4f;%.4f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
                '%.3f;%.0f;%.3f;%.0f;%.2f;%.2f;'...
                '\n'];
            
            % Nom du fichier en �criture et ouverture
            % ---------------------------------------
            disp("... Choose the location for the result file interpolation TSG/CO2 ");
            [FileOut,PathOut] = uiputfile('*.csv','O2 CO2 interpolation result file');
            interpFile = strcat (PathOut, FileOut);
            fidOut = fopen( [PathOut FileOut], 'w' );
            
            % Ecriture entete
            % ---------------
            if fidOut == -1
                error("Cannot open file");
            else
                
                % R�ordonne les champs
                % --------------------
                co2b = orderfields(co2, StrucOrder);
                
                % conversion de la structure en cellule de cellule
                % ------------------------------------------------
                c = struct2cell(co2b);
                
                % Nombre de cellules dans c : correspond au nombre de colonnes
                % ------------------------------------------------------------
                n = size(c,1);
                
                % Nombre de ligne d'une cellule
                % ----------------------------
                m = size(c{1},1);
                
                % Extraction des entiers et reformatage de la matrice
                % ---------------------------------------------------
                x = cell2mat(c(5:n));
                y = reshape(x,m,n-4);
                
                % Conversion de la cellule contenant la date et l'heure
                % -----------------------------------------------------
                [Y, M, D, H, MN, S] = datevec(c{1});
                date = [D,M,Y,H,MN,S];
                
                disp(strcat("... Writing results in : ", interpFile));
                % ecriture
                % --------
                fprintf( fidOut,'%s\n', HeaderOut);
                
                for i=1:m
                    fprintf( fidOut, formatOut, date(i,:), co2.GPS_TIME(i,:), co2.TYPE(i,:),y(i,:));
                end
                fclose(fidOut);
            end
            
        end  % if error2
    end  % if error1
end  % if error
disp(">> interpTSG_CO2 : DONE <<");
end

%% Fonction selectTS
%
function [tsg] = selectTS(tsg)

% Le code suivant permet :
% 1 - d'initialiser la s�rie temporelle de salinit� (SSPS) � 35 et le code
%     qualit� � 9 (missing value)
% 2 - de s�lectionner la bonne variable.
%      Soit tsg.SSPS avec un code qualit� 1 (GOOD) ou 2 (PROBABLY GOOD),
%      Soit tsg.SSPS_ADJUSTED avec un code 5 (VALUE CHANGED)
% ---------------------------------------------------------------------
disp("... Selecting relevant TSG data");

probablygoodQC = 2;
nocontrolQC    = 0;
adjustedQC     = 5;
harbourQC      = 6;
nomeasureQC    = 9;

PARA = {'SSPS', 'SSJT'};

for par = PARA
    
    para = char(par);
    
    % intialisation des valeurs par d�faut
    % ------------------------------------
    switch para
        case 'SSPS'
            defaultPARA = 35;
        case 'SSJT'
            defaultPARA = -999;
        otherwise
            disp('Nom de variable inconnu');
            return;
    end
    
    % initialisation des variables interm�diaires
    % -------------------------------------------
    A    = defaultPARA * ones(size(tsg.(para)));
    A_QC = nomeasureQC * ones(size(tsg.(para)));
    
    % V�rifie si la variable non ADJUSTED est vide.
    % On s�lectionne les donn�es brutes ayant un code qualit� 1 ou 2
    % Par commodit� on positionne le code qualit� � 2 (PROBABLY GOOD)
    % --------------------------------------------------------------
    ind = find( ~isnan( tsg.(para) ) & (tsg.([para '_QC']) < probablygoodQC+1 | tsg.([para '_QC']) == harbourQC));
    if ~isempty( ind )
        A( ind )      = tsg.(para)( ind );
        A_QC( ind )   = probablygoodQC;
        
        % Si les mesures n'ont pas �t� control�es/valid�es, leur QC (0)est
        % conserv�
        % ----------------------------------------------------------------
        ind = find( tsg.([para '_QC']) == nocontrolQC);
        if ~isempty(ind)
            A_QC( ind ) = nocontrolQC;
        end
        
    end
    
    % V�rifie si la variable corrig�e (ADJUSTED) n'est pas vide
    % Le code QC est forc� � 5
    % Si des donn�es ADJUSTED existent, elles �crasent les mesures brutes
    % -------------------------------------------------------------------
    ind = find( ~isnan( tsg.([para '_ADJUSTED'])) );
    if ~isempty( ind )
        A( ind )    = tsg.([para '_ADJUSTED'])( ind );
        A_QC( ind ) = adjustedQC ;
    end
    
    tsg.([para '_SEL']) = A;
    tsg.([para '_QC_SEL']) = A_QC;
    
end

% % Test de trac�
% % -------------
% figure( 'Name', 'selectTSG' )
% %plot( tsg.DAYD,tsg.SSPS, 'k.')
% hold on
% %plot( tsg.DAYD,tsg.SSPS_SEL, 'm*')
% legendTxt = '';
% ind = find(tsg.SSPS_QC_SEL < 10);
% if ~isempty( ind )
%     plot( tsg.DAYD(ind), tsg.SSPS_SEL(ind), 'r*');
%     legendTxt{1,1} = 'SSPS NoMeasure';
% end
% ind = find(tsg.SSPS_QC_SEL < 6);
% if ~isempty( ind )
%     plot( tsg.DAYD(ind), tsg.SSPS_SEL(ind), 'g*');
%     legendTxt{1,2} = 'SSPS ADJUSTED';
% end
% ind = find(tsg.SSPS_QC_SEL < 3);
% if ~isempty( ind )
%     plot( tsg.DAYD(ind), tsg.SSPS_SEL(ind), 'b*');
%     legendTxt{1,3} = 'SSPS QC = 1,2 ou 6';
% end
% ind = find(tsg.SSPS_QC_SEL == 0);
% if ~isempty( ind )
%     plot( tsg.DAYD(ind), tsg.SSPS_SEL(ind), 'b*');
%     legendTxt{1,4} = 'SSPS NoControl';
% end
% datetick('x', 'mmm-dd', 'keeplimits', 'keepticks')
% title( 'Mesures SSPS selectionnees');
% legend( legendTxt, 'Location','SouthWest');
% % legend('SSPS NoMeasure', 'SSPS ADJUSTED', 'SSPS QC = 1 ou 2' , 'SSPS NoControl', 'Location','SouthWest');
% 
% % Sauvegarde la figure au format *.png
% eval( ['print -dpng figs' filesep get(gcf, 'name')]);
disp("... selectTS : DONE");
end

%% Function interpolation
%
function [co2] = interp(co2, tsg)
%
% Interpolation et traitement des cas particuliers
% -------------------------------------------------
disp("... Interpolating co2 and tsg");
% Initialisation
% --------------
dTmax          = 2;
nocontrolQC    = 0;
probablygoodQC = 2;
adjustedQC     = 5;
nomeasureQC    = 9;

% L'interpolation ne devrait pas �tre possible lorsqu'il y a des
% donn�es manquantes sur des p�riodes sup�rieures � dT heures.
% --------------------------------------------------------------
dT = datenum(0,0,0,dTmax,0,0);

PARA = {'SSPS', 'SSJT'};

for par = PARA
    
    para = char(par);
    
    % intialisation des valeurs par d�faut
    % ------------------------------------
    switch para
        case 'SSPS'
            defaultPARA = 35;
        case 'SSJT'
            defaultPARA = -999;
        otherwise
            disp('Nom de variable inconnu');
            return;
    end
    
    co2.(para)    = defaultPARA * ones(size(co2.DAYD));
    co2.([para '_QC']) =  nomeasureQC * ones(size(co2.DAYD));
    
    % Test les limites temporelles min et max pour lesquelles les mesures
    % du TSG peuvent �tre interpol�es � la position des mesures CO2.
    % On n'utilise que les bonnes mesures TSG (code qualit� < 9)
    % -------------------------------------------------------------------
    ind = find( tsg.([para '_QC_SEL']) < nomeasureQC );
    
    indmin = 1;
    if co2.DAYD(1) < tsg.DAYD(ind(1))
        A = find( co2.DAYD > tsg.DAYD(ind(1)) );
        if ~isempty(A)
            indmin = A(1);
        end
    end
    
    indmax = size(co2.DAYD,1);
    if co2.DAYD(end) > tsg.DAYD(ind(end))
        A = find( co2.DAYD < tsg.DAYD(ind(end)) );
        if ~isempty(A)
            indmax = A(end);
        end
    end
    
    % Interpolation des mesures TSG � la position des mesures CO2
    % On n'utilise que les bonnes mesures (code qualit� < 9)
    % ------------------------------------------------------------
    co2.(para)(indmin:indmax) = interp1(tsg.DAYD(ind), tsg.([para '_SEL'])(ind), co2.DAYD(indmin:indmax));
    co2.([para '_QC'])(indmin:indmax) = interp1(tsg.DAYD(ind), tsg.([para '_QC_SEL'])(ind), co2.DAYD(indmin:indmax));
    
    % Code pour remplacer les valeurs interpol�es sur des p�riodes
    % sup�rieures � 2h, par les valeurs par d�faut
    % ----------------------------------------------------------
    if ~isempty( ind )
        
        % Calcul la diff�rence de temps entre 2 mesures TSG correctes
        % -----------------------------------------------------------
        dTime = diff(tsg.DAYD(ind));
        
        % Recherche les indices pour lesquels la diff�rence de temps
        % entre 2 mesures TSG correctes est sup�rieure � dT heures
        % ---------------------------------------------------------------
        ind2  = find(dTime > dT);
        
        if ~isempty(ind2)
            
            % Boucle sur les p�riodes o� les diff�rences de temps sont
            % sup�rieures � dT
            % --------------------------------------------------------
            for i = 1:size(ind2,1)
                
                % Indices des heures de d�but et fin o� les mesures ont �t�
                % interpol�es sur plus de dT heures
                % ---------------------------------------------------------
                i1 = ind(ind2(i));
                i2 = ind(ind2(i)+1);
                
                % Recherche les dates des mesures CO2 correspondant �
                % des interpolations TSG sup�rieures � dT heures.
                % Remplace les mesures TSG interpol�es par les valeurs par d�faut
                % ---------------------------------------------------------------
                ind3 = find( co2.DAYD > tsg.DAYD(i1) & co2.DAYD < tsg.DAYD(i2));
                co2.(para)(ind3)    = defaultPARA;
                co2.([para '_QC'])(ind3) = nomeasureQC;
            end
        end
    end
    
    % Traitement des QC des mesures pour lesquelles il y a eu interpolation
    % entre des mesures avec QC = probablyGOOD et des mesures corrig�es
    % avec QC = measureQC. On positionne les QC de ces mesures interpol�es
    % � measureQC
    % ---------------------------------------------------------------------
    ind = find( co2.([para '_QC']) > probablygoodQC & co2.([para '_QC']) <= adjustedQC);
    if ~isempty(ind)
        co2.([para '_QC'])(ind) = adjustedQC;
    end
    
    % Traitement des QC des mesures pour lesquelles il y a eu interpolation
    % entre des mesures avec QC = probablyGOOD et des mesures non valid�es
    % avec QC = nocontrolQC. On positionne les QC de ces mesures interpol�es
    % � nocontrolQC
    % ---------------------------------------------------------------------
    ind = find( co2.([para '_QC']) >= nocontrolQC & co2.([para '_QC']) < probablygoodQC);
    if ~isempty(ind)
        co2.([para '_QC'])(ind) = nocontrolQC;
    end
    
end
    disp("... interp : DONE");
end
%% Function interpolation Position
%
function [co2] = interp_POS(co2, tsg)
%
% Interpolation et traitement des cas particuliers
% -------------------------------------------------
disp("... Interpolating positions");
PARA = {'LATX', 'LONX'};

for par = PARA
    
    para = char(par);
    
    % intialisation des valeurs par d�faut
    % ------------------------------------
    defaultPARA = NaN;
    
    co2.([para '_INT'])  = defaultPARA * ones(size(co2.DAYD));
    
    % Test les limites temporelles min et max pour lesquelles les mesures
    % du TSG peuvent �tre interpol�es � la position des mesures CO2.
    % -------------------------------------------------------------------
    
    indmin = 1;
    if co2.DAYD(1) < tsg.DAYD(1)
        A = find( co2.DAYD > tsg.DAYD(1) );
        if ~isempty(A)
            indmin = A(1);
        end
    end
    
    indmax = size(co2.DAYD,1);
    if co2.DAYD(end) > tsg.DAYD(end)
        A = find( co2.DAYD < tsg.DAYD(end) );
        if ~isempty(A)
            indmax = A(end);
        end
    end
    
    % Interpolation des positions � la datedes mesures CO2
    % ------------------------------------------------------------
    co2.([para '_INT'])(indmin:indmax) = interp1(tsg.DAYD, tsg.(para), co2.DAYD(indmin:indmax));
    
    %   % Code pour remplacer les valeurs interpol�es sur des p�riodes
    %   % sup�rieures � 2h, par les valeurs par d�faut
    %   % ----------------------------------------------------------
    %   if ~isempty( ind )
    %
    %     % Calcul la diff�rence de temps entre 2 mesures TSG correctes
    %     % -----------------------------------------------------------
    %     dTime = diff(tsg.DAYD(ind));
    %
    %     % Recherche les indices pour lesquels la diff�rence de temps
    %     % entre 2 mesures TSG correctes est sup�rieure � dT heures
    %     % ---------------------------------------------------------------
    %     ind2  = find(dTime > dT);
    %
    %     if ~isempty(ind2)
    %
    %       % Boucle sur les p�riodes o� les diff�rences de temps sont
    %       % sup�rieures � dT
    %       % --------------------------------------------------------
    %       for i = 1:size(ind2,1)
    %
    %         % Indices des heures de d�but et fin o� les mesures ont �t�
    %         % interpol�es sur plus de dT heures
    %         % ---------------------------------------------------------
    %         i1 = ind(ind2(i));
    %         i2 = ind(ind2(i)+1);
    %
    %         % Recherche les dates des mesures CO2 correspondant �
    %         % des interpolations TSG sup�rieures � dT heures.
    %         % Remplace les mesures TSG interpol�es par les valeurs par d�faut
    %         % ---------------------------------------------------------------
    %         ind3 = find( co2.DAYD > tsg.DAYD(i1) & co2.DAYD < tsg.DAYD(i2));
    %         co2.(para)(ind3)    = defaultPARA;
    %         co2.([para '_QC'])(ind3) = nomeasureQC;
    %       end
    %     end
    %   end
    
    
end
    disp("... interp_POS : DONE");
end
