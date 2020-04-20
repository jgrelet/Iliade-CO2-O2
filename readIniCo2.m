function [ini, error] = readIniCo2(co2File)
%
% Lecture du fichier d'information associé au fichier CO2
%

% Forme le nom de fichier. Il faut simplement remplacer le suffixe du
% fichier C02 'csv' par 'ini'
% -------------------------------------------------------------------
fileINI = regexprep(co2File, '.csv', '_CO2.ini');
error = 1;

% ouverture du fichier
% --------------------
fid = fopen( fileINI, 'r' );

% Check file
% -----------
if fid == -1
  msg_error = ['Pas de fichier : ' fileINI];
  disp( 'ATTENTION');
  disp( msg_error );
  %warndlg( msg_error, 'ASCII error dialog', 'modal');
  ini = [];
  error = -1;
  return;
  
else
  %   line = fgetl( fid );
  while ~feof( fid )
    line = fgetl( fid );
    if strcmp(line(1:1), '%') == 0
      c = textscan(line','%s = %f');
      ini.(char(c{1})) = c{2};
    end
  end
  
  fclose( fid )
end

end