import pandas as pd
from sklearn.model_selection import train_test_split
from xgboost import XGBClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import numpy as np
from sklearn.preprocessing import LabelEncoder
import joblib

# Lade den Trainingsdatensatz
train_df = pd.read_csv("indoor_p1_round1.csv")
train_df = train_df.iloc[:-9]  # Optional: Entferne die letzten 9 Zeilen

# Lade den Testdatensatz
test_df = pd.read_csv("indoor_p2_round1.csv")
train_df = train_df.iloc[:-1]  # Optional: Entferne die letzten 9 Zeilen


# Verwende LabelEncoder auf den Trainingsdatensatz
label_encoder = LabelEncoder()
train_df['labels'] = label_encoder.fit_transform(train_df['labels'])

# Gruppiere nach Zeitfenstern und berechne Features für den Trainingsdatensatz
window_size = 40
feature_columns = [
    'blinks_left_index',
    'blinks_right_index',
    'afe_R_m0', 'afe_R_m1', 'afe_R_m2', 'afe_R_m3', 'afe_R_m4', 'afe_R_m5',
    'afe_L_m0', 'afe_L_m1', 'afe_L_m2', 'afe_L_m3', 'afe_L_m4', 'afe_L_m5',
    'lightsensor_uv1', 'lightsensor_uv2',
    'lightsensor_ambient', 'lightsensor_ir', 'imu_x', 'imu_y', 'imu_z'
]
train_df_reset = train_df.reset_index(drop=True)
X_train = train_df_reset.groupby(train_df_reset.index // window_size).agg({
    col: 'mean' for col in feature_columns
})
X_train.columns = ['{0}: mean'.format(col) for col in X_train.columns]
y_train = train_df.groupby(train_df.index // window_size)['labels'].agg(lambda x: x.mode().iloc[0] if not x.mode().empty else '').reset_index(drop=True)

# Teile den Trainingsdatensatz in Trainings- und Testsets auf
X_train, X_test, y_train, y_test = train_test_split(X_train, y_train, test_size=0.2, random_state=42)

# Gruppiere nach Zeitfenstern und berechne Features für den Testdatensatz
test_df_grouped = test_df.groupby(test_df.index // window_size).agg({
    col: 'mean' for col in feature_columns
})
test_df_grouped.columns = ['{0}: mean'.format(col) for col in test_df_grouped.columns]
X_test = test_df_grouped

# Initialisiere den XGBoost Classifier
clf = XGBClassifier(random_state=42)

# Trainiere das Modell
clf.fit(X_train, y_train)

# Mache Vorhersagen auf dem Testdatensatz
y_pred = clf.predict(X_test)

# Evaluierung des Modells
accuracy = accuracy_score(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)
class_report = classification_report(y_test, y_pred)

# Speichere das trainierte Modell
model_filename = 'xgboost_model.joblib'
joblib.dump(clf, model_filename)

# Ausgabe der Ergebnisse
print(f'Accuracy: {accuracy}')
print(f'Confusion Matrix:\n{conf_matrix}')
print(f'Classification Report:\n{class_report}')
