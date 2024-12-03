function [avg_count,std_count,mean_distance,std_distance, clustPercentage] = count_cells2(xyzct,channel,stp, voxel_sizeX, voxel_sizeY)

time = size(xyzct,5);

cell_count = zeros(time,1);

avg_shortest_distance = zeros(time,1);

clusteringCoefficient = zeros(time,1);

    
    hblob1 = vision.BlobAnalysis( ...
                'AreaOutputPort', false, ...
                'BoundingBoxOutputPort', false, ...
                'OutputDataType', 'single', ...
                'MinimumBlobArea', 30, ...
                'MaximumBlobArea', 200, ...
                'MaximumCount', 1500);
    

    
    hblob2 = vision.BlobAnalysis( ...
                'AreaOutputPort', false, ...
                'BoundingBoxOutputPort', false, ...
                'OutputDataType', 'single', ...
                'MinimumBlobArea', 10, ...
                'MaximumBlobArea', 300, ...
                'MaximumCount', 1500);
 

for t = 1:stp:time
    
    xyz = xyzct(:,:,:,channel,t);
    
    projection = uint8(255*(max((xyz./max(max(xyz))),[],3)));
    
    projection = wiener2(projection);
        
    projection = adapthisteq(projection); %works way too bad for noisy
%       videos

    thresh = multithresh(projection)*1.2;
    
    mask = projection > thresh;
    
    %   bw = imfill(mask,'holes');
    
    bw = imopen(mask, strel('disk',2));
    
    bw = bwareaopen(bw, 10);
            
    maxs = imextendedmax(projection,  5);

    maxs = imclose(maxs, strel('disk',1));

%   maxs = imfill(maxs, 'holes');

    Jc = imcomplement(projection);
    
    I_mod = imimposemin(Jc, ~bw | maxs);
    
    L = watershed(I_mod);
    
    %labeledImage = label2rgb(L);
    
    [L, ~] = bwlabel(L);
    
    mask2 = imbinarize(L, 1);

%   overlay = imoverlay(projection, mask2, [1 .3 .3]);
        
    Centroid1 = step(hblob1, bw); 
        
    Centroid2 = step(hblob2, mask2);
    
    if size(Centroid1,1) > size(Centroid2,1)
        
        Centroid = Centroid1;
        
    else
        
        Centroid = Centroid2;
        
    end
    
    
    if channel ~=3 && abs(size(Centroid2,1)-size(Centroid1,1)) <= 50
        
        cell_count(t) = (size(Centroid1,1) + size(Centroid2,1) )/2;
    
    else

        cell_count(t) = (size(Centroid1,1));
     
    end
   
    
    Centroid = Centroid.*[voxel_sizeX, voxel_sizeY];
    
%   image_out = insertMarker(projection, Centroid, '*', 'Color', 'green');
    
    matrix_distance = (pdist2(Centroid, Centroid,'euclidean')); 
    
    matrix_distance(matrix_distance == 0) = 9999999;
    
    distances = min(matrix_distance,[],2);
        
    avg_shortest_distance(t) = mean(distances);
    
    sumNeighbor = sum(matrix_distance <= 20,2); 
    
    closeNeighbor = numel(sumNeighbor(sumNeighbor >= 4));
    
    clusteringCoefficient(t) = round((closeNeighbor)/numel(distances),3);
    
    
end

cell_count(cell_count == 0) = [];

avg_shortest_distance(avg_shortest_distance == 0) = [];

clusteringCoefficient(clusteringCoefficient == 0) = [];

avg_count = floor(mean(cell_count));

std_count = round(std(cell_count));

mean_distance = round(mean(avg_shortest_distance),2); 

std_distance = round(std(avg_shortest_distance),2);

clustPercentage = round(mean(clusteringCoefficient),3);

end
