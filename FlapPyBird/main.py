import asyncio
import multiprocessing
import sys

import mediapipe as mp
import cv2
import os

from src.flappy import Flappy

os.chdir(os.path.dirname(sys.argv[0]))


def jump_detector(shared_counter):
    # Initialize MediaPipe Pose model.
    mp_pose = mp.solutions.pose
    pose = mp_pose.Pose()

    # Initialize OpenCV for video capture.
    cap = cv2.VideoCapture(0)

    # Variables to track vertical movement.
    prev_avg_y = None
    jump_detected = False
    jump_peak_reached = False
    threshold_up = 0.03  # Tune these thresholds
    threshold_down = 0.03

    print(2)
    while cap.isOpened():
        success, image = cap.read()
        if not success:
            continue

        # Convert the image color from BGR to RGB and process with MediaPipe.
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = pose.process(image)
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        # Draw landmarks and detect jump.
        if results.pose_landmarks:
            mp.solutions.drawing_utils.draw_landmarks(image, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)

            # Get y-coordinates of key landmarks (hips or shoulders).
            landmarks = [results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_HIP],
                         results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_HIP]]
            current_avg_y = sum([landmark.y for landmark in landmarks]) / len(landmarks)

            # Jump detection logic.
            if prev_avg_y is not None:
                if current_avg_y < prev_avg_y - threshold_up and not jump_peak_reached:
                    jump_peak_reached = True
                elif jump_peak_reached and current_avg_y > prev_avg_y + threshold_down:
                    jump_detected = True
                    jump_peak_reached = False
                    if jump_detected:  # Replace this with actual jump detection

                        with shared_counter.get_lock():  # Lock for safe access
                            shared_counter.value += 1
            prev_avg_y = current_avg_y

            # Display jump status.
            if jump_detected:
                # comment out for dont show window
                cv2.putText(image, 'Jump Detected', (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)
                jump_detected = False

        # Display the image.
        # comment out for dont show window
        cv2.imshow('MediaPipe Pose', image)

        if cv2.waitKey(5) & 0xFF == 27:
            break

    cap.release()


async def run_flappy(shared_counter):
    # Initialize and run the Flappy game.
    # Ensure that Flappy class is designed to receive shared_counter and use it.
    game = Flappy(shared_counter)
    await game.start()


def start_flappy_game(shared_counter):
    # Run the asyncio event loop for Flappy.
    asyncio.run(run_flappy(shared_counter))


def run_game():
    # Create a shared counter
    shared_counter = multiprocessing.Value('i', 0)  # 'i' for integer type

    # Create processes
    p1 = multiprocessing.Process(target=jump_detector, args=(shared_counter,))
    p2 = multiprocessing.Process(target=start_flappy_game, args=(shared_counter,))

    # Start processes
    p1.start()
    p2.start()

    # Join processes (optional, depending on your use case)
    p1.join()
    p2.join()


run_game()
