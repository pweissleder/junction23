import json

from src.models.challenge import Challenge
from src.models.cosmetic import init_cosmetics, Cosmetic
from src.models.skill import Health, StepSkill, GeneralSkill


class Avatar:
    def __init__(self, userid,username, name, age=None, height=None, weight=None, gender=None):
        self.id = userid
        self.username = username
        self.name = name

        # Personal data
        # TODO: IMMER DATEN ERFRAGEN ODER NICHT? LASSEN WIR NONE ???
        self.age = age
        self.gender = gender
        self.height = height
        self.weight = weight

        # Game information
        self.skills = self.init_skills()
        self.challenges = []
        self.inventory = self.init_cosmetic()


    @staticmethod
    def init_skills():
        health = Health()
        step = StepSkill()

        return {
            # TODO: CHANGE HEALTH NAMING
            "General Health": health,
            "Steps": step
        }

    def init_challenges(self):
        """
        PARAMETER: name, assoc_skill, description, xp_reward, coin_reward, sensor_start_value, target_value
        :return:
        """

        challenges = [
            Challenge("Step it up!", f"Walk {str(2000)} steps today!","Steps", 10, 5, 745, 2000),
            Challenge("Swim", f"swim 10 minutes!", 10, 5, 0, 10),
            Challenge("Drive your bike", f"Drive 1km", 10, 5, 0, 2),
        ]

        self.challenges = challenges


    def init_cosmetic(self):
        inventory = {}
        new_cosmetic = init_cosmetics()
        inventory[new_cosmetic.id] = new_cosmetic
        return inventory


    def to_json(self):
        avatar_dict = {
            "user_id": self.id,
            "name": self.name,
            "age": self.age,
            "gender": self.gender,
            "height": self.height,
            "weight": self.weight,
            "skills": {skill: skill_data.to_json() for skill, skill_data in self.skills.items()},
            "inventory": {inventory: cosmetic_data.to_json() for inventory, cosmetic_data in self.inventory.items()}
        }
        return json.dumps(avatar_dict, indent=4)
