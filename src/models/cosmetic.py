from enum import Enum


class CosmeticType(Enum):
    HAT = "Hat"


class Cosmetic:
    def __init__(self, name):
        self.name = name
        self.img = "URL"  # TODO: PUT CORRECT DATA FORMAT
        self.type = 0
        self.skill = 0
        self.price = 0


def init_cosmetics():
    return Cosmetic("Bobby")
