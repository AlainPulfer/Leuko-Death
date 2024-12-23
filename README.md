# Leuko-Death  

**Leuko-Death** is a Python toolkit for reading movies of cell death events acquired with two-photon intravital microscopy and stored in HDF5 files. The repository provides functionalities to read HDF5 movies, extract and save frames, and visualize 2D and 3D volumes. This repository and the related data provide the basis to build derivative datasets to design and test computational methods for the detectin and classifcation of cell death. 

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

2. Clone the repository:  
   ```bash  
   pip install requirement.txt

## Download files from Zenodo

1. Download target movie:  
   ```python  
   import requests

   response = requests.get('https://zenodo.org/api/records/13787839')
   file_name = 'Neu1.h5'  #specify here the
   metadata = response.json()

   files = metadata['files']
   file_url = next(file['links']['self'] for file in files if file['key'] == file_name)
   file_response = requests.get(file_url)

   with open(file_name, 'wb') as file:
    for chunk in file_response.iter_content(chunk_size=1024):
        if chunk:
            file.write(chunk)

2. Download zip file containing annotations:  
   ```python
   file_name = 'Annotations.zip'
   metadata = response.json()
   files = metadata['files']
   file_url = next(file['links']['self'] for file in files if file['key'] == file_name)
   file_response = requests.get(file_url)

   with open(file_name, 'wb') as file:
    for chunk in file_response.iter_content(chunk_size=1024):
        if chunk:
            file.write(chunk)

## Usage 

1. Append pathway of repository:  
   ```python
   import sys
   sys.path.append('/path/to/Leuko-Death')  

2. Reading HDF5 movies:
   ```python
   from Leuko_Death import hd5_reader
   movie_2D = hd5_reader('Neu1.h5', 0, 1)
   movie_3D = hd5_reader('Neu1.h5', 0, 0)  

3. Inspecting movies metadata:
   ```python
   x_res = movie_2D.shape[0]
   y_res = movie_2D.shape[1]
   channels = movie_2D.shape[2]
   frame_duration = movie_2D.shape[3]
   
   print(f"Number of channels: {channels}")
   print(f"X resolution: {x_res}")
   print(f"Y resolution: {y_res}")
   print(f"Frame duration: {frame_duration}")  

4. Display 2D scene:
   ```python

   from matplotlib import pyplot as plt

   time = 1
   channel = 0
   scene_2D = movie_2D[:, :, channel, time]

   plt.imshow(scene_2D, cmap='gray')
   plt.show()

5. Display 3D scene:
   ```python
   scene_3D = movie_3D[:,:,:,channel, time]

   display_3Dvolume(scene_3D, channel=0, time=10, zoom_factor=2)

6. Exctract and saves in TIFF file froms of cell death sequence annotated Select annotation containing tracks of cell deaths and exctract the corresponding frames in multi TIFF file:
   ```python

   annotation_path = '/content/Annotations/Cell deaths/Neu1_ch1.xls'

   extract_and_save_frames(annotation_path, movie_2D, channel=0, output_folder="/content/result", square_size=59)

# Demo
The following link is a demo for the use of Leuko-Death in Colab: [Open in Colab](https://colab.research.google.com/drive/1v063vofn-dUwEjd8qWW8qaGyuXwpriBy#scrollTo=PeEih678oKaR)

# Data Access
You can download the HDF5 movies and annotation files from:
https://zenodo.org/api/records/13787839
https://app.immunemap.org/cddb

# License
This project is licensed under the GPL 3.0 License. See the LICENSE file for details.



