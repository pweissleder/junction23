from enum import Enum


class CosmeticType(Enum):
    HAT = "Hat"
    GlASSES = "Glasses"
    TOP = "Top"
    PANTS = "Pants"
    SHOES = "Shoes"
    BACKGROUND = "Background"



class Cosmetic:
    def __init__(self, name, skill):
        self.name = name
        self.img = "URL"  # TODO: PUT CORRECT DATA FORMAT
        self.type = 0
        self.skill = ""
        self.price = 0


def init_cosmetics():
    return Cosmetic("Bobby")
