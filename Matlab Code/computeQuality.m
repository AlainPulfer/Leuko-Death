function quality = computeQuality(table)


resolution = table2array(table(:,2));

voxSize = table2array(table(:,3));

meanSNR = nanmean(table2array(table(:,5)),2);

meanPeakSNR = nanmean(table2array(table(:,6)),2);

avgInvSTD = nanmean(table2array(table(:,7)),2);

avgChangeIntensity = nanmean(table2array(table(:,8)),2);

quality = [resolution(:,2:3),meanSNR,meanPeakSNR,avgInvSTD, avgChangeIntensity];

mn = min(quality);

mx = max(quality);
   
normalizedQuality = (quality - mn)./(mx-mn);

end

%%

% histogram stats SNR, pwrSpec, Cells, Cluster coeff

SNR = tabl(:,1:3);

meanSNR = nanmean(SNR,2);

pwrSPEC = tabl(:,9:12);

meanPwr = nanmean(pwrSPEC,2);

brightnessStd = tabl(:,13:16);

meanBrightnessStd = nanmean(brightnessStd,2);

cellsN = tabl(:,17:20);

avgCells = nanmean(cellsN,2);

clustCoef= tabl(:,25:28);

