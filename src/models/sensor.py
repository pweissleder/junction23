
class Sensor:
    def __init__(self, value=0):
        self.value = value

    def update_sensor_data(self, new_val):
        self.value = new_val