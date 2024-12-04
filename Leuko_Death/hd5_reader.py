import h5py
import numpy as np
import re


def hd5_reader(videoname, resolution, max_proj):
  """
  This function takes as input the path of a movie in h5f format, the level of resolution (0,1)
  and an argument for maximum projection (true, false). The output is a 2D time or 3D time lapse.
  """

  dataset = h5py.File(videoname, 'r')

  if 'DataSet' not in dataset:
      raise ValueError(f"'DataSet' not found in {videoname}. Available keys: {list(dataset.keys())}")

  # Determine quality level
  if resolution == 0:
      quality = 'ResolutionLevel 0'
  else:
      quality = 'ResolutionLevel 1'

  # Check if 'quality' level exists
  if quality not in dataset['DataSet']:
      raise ValueError(f"'{quality}' not found in 'DataSet'. Available keys: {list(dataset['DataSet'].keys())}")

  # Check if 'TimePoint 0' exists
  if 'TimePoint 0' not in dataset['DataSet'][quality]:
      raise ValueError(f"'TimePoint 0' not found in '{quality}'. Available keys: {list(dataset['DataSet'][quality].keys())}")

  nChannels = np.array(dataset['DataSet'][quality]['TimePoint 0']).shape[0]

  channels = np.array(dataset['DataSet'][quality]['TimePoint 0'])

  nTimePoints = np.array(list(dataset['DataSet'][quality].keys())).shape[0]

  datatimes = np.array(dataset['DataSet']['ResolutionLevel 0'])

  dimension = np.array(dataset['DataSet'][quality]['TimePoint 0']['Channel 0']['Data']).shape

  if max_proj == True:

      xyct = np.zeros((dimension[1],dimension[2],nChannels,nTimePoints))

      for ii in datatimes:

          time = np.int32(re.findall(r'\d+', ii)[0])

          for channel in range(0,nChannels):

              currentVolume = np.array(dataset.get('DataSet').get(quality).get(ii).get(channels[channel]).get('Data'))

              projection = np.max(currentVolume,0)

              xyct[:,:,channel,time] = projection

      mxx = np.max(xyct)
      mnn = np.min(xyct)

      xyct = 255*((xyct-mnn)/(mxx-mnn))

      output = np.uint8(xyct)

  if max_proj == False:

      hdf5_store = h5py.File("./cache.hdf5", "a")

      zxyct =  hdf5_store.create_dataset("zxyct",(dimension[0],dimension[1],dimension[2],nChannels,nTimePoints), compression="gzip")

      for ii in datatimes:

          time = int(re.findall(r'\d+', ii)[0])

          for channel in range(0,nChannels):

              currentVolume = np.array(dataset.get('DataSet').get(quality).get(ii).get(channels[channel]).get('Data'))

              zxyct[:,:,:,channel,time] = currentVolume

      output = zxyct
