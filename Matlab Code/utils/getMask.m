%%This code reads an imaris Isosurface and converts it in a 3D mask to be
%%

function [Masks_3D, Masks_2D] = getMask(videoname)
	
	Masks_3D = [];

	Masks_2D = [];

imsObj = ImarisReader(videoname);

surfObj = imsObj.Surfaces;

time_points = unique(surfObj.GetIndicesT); 
        

    for t = 1:numel(time_points)

        mask_3D = surfObj.GetMask(t-1);  
        
        Masks_3D = cat(4,Masks_3D, mask_3D);
        
        mask_2D = transpose(max(mask_3D,[],3));

	   Masks_2D = cat(4,Masks_2D, mask_2D);
            
    end

   
end
