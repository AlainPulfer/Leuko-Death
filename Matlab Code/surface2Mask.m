%%This code reads an imaris Isosurface and converts it in a 3D mask to be
%%appied to volumetric ims data

addpath('E:\Alain\Unet_Masks\ImarisReader')

addpath('E:\Alain\Unet_Masks\Input')

addpath('E:\Alain\Unet_Masks\Output')

addpath('E:\Alain\Unet_Masks\Videos')

% Select channel and number of rotational augmentation

channel = 1;

rotations = 0;

folder_videos = 'E:\Alain\Unet_Masks\Videos';

videoList = dir(fullfile(folder_videos, '*.ims'));

nvideos = numel(videoList);

% mask3D = zeros([555 555 14]);
% 
% volumes =  zeros([555 555 14]);

for vid = 1:nvideos

videoname = videoList(vid).name;

imsObj = ImarisReader(videoname);

surfObj = imsObj.Surfaces;

time_points = unique(surfObj.GetIndicesT); 
        
data = imsObj.DataSet;

xyzct = data.GetData; % xyzct

    for t = 1:numel(time_points)

        time = time_points(t);
        
        stack = xyzct(:,:,:,channel, time + 1);
        
        stack = uint8(255*stack./max(max(max(stack)))); %Normalization according to plane

        mask = surfObj.GetMask(t-1);  %at the first time point 
        
%         mask3D = cat(4,mask3D, mask);
%         
%         volumes = cat(4,volumes, stack);
        
        mask2D = transpose(max(mask,[],3));
        
        imwrite(imresize(max(stack,[],3),[555 555]), strcat(cd,'\Input\','Original_Video =',num2str(vid),'_time =',num2str(time),'.png'));
       
        imwrite(imresize(max(mask2D,[],3),[555 555]), strcat(cd,'\Output\','Mask_Video =',num2str(vid),'_time =',num2str(time),'.png'));
    
    end

    
    
end

%%

cd 'E:\Alain\Unet_Masks\Input'

list = dir;

n = size(list,1);

images = zeros([n 512 512 1]);

for j = 3:n
    
    imagename= list(j).name;
    
    image = imread(imagename);
        
    images(j,:,:,1) = imresize(uint8(image), [512 512]);
    
end

Inputs = images;

%%

cd 'E:\Alain\Unet_Masks\Output'

list = dir;

n = size(list,1);

images = zeros([n 512 512 1]);

for j = 3:n
    
    imagename= list(j).name;
    
    image = imread(imagename);
        
    images(j,:,:,1) = imresize(uint8(image), [512 512]);
    
end

Outputs = images;


