function concatCO2
%
% Cette fonction permet de concat�ner les fichiers CO2 de type *data.txt
% Elle cr�e un fichier unique au format Excel, *.CSV, dont les colonnes
% sont s�par�es par des points virgules.
% La lecture des fichiers peut se faire dans n'importe quel ordre, les
% enregistrement sont tri�s, avant �criture, par ordre croissannt de date.
%
% ATTENTION
% 1 - On consid�re que le nombre de colonnes est fixe : 34. Il est difficile
%     de tester le nombre de colonnes des fichiers car les noms d'ent�tes
%     ne sont pas tous des chaines de caract�res li�es. Ils peuvent �tre
%     s�par�s par des blancs (exemple : "GPS TIME"). Autre difficult� :
%     l'absence de point GPS se traduit par une heure au format '::' au
%     lieu du format habituel hh:mmm:ss
% 2 - Le format des fichiers Craig Neil diff�re du format des
%     fichiers G.O.
%     Les fichiers G.O. peuvent contenir des colonnes suppl�mentaires :
%     celles-ci ne sont pas lues
%     La variable "cond temp" est plac�e en colonne 32 dans les fichiers GO
%     et en colonne 28 dans les fichiers Craig Neil. Le fichier final est
%     au format Craig Neil
% 3 - On consid�re que les ent�tes des colonnes ne varient pas. Un test
%     contr�le la chaine de caract�res de l'ent�te qui est lue avec 
%     la chaine de caract�res "HeaderIn".
% 4 - Le s�parateur num�rique des nombres est le '.'. Selon la
%     configuration des param�tres internationaux de l'ordinateur, le
%     s�parateur peut �tre une ','. Pourqu'Excel consid�re que ce sont
%     bien des nombres il faudra remplacer tous le '.' par des ','
% 5 - Les dates au format jj/mm/aaaa hh:mm:ss dans un fichier *.CSV sont
%     affich�es dans Excel avec le format jj/mm/aaaa hh:mm. Il manque
%     les secondes.
%     Si le fichier devait �tre modifi� et sauvegard� au format *.CSV
%     il convient de modifier le format de la colonne des date pour que
%     celle-ci affiche bien les secondes.
%
% Le programme
% 1 - permet de regrouper les colonnes "Date" et "Time" (du PC) dans une 
%     seule colonne appel�e : "Date Time".
% 2 - permet de s�lectionner plusieurs fichiers.
%     Le repertoire o� se trouvent les fichiers peut �tre modifi� � la ligne
%     XXXX - Variable repIn
% 3 - permet de donner le nom du fichier concat�n�
%     Le repertoire o� sera sauvegard� le fichier peut �tre modifi� � la ligne
%     XXXX - Variable repOut
%
% ERREUR
% Le programme teste si le fichier n'est pas complet ou si le nombre de
% colonnes n'est pas r�gulier. En particulier si la premi�re colonne
% contient plusieurs chaines de caract�res comme : "GO TO SLEEP",
% "SHUT DOWN", "WAKE UP".
% Le programme ne lit pas ces lignes.
%

clear all
close all
clc

% Constantes
% ----------
% repIn  = 'D:\0-US191\UR-US Clientes\UR182 - LOCEAN\UR182 - CO2 et navires marchands\Donn�es';
% repOut = 'D:\0-US191\UR-US Clientes\UR182 - LOCEAN\UR182 - CO2 et navires marchands\Donn�es\';
FileType = '*dat.txt';

% eval( ['cd ''' repIn ' '' ']);
% eval( ['cd ''' repOut ' '' ']);

% Nombre de colonnes des fichiers � concat�ner
% Appareil type Craig Neil : 34
% Appareil type GO : 36
% --------------------------------------------
NbColCN = 34;

% Ent�te des fichiers d'origine
% Appareil Craig Neil
% -----------------------------
HeaderCN  = ['Type	error	Date	Time	 GPS time	 latitude	 longitude	 '...
  'equ temp	Std	 CO2 raw	 CO2 um/m	 H2O raw	 H2O mm/m	 '...
  'cell temp	 cell press	 atm press	 equ press	 H2O flow	 '...
  'licor flow	 equ pump	vent flow	 cond temp	 atm cond	 '...
  'equ cond	 drip 1	 drip 2	 PC temp	 DB temp'];

