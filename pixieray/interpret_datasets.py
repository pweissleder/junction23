import pandas as pd
import os
import json
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.animation import FuncAnimation, PillowWriter
from IPython.display import display, HTML
from moviepy.editor import VideoFileClip
import cv2
from tqdm import tqdm


print(os.getcwd())

def get_data():
    # Pfad zur Excel-Datei
    excel_datei = 'driving_p1_round1.xlsx'
    csv_datei = 'driving_p1_round1.csv'

    # Initialisiere einen leeren DataFrame, um Daten aus allen Schleifendurchläufen zu kombinieren
    df_combined = pd.DataFrame()

    for i in range(4):
        json_datei_afe = f'datasets/driving/Participant_1/AFE_00{i}_CONFIDENTIAL.json'
        json_datei_imu = f"datasets/driving/Participant_1/IMU_00{i}_CONFIDENTIAL.json"

        # DataFrame aus der JSON-Datei erstellen
        with open(json_datei_afe, 'r') as f:
            data_afe = json.load(f)

        # DataFrame erstellen
        df_afe = pd.json_normalize(data_afe, sep='_')

        df_afe['afe_R_m0'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][0] if len(x) > 1 and x[1] else None)
        df_afe['afe_R_m1'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][1] if len(x) > 1 and x[1] else None)
        df_afe['afe_R_m2'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][2] if len(x) > 1 and x[1] else None)
        df_afe['afe_R_m3'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][3] if len(x) > 1 and x[1] else None)
        df_afe['afe_R_m4'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][4] if len(x) > 1 and x[1] else None)
        df_afe['afe_R_m5'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][5] if len(x) > 1 and x[1] else None)

        df_afe['afe_L_m0'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][0] if len(x) > 1 and x[1] else None)
        df_afe['afe_L_m1'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][1] if len(x) > 1 and x[1] else None)
        df_afe['afe_L_m2'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][2] if len(x) > 1 and x[1] else None)
        df_afe['afe_L_m3'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][3] if len(x) > 1 and x[1] else None)
        df_afe['afe_L_m4'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][4] if len(x) > 1 and x[1] else None)
        df_afe['afe_L_m5'] = df_afe['afe'].apply(lambda x: x[1]['m'][0][5] if len(x) > 1 and x[1] else None)

        df_afe['ticktime'] = df_afe['afe'].apply(lambda x: x[1]['i'][0] if len(x) > 1 and x[1] else None)
        df_afe['timestamp'] = df_afe['afe'].apply(lambda x: x[1]['i'][1] if len(x) > 1 and x[1] else None)
        df_afe['afe_counter'] = df_afe['afe'].apply(lambda x: x[1]['i'][3] if len(x) > 1 and x[1] else None)
        df_afe['afe_R_STATUS'] = df_afe['afe'].apply(lambda x: x[1]['i'][2] if len(x) > 1 and x[1] else None)
        df_afe['afe_L_STATUS'] = df_afe['afe'].apply(lambda x: x[0]['i'][2] if len(x) > 0 and x[0] else None)

        df_afe['lightsensor_STATUS'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[2] if len(x) > 0 and x[0] else None)
        df_afe['lightsensor_counter'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[3] if len(x) > 0 and x[0] else None)

        df_afe['lightsensor_uv1'] = df_afe['auxSensors_lightAmbient_v'].apply(lambda x: x[0] if len(x) > 0 and x[0] else None)
        df_afe['lightsensor_uv2'] = df_afe['auxSensors_lightAmbient_v'].apply(lambda x: x[1] if len(x) > 0 and x[0] else None)
        df_afe['lightsensor_ambient'] = df_afe['auxSensors_lightAmbient_v'].apply(lambda x: x[2] if len(x) > 0 and x[0] else None)
        df_afe['lightsensor_ir'] = df_afe['auxSensors_lightAmbient_v'].apply(lambda x: x[3] if len(x) > 0 and x[0] else None)

        df_afe.drop('afe', axis=1, inplace=True)
        df_afe.drop('auxSensors_lightAmbient_n', axis=1, inplace=True)
        df_afe.drop('auxSensors_lightAmbient_i', axis=1, inplace=True)
        df_afe.drop('auxSensors_lightAmbient_v', axis=1, inplace=True)
        df_afe.drop('auxSensors_lightAmbient_s', axis=1, inplace=True)
        df_afe.drop('auxSensors_tempEt_n', axis=1, inplace=True)
        df_afe.drop('auxSensors_tempEt_i', axis=1, inplace=True)
        df_afe.drop('auxSensors_tempEt_v', axis=1, inplace=True)
        df_afe.drop('auxSensors_tempEt_s', axis=1, inplace=True)


        with open(json_datei_imu, 'r') as f:
            data_imu = json.load(f)

        df_imu = pd.json_normalize(data_imu, sep='_')
        columns_df_imu = ['t', 'i', 'v']
        df_afe[columns_df_imu] = df_imu[columns_df_imu]
        df_afe['imu_STATUS'] = df_afe['i'].apply(lambda x: x[2] if len(x) > 0 and x[0] else None)
        df_afe['imu_counter'] = df_afe['i'].apply(lambda x: x[3] if len(x) > 0 and x[0] else None)
        df_afe['imu_x'] = df_afe['v'].apply(lambda x: x[0] if len(x) > 0 and x[0] else None)
        df_afe['imu_y'] = df_afe['v'].apply(lambda x: x[1] if len(x) > 0 and x[0] else None)
        df_afe['imu_z'] = df_afe['v'].apply(lambda x: x[2] if len(x) > 0 and x[0] else None)

        df_afe.drop('v', axis=1, inplace=True)
        df_afe.drop('i', axis=1, inplace=True)

        # Füge die Daten des aktuellen Durchlaufs zum kombinierten DataFrame hinzu
        df_combined = pd.concat([df_combined, df_afe], ignore_index=True)

    # Erste Übersicht der kombinierten Daten anzeigen
    print("Erste Übersicht der kombinierten Daten:")
    print(df_combined.head())

    # DataFrame in Excel speichern
    df_combined.to_excel(excel_datei, index=False)
    df_combined.to_csv(csv_datei, index=False)
    print(f"DataFrame wurde erfolgreich in {excel_datei} gespeichert.")
