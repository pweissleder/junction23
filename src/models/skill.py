from src.models.sensor import Sensor


class GeneralSkill:
    def __init__(self, skill_name, initial_level=1):
        self.name = skill_name
        self.current_level = initial_level
        self.current_xp = 0
        self.levels = {}  # Define as needed
        self.assoc_sensor = {}

    def add_xp(self, xp):
        self.current_xp += xp
        self.update_level()

    def update_level(self):
        next_level_xp = self.levels.get(self.current_level + 1)
        if self.current_xp >= next_level_xp:
            self.current_level += 1
            self.current_xp -= next_level_xp

    def to_json(self):
        skill_data = {
            "name": self.name,
            "current_level": self.current_level,
            "current_xp": self.current_xp,
            "levels": self.levels,
            "assoc_sensor": self.assoc_sensor
        }
        return skill_data


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


class StepSkill(GeneralSkill):
    def __init__(self):
        super().__init__("Walking")
        self.lv_xp_dic = {
            1: 100,
            2: 250,
            3: 500,
            4: 900,
            5: 1500
        }
        self.assoc_sensor = Sensor()
