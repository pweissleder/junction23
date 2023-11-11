import pandas as pd
from sklearn.preprocessing import LabelEncoder
import joblib
from pixieray.classification import feature_columns, label_encoder

# Lade den unbekannten Datensatz
unknown_df = pd.read_csv("indoor_p2_round1.csv")
unknown_df = unknown_df.iloc[:-1]
print(len(unknown_df))

# Wende die gleichen Vorverarbeitungsschritte wie beim Trainingsdatensatz an
unknown_df['labels'] = label_encoder.transform(unknown_df['labels'])  # Verwende den gleichen LabelEncoder wie beim Training

# Gruppiere nach Zeitfenstern und berechne Features
window_size = 40
unknown_df_grouped = unknown_df.groupby(unknown_df.index // window_size).agg({
    col: 'mean' for col in feature_columns
})
unknown_df_grouped.columns = ['{0}: mean'.format(col) for col in unknown_df_grouped.columns]

# Trenne Features (X) und Labels (y)
X_unknown = unknown_df_grouped

# Lade das zuvor trainierte Modell
loaded_model = joblib.load('xgboost_model.joblib')

# Mache Vorhersagen auf dem unbekannten Datensatz
y_unknown_pred = loaded_model.predict(X_unknown)

# Die Vorhersagen sind jetzt in y_unknown_pred
print(y_unknown_pred)
