function MU_raster_plot(Neuron_TimeStamp)
for iTrial = 1:length(Neuron_TimeStamp)

    spks            = Neuron_TimeStamp{iTrial}';         % Get all spikes of respective trial
    xspikes         = repmat(spks,3,1);         % Replicate array
    yspikes      	= nan(size(xspikes));       % NaN array

    if ~isempty(yspikes)
        yspikes(1,:) = iTrial-1;                % Y-offset for raster plot
        yspikes(2,:) = iTrial;
    end

    plot(xspikes, yspikes, 'Color', 'k')
end
end