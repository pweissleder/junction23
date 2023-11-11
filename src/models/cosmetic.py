from enum import Enum


class CosmeticType(Enum):
    HAT = "Hat"
    GlASSES = "Glasses"
    TOP = "Top"
    PANTS = "Pants"
    SHOES = "Shoes"
    BACKGROUND = "Background"


class Cosmetic:
    def __init__(self, name, img="URL", type=0, skill="", unlock_level=0, price=0):
        self.name = name
        self.img = img  # TODO: PUT CORRECT DATA FORMAT
        self.type = type
        self.skill = skill
        self.unlock_level = unlock_level
        self.price = price
        self.suggested = False
        self.bought = False

    def buy(self):
        self.bought = True



#TODO Hardcode cosmetics
def init_cosmetics():
        return Cosmetic("Bobby")

