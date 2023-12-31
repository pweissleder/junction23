from enum import Enum

from src.models.skill import GeneralSkill


class Status(Enum):
    INACTIVE = "inactive"
    ACTIVE = "active"
    COMPLETED = "completed"


class Challenge:
    def __init__(self, name, description="", assoc_skill="", xp_reward=0, coin_reward=0, sensor_start_value=0, target_value=0):
        self.name = name
        self.description = description
        self.assoc_skill = assoc_skill
        self.xp_reward = xp_reward
        self.coin_reward = coin_reward
        self.status = "active"
        self.sensor_start_value = sensor_start_value
        self.target_value = target_value
        self.progress = 0

    def calc_progress(self, current_value):
        self.progress = current_value / (self.target_value + self.sensor_start_value)

    def check_completion(self):
        """
        Needs Updateloop. Uses updated sensor data which itself is updated by pushed
        from the sensordata of the device
        """
        if self.progress == 1:
            self.status = Status.COMPLETED

    def to_json(self):
        challenge_data = {
            "name": self.name,
            "description": self.description,
            "assoc_skill": self.assoc_skill,
            "xp_reward": self.xp_reward,
            "coin_reward": self.coin_reward,
            "status": "active",
            "sensor_start_value": self.sensor_start_value,
            "target_value": self.target_value,
            "progress": self.progress
        }
        return challenge_data
"""
class StepChallenge(Challenge):
    def __init__(self, name, assoc_skill, target_steps, xp_reward):
        super().__init__(name, assoc_skill, xp_reward)
        self.steps_done = 0
        self.target_steps = target_steps
            
    def to_json(self):
        pass
"""