# Leuko-Death  

**Leuko-Death** is a Python toolkit for processing and analyzing two-photon intravital movies stored in HDF5 files. The repository provides functionalities to read HDF5 movies, extract and save frames, and visualize 3D volumes. It also includes utilities for inspecting movie metadata and working with annotations.  

## Features  
- **HDF5 Reader**:  
  - Load two-photon intravital movies as 2D or 3D time-lapse data.  
  - Support for `xyct` (2D) and `zxyct` (3D) dimensions.  
- **Utilities**:  
  - Display 3D volumes and individual frames.  
  - Extract and save specific frames from the time-lapse.  
  - Inspect movie metadata, such as resolution, frame count, and number of channels.  
- **Annotation Support**:  
  - Download and unzip annotation files directly from Zenodo for easier integration with the movies.  

## Installation  

1. Clone the repository:  
   ```bash  
   git clone https://github.com/AlainPulfer/Leuko-Death.git  
   cd Leuko-Death

   pip install requirements.txt

## Usage 

import sys  
sys.path.append('/path/to/Leuko-Death')  

# Reading HDF5 movies

from Leuko_Death import hd5_reader  
 
movie_2D = hd5_reader('Neu1.h5', 0, 1)  

movie_3D = hd5_reader('Neu1.h5', 0, 0)  

# Inspecting movie metadata

x_res = movie_2D.shape[0]  
y_res = movie_2D.shape[1]  
channels = movie_2D.shape[2]  
frame_duration = movie_2D.shape[3]  

print(f"Number of channels: {channels}")  
print(f"X resolution: {x_res}")  
print(f"Y resolution: {y_res}")  
print(f"Frame duration: {frame_duration}")  

# Display 2D scene

from matplotlib import pyplot as plt  

time = 1  
channel = 0  
scene_2D = movie_2D[:, :, channel, time]  
plt.imshow(scene_2D, cmap='gray')  
plt.show()

# Display 3D scene

scene_3D = movie_3D[:,:,:,channel, time]

display_3Dvolume(scene_3D, channel=0, time=10, zoom_factor=2)

# Select annotation containing tracks of cell deaths and exctract the corresponding frames in multi TIFF file

annotation_path = '/content/Annotations/Cell deaths/Neu1_ch1.xls'
extract_and_save_frames(annotation_path, movie_2D, channel=0, output_folder="/content/result", square_size=59)

## Data Access
You can download sample HDF5 movies and annotation files from Zenodo: https://zenodo.org/api/records/13787839

##License
This project is licensed under the MIT License. See the LICENSE file for details.
