function [CorrSWD,CorrNonSWD,LagSWD,LagNonSWD]=CrossCorrelationLagAnalysis(cellData, behavData, seizureInterval, nonSeizureInterval)
%% This program is used to quantify the cross correlation and time lag among different unit, which was originally written by Konstantin

rateHistogramBinSize = 0.01;
xCorrWindowSize = 0.5; 

[cellData] = getRateHistograms(cellData,behavData,rateHistogramBinSize);

[~,seizureInds] = applyIntervalFilter(cellData.rateHistogramBins(1:end-1),seizureInterval);

[~,nonSeizureInds] = applyIntervalFilter(cellData.rateHistogramBins(1:end-1),nonSeizureInterval);

% on stage mean SWD
disp('SWD cross-correlation')
[RMatOn,lagMatOn] = popCorr(cellData,xCorrWindowSize,rateHistogramBinSize,seizureInds);

% waitforbuttonpress


% off stage mean non-SWD
disp('Non-SWD cross-correlation')
[RMatOff,lagMatOff] = popCorr(cellData,xCorrWindowSize,rateHistogramBinSize,nonSeizureInds);

%%
figure(125)
clf
subplot(232)
h=imagesc(RMatOn);
set(h,'AlphaData',~isnan(RMatOn))
% imagesc_lowbotton(RMatOn)
axis square
xlabel('neuron')
ylabel('neuron')
title('correlation (SWD)')
colorbar
colormap('parula')
clim([0 0.06])

subplot(231)
% imagesc_lowbotton(RMatOff)
h=imagesc(RMatOff);
set(h,'AlphaData',~isnan(RMatOff))
axis square
xlabel('neuron')
ylabel('neuron')
title('correlation (Non-SWD)')
colorbar
clim([0 0.06])

subplot(235)
% imagesc(lagMatOn)
% lagMatOn=tril(lagMatOn,-1);
h=imagesc(lagMatOn);
set(h,'AlphaData',~isnan(lagMatOn))
axis square
xlabel('neuron')
ylabel('neuron')
title('lag (SWD)')
colorbar
clim([-0.5 0.5])

subplot(234)
imagesc(lagMatOff)
% lagMatOff=tril(lagMatOff,-1);
h=imagesc(lagMatOff);
set(h,'AlphaData',~isnan(lagMatOff))
axis square
xlabel('neuron')
ylabel('neuron')
title('lag (Non-SWD)')
colorbar
clim([-0.5 0.5])

subplot(233)
nonDuplicateInds = ones(size(RMatOn));
nonDuplicateInds = tril(nonDuplicateInds,-1);
CorrSWD = RMatOn(nonDuplicateInds == 1);
LagSWD = lagMatOn(nonDuplicateInds == 1);
CorrNonSWD = RMatOff(nonDuplicateInds == 1);
LagNonSWD = lagMatOff(nonDuplicateInds == 1);

edges = linspace(0, 0.1, 40);

histogram(CorrSWD,'BinEdges',edges,'FaceColor','r','EdgeColor','none')
hold on
histogram(CorrNonSWD,'BinEdges',edges, 'FaceColor','k','EdgeColor','none')
% xlim([0 0.06])
legend
axis square
xlabel('Correlation')

subplot(236)
edges = linspace(-0.5, 0.5, 40);
histogram(LagSWD,'BinEdges',edges ,'FaceColor','r','EdgeColor','none')
hold on
histogram(LagNonSWD,'BinEdges',edges,'FaceColor','k','EdgeColor','none')
% xlim([-0.4 0.4])
legend
xlabel('Lag')
axis square
end