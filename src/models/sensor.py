
class Sensor:
    def __init__(self, value=0):
        self.value = value

    def update_sensor_data(self, new_val):
        self.value = new_val

    def to_json(self):
        return {"value": self.value.__str__()}

    def from_json(self):
        return Sensor(self["value"])