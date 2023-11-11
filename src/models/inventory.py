from src.models.cosmetic import Cosmetic


class Inventory():
    def __init__(self):
        self.cosmetics = []


    def add(self, new_cosmetic: Cosmetic):
        self.cosmetics.append(new_cosmetic)

    def remove(self, cosmetic: Cosmetic):
        self.cosmetics.remove(cosmetic)
