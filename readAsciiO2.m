function [o2, error] = readAsciiO2
% readAsciiO2
% Function to read o2 data in ASCII format.
%
% Input
% -----
%
% Output
% ------
% o2 ........ Structure with the relevant o2 data
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


% We can put the format in the toml file
% it will allow to update the data input in case of equipment changes

% Build of the header


header = ["YYMMDD", "HHmmss", ...
    "measurement", "measurement_val_1", "measurement_val_2",...
    "oxygen", "oxygen_val",...
    "saturation", "saturation_val",...
    "temperature", "temperature_val",...
    "DPhase", "DPhase_val",...
    "BPhase", "BPhase_val",...
    "RPhase", "RPhase_val",...
    "BAmp", "BAmp_val",...
    "BPot", "BPot_val",...
    "RAmp", "RAmp_val",...
    "RawTem", "RawTem_val",...
    ];

% At the moment we read all the data as strings
format = '';
for i = 1 : 25
    format = [format ' %s'];
end
disp(format);
cellData = textscan( fid, format);

s = cell2struct(cellData, header, 2);

% Get the date
[YY, MMDD] = strtok(s.YYMMDD, '-');
[MM, DD] = strtok(MMDD, '-');
DD = erase(DD, '-');
time = strtok(s.HHmmss, ':');
[HH, mmss] = strtok(s.HHmmss, ':');
[mm, ss] = strtok(mmss, ':');
ss = erase(ss, ':');

o2.DATE = [YY MM DD HH mm ss];
disp(o2.DATE);
% Close the file
% --------------
fclose( fid );

% Everything OK
% -------------
error = 1;

end
