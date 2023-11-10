import pandas as pd
import os
import json

print(os.getcwd())

# Annahme: Deine JSON-Datei heißt 'daten.json'
import pandas as pd
import json

# Pfad zur Excel-Datei
excel_datei = 'driving_p1_round1.xlsx'

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

    df_afe['afe_ticktime'] = df_afe['afe'].apply(lambda x: x[1]['i'][0] if len(x) > 1 and x[1] else None)
    df_afe['afe_timestamp'] = df_afe['afe'].apply(lambda x: x[1]['i'][1] if len(x) > 1 and x[1] else None)
    df_afe['afe_counter'] = df_afe['afe'].apply(lambda x: x[1]['i'][2] if len(x) > 1 and x[1] else None)
    df_afe['afe_R_STATUS'] = df_afe['afe'].apply(lambda x: x[1]['i'][3] if len(x) > 1 and x[1] else None)
    df_afe['afe_L_STATUS'] = df_afe['afe'].apply(lambda x: x[0]['i'][3] if len(x) > 0 and x[0] else None)

    df_afe['lightsensor_STATUS'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[2] if len(x) > 0 and x[0] else None)
    df_afe['lightsensor_counter'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[3] if len(x) > 0 and x[0] else None)

    df_afe['lightsensor_uv1'] = df_afe['auxSensors_lightAmbient_v'].apply(lambda x: x[0] if len(x) > 0 and x[0] else None)
    df_afe['lightsensor_uv2'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[1] if len(x) > 0 and x[0] else None)
    df_afe['lightsensor_ambient'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[2] if len(x) > 0 and x[0] else None)
    df_afe['lightsensor_ir'] = df_afe['auxSensors_lightAmbient_i'].apply(lambda x: x[3] if len(x) > 0 and x[0] else None)

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

print(f"DataFrame wurde erfolgreich in {excel_datei} gespeichert.")