% Appareil GO - N'inclut pas les colonnes au-del� de la 34�me
% ------------------------------------------------------------
HeaderGO  = ['Type	error	Date	PC Time	 gps time	 latitude	 longitude	 '...
  'equ temp	std val	 CO2 mv	 CO2 um/m	 H2O mv	 H2O mm/m	 ',...
  'licor temp	 licor press	 atm press	 equ press	 H2O flow	 '...
  'licor flow	 equ pump	 vent flow	 atm cond	 '...
  'equ cond	 drip 1	 drip 2	 cond temp	 dry box temp	 deck box temp'];

% Appareil GO -type fichier 2 - N'inclut pas les colonnes au-del� de la 34�me
% ------------------------------------------------------------
HeaderGO2 = ['Type	error	PC Date	PC Time	GPS date	gps time	latitude	'...
    'longitude	equ temp	std val	CO2a W	CO2b W	CO2 um/m	H2Oa W	H2Ob W	'...
    'H2O mm/m	licor temp	licor press	 atm press	equ press	H2O flow	'...
    'licor flow	equ pump	vent flow	atm cond	equ cond	drip 1	na	'...
    'cond temp	dry box temp	deck box temp'];

% Format de lecture. Lit les entiers avec %f car la conversion
% d'un tableau de cellule en tableau num�rique via "cell2mat" n'est
% possible que si les donn�es ont le m�me format.
% Le format NoGPS rempalce la lecture de l'heure GPS "%f:%f:%f" par "::"
% car si l'acquistion GPS n'est pas possible aucun digit n'est enregistr�
% Le format In2 consid�re les fichiers GO de type 2, qui poss�dent plus de
% param�tres
% Le format NoGPS2 rempalce la lecture de l'heure GPS "%f:%f:%f" par "::"
% pour les fichiers de type 2 car si l'acquistion GPS n'est pas possible 
% aucun digit n'est enregistr�
% -----------------------------------------------------------------------
formatIn  = ['%s %f %f/%f/%f %f:%f:%f %f:%f:%f '...
  '%f %f %f %f %f %f %f %f %f %f %f '...
  '%f %f %f %f %f %f %f %f %f %f %f %f'];
formatIn2 = ['%s %f %f/%f/%f %f:%f:%f %f/%f/%f '...
  '%f:%f:%f %f %f %f %f %f %f %f %f %f %f %f '...
  '%f %f %f %f %f %f %f %f %f %f %f %f %f %f'];
formatNoGPS = ['%s %f %f/%f/%f %f:%f:%f :: '...
  '%f %f %f %f %f %f %f %f %f %f %f '...
  '%f %f %f %f %f %f %f %f %f %f %f %f'];
formatNoGPS2 = ['%s %f %f/%f/%f %f:%f:%f '...
  '%f %f %f %f %f %f %f %f %f %f %f '...
  '%f %f %f %f %f %f %f %f %f %f %f %f'];
% Ent�te en �criture
% S�paration des colonnes par un ";" compatible avec le format Excel *.CSV
% les 2 colonnes Date et Time sont rassembl�es dans la m�me colonne
% pour faciliter le traitement sous excel
% ----------------------------------------------------------------
HeaderOut = ['Type;error;Date Time; GPS time; latitude; longitude;'...
  'equ temp;Std; CO2 raw; CO2 um/m; H2O raw; H2O mm/m;'...
  'licor temp; licor press; atm press; equ press; H2O flow;'...
  'licor flow; equ pump;vent flow; cond temp; atm cond;'...
  'equ cond; drip 1; drip 2; dry box temp; deck box temp'];

HeaderOut = ['DATE_TIME;GPS_TIME;TYPE;ERROR;LATX;LONX;'...
  'EQU_T;STD;CO2_RAW;CO2_PHYS;H2O_RAW;H2O_PHYS;'...
  'LICOR_T;LICOR_P;ATM_P;EQU_P;H2O_FLOW;LICOR_FLOW;'...
  'EQU_PUMP;VENT_FLOW;COND_T;COND_ATM;COND_EQU;'...
  'DRIP_1;DRIP_2;DRY_BOX_T;DECK_BOX_T'];

