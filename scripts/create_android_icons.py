from pathlib import Path
from PIL import Image, ImageDraw
import math

ROOT = Path("android/app/src/main/res")
SIZES = {"mipmap-mdpi": 48, "mipmap-hdpi": 72, "mipmap-xhdpi": 96, "mipmap-xxhdpi": 144, "mipmap-xxxhdpi": 192}

def make_icon(size):
    im = Image.new("RGBA", (size, size), (7, 12, 30, 255))
    px = im.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * size)
            px[x, y] = (int(12 + 42*t), int(20 + 18*t), int(54 + 105*t), 255)
    d = ImageDraw.Draw(im)
    m = int(size*.08)
    d.rounded_rectangle((m,m,size-m,size-m), radius=int(size*.23), outline=(87,205,255,255), width=max(1,size//36))
    # Headphone arch and ear cups
    d.arc((size*.19,size*.14,size*.81,size*.78), 185, 355, fill=(225,240,255,255), width=max(2,size//11))
    d.rounded_rectangle((size*.16,size*.43,size*.31,size*.72), radius=int(size*.07), fill=(84,214,208,255))
    d.rounded_rectangle((size*.69,size*.43,size*.84,size*.72), radius=int(size*.07), fill=(84,214,208,255))
    # Play triangle
    d.polygon([(size*.43,size*.38),(size*.43,size*.66),(size*.65,size*.52)], fill=(255,255,255,255))
    # Download arrow in lower area, kept compact
    d.line((size*.50,size*.68,size*.50,size*.83), fill=(255,190,70,255), width=max(2,size//13))
    d.polygon([(size*.39,size*.76),(size*.50,size*.87),(size*.61,size*.76)], fill=(255,190,70,255))
    return im

for folder, size in SIZES.items():
    out = ROOT / folder
    out.mkdir(parents=True, exist_ok=True)
    make_icon(size).convert("RGB").save(out / "ic_launcher.png", optimize=True)
    make_icon(size).convert("RGB").save(out / "ic_launcher_round.png", optimize=True)

foreground = Image.new("RGBA", (432,432), (0,0,0,0))
icon = make_icon(432)
foreground.alpha_composite(icon, (0,0))
drawable = ROOT / "drawable-nodpi"
drawable.mkdir(parents=True, exist_ok=True)
foreground.save(drawable / "ic_launcher_foreground.png", optimize=True)
adaptive = ROOT / "mipmap-anydpi-v26"
adaptive.mkdir(parents=True, exist_ok=True)
xml = '''<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
'''
(adaptive / "ic_launcher.xml").write_text(xml)
(adaptive / "ic_launcher_round.xml").write_text(xml)
colors = ROOT / "values"
colors.mkdir(parents=True, exist_ok=True)
color_file = colors / "ic_launcher_background.xml"
color_file.write_text('''<resources><color name="ic_launcher_background">#090D18</color></resources>''')

manifest = Path("android/app/src/main/AndroidManifest.xml")
if manifest.exists():
    s = manifest.read_text()
    s = s.replace('android:label="media_master"', 'android:label="Music Player &amp; Video Downloader"')
    manifest.write_text(s)
