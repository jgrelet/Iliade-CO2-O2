function [tsg, error] = readAsciiTsgCO2
% readAsciiTsgCO2
% Function to read TSG data in ASCII format.
%
% Input
% -----
%
% Output
% ------
% tsg ........ Structure contenant toutes les variables des fichiers TSG
% error ...... code d'erreur
%              1 .... tout s'est bien passé
%             -1 .... pb d'ouverture de fichier
% 

% Sélection du fichier
% ---------------------
[FileIn, PathIn] = uigetfile( '*.tsgqc', 'Read file name', 'MultiSelect','off');

% ouverture du fichier
% --------------------
fileIn = char([PathIn FileIn]);
disp(char(FileIn))
fid    = fopen( fileIn, 'r' );

% Check file
% -----------
if fid == -1
  msg_error = ['Open file error : ' FileIn];
  warndlg( msg_error, 'ASCII error dialog');
  error = -1;
  return;
end

% Display more info about read file on console
% --------------------------------------------
fprintf('...reading %s : ', FileIn);

% Read the header till the header line has been read
% --------------------------------------------------
OK = 0;
while ~OK

  % Read every line
  % ---------------
  line = fgetl( fid );
  c = textscan( line, '%s');

  switch char( c{1}(1) )

    case '%HEADER'

      % Read the header then quit the while loop
      % ----------------------------------------
      header = c{1}(2:end);
      nHeader = length( header );
      OK = 1;

    otherwise

      % Get the parameter Name (Delete '%')
      % ----------------------------------
      Para = char( strtok(c{1}(1), '%') );
% 
%       % Read the parameter value
%       % ------------------------
%       ind = strmatch( Para, tsgNames);
%       if ~isempty( ind )
        
        % patch added for composed name
        % -----------------------------
        a = c{1}(2:end)';
        str=[];
        for i=a
          str = sprintf('%s %s', str, char(i));
        end
        
        % copy to tsg struct & remove leading and trailing white space
        % ------------------------------------------------------------
        tsg.(Para) = strtrim(str);
%       end

  end
end

% Builld the format depending on the header parameters
% 1 - Decimate the HEADER - The 7th first parameters are always
%     %HEADER YEAR MNTH DAYX hh mm ss
% 2 - The 6 Date and time parametes are read in %d
% -------------------------------------------------------------
format = '%d %d %d %d %d %d';
for i = 7 : nHeader
  format = [format ' %f'];
end

% Read the data in a cell
% -----------------------
cellData = textscan( fid, format );

% Convert cell to a structure
% ---------------------------
s = cell2struct(cellData, header, 2);

clear cellData

% Date (y m d h m s) in the first 6 elements in data
% --------------------------------------------------
yy = double( s.(char(header(1))) );
mm = double( s.(char(header(2))) );
dd = double( s.(char(header(3))) );
hh = double( s.(char(header(4))) );
mi = double( s.(char(header(5))) );
ss = double( s.(char(header(6))) );

tsg.DAYD = datenum(yy, mm, dd, hh, mi, ss);

% Convert date in character. This cannot be done using
% the Matlab Serial Date format as there can be
% some loss of precision.
% The following instruction is not precise enough :
% tsg.DATE = datestr( tsg.DAYD, 'yyyymmddHHMMSS' );
% ------------------------------------------------------
yy = num2str( s.(char(header(1))), '%4d' );
mm = num2str( s.(char(header(2))), '%02d' );
dd = num2str( s.(char(header(3))), '%02d' );
hh = num2str( s.(char(header(4))), '%02d' );
mi = num2str( s.(char(header(5))), '%02d' );
ss = num2str( s.(char(header(6))), '%02d' );
tsg.DATE = [yy mm dd hh mi ss];

nHeader = length( header );
for i = 7 : nHeader

%   % QC should be converted in int8
%   % ----------------------------------
%   if ~isempty( strfind(char(header(i)), '_QC'))
%     tsg.(char(header(i))) = int8(s.(char(header(i))));
%   else
    tsg.(char(header(i))) = s.(char(header(i)));
%   end

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

end