### Analysis CSV
def analysis_dataframe(df_combined):
    max_x = df_combined['imu_x'].max()
    max_y = df_combined['imu_y'].max()
    max_z = df_combined['imu_z'].max()

    min_x = df_combined['imu_x'].min()
    min_y = df_combined['imu_y'].min()
    min_z = df_combined['imu_z'].min()

    print(f"Die größte X-Koordinate ist: {max_x}")
    print(f"Die größte Y-Koordinate ist: {max_y}")
    print(f"Die größte Z-Koordinate ist: {max_z}")
    print(f"Die größte X-Koordinate ist: {min_x}")
    print(f"Die größte Y-Koordinate ist: {min_y}")
    print(f"Die größte Z-Koordinate ist: {min_z}")


###State 2 Visualization
def visualize_eyemovement(df):

    # Erstelle ein 3D-Figurenobjekt
    fig = plt.figure(figsize=(10, 10))
    ax = fig.add_subplot(111, projection='3d')

    # Scatter-Plot mit Zeit als Farbskala
    scatter = ax.scatter(df['imu_x'], df['imu_y'], df['imu_z'], c=df['afe_timestamp'], cmap='viridis', s=50)

    # Füge eine Farbskala hinzu
    cbar = fig.colorbar(scatter, ax=ax, label='Zeit')

    # Beschriftungen der Achsen
    ax.set_xlabel('X-Achse')
    ax.set_ylabel('Y-Achse')
    ax.set_zlabel('Z-Achse')


    # Titel des Diagramms
    ax.set_title('4-D Koordinatensystem')

    for i, txt in enumerate(df['afe_timestamp']):
        ax.text(df['imu_x'][i], df['imu_y'][i], df['imu_z'][i], str(i + 1), color='red')

    plt.savefig('scatter_plot.png')



def vid_eyemovement(df, points_per_frame, gif_name):
    # Erstelle ein 3D-Figurenobjekt
    fig = plt.figure(figsize=(10, 10))
    ax = fig.add_subplot(111, projection='3d')

    # Initialisiere leeren Scatter-Plot
    scatter = ax.scatter([], [], [], c=[], cmap='viridis', s=50)

    # Füge eine Farbskala hinzu
    cbar = fig.colorbar(scatter, ax=ax, label='Zeit')

    # Beschriftungen der Achsen
    ax.set_xlabel('X-Achse')
    ax.set_ylabel('Y-Achse')
    ax.set_zlabel('Z-Achse')

    # Titel des Diagramms
    ax.set_title('4-D Koordinatensystem')

    ax.set_xlim(-8, 8)
    ax.set_ylim(5, 15)
    ax.set_zlim(-8, 8)

    max_points_per_frame = points_per_frame

    def update(frame):
        nonlocal scatter

        # Zeige maximal 10 Punkte
        start = max(0, frame - max_points_per_frame + 1)
        end = frame + 1

        x = df['imu_x'][start:end]
        y = df['imu_y'][start:end]
        z = df['imu_z'][start:end]
        timestamp = df['afe_timestamp'][start:end]

        # Entferne alle vorhandenen Punkte
        if scatter:
            scatter.remove()

        # Füge neuen Scatter-Plot hinzu
        scatter = ax.scatter(x, y, z, c=timestamp, cmap='viridis', s=50)

        # Fortschrittsbalken aktualisieren
        pbar.update(1)

    # Erstellen Sie einen Fortschrittsbalken mit der Gesamtanzahl der Frames
    with tqdm(total=len(df['afe_timestamp'])) as pbar:
        # Erstellen Sie die Animation
        animation = FuncAnimation(fig, update, frames=len(df['afe_timestamp']), interval=1000, repeat=False)

        # Speichern Sie die Animation
        gif_datei = gif_name
        animation.save(gif_datei, writer='ffmpeg', fps=30)





def get_fps(video_path):
    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    cap.release()
    return fps

###MAIN

#get_data()

csv_datei = 'driving_p1_round1.csv'
df = pd.read_csv(csv_datei)
df = df.head(100)


#analysis_dataframe(df)


# video_path = 'datasets/driving/Participant_1/Participant_1-Driving-720p.mp4'
# fps = get_fps(video_path)
# print(f'FPS Rate: {fps}')

#df = df.head(30)
#visualize_eyemovement(df)

vid_eyemovement(df, "driving_test.gif")