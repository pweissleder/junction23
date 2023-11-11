import moviepy.editor as mp

# Lade das GIF
gif_path = 'animation.gif'
clip = mp.VideoFileClip(gif_path)

# Speichere es als MP4
mp4_path = 'driving_1000timestaps.mp4'
clip.write_videofile(mp4_path, codec='libx264', fps=30)