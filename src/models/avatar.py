import json

from src.models.skill import Health


class Avatar:
    def __init__(self, userid, name, age=None, height=None, weight=None, gender=None):

        self.id = userid
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
        # self.inventory
        # self.cosmetics

    @staticmethod
    def init_skills():
        health = Health()
        # walking = StepSkill()

        return {
            # TODO: CHANGE HEALTH NAMING
            "General Health": health,
            # "Walking": walking,
        }

    def add_challenge(self, name, assoc_skill, description, xp_reward, coin_reward, sensor_start_value, target_value):
        new_chall = Challenge(name, assoc_skill, description, xp_reward, coin_reward, sensor_start_value, target_value)

        self.challenges.append(new_chall)

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
            "user_id": self.id,
            "name": self.name,
            "age": self.age,
            "gender": self.gender,
            "height": self.height,
            "weight": self.weight,
            "skills": {skill: skill_data.to_json() for skill, skill_data in self.skills.items()},
            "challenges": self.challenges
        }
        return json.dumps(avatar_dict, indent=4)
