import pandas as pd
import os
import json

print(os.getcwd())

# Annahme: Deine JSON-Datei heißt 'daten.json'
json_datei = 'datasets/driving/AFE_000_CONFIDENTIAL.json'

# DataFrame aus der JSON-Datei erstellen
with open(json_datei, 'r') as f:
    data = json.load(f)

# DataFrame erstellen
df = pd.json_normalize(data, sep='_')

df['afe_R_m'] = df['afe'].apply(lambda x: x[1]['m'][0] if len(x) > 1 and x[1] else None)
df['afe_L_m'] = df['afe'].apply(lambda x: x[0]['m'][0] if len(x) > 0 and x[0] else None)
df['afe_R_i'] = df['afe'].apply(lambda x: x[1]['i'] if len(x) > 1 and x[1] else None)
df['afe_L_i'] = df['afe'].apply(lambda x: x[0]['i'] if len(x) > 0 and x[0] else None)
df.drop('afe', axis=1, inplace=True)

# Erste Übersicht der Daten anzeigen
print("Erste Übersicht der Daten:")
print(df.head())

excel_datei = 'first_summary_v2.xlsx'

# DataFrame in Excel speichern
df.to_excel(excel_datei, index=False)
