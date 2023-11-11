import multiprocessing
import time

import pygame
import imageio
import cv2
import numpy as np
import pygame
from moviepy.video.io.VideoFileClip import VideoFileClip
import os
import pygetwindow as gw

def play_video(video_path):
    pygame.init()
    pygame.display.set_caption("Video Player")
    screen = pygame.display.set_mode((800, 800))

    clock = pygame.time.Clock()
    done = False

    cap = cv2.VideoCapture(video_path)

    while not done:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                done = True

        ret, frame = cap.read()
        if not ret:
            done = True
            continue

        frame = cv2.flip(frame, 1)
        frame = cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        frame = pygame.surfarray.make_surface(frame)
        screen.blit(frame, (0, 0))
        pygame.display.flip()
        clock.tick(30)

    cap.release()
    pygame.quit()


if __name__ == "__main__":
    mp4_path = "datasets/driving/Participant_1/Participant_1-Driving-720p.mp4"
    gif_path = "driving_1000timestaps.mp4"

    process1 = multiprocessing.Process(target=play_video, args=(mp4_path,))
    process2 = multiprocessing.Process(target=play_video, args=(gif_path,))

    process1.start()
    process2.start()

    time.sleep(1)

    # Ändere die Fensterpositionen
    mp4_window = gw.getWindowsWithTitle("Video Player")[0]
    gif_window = gw.getWindowsWithTitle("Video Player")[1]  # Hier Fenstertitel von Gif Player einfügen

    mp4_window.moveTo(0, 0)
    gif_window.moveTo(800, 0)

    process1.join()
    process2.join()
