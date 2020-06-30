function traceCO2
%
% Tracé d'un fichier CO2 navires marchands au format *.csv 
%
% Sauvegarde automatique des figures au format *.PNG
%
% En entrée :
% Fichier au format *.csv concaténé par le programme "concatCO2"
%
% Tracé
% EQU TEMP et CO2 umol/mol
% Licor Pression et Atm pression
% H2O mmole/mol
% H2O flow et licor flow
% temperature EQU, LICOR, COND, DRY BOX, DECK BOX
%

% Nombre de colonnes di fichier
% -----------------------------
NbCol = 34;

% Entête du fichier à lire. inscrit pour mémoire
% ---------------------------------------------------
HeaderIn = ['Type;error;Date Time; GPS time; latitude; longitude;'...
  'equ temp;Std; CO2 raw; CO2 um/m; H2O raw; H2O mm/m;'...
  'licor temp; licor press; atm press; equ press; H2O flow;'...
  'licor flow; equ pump;vent flow; cond temp; atm cond;'...
  'equ cond; drip 1; drip 2; dry box temp; deck box temp'];

% Sélection et ouverture du fichier
% ---------------------------------
disp("Select the result of the concatCO2 function (should be a .csv file with i in it name)");
[FileIn, PathIn] = uigetfile( '*.csv', 'Select the concatened CO2 file', 'MultiSelect','off');
fileIn = char([PathIn FileIn]);
disp(char(FileIn))

% ouverture du fichier
% --------------------
fid    = fopen( fileIn, 'r' );

data = [];

if fid ~= -1
  disp ('Ouverture fichier ok' );
  header = fgetl( fid );
  
  % Lecture
  % -------
  format = ['%d/%d/%d %d:%d:%d %d:%d:%d %s %d '...
    '%f %f %f %f %f %f %f %f %f %f %f  '...
    '%f %f %f %f %f %f %f %f %f %f %f %f'];
  data = textscan( fid, format, 'delimiter', ';' );
  
  if size(data, 2) ~= NbCol
    disp(['Attention le fichier ne comporte pas '...
      num2str(NbCol) ' colonnes']);
  end
  
  fclose( fid );
end

% conversion des dates heures en une matrice de nombres
% datenum accepts only double array
% --------------------------------------------------------------
temp = double(cell2mat( data(:,1:6)));
date = datenum(temp(:,3), temp(:,2), temp(:,1), temp(:,4), temp(:,5), temp(:,6));

% Recherche les indices des lignes débutant par les chaines decaractères
% EQU, ATM, STD
% ----------------------------------------------------------------------
indEQU = find( strncmpi(data{1,10}, 'EQU', 3));
indATM = find( strncmpi(data{1,10}, 'ATM', 3));
indSTD = find( strncmpi(data{1,10}, 'STD', 3));

% Tracé des variables EQU TEMP et CO2 um/m
% ----------------------------------------
figure( 'name', 'Graphe_général');
box on
[hA1,hline1,hline2] = plotyy(date(indEQU), data{17}(indEQU), date, data{14});
hold(hA1(1),'on')
hold(hA1(2),'on')

