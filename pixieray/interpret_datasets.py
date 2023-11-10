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

# Erste Übersicht der Daten anzeigen
print("Erste Übersicht der Daten:")
print(df.head())

excel_datei = 'first_summary.xlsx'

# DataFrame in Excel speichern
df.head().to_excel(excel_datei, index=False)
