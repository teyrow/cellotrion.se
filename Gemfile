source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins
gem "jekyll-include-cache", group: :jekyll_plugins


gem "tzinfo-data"
gem "wdm", "~> 0.1.0" if Gem.win_platform?

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  gem "jekyll-gist"
  gem "jekyll-feed"
  gem "jemoji"
  gem "jekyll-include-cache"
  gem "jekyll-algolia"
end

# Används av tools/responsive_images.rb för att generera bildvarianter.
# Kräver libvips på datorn (brew install vips / apt install libvips-tools).
# GitHub Pages läser inte den här filen, så gemet påverkar inte publiceringen.
gem "ruby-vips"
