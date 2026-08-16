#!/usr/bin/env python3
"""Genererar responsiva bildvarianter (WebP + JPEG) och _data/responsive.yml.

GitHub Pages kan inte bearbeta bilder vid bygget, så varianterna måste checkas
in. Kör det här skriptet när du lagt till eller bytt en bild i ett inlägg:

    pip install Pillow
    python3 tools/responsive-images.py

Skriptet letar själv upp vilka bilder som används som teaser (image_path) eller
sidhuvud (header.overlay_image / header.image) i _posts och _pages.
"""
from PIL import Image
import glob
import io
import os
import re

WIDTHS = [400, 800, 1200, 1600]
OUT_DIR = "assets/images/resp"
DATA_FILE = "_data/responsive.yml"
KEYS = ("image_path", "overlay_image", "image", "teaser")


def sources():
    """Bildsökvägar som används i front matter, utan inledande snedstreck."""
    found = set()
    for path in glob.glob("_posts/*.md") + glob.glob("_pages/*.md"):
        text = io.open(path, encoding="utf-8").read()
        for key in KEYS:
            for match in re.finditer(rf"^\s*{key}:\s*[\"']?(\S+?)[\"']?\s*$", text, re.M):
                value = match.group(1).lstrip("/")
                if value.startswith("assets/images/") and os.path.isfile(value):
                    found.add(value)
    return sorted(found)


def build(src):
    im = Image.open(src).convert("RGB")
    stem = os.path.splitext(os.path.basename(src))[0]
    widths = sorted({w for w in WIDTHS if w < im.width} | {im.width})
    variants = []
    for w in widths:
        resized = im if w == im.width else im.resize(
            (w, round(im.height * w / im.width)), Image.LANCZOS)
        entry = {"w": w}
        for ext, opts in (("webp", {"quality": 80, "method": 6}),
                          ("jpg", {"quality": 80, "optimize": True, "progressive": True})):
            out = f"{OUT_DIR}/{stem}-{w}.{ext}"
            resized.save(out, **opts)
            entry[ext] = "/" + out
        variants.append(entry)
    return {"width": im.width, "height": im.height, "variants": variants}


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    lines = ["# Genererad av tools/responsive-images.py – redigera inte för hand.\n"]
    for src in sources():
        data = build(src)
        lines.append(f"{src}:\n  width: {data['width']}\n  height: {data['height']}\n  variants:\n")
        for v in data["variants"]:
            lines.append(f"    - w: {v['w']}\n      webp: {v['webp']}\n      jpg: {v['jpg']}\n")
        sizes = ", ".join(str(v["w"]) for v in data["variants"])
        print(f"{src}: {sizes}")
    io.open(DATA_FILE, "w", encoding="utf-8").write("".join(lines))
    print(f"\nSkrev {DATA_FILE}")


if __name__ == "__main__":
    main()
