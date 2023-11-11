import random
from typing import List, Tuple

import pygame

from .constants import BACKGROUNDS, PIPES, PLAYERS


class Images:
    numbers: List[pygame.Surface]
    game_over: pygame.Surface
    welcome_message: pygame.Surface
    base: pygame.Surface
    background: pygame.Surface
    player: Tuple[pygame.Surface]
    pipe: Tuple[pygame.Surface]

    def __init__(self) -> None:
        self.numbers = list(
            (
                pygame.image.load(f"assets/sprites/{num}.png").convert_alpha()
                for num in range(10)
            )
        )

        # game over sprite
        self.game_over = pygame.image.load(
            "assets/sprites/gameover.png"
        ).convert_alpha()
        # welcome_message sprite for welcome screen
        self.welcome_message = pygame.image.load(
            "assets/sprites/message.png"
        ).convert_alpha()
        # base (ground) sprite
        self.base = pygame.image.load("assets/sprites/base.png").convert_alpha()
        self.randomize()

    def randomize(self):
        # select random background sprites
        rand_bg = random.randint(0, len(BACKGROUNDS) - 1)
        # select random player sprites
        rand_player = random.randint(0, len(PLAYERS) - 1)
        # select random pipe sprites
        rand_pipe = random.randint(0, len(PIPES) - 1)

        size = 80
        self.background = pygame.image.load(BACKGROUNDS[rand_bg]).convert()
        img0 = pygame.image.load(PLAYERS[0][0]).convert_alpha()
        img0 = pygame.transform.scale(img0, (size, size))
        #img0 = pygame.transform.rotate(img0, 90)
        img1 = pygame.image.load(PLAYERS[0][1]).convert_alpha()
        img1 = pygame.transform.scale(img1, (size, size))
        #img1 = pygame.transform.rotate(img1, 90)
        img2 = pygame.image.load(PLAYERS[0][2]).convert_alpha()
        img2 = pygame.transform.scale(img2, (size, size))
        #img2 = pygame.transform.rotate(img2, 90)
        self.player = (img0, img1, img2)

        self.pipe = (
            pygame.transform.flip(
                pygame.image.load(PIPES[rand_pipe]).convert_alpha(),
                False,
                True,
            ),
            pygame.image.load(PIPES[rand_pipe]).convert_alpha(),
        )
