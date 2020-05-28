function interpTSG_CO2_O2(co2InterpFile, varargin)
%
% Interpolation of O2 measure at co2 dates.
% At the end, we will add the following columns to the .csv:
% O2_RAW      oxygen raw values
% O2_ADJ      oxygen values adjusted
% SATURATION  saturation
%
% Input :
% 1 - .csv file from function "interpTSG_CO2"
%     data is read with read interp
% 2 - Fichier ASCII de mesures TSG
%     Le fichier est ouvert via la fonction "readAsciiTsgCO2"
%
% Fonctions externes appelées :
% readConcatCO2, readAsciiTsgCO2
%
% Fonctions internes en fin de ce fichier :
% selectTSG, interp