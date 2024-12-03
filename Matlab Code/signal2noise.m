function [avg_snr, avg_peakSnr] = signal_to_noise2(xyzct, channel, stp, adaptative)

time = size(xyzct,5);

snr = zeros(time,1);

peakSnr = zeros(time,1);

for t = 1:stp:time
    
    xyz = xyzct(:,:,:,channel,t);
    
    projection = uint8(255*(max((xyz./max(max(xyz))),[],3)));
    
    reference = wiener2(projection, [10,10]);
                
    [snr(t),peakSnr(t)] = psnr(projection, reference);
        
        
    if adaptative == 0
            
        filtered = medfilt2(projection,[5,5]);
        
        noisy_image = projection - filtered;
        
        thresh = multithresh(filtered);
      
        foreground_mask = filtered > thresh;
        
        background_mask = ones(size(foreground_mask)) - foreground_mask;
        
        fg = projection(foreground_mask);
        
        bg = noisy_image(background_mask==1);
    
        peakSnr(t) = (mean(fg)-mean(bg))./(std(double(bg)));
    
    end
    
    peakSnr(peakSnr == 0) = [];
    
    avg_peakSnr = floor(mean(peakSnr));
    
    avg_snr = floor(mean(snr));
          
end


end