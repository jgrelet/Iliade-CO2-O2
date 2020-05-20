function [o2, error] = readAsciiO2
% readAsciiO2
% Function to read o2 data in ASCII format.
%
% Input
% -----
%
% Output
% ------
% o2 ........ Structure contenant toutes les variables des fichiers o2
% error ...... code d'erreur
%              1 .... tout s'est bien passé
%             -1 .... pb d'ouverture de fichier
% 

% Sélection du fichier
% ---------------------
[FileIn, PathIn] = uigetfile( '*.oxy', 'Read file name', 'MultiSelect','off');

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
      %header = c{1}(2:end);
      %nHeader = length( header );
      %OK = 1;

    otherwise

      % Get the parameter Name (Delete '%')
      % ----------------------------------
      %Para = char( strtok(c{1}(1), '%') );
% 
%       % Read the parameter value
%       % ------------------------
%       ind = strmatch( Para, o2Names);
%       if ~isempty( ind )
        
        % patch added for composed name
        % -----------------------------
        %a = c{1}(2:end)';
        %str=[];
        %for i=a
        %  str = sprintf('%s %s', str, char(i));
        %end
        
        % copy to o2 struct & remove leading and trailing white space
        % ------------------------------------------------------------
        %o2.(Para) = strtrim(str);
%       end

  end
end

% Builld the format depending on the header parameters
% 1 - Decimate the HEADER - The 7th first parameters are always
%     %HEADER YEAR MNTH DAYX hh mm ss
% 2 - The 6 Date and time parametes are read in %d
% -------------------------------------------------------------


% Read the data in a cell
% -----------------------
%cellData = textscan( fid, format );

% Convert cell to a structure
% ---------------------------
%s = cell2struct(cellData, header, 2);

clear cellData

% Date (y m d h m s) in the first 6 elements in data
% --------------------------------------------------

% Convert date in character. This cannot be done using
% the Matlab Serial Date format as there can be
% some loss of precision.
% The following instruction is not precise enough :
% o2.DATE = datestr( o2.DAYD, 'yyyymmddHHMMSS' );
% ------------------------------------------------------


%   % QC should be converted in int8
%   % ----------------------------------


% populate o2.file structure
% ---------------------------
% [o2.file.pathstr, o2.file.name, o2.file.ext] = fileparts(filename);

% o2.file.type = 'ASCII';

% Close the file
% --------------
fclose( fid );

% Everything OK
% -------------
error = 1;

end
