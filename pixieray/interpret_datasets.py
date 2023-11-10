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

    df_afe['afe_R_m'] = df_afe['afe'].apply(lambda x: x[1]['m'][0] if len(x) > 1 and x[1] else None)
    df_afe['afe_L_m'] = df_afe['afe'].apply(lambda x: x[0]['m'][0] if len(x) > 0 and x[0] else None)
    df_afe['afe_R_i'] = df_afe['afe'].apply(lambda x: x[1]['i'] if len(x) > 1 and x[1] else None)
    df_afe['afe_L_i'] = df_afe['afe'].apply(lambda x: x[0]['i'] if len(x) > 0 and x[0] else None)
    df_afe.drop('afe', axis=1, inplace=True)

    with open(json_datei_imu, 'r') as f:
        data_imu = json.load(f)

    df_imu = pd.json_normalize(data_imu, sep='_')
    columns_df_imu = ['t', 'i', 'v']
    df_afe[columns_df_imu] = df_imu[columns_df_imu]

    # Füge die Daten des aktuellen Durchlaufs zum kombinierten DataFrame hinzu
    df_combined = pd.concat([df_combined, df_afe], ignore_index=True)

# Erste Übersicht der kombinierten Daten anzeigen
print("Erste Übersicht der kombinierten Daten:")
print(df_combined.head())

# DataFrame in Excel speichern
df_combined.to_excel(excel_datei, index=False)

print(f"DataFrame wurde erfolgreich in {excel_datei} gespeichert.")

