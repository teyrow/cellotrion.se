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

`_includes/page__hero.html` är en lokal kopia av temats include – jämför med
upstream vid temauppgradering, kommentaren högst upp i filen förklarar vad som
är ändrat.

Formatet på en hero-bild styrs av två saker som inte syns i front matter:

- Includen väljer **största varianten ≤ 1600 px**. Bredare källbilder ger en
  variant som aldrig används som sidhuvud.
- Temats `.page__hero--overlay` har `background-size: cover` och
  `background-position: center`, och **ingen fast höjd** – rutan blir så hög som
  rubrik, ingress och metarad kräver, ungefär 300–450 px.

Alltså: **1600 px bred, ungefär 2:1, motivet vertikalt centrerat.** På breda
skärmar beskärs bilden hårt i höjdled, och det som ligger högst upp och längst
ner i filen syns aldrig.

## Publicering

Push till `main` startar `pages-build-deployment` hos GitHub Pages, klart på
ungefär en minut. Ingen egen workflow-fil finns i repot.

## Lokal miljö

`Gemfile.lock` är gitignorerad, så `bundle exec` fungerar först efter
`bundle install` på den egna maskinen. Bildskriptet kräver dessutom libvips
(`brew install vips`), som inte kommer med bundlen.
