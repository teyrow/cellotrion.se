# Anteckningar för Claude

Kompletterar README, som täcker installation, lokal körning och grunderna för
bildskriptet. Här står bara det som inte går att läsa sig till på annat håll.

Skriv commit-meddelanden och kodkommentarer på svenska, som resten av repot.

## Bilder

Arbetsordningen vid byte eller tillägg av en bild i ett inlägg:

1. Lägg källbilden i `assets/images/` och peka ut den i front matter.
2. `bundle exec ruby tools/responsive_images.rb`
3. Kontrollera att inget annat refererar den bild du ersatte.
4. Checka in källbild, allt nytt i `assets/images/resp/` och `_data/responsive.yml`.

Steg 3 är lätt att glömma. **Skriptet städar inte efter sig:** slutar en bild
vara refererad försvinner posten ur `responsive.yml`, men filerna i `resp/`
ligger kvar och blir död vikt i repot. De måste bort för hand.

Skriptet hittar bilder genom nycklarna `image_path`, `overlay_image`, `image`
och `teaser` i front matter, på valfritt djup. En bild som bara refereras från
Markdown-texten får inga varianter.

Bredderna är `400, 800, 1200, 1600` plus källbildens egen bredd.

## Sidhuvudsbilder

`_includes/hjalte.html` ritar sidhuvudet. `header.overlay_image` ger en
bakgrundsbild med rubrik och ingress ovanpå, `header.image` en vanlig bild i
full bredd utan text.

Formatet på en overlay-bild styrs av två saker som inte syns i front matter:

- Includen väljer **största varianten ≤ 1600 px**. Bredare källbilder ger en
  variant som aldrig används som sidhuvud.
- `.hjalte` har `background-size: cover` och `background-position: center`, och
  **ingen fast höjd** – rutan blir så hög som rubrik och ingress kräver,
  ungefär 300–350 px.

Alltså: **1600 px bred, ungefär 2:1, motivet vertikalt centrerat.** På breda
skärmar beskärs bilden hårt i höjdled, och det som ligger högst upp och längst
ner i filen syns aldrig.

## Layouter och stilmall

Sajten använder **inget tema**. Allt ligger i repot:

- `_layouts/default.html` är skalet. `single` är en vanlig sida, `splash` en
  sida i full bredd och `event` en konsert.
- `assets/css/main.css` är **ren CSS utan Sass-steg**, så CSS-variabler och
  annat modernt fungerar. Färger och mått ligger som variabler överst.
- Ikonerna ritas av inbäddad SVG som mask i samma fil, sju stycken. Lägger du
  till en ny ikon i `_config.yml` måste regeln läggas till där också.
- Sökningen är `assets/js/sok.js` plus `sok.json`, som Jekyll bygger av sidor
  och inlägg. Med ett tiotal sidor räcker delsträngsmatchning – inget sökindex
  behövs. Det är sajtens enda JavaScript.
- `_includes/seo.html` sätter titel, beskrivning, canonical och delningsdata.
  `schema.html` är gruppens data på startsidan, `event_schema.html` konsertens.

## Publicering

Push till `main` startar `pages-build-deployment` hos GitHub Pages, klart på
ungefär en minut. Ingen egen workflow-fil finns i repot.

## Lokal miljö

`Gemfile.lock` är gitignorerad, så `bundle exec` fungerar först efter
`bundle install` på den egna maskinen. Bildskriptet kräver dessutom libvips
(`brew install vips`), som inte kommer med bundlen.
