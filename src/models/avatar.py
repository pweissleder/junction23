import json

from src.models.cosmetic import init_cosmetics
from src.models.skill import Health, WalkingSkill


class Avatar:
    def __init__(self, name, age=None, height=None, weight=None, gender=None):

        self.name = name

        # Personal data
        # TODO: IMMER DATEN ERFRAGEN ODER NICHT? LASSEN WIR NONE ???
        self.age = age
        self.gender = gender
        self.height = height
        self.weight = weight

        # Game information
        self.skills = self.init_skills()
        # self.challenges = {}
        # self.inventory
        # self.cosmetics

    @staticmethod
    def init_skills():
        health = Health()
        walking = WalkingSkill()

        return {
            # TODO: CHANGE HEALTH NAMING
            "Health": health,
            "Walking": walking,
        }

    def add_challenge(self):
        Challenge()
        pass

    def complete_challenge(self, associated_skill, xp):
        """
        If a challenge is completed, the general Health Skill will always be increased,
        additionally the associated skill from the challenge (e.g. Walking) will be
        updated too.
        """
        health_skill = self.skills.get("Health")
        health_skill.add_xp(xp)

        progressed_skill = self.skills.get(associated_skill)
        progressed_skill.add_xp(xp)

    def get_outfit(self):
        """
        Will get the equipped cosmetics and provide the URLS from firebase to the frontend
        """
        pass

    def to_json(self):
        avatar_dict = {
            "name": self.name,
            "age": self.age,
            "gender": self.gender,
            "height": self.height,
            "weight": self.weight,
            "skills": self.skills,
            "active_challenges": self.challenges
        }
        return json.dumps(avatar_dict, indent=4)
