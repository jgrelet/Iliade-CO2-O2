function [co2, co2File, error] = readConcatCO2(co2File)
% readconcatCO2
% Function to read CO2 data .
%
% Input
% -----
%
% Output
% ------
% co2 ........ Structure contenant toutes les variables des fichiers CO2
% co2File .... Nom du fichier CO2 qui a été lu
% error ...... code d'erreur
%              1 .... tout s'est bien passé
%             -1 .... pb d'ouverture de fichier
% 
disp("... Reading the data from the concat CO2 file");
% Sélection du fichier
% ---------------------
if nargin ~= 1
    disp("Select the CO2 file name");
    [FileIn, PathIn] = uigetfile( '*.csv', 'Select the CO2 file name', 'MultiSelect','off');
    co2File = char([PathIn FileIn]);
end
% ouverture du fichier
% --------------------
fid    = fopen( co2File, 'r' );

% Check file
% -----------
if fid == -1
  msg_error = ['Open file error : ' co2File];
  warndlg( msg_error, 'ASCII error dialog');
  error = -1;
  return;
end

disp(strcat('... Reading ', co2File));

% Lecture de l'entête
% 
% Les 2 premières chaines de caractères de l'entete DATE_TIME et GPS_TIME 
% correspondent % à 6 entiers(J/M/A H:M:S) et 3 entiers(H:M:S)
% Les données sont lues via la fonction TEXTSCAN, puis le tableau de cellule
% est converti en STRUCT via la fonction CELL2STRUCT. Les champs de cette
% structure sont ceux de l'entete sauf pour DATE_TIME et GPS_TIME ou il
% faut créer 6 + 3 champs. 
% -------------------------------------------------------------------------

% Lecture de l'entête et des champs. On ne conserve pas les 2 premiers
% champs DATE_TIME et % GPS_TIME
line = fgetl( fid );
c = textscan( line, '%s', 'delimiter', ';' );
header = c{1}(3:end);

% On reconstruit l'entête en ajoutant les bonnes chaines de caractères
% Les champs de l'entete
% -------------------------------------------------------------------------
a = {'D'; 'M'; 'Y'; 'HOUR'; 'MIN'; 'SEC'; 'GPS_H'; 'GPS_MIN'; 'GPS_SEC'};
header = [a; header];
nHeader = length( header );

% Builld the format depending on the header parameters
% - Decimate the HEADER - 
% 1 - The 2 first parameters are always
%     'DATE_TIME' and 'GPS_TIME';
%     DATE_TIME : 6 integers - GPS_TIME : 3 integers
% 2 - The 3rd parameter is 'TYPE' : string
%
% -------------------------------------------------------------
format = '%d/%d/%d %d:%d:%d %d:%d:%d %s';
for i = 11 : nHeader
  format = [format ' %f'];
end

% Read the data in a cell
% -----------------------
cellData = textscan( fid, format, 'delimiter', ';' );

% Convert cell to a structure
% ---------------------------
s = cell2struct(cellData, header, 2);

clear cellData

% Traitement particulier pour s.TYPE : chaines de caractéres stockés
% dans une cellule. On convertit cette cellule en tableau de chaine
% de caractères
% ------------------------------------------------------------------
s.TYPE = char(s.TYPE);

% Conversion de la date en date numérique Matlab
% Date (y m d h m s) in the first 6 elements in data
% --------------------------------------------------
dd = double( s.(char(header(1))) );
mm = double( s.(char(header(2))) );
yy = double( s.(char(header(3))) );
hh = double( s.(char(header(4))) );
mi = double( s.(char(header(5))) );
ss = double( s.(char(header(6))) );

co2.DAYD = datenum(yy, mm, dd, hh, mi, ss) ;

% Convert date in character. 
% --------------------------
co2.DATE =  datestr( co2.DAYD, 'yyyymmddHHMMSS' );

hh = num2str( s.(char(header(7))), '%02d:' );
mi = num2str( s.(char(header(8))), '%02d:' );
ss = num2str( s.(char(header(9))), '%02d' );
co2.GPS_TIME = [hh mi ss];

% 
% ------------------------------------------
for i = 10 : nHeader
  co2.(char(header(i))) = s.(char(header(i)));
end

% populate tsg.file structure
% ---------------------------
% [tsg.file.pathstr, tsg.file.name, tsg.file.ext] = fileparts(filename);

% tsg.file.type = 'ASCII';

% Close the file
% --------------
fclose( fid );

% Everything OK
% -------------
error = 1;
disp("... readConcatCO2 : DONE");
end
