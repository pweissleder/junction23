from src.models.sensor import Sensor


class GeneralSkill:
    def __init__(self, skill_name, initial_level=0):
        self.name = skill_name
        self.current_level = initial_level
        self.current_xp = 0
        self.levels = {}  # Define as needed
        self.assoc_sensor = Sensor()

    def __init__(self, skill_name, initial_level=1,current_xp=0, levels={}, sensor=None):
        self.name = skill_name
        self.current_level = initial_level
        self.current_xp = current_xp
        self.levels = levels
        self.assoc_sensor = sensor

    def add_xp(self, xp):
        self.current_xp = int(self.current_xp) + int(xp)
        self.update_level()

    def update_level(self):
        next_level_xp = self.levels.get(str(self.current_level + 1))
        if self.current_xp >= int(next_level_xp):
            self.current_level += 1
            self.current_xp -= int(next_level_xp)

    def to_json(self):
        skill_data = {
            "name": self.name,
            "current_level": self.current_level,
            "current_xp": self.current_xp,
            "levels": self.levels,
            "assoc_sensor": self.assoc_sensor.to_json()
        }
        return skill_data

    @staticmethod
    def skill_from_json(self):
        json_data = self
        match(json_data["name"]):
            case "Health": return Health(
                json_data["name"],
                json_data["current_level"],
                json_data["current_xp"],
                json_data["levels"],
                Sensor.from_json(json_data["assoc_sensor"])
            )

            case "Steps": return StepSkill(
                json_data["name"],
                json_data["current_level"],
                json_data["current_xp"],
                json_data["levels"],
                Sensor.from_json(json_data["assoc_sensor"])
            )

            case _: return GeneralSkill(
                json_data["name"],
                json_data["current_level"],
                json_data["current_xp"],
                json_data["levels"],
                Sensor.from_json(json_data["assoc_sensor"])
            )


class Health(GeneralSkill):
    """
    TODO: RENAME TO GENERAL PROGRESS?

    This class represents the overall Health  / general skill level of the user.
    It is progressed by progressing in other Skills (e.g) Walking, Hiking, Swimming.

    """

    def __init__(self):
        super().__init__("Health")
        self.levels = {
            1: 100,
            2: 500,
            3: 1000,
            4: 2000,
            5: 5000,
        }

    def __init__(self, skill_name, current_level, levels, initial_level, sensor):
        super().__init__(skill_name, current_level, levels, initial_level, sensor)




class StepSkill(GeneralSkill):
    def __init__(self):
        super().__init__("Steps")
        self.lv_xp_dic = {
            1: 100,
            2: 250,
            3: 500,
            4: 900,
            5: 1500
        }

    def __init__(self, skill_name, current_level, levels, initial_level, sensor):
        super().__init__(skill_name, current_level, levels, initial_level, sensor)