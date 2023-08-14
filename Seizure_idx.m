function [sorted_sum]=Seizure_idx(EEG_output,NegativeVoltageThreshold)
%%
figure('Units','normalized','Position',[0 0 .3 1])
clf

subplot(6,1,1)
plot(EEG_output(:,1),EEG_output(:,2),'k')
title ('EEG raw plot')
xlabel ('Time (s)')
ylabel ('EEG votage (uV)')
xlim ([EEG_output(1,1) EEG_output(end,1)])
ylim ([-500 500])
%%
subplot(6,1,2)
EEG_raw_down=EEG_output(:,2);
EEG_revert=smooth(EEG_raw_down*(-1),30);
EEG_revert(EEG_revert<NegativeVoltageThreshold)=0;
[pks, locs]=findpeaks(EEG_revert);
% locs=locs+EEG_output(1,1)*1000;
plot(EEG_output(:,1),EEG_revert*(-1),'k')
title ('Voltage amplitude and time')
xlabel ('Time (s)')
ylabel ('Voltage (uV)')
xlim ([EEG_output(1,1) EEG_output(end,1)])
ylim([-500 500])
%%
subplot(6,1,3)
% plot(EEG_output(:,1),EEG_raw_down)
% hold on
% plot(locs/1000+EEG_output(1,1),EEG_raw_down(locs),'m*');


% title('EEG raw with seizure index')
% xlabel ('Time (s)')
% ylabel ('EEG votage (uV)')
% xlim ([EEG_output(1,1) EEG_output(end,1)])

% ylim([-500 500])

loc_peak=[locs pks];
distance=pdist(loc_peak,'euclidean');



if ~isempty(locs)
    Total_events_length=length(locs);

    locs_n=locs/10000;
    seizure_idx=[];
    for k=1:Total_events_length
        if k==1
            seizure_idx(k)=((pks(1)+pks(2))/2)*(1/(locs_n(2)-locs_n(1)));
        elseif k==Total_events_length
            seizure_idx(k)=((pks(end-1)+pks(end))/2)*(1/(locs_n(end)-locs_n(end-1)));
        else
            seizure_idx(k)=((pks(k-1)+pks(k)+pks(k+1))/3)*((1/(locs_n(k+1)-locs_n(k))+(1/(locs_n(k)-locs_n(k-1)))/2));
        end
    end
    seizure_idx=seizure_idx/1000; % make it smaller and easy to see the value
    %%

    subplot(6,1,4)

    %     plot(EEG_output(:,1),EEG_raw_down)
    %     hold on
    %     plot(locs/1000+EEG_output(1,1),seizure_idx*10,'r*')

    seizure_detection=seizure_idx;
    % display seizure dection results
    seizure_value=-400;

    % To determinate the SWD_idx based on seizure_idx on a percentage,25%
    %
    percentage_threshold=25;
    [SWD_idx_loc_output,SWD_idx]=SWD_idx_low_remover(seizure_idx,locs,percentage_threshold);

    ori_locs=SWD_idx_loc_output(:,2);
    ori_seizure_idx=SWD_idx_loc_output(:,1);

    % sorting the data according to its seizure idx
    [sorted_seizure_idx,sortIdx] = sort(ori_seizure_idx,'descend');
    % sort B using the sorting index
    sorted_locs = ori_locs(sortIdx);
    sorted_locs=sorted_locs/1000; % change it to the real time (second)

    sorted_sum=[sorted_locs sorted_seizure_idx];

    seizure_detection(seizure_detection<SWD_idx)=0;
    seizure_detection(seizure_detection>=SWD_idx)=seizure_value;
    plot(locs/1000+EEG_output(1,1),seizure_detection,'g*')
    ylim([-500 500])


    pos=find(seizure_detection==seizure_value);
    output_locs=locs(pos);

    %     title('EEG raw with higher seizure index')
    %     xlabel ('Time (s)')
    %     ylabel ('EEG votage (uV)')
    %     xlim ([EEG_output(1,1) EEG_output(end,1)])
    %     ylim([-500 500])


    subplot(6,1,3)
    %     plot(locs/1000+EEG_output(1,1),seizure_idx*10)

    x1=locs/1000+EEG_output(1,1);
    y1=seizure_idx*10;

    x=EEG_output(1,1):0.001 :EEG_output(end,1);
    y=zeros(1,length(x));


    idx=floor((x1-EEG_output(1,1))*1000);
    for kk=1:length(idx)
        pos5=idx(kk);
        y(pos5)=y1(kk);

    end
    plot(x,y,'k','LineWidth',1)
    title('SWD index')
    xlabel ('Time (s)')
    ylabel ('SWD index')
    xlim ([EEG_output(1,1) EEG_output(end,1)])
    ylim([-20 200])

    subplot(6,1,4)

    remove_idx=find(seizure_detection==0);
    locs(remove_idx)=[];


    plot(EEG_output(:,1),EEG_raw_down,'k')
    hold on
    plot(locs/1000+EEG_output(1,1),EEG_raw_down(locs),'r*');


    title('EEG raw with seizure index')
    xlabel ('Time (s)')
    ylabel ('EEG votage (uV)')
    xlim ([EEG_output(1,1) EEG_output(end,1)])

    ylim([-500 500])

    subplot(6,1,5)
    EEG_raw_seg=EEG_raw_down;
    EEG_raw_seg_s=smooth(EEG_raw_seg,50);
    EEG_output_SampleRate=1000;
    eegFilt = bandpass(EEG_raw_seg_s,[2 20],EEG_output_SampleRate);

    %          search the negative max in the EEG_raw_seg
    V_SWD_threshold=300;
    search_range_left=1000;
    search_range_right=3000;

%     plot(EEG_raw_seg,'k')
%     hold on
    plot(eegFilt,'k')
%       xlim ([EEG_output(1,1) EEG_output(end,1)])
        ylim([-500 500])

    title('Smooth')

    for mm=1:length(locs)

        SWD_timeStamp=locs(mm);
        Postive_start=SWD_timeStamp-300;
        Postive_end=SWD_timeStamp;
        [pks5, pos5]=findpeaks(eegFilt(Postive_start:Postive_end));
        Positive_x_position(mm)=pos5(end)+Postive_start;
    end

 subplot(6,1,6)
 plot(EEG_output(:,1),EEG_raw_down,'k')
    hold on
    plot(locs/1000+EEG_output(1,1),EEG_raw_down(locs),'r*');
    plot(Positive_x_position/1000+EEG_output(1,1),EEG_raw_down(Positive_x_position),'g*');
        title('Final SWD onset labeled')
        xlabel ('Time (s)')
        ylabel ('EEG votage (uV)')
        xlim ([EEG_output(1,1) EEG_output(end,1)])
        ylim([-500 500])

end