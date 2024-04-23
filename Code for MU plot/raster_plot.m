function raster_plot(unitRaster,spikeBinSize,spikeTimeBins,ts,tf)
unitRaster_F = full(rasterSparsify(unitRaster,spikeBinSize,spikeTimeBins))./spikeBinSize;      
line([unitRaster.relEventTime';unitRaster.relEventTime'],...
[unitRaster.TrialInd';unitRaster.TrialInd']+repmat([-0.4;0.4],1,length(unitRaster.TrialInd)),'color','k')
xlabel('Time')
xlim([ts tf])
ylabel('trial number')
end