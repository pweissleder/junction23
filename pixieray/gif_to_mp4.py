import moviepy.editor as mp

# Lade das GIF
gif_path = 'animation_5000.gif'
clip = mp.VideoFileClip(gif_path)

# Speichere es als MP4
mp4_path = 'driving_5k.mp4'
clip.write_videofile(mp4_path, codec='libx264', fps=30)