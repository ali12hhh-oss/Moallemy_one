from pathlib import Path
from PIL import Image
from collections import deque

ICON_FILES = [
    Path('android/app/src/main/res/mipmap-mdpi/ic_launcher.png'),
    Path('android/app/src/main/res/mipmap-hdpi/ic_launcher.png'),
    Path('android/app/src/main/res/mipmap-xhdpi/ic_launcher.png'),
    Path('android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png'),
    Path('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png'),
]

# Remove only near-white pixels connected to the image corners. This keeps
# the icon geometry, dimensions, colors, and any isolated white artwork intact.
THRESHOLD = 250

def is_background_white(px):
    r, g, b, a = px
    return a > 0 and r >= THRESHOLD and g >= THRESHOLD and b >= THRESHOLD

for path in ICON_FILES:
    image = Image.open(path).convert('RGBA')
    pixels = image.load()
    w, h = image.size
    q = deque()
    seen = set()

    seeds = [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]
    for x, y in seeds:
        if is_background_white(pixels[x, y]):
            q.append((x, y))
            seen.add((x, y))

    while q:
        x, y = q.popleft()
        r, g, b, a = pixels[x, y]
        pixels[x, y] = (r, g, b, 0)
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in seen:
                if is_background_white(pixels[nx, ny]):
                    seen.add((nx, ny))
                    q.append((nx, ny))

    image.save(path, format='PNG', optimize=False)
    print(f'Processed {path} ({w}x{h}), cleared {len(seen)} corner-connected pixels')
