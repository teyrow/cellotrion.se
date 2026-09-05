# cellotrion.se

Sajten för Cellotrion, byggd med Jekyll. Layouter, stilmall och den lilla
sökfunktionen ligger i repot – inget tema hämtas utifrån. Publiceras med
GitHub Pages.

## Köra lokalt

    bundle install
    bundle exec jekyll serve

Sajten ligger sedan på http://localhost:4000. Får du felet
`Invalid US-ASCII character` är det skalets teckenkodning: kör
`export LANG=en_US.UTF-8` först.

## Bilder

Bilder i inlägg och sidor serveras i flera storlekar och som WebP. Varianterna
genereras i förväg eftersom GitHub Pages inte kan bearbeta bilder vid bygget.
Kör det här efter att du lagt till eller bytt en bild:

    bundle exec ruby tools/responsive_images.rb

Skriptet hittar själv vilka bilder som används, lägger varianterna i
`assets/images/resp/` och skriver `_data/responsive.yml`. Checka in resultatet.
Det kräver libvips: `brew install vips` på macOS, `apt install libvips-tools`
på Ubuntu.

---

# Minimal Mistakes remote theme starter

Click [**Use this template**](https://github.com/mmistakes/mm-github-pages-starter/generate) button above for the quickest method of getting started with the [Minimal Mistakes Jekyll theme](https://github.com/mmistakes/minimal-mistakes).

Contains basic configuration to get you a site with:

- Sample posts.
- Sample top navigation.
- Sample author sidebar with social links.
- Sample footer links.
- Paginated home page.
- Archive pages for posts grouped by year, category, and tag.
- Sample about page.
- Sample 404 page.
- Site wide search.

Replace sample content with your own and [configure as necessary](https://mmistakes.github.io/minimal-mistakes/docs/configuration/).

---

## Troubleshooting

If you have a question about using Jekyll, start a discussion on the [Jekyll Forum](https://talk.jekyllrb.com/) or [StackOverflow](https://stackoverflow.com/questions/tagged/jekyll). Other resources:

- [Ruby 101](https://jekyllrb.com/docs/ruby-101/)
- [Setting up a Jekyll site with GitHub Pages](https://jekyllrb.com/docs/github-pages/)
- [Configuring GitHub Metadata](https://github.com/jekyll/github-metadata/blob/master/docs/configuration.md#configuration) to work properly when developing locally and avoid `No GitHub API authentication could be found. Some fields may be missing or have incorrect data.` warnings.
