% T
% This is the program to analysis the SWD peaks from the EEG data saved in
% the Nex5 datafiles
clc
clear;
close all;

% Load the program for the analysis
addpath('D:\Matlab_analysis_program\HowToReadAndWriteNexAndNex5FilesInMatlab')
% addpath(genpath('D:\Matlab_analysis_program\MU_analysis'))

% Load the nex5 file data from current folder
current_folder_name= pwd;
fileList = dir(fullfile(current_folder_name, '*.nex5'));

% read the nex5 file from current folder
nex5FilePath = strcat(current_folder_name, '\',fileList.name);
nexFileData = readNexFile(nex5FilePath);

% Load the EEG, unit_data from nex5 data
EEG_raw=nexFileData.contvars{1,1}.data;
EEG_Sample_Freq = 10000;
% Transform the EEG data and change them to real value
DownSampleRate = 10;
[EEG_output, EEG_output_SampleRate]=EEG_Transform(EEG_raw,EEG_Sample_Freq,DownSampleRate);

% Example time for demostration purpose
EEG_Ts=1415;
EEG_Tf=1425;

% Time for the 1 hour EEG recording
% EEG_Ts=1;
% EEG_Tf=3599;


EEG_output=EEG_output(EEG_Ts*1000:EEG_Tf*1000-1,:);

% Set the parameter of SWD detection
NegativeVoltageThreshold=300;

% Plot the SWD, Seizure_idx, Sorted Seizure_idx

[sorted_sum]=Seizure_idx(EEG_output,NegativeVoltageThreshold);

% Obtain and sort all the SWD positive peaks timestamps
SWD_initial_timeStamp=sorted_sum(:,1);

