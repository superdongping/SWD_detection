function [Neuron_firing_rate_sum,MeanSpikeRate]=EEG_Raster_Burst_plot(EEG_output,nexFileData,Chosen_ts,Chosen_tf,EEG_output_SampleRate)
ts=Chosen_ts;
tf=Chosen_tf;

EEG_freq=EEG_output_SampleRate;
figure('Units','normalized','Position',[0 0 .3 1])
clf

%% Plot the EEG raw trace
ax = subplot(5,1,1); hold on
EEG_Seg=EEG_output(ts*EEG_freq+1:tf*EEG_freq);

xstick_interval=floor((tf-ts)/10);

plot(EEG_output(:,2),'k');
ax.XLim = [ts*EEG_freq+1 tf*EEG_freq];
ax.YLim = [-500 500];
ax.XTick  = ts*EEG_freq:xstick_interval*EEG_freq:tf*EEG_freq;
ax.XTickLabel = ts:xstick_interval:tf;
ax.XLabel.String  	= 'Time [s]';
ax.YLabel.String  	= 'EEG (uV)';
ax.Title.String = 'EEG';

%% Plot the Unit spike
ax= subplot(5,1,2); hold on
Neuron_len=length(nexFileData.neurons);
Neuron_TimeStamp_sum=[];

for ii=1:Neuron_len
    %     Neuron_select = 4;
    % import the Neuron TimeStamp
    Neuron_TimeStamp=nexFileData.neurons{ii, 1}.timestamps;
    % Exclude the Neuron TimeStamp which is out of range
    Neuron_TimeStamp(Neuron_TimeStamp>tf)=[];
    Neuron_TimeStamp(Neuron_TimeStamp<ts)=[];
    %     Neuron_TimeStamp=Neuron_TimeStamp';
    Neuron_TimeStamp_sum{1,ii}=Neuron_TimeStamp;
end

MU_raster_plot(Neuron_TimeStamp_sum)
ax.XLim             = [ts tf];
ax.YLim             = [0 length(Neuron_TimeStamp_sum)];
ax.XTick            = ts:xstick_interval:tf;

ax.XLabel.String  	= 'Time [s]';
ax.YLabel.String  	= 'Neuron Number';
ax.Title.String = 'Raster plot';
%% Peristimulus time histogram (PSTH)
ax = subplot(5,1,3);

all = [];
Neuron_firing_rate_sum=[];
for iTrial = 1:length(Neuron_TimeStamp_sum)
    all= [all; Neuron_TimeStamp_sum{iTrial}];% Concatenate spikes of all trials
    % mean firing rate of selected time
    Neuron_firing_rate=length(Neuron_TimeStamp_sum{iTrial})/(tf-ts);
    Neuron_firing_rate_sum=[Neuron_firing_rate_sum; Neuron_firing_rate];
end

MeanSpikeRate=mean(Neuron_firing_rate_sum);

nbins = (tf-ts)*EEG_freq/100; % set bin width = 0.1s
h = histogram(all,nbins);

h.FaceColor = 'k';

mVal = max(h.Values)+round(max(h.Values)*.1);

ax.XLim = [ts tf];
ax.YLim = [0 mVal];

ax.XTick = ts:xstick_interval:tf;

ax.XLabel.String = 'Time [s]';
ax.YLabel.String = 'Spikes/Bin';
ax.Title.String = 'PSTH';


%% Plot burst (Freq >= 150Hz) firing timeStamp

for ii=1:Neuron_len
    Burst_threshold=150;  % Setting the burst threshold'
    Unit_freq=1./diff(nexFileData.neurons{ii, 1}.timestamps);

%     Unit_freq=Data.Spike_Freq{1,ii};
    pos=find(Unit_freq>Burst_threshold)+1; % when calculate the ISI and freq the 1st data was omitted, add 1 to get the accurate position of the time stamp
    Data.Unit_burst_TimeStamp{ii}=nexFileData.neurons{ii, 1}.timestamps(pos);
end

% ts=0;
% tf=1000;

ax= subplot(5,1,4); hold on
Neuron_len=length(Data.Unit_burst_TimeStamp);
Neuron_TimeStamp_sum=[];

for ii=1:Neuron_len
    %     Neuron_select = 4;
    % import the Neuron TimeStamp
    Neuron_TimeStamp=Data.Unit_burst_TimeStamp{1, ii};
    % Exclude the Neuron TimeStamp which is out of range
    Neuron_TimeStamp(Neuron_TimeStamp>tf)=[];
    Neuron_TimeStamp(Neuron_TimeStamp<ts)=[];
    %     Neuron_TimeStamp=Neuron_TimeStamp';
    Neuron_TimeStamp_sum{1,ii}=Neuron_TimeStamp;
end

MU_raster_plot(Neuron_TimeStamp_sum)

ax.XLim             = [ts tf];
ax.YLim             = [0 length(Neuron_TimeStamp_sum)];
ax.XTick            = ts:xstick_interval:tf;

ax.XLabel.String  	= 'Time [s]';
ax.YLabel.String  	= 'Neuron Number';
ax.Title.String = 'Burst firing';

%% Peristimulus time histogram (PSTH) for the burst
ax = subplot(5,1,5);

all = [];
for iTrial = 1:length(Neuron_TimeStamp_sum)
    all= [all; Neuron_TimeStamp_sum{iTrial}];% Concatenate spikes of all trials
end

nbins = (tf-ts)*EEG_freq/100; % set bin width = 0.1s

h = histogram(all,nbins);
h.FaceColor = 'k';

mVal = max(h.Values)+round(max(h.Values)*.1);

ax.XLim = [ts tf];
ax.YLim = [0 mVal];

ax.XTick = ts:xstick_interval:tf;

ax.XLabel.String = 'Time [s]';
ax.YLabel.String = 'Spikes/Bin';
ax.Title.String = 'PSTH for the burst';
end











