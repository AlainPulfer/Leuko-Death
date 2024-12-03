
function [changeIntensity] = fluctIntensity(xyzct)

time = size(xyzct,5);

channel = size(xyzct,4);

intensities = zeros(time,channel);

for cc = 1:channel
    
    for tt = 1:time
        

        xyz = xyzct(:,:,:,cc,tt);
        
        I = uint8(255*(max((xyz./max(max(xyz))),[],3)));
        
        intensities(tt,cc) = mean(mean(I));
    
    end
        
end

% linearFit1 = polyfit(transpose(1:time),intensities(:,1),1);
% 
% slope1 = linearFit1(1);
% 
% linearFit2 = polyfit(transpose(1:time),intensities(:,2),1);
% 
% slope2 = linearFit2(1);
% 
% linearFit3 = polyfit(transpose(1:time),intensities(:,3),1);
% 
% slope3 = linearFit3(1);


changeIntensity = std(intensities);

% slopes = [slope1,slope2,slope3];

end
    
    
    
    