% Format en �criture. Colonnes s�par�es par des ";" pour une
% lecture sous Excel
% Les colonnes Date et Time sont concat�n�es (plac�es entre 2 ";")
% ---------------------------------------------------------------
formatOut = ['%02d/%02d/%4d %02d:%02d:%02d;%02d:%02d:%02d;'...
  '%s;%d;%.4f;%.4f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;'...
  '%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f\n'];

% S�lection des fichiers � concat�ner via une fen�tre utilisateur
% Le programme ne fonctionne pas si un seul fichier est s�lectionn�
% La multiselection de garantit par l'ordre des fichiers
% -----------------------------------------------------------------
[FileIn, PathIn] = uigetfile( FileType, 'Fichiers en lecture', 'MultiSelect','on');

if ~isempty( PathIn )
  
  % Initialisation du tableau de cellules qui contient les donn�es concat�n�es
  % --------------------------------------------------------------------------
  data = {};
  
  % Boucle sur les fichiers � concat�ner
  % ------------------------------------
  length = size(FileIn);
  for ifile = 1:length(2)
    
    % Ouverture d'un fichier
    % ----------------------
    fileIn = char([PathIn FileIn{ifile}]);
    fid    = fopen( fileIn, 'r' );
    
    if fid ~= -1
      
      % Variable qui permet de tester la date au format 2011 ou 11
      % fmtDate = 0 si format 11
      % fmtDate = 2000 si format 2011
      % ----------------------------------------------------------
      fmtDate = 0;
      
      disp(' ');
      disp(char(FileIn{ifile}))
      
      % Lecture de l'entete et comparaison pour d�terminer l'origine du
      % fichier
      % L'entete d�termline le type de fichier Craig Neil ou GO
      % Not case sensitive
      % ------------------------------------------------------
      header = fgetl( fid );
      if strncmpi( header, HeaderCN, size(HeaderCN,2) )
        disp('Lecture d''un fichier type Craig Neil' );
        TypeApp = 'CN';
      elseif strncmpi( header, HeaderGO, size(HeaderGO,2) )
        disp('Lecture d''un fichier type G.O.' );
        TypeApp = 'GO';
      elseif strncmpi( header, HeaderGO2, size(HeaderGO2,2) )
        disp('Lecture d''un fichier type G.O. (type2)' );
        TypeApp  = 'GO2';
        formatIn = formatIn2; % Changement foramt de fichiers car plus de param�tres
      else
        disp('Type de fichier inconnu - Pb d''ent�te');
      end
            
      % Lecture ligne � ligne pour d�tecter les lignes incompl�tes
      % ----------------------------------------------------------
      nligne = 0;
      while ~feof(fid)
        try
          nligne = nligne + 1;
          ligne = fgetl( fid );
          
          % Ne lit que les ligne commen�ant par les 3 caract�res :
          % EQU - STD - ATM - Test not case sensitive
          % ------------------------------------------------------
          temp = {};
          if strcmpi(ligne(1:3),'EQU') || strcmpi(ligne(1:3),'STD') || strcmpi(ligne(1:3),'ATM')
            temp = textscan( ligne, formatIn, 1, 'ReturnOnError', 0 );
          end
          
        catch
          
          % Gestion des erreurs de lecture
          % ------------------------------
          if strfind(ligne, '::')
            
            % Si le GPS ne fonctionne pas, l'heure n'est pas enregistr�e.
            % Uniquement la chaine de caract�re '::', utilise le second
            % format d electure (NoGPS) et remplace l'heure GPS par des
            % NaN.
            % ------------------------------------------------------------
            try
              temp = textscan( ligne, formatNoGPS, 1, 'ReturnOnError', 0 );
              temp2 = {temp{1:8} NaN NaN NaN NaN NaN NaN temp{9:end}};
              temp = temp2;
            catch
              
              % Si un autre probl�me de lecture. Emission d'un message
              % La cellule temp sera vide
              % ------------------------------------------------------
              disp(['Probl�me � la Lecture de la ligne n� : ' num2str(nligne + 1)] );
              disp( ligne );
            end
            
          elseif strcmp( TypeApp, 'GO2' )
              
            % Pour les fichiers GO de type 2, si le GPS ne fonctionne pas, 
            % l'heure n'est pas enregistr�e.
            % Pas de cha�ne de caract�re, utilise le second
            % format d electure (NoGPS2) et remplace l'heure GPS et la postition 
            % par des NaN.
            % ------------------------------------------------------------
            try
              temp = textscan( ligne, formatNoGPS2, 1, 'ReturnOnError', 0 );
              temp2 = {temp{1:2} NaN NaN NaN NaN NaN NaN temp{3:5} NaN NaN NaN NaN NaN temp{9:end}};
              temp = temp2;
            catch
              
              % Si un autre probl�me de lecture. Emission d'un message
              % La cellule temp sera vide
              % ------------------------------------------------------
              disp(['Probl�me � la Lecture de la ligne n� : ' num2str(nligne + 1)] );
              disp( ligne );
            end
            
          else
              % Si un autre probl�me de lecture. Emission d'un message
              % La cellule temp sera vide
              % ------------------------------------------------------
            disp(['Probl�me � la Lecture de la ligne n� : ' num2str(nligne + 1)] );
            disp( ligne );
          end
        end
        
        if ~isempty( temp )
          % La variable 'cond temp' ne se trouve pas dans la m�me colonne
          % pour l'appareil GO. On la change de position
          % Pour les fichiers de type GO2, r�arrangement des colonnes
          % -------------------------------------------------------------
          if strcmp( TypeApp, 'GO' )
            temp = {temp{1:27} temp{32} temp{28:31} temp{33:34}};
          elseif strcmp( TypeApp, 'GO2' )
            temp = {temp{1:2} temp{9:14} temp{6:8} temp{15:19} temp{21:22} temp{24:31} temp{37} temp{32:36} temp{38:39}};
          end
          
          % Remplace les cellules vides par des Nan
          % ---------------------------------------
          for i = 2:NbColCN
            if isempty( temp{i} )
              temp{i} = NaN;
            end
          end
          
          % Ajoute 2000 � la date
          % ---------------------
          if (2000-temp{5}) < 0
            fmtDate = 2000;
          else
            temp{5} = temp{5} + 2000;
          end
          
          % Concat�ne les tableaux de cellules
          % ----------------------------------
          if isempty(data)
            data = temp;
          else
            for i = 1:NbColCN
              data{i} = [data{i}; temp{i}];
            end
          end      
        end 
      end
    end
    
    % Test sur le format de la date pour affichage d'un avertissement
    % ---------------------------------------------------------------
    if fmtDate == 2000
      disp('Attention date au format 2000' );
    end
    
    fclose( fid );
  end
end

% Pr�paration des tableaux pour l'�criture par fprintf.
% Je n'ai pas r�ussi � �crire un tableau de cellules contenant
% des chaines de caract�res et des flottants.
% S�pare le tableau de celllules en un vecteur de chaine de
% caract�res "A" et un tableau de nombres "B"
% ------------------------------------------------------------
% Convertit la cellule de chaine de caract�res en un vecteur
A(:,:)= char(data{1}(:));
% Remplace la cellule 1 (chaine de caract�res) par la cellule 2
% (flottants)
data{1} = data{2};
% conversion du tableau de cellules en un tableau de doubles.
B = cell2mat(data);
% �limine la premi�re colonne dans laquelle se trouvait � l'origine
% les chaines de carat�res.
B(:,1) = [];

% Teste que les dates sont bien croissantes
% Conversion des dates heures en une matrice de nombres :
% datenum accepts only double array
% --------------------------------------------------------------
date = double( datenum(B(:,4), B(:,3), B(:,2), B(:,5), B(:,6), B(:,7)) );

if any( diff( date) <= 0 )
  
  [sortDate, IX] = sort(date);
  A(:,:) = A(IX,:);
  B = B(IX,:);
  
  disp(' ');
  disp('Les dates ne sont pas strictement croissantes');
  disp('Le fichier final a �t� tri�');
end

% Nom du fichier en �criture et ouverture
% ---------------------------------------
[FileOut,PathOut] = uiputfile('*.csv','Fichier en �criture');
fidOut = fopen( [PathOut FileOut], 'w' );

if fidOut ~= -1
  
  % Ecriture entete
  % ---------------
  fprintf( fidOut,'%s\n', HeaderOut);
   
  % Ecriture donn�es
  % ----------------
  [m,n] = size(B);
  for i=1:m
    fprintf( fidOut, formatOut, B(i,[2:10]),A(i,:),B(i,[1,11:end]));
  end
  
  fclose( fidOut );
  
  disp(' ');
  disp ('Ecriture fichier ok' );  
end
end