plot(hA1(1),date(indATM), data{17}(indATM), 'dm', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 
plot(hA1(1),date(indSTD), data{17}(indSTD), '+m', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 

datetick(hA1(1),'x','dd/mm/yy','keepticks','keepLimits');
set(get(hA1(1),'Ylabel'),'String','CO2 \mumol/mol', 'Color', 'm')
set( hA1(1), 'XLimMode', 'auto', 'YLimMode', 'auto','YColor', 'm','YGrid','on' );
set(hline1,'LineStyle', 'none','Marker','o', 'Color', 'm', 'MarkerFaceColor', 'none', 'MarkerSize', 6)

datetick(hA1(2),'x','dd/mm/yy','keepticks','keepLimits');
set(get(hA1(2),'Ylabel'),'String','EQU TEMP', 'Color', 'b')
set( hA1(2), 'YColor', 'b' );
set(hline2,'LineStyle', 'none','Marker','o', 'Color', 'b', 'MarkerFaceColor', 'none', 'MarkerSize', 6)

plot(hA1(2),date(indATM), data{14}(indATM), 'db', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 
plot(hA1(2),date(indSTD), data{14}(indSTD), '+b', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 

legend('CO2 EQU','CO2 ATM','CO2 STD','EQU_TEMP EQU','EQU_TEMP ATM','EQU_TEMP STD', 'Location','SouthWest')

title(['Fichier : ' FileIn]);
xlabel('Date')

% Sauvegarde la figure au format *.png
eval( ['cd ''' PathIn ''' ']);
eval( ['print -dpng ' get(gcf, 'name')]);

% Licor Pression et Atm pression
% ------------------------------
figure( 'name', 'Graphe_pressions' );
box on;
hold on
plot(date(indEQU), data{21}(indEQU), 'ob', 'MarkerFaceColor', 'none', 'MarkerSize', 6);
plot(date(indATM), data{21}(indATM), 'db', 'MarkerFaceColor', 'none', 'MarkerSize', 6);
plot(date(indSTD), data{21}(indSTD), '+b', 'MarkerSize', 6);
plot(date(indEQU), data{22}(indEQU), 'om', 'MarkerFaceColor', 'none', 'MarkerSize', 6);
plot(date(indATM), data{22}(indATM), 'dm', 'MarkerFaceColor', 'none', 'MarkerSize', 6);
plot(date(indSTD), data{22}(indSTD), '+m', 'MarkerSize', 6);

set(gca,'YGrid','on');
datetick('x','dd/mm/yy','keeplimits', 'keepticks');
legend('Licor EQU','Licor ATM','Licor STD',...
       'Atm. EQU', 'Atm. ATM', 'Atm. STD',...
       'Location','SouthWest');

ylabel( 'Pressure')
xlabel('Date')
title(['Fichier : ' FileIn]);

% Sauvegarde la figure au format *.png
eval( ['print -dpng ' get(gcf, 'name')]);

% Tracé variable H2O mm/m
% -----------------------
figure('name', 'Graphe_humidité');
box on
hold on
plot(date(indEQU), data{19}(indEQU), 'om', 'MarkerFaceColor', 'none', 'MarkerSize', 6);
plot(date(indATM), data{19}(indATM), 'db', 'MarkerFaceColor', 'none', 'MarkerSize', 6);
plot(date(indSTD), data{19}(indSTD), '+r', 'MarkerSize', 6);

datetick('x','dd/mm/yy','keeplimits', 'keepticks');

set(gca,'YGrid','on');

legend('EQU','ATM','STD', 'Location','SouthWest')
ylabel( 'H2O mmol/mol')
xlabel('Date')
title(['Fichier : ' FileIn]);

% Sauvegarde la figure au format *.png
eval( ['print -dpng ' get(gcf, 'name')]);

% Tracé variables H2O flow et licor flow
% ---------------------------------------
figure( 'name', 'Graphe_débits');
[hA2,hline3,hline4] = plotyy(date(indEQU), data{24}(indEQU), date(indEQU), data{25}(indEQU));

hold(hA2(1),'on')
hold(hA2(2),'on')

datetick(hA2(1),'x','dd/mm/yy','keeplimits', 'keepticks');
set(get(hA2(1),'Ylabel'),'String','H2O flow', 'Color', 'm')
set( hA2(1), 'YColor', 'm' );
set(hline3,'LineStyle','none', 'Marker', 'o', 'Color', 'm', 'MarkerFaceColor', 'none', 'MarkerSize', 6)
set(hA2(1),'YGrid','on');

plot(hA2(1),date(indATM), data{24}(indATM), 'dm', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 
plot(hA2(1),date(indSTD), data{24}(indSTD), '+m', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 

datetick(hA2(2),'x','dd/mm/yy','keeplimits', 'keepticks');
set(get(hA2(2),'Ylabel'),'String','licor flow', 'Color', 'b')
set( hA2(2), 'YColor', 'b' );
set(hline4,'LineStyle','none', 'Marker', 'o', 'Color', 'b', 'MarkerFaceColor', 'none', 'MarkerSize', 6)

plot(hA2(2),date(indATM), data{25}(indATM), 'db', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 
plot(hA2(2),date(indSTD), data{25}(indSTD), '+b', 'MarkerFaceColor', 'none', 'MarkerSize', 6) 

legend('H2O EQU', 'H2O ATM', 'H2O STD','LICOR EQU', 'LICOR ATM','LICOR STD', 'Location','SouthWest')

title(['Fichier : ' FileIn]);
xlabel('Date')

% Sauvegarde la figure au format *.png
eval( ['print -dpng ' get(gcf, 'name')]);

% Tracé variables de temperature EQU (14), LICOR (20), COND (28), 
% DRY BOX (33), DECK BOX (34)
% ---------------------------------------------------------------
figure('name', 'Graphe_températures');
box on;
hold on
plot(date, data{14}, '+b');
plot(date, data{20}, '+m');
plot(date, data{28}, '+y');
plot(date, data{33}, '+c');
plot(date, data{34}, '+r');

% set(gcf, 'color', [1 1 1])
% set(gca, 'color', [0.9 0.9 0.9])
set(gca,'YGrid','on');

datetick('x','dd/mm/yy','keeplimits', 'keepticks');
legend('EQU','LICOR', 'COND', 'DRY BOX', 'DECK BOX', 'Location','SouthWest')
ylabel( 'Temperature (C)')
xlabel('Date')
title(['Fichier : ' FileIn]);

% Sauvegarde la figure au format *.png
eval( ['print -dpng ' get(gcf, 'name')]);

end
