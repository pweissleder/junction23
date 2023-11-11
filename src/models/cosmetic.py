from enum import Enum


class CosmeticType(Enum):
    HAT = "Hat"
    GlASSES = "Glasses"
    TOP = "Top"
    PANTS = "Pants"
    SHOES = "Shoes"
    BACKGROUND = "Background"

    def to_json(self):
        return self.value



class Cosmetic:
    def __init__(self, id, name, img="URL", type=0, skill="", unlock_level=0, price=0):
        self.id = id
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

    def to_json(self):
        cosmetic_data = {
            "id": self.id,
            "name": self.name,
            "img": self.img,
            "type": self.type,
            "skill": self.skill,
            "unlock_levels": self.unlock_level,
            "price": self.price,
            "suggested": self.suggested,
            "bought": self.bought
        }
        return cosmetic_data


#TODO Hardcode cosmetics
def init_cosmetics():
        return Cosmetic(1,"Bobby")

