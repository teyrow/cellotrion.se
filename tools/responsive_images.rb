#!/usr/bin/env ruby
# frozen_string_literal: true

# Genererar responsiva bildvarianter (WebP + JPEG) och _data/responsive.yml.
#
# GitHub Pages kan inte bearbeta bilder vid bygget, så varianterna måste
# checkas in. Kör skriptet när du lagt till eller bytt en bild i ett inlägg:
#
#     bundle exec ruby tools/responsive_images.rb
#
# Kräver libvips på datorn (macOS: brew install vips, Ubuntu:
# apt install libvips-tools). Gemet ruby-vips ligger i Gemfile.
#
# Skriptet letar själv upp vilka bilder som används som teaser (image_path)
# eller sidhuvud (header.overlay_image / header.image) i _posts och _pages.

require "yaml"
require "date"
require "fileutils"

begin
  require "vips"
rescue LoadError
  abort "Hittar inte libvips. Installera det först: brew install vips " \
        "(macOS) eller apt install libvips-tools (Ubuntu)."
end

WIDTHS = [400, 800, 1200, 1600].freeze
MAX_HEIGHT = 1_000_000 # bara bredden ska styra skalningen
OUT_DIR = "assets/images/resp"
DATA_FILE = "_data/responsive.yml"
IMAGE_KEYS = %w[image_path overlay_image image teaser].freeze
HEADER = "# Genererad av tools/responsive_images.rb – redigera inte för hand.\n"

# Plockar ut bildsökvägar ur front matter, inklusive de som ligger under header.
def paths_in(front_matter)
  found = []
  walk = lambda do |node|
    case node
    when Hash
      node.each do |key, value|
        found << value if IMAGE_KEYS.include?(key) && value.is_a?(String)
        walk.call(value)
      end
    when Array
      node.each { |item| walk.call(item) }
    end
  end
  walk.call(front_matter)
  found
end

def sources
  Dir.glob("{_posts,_pages}/*.md").flat_map { |file|
    # explicit UTF-8: inläggen innehåller åäö och skalets locale är inte alltid satt
    front_matter = File.read(file, encoding: "UTF-8")[/\A---\s*\n(.*?)\n---\s*\n/m, 1]
    next [] unless front_matter

    paths_in(YAML.safe_load(front_matter, permitted_classes: [Date, Time]))
  }.map { |path| path.sub(%r{\A/}, "") }
   .select { |path| path.start_with?("assets/images/") && File.file?(path) }
   .uniq
   .sort
end

def build(src)
  stem = File.basename(src, ".*")
  original = Vips::Image.new_from_file(src)
  widths = (WIDTHS.select { |w| w < original.width } + [original.width]).sort

  variants = widths.map do |w|
    # height: vips tolkar annars bredden som en kvadratisk ram och stående
    # bilder blir smalare än vad srcset lovar. size: :down hindrar uppskalning.
    image = Vips::Image.thumbnail(src, w, height: MAX_HEIGHT, size: :down)
    image = image.flatten(background: [255, 255, 255]) if image.has_alpha?
    # copy_memory: bilden skrivs i två format och vips strömmar annars källan en gång
    image = image.copy_memory
    entry = { "w" => w }
    {
      "webp" => { Q: 80, strip: true },
      "jpg" => { Q: 80, strip: true, interlace: true, optimize_coding: true }
    }.each do |ext, options|
      out = File.join(OUT_DIR, "#{stem}-#{w}.#{ext}")
      image.write_to_file(out, **options)
      entry[ext] = "/#{out}"
    end
    entry
  end

  { "width" => original.width, "height" => original.height, "variants" => variants }
end

FileUtils.mkdir_p(OUT_DIR)
data = sources.each_with_object({}) do |src, acc|
  acc[src] = build(src)
  puts "#{src}: #{acc[src]['variants'].map { |v| v['w'] }.join(', ')}"
end

File.write(DATA_FILE, HEADER + data.to_yaml.sub(/\A---\n/, ""), mode: "w:UTF-8")
puts "\nSkrev #{DATA_FILE}"
