import re
from scipy.ndimage import zoom
import plotly.graph_objects as go
import pandas as pd
import os
from PIL import Image
import imageio


def display_3Dvolume(movie_3D, channel, time, zoom_factor=2, opacity=0.1, surface_count=20):
    """
    Interpolates and displays a 3D volume from a 5D movie.

    Parameters:
    - movie_3D: 5D numpy array of the movie data (X, Y, Z, channels, time)
    - channel: Channel of interest to extract the 3D volume
    - time: Time index to extract the 3D volume
    - zoom_factor: Factor by which to interpolate (upsample) the 3D volume
    - opacity: Opacity of the 3D volume rendering
    - surface_count: Number of isosurfaces to display in the volume rendering
    """

    # Extract the 3D scenery from the 5D movie
    scenery_3D = movie_3D[:,:,:,channel, time]

    # Perform interpolation (upsampling)
    scenery_3D_interpolated = zoom(scenery_3D, zoom_factor)

    # Visualize the 3D volume using Plotly
    fig = go.Figure(data=go.Volume(
        x=np.linspace(0, scenery_3D_interpolated.shape[0], scenery_3D_interpolated.shape[0]),
        y=np.linspace(0, scenery_3D_interpolated.shape[1], scenery_3D_interpolated.shape[1]),
        z=np.linspace(0, scenery_3D_interpolated.shape[2], scenery_3D_interpolated.shape[2]),
        value=scenery_3D_interpolated.flatten(),
        opacity=opacity,  # Adjust opacity for better visualization
        surface_count=surface_count,  # Number of isosurfaces to display
        colorscale='Gray'  # Color map for volume rendering
    ))

    fig.update_layout(
        scene=dict(
            xaxis_title='X',
            yaxis_title='Y',
            zaxis_title='Z',
        ),
        title="Interpolated 3D Volume"
    )

    fig.show()

def extract_and_save_frames(excel_file, video_data, channel, output_folder="result", square_size=59):
    """
    Extracts frames from the video around centroids and saves them in a TIFF file.

    Parameters:
    - excel_file: Path to the Excel file containing object coordinates (X, Y, Z, time, ID).
    - video_data: 5D numpy array representing the movie (X, Y, Z, channels, time).
    - output_folder: Folder where the resulting TIFFs will be saved.
    - square_size: Size of the square to extract around each centroid (default is 59x59).
    """

    # Create output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Read the Excel file and extract coordinates from the "Position" sheet
    df = pd.read_excel(excel_file, sheet_name="Position")

    # Get the raw values from the DataFrame
    data = df.values

    # Ensure the ID column is treated as a string to handle mixed data types
    data[:, 7] = data[:, 7].astype(str)

    # Half size of the square to extract
    half_size = square_size // 2

    # Extract unique object IDs (from column 8, index 7)
    unique_ids = np.unique(data[:, 7])

    for obj_id in unique_ids:
        # Filter rows for the current object ID (based on column 8, index 7)
        obj_data = data[data[:, 7] == obj_id]

        # List to store the sequence of frames for this object
        frames = []

        for row in obj_data:
            # Access values directly from the row using array indexing
            try:
                x = int(row[0])  # X-coordinate (column 1)
                y = int(row[1])  # Y-coordinate (column 2)
                z = int(row[2])  # Z-coordinate (column 3)
                t = int(row[6])  # Time (column 7)
            except ValueError:
                print(f"Skipping invalid row: {row}")
                continue  # Skip rows with invalid data

            # Extract the frame at time t (assuming video_data is 5D: (X, Y, Z, channels, time))
            frame = video_data[:, :, channel, t]  # Extract frame for the channel of interest

            # Cut a 59x59 square around the centroid (X, Y)
            x_min = max(x - half_size, 0)
            x_max = min(x + half_size, frame.shape[0])
            y_min = max(y - half_size, 0)
            y_max = min(y + half_size, frame.shape[1])

            square = frame[x_min:x_max, y_min:y_max]

            # Add the extracted square to the sequence
            frames.append(square)

        # Convert the list of frames to a TIFF sequence
        tiff_filename = os.path.join(output_folder, f"cell_death_{obj_id}.tif")

        # Save frames as a multi-page TIFF
        imageio.mimwrite(tiff_filename, frames, format='TIFF')
        print(f"Saved TIFF for object {obj_id} as {tiff_filename}")