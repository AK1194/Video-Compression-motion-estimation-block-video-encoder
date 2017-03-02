clc
clear all
close all
srcFiles = dir('E:\foreman_10frames\*.pgm'); % the folder in which ur images exists

for j = 1 : length(srcFiles)
    filename = strcat('E:\foreman_10frames\',srcFiles(j).name);
    Im = imread(filename);
    figure, imshow(Im);
end