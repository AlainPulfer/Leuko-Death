
function [invSTD] =  pwrSpectrum(xyzct)

time = size(xyzct,5);

channel = size(xyzct,4);

invSTD = zeros(time,channel);

for cc = 1:channel
    
    for tt = 1:time
        
        xyz = xyzct(:,:,:,cc,tt);
        
        I = uint8(255*(max((xyz./max(max(xyz))),[],3)));
        
        [pwr,Hz] = periodogram((double(I2)));

        pwr = 10*log10(mean(pwr,2));
        
        tail = Hz > 0.6*max(Hz);
        
        invSTD(tt,cc) = std(pwr(tail));
    
    end
    
    invSTD = mean(invSTD);
        
end



end



% figure(); plot(Hz,pwr);