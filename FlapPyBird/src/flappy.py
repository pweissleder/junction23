import asyncio
import sys

import pygame
from pygame.locals import K_ESCAPE, K_SPACE, K_UP, KEYDOWN, QUIT

from .entities import (
    Background,
    Floor,
    GameOver,
    Pipes,
    Player,
    PlayerMode,
    Score,
    WelcomeMessage,
)
from .utils import GameConfig, Images, Sounds, Window
import os.path

import firebase_admin
from firebase_admin import credentials, firestore

current_directory = os.getcwd()
service_account_key_path = os.path.join(current_directory, 'config', 'junction23-f7df7-firebase-adminsdk-c9vm7-257e9698f3.json')

cred = credentials.Certificate(os.path.join(service_account_key_path))

app = firebase_admin.initialize_app(cred)
database = firestore.client()


class Flappy:
    def __init__(self, shared_counter):
        pygame.init()
        pygame.display.set_caption("Flappy Bird")
        window = Window(288, 512)
        screen = pygame.display.set_mode((window.width, window.height))
        images = Images()
        self.shared_counter = shared_counter
        self.previous_jump_count = 0

        self.config = GameConfig(
            screen=screen,
            clock=pygame.time.Clock(),
            fps=30,
            window=window,
            images=images,
            sounds=Sounds(),
        )

    async def start(self):
        while True:

            self.background = Background(self.config)
            self.floor = Floor(self.config)
            self.player = Player(self.config)
            self.welcome_message = WelcomeMessage(self.config)
            self.game_over_message = GameOver(self.config)
            self.pipes = Pipes(self.config)
            self.score = Score(self.config)
            await self.splash()
            await self.play()
            await self.game_over()

    async def splash(self):
        """Shows welcome splash screen animation of flappy bird"""

        self.player.set_mode(PlayerMode.SHM)

        while True:

            for event in pygame.event.get():
                self.check_quit_event(event)
                if self.is_tap_event_laptop(event):
                    return
            if self.is_tap_event():
                return

            self.background.tick()
            self.floor.tick()
            self.player.tick()
            self.welcome_message.tick()

            pygame.display.update()
            await asyncio.sleep(0.1)
            self.config.tick()

    def check_quit_event(self, event):
        if event.type == QUIT or (
            event.type == KEYDOWN and event.key == K_ESCAPE
        ):
            pygame.quit()
            sys.exit()

    def is_tap_event(self):
        if self.previous_jump_count < self.shared_counter.value:
            self.previous_jump_count = self.shared_counter.value
            return True
        return False

    def is_tap_event_laptop(self, event):
        m_left, _, _ = pygame.mouse.get_pressed()
        space_or_up = event.type == KEYDOWN and (
            event.key == K_SPACE or event.key == K_UP
        )
        screen_tap = event.type == pygame.FINGERDOWN
        return m_left or space_or_up or screen_tap


    async def play(self):
        self.score.reset()
        self.player.set_mode(PlayerMode.NORMAL)

        while True:
            if self.player.collided(self.pipes, self.floor):
                return

            for i, pipe in enumerate(self.pipes.upper):
                if self.player.crossed(pipe):
                    self.score.add()

            for event in pygame.event.get():
                self.check_quit_event(event)
                if self.is_tap_event_laptop(event):
                    self.player.flap()
            if self.is_tap_event():
                self.player.flap()

            self.background.tick()
            self.floor.tick()
            self.pipes.tick()
            self.score.tick()
            self.player.tick()

            pygame.display.update()
            await asyncio.sleep(0.08)
            self.config.tick()

    async def game_over(self):
        """crashes the player down and shows gameover image"""

        self.player.set_mode(PlayerMode.CRASH)
        self.pipes.stop()
        self.floor.stop()

        while True:
            for event in pygame.event.get():
                self.check_quit_event(event)
            if self.is_tap_event():
                if self.player.y + self.player.h >= self.floor.y - 1:
                    return

            self.background.tick()
            self.floor.tick()
            self.pipes.tick()
            self.score.tick()
            self.player.tick()
            self.game_over_message.tick()

            self.config.tick()
            pygame.display.update()

            if self.score.score != 0:
                print(self.score.score)
                user_ref = database.collection("users").document("iHe7WMOWY3YEiA4qAubXJKOCx6O2")
                doc = user_ref.get()
                if doc.exists:
                    current_coins = doc.to_dict().get('coins', 0)
                    new_coins = current_coins + self.score.score
                    user_ref.update({"coins": new_coins})
                    print(f"Coins updated to {new_coins}")
                self.score.reset()
            await asyncio.sleep(0)
