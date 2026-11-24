# Handover: cellotrion.se

Läget 24 november 2026. Kompletterar `README.md` (installation och lokal
körning) och `CLAUDE.md` (bilder, sidhuvudsbilder, layouter) – här står
sammanhanget: var sajten står, varför den ser ut som den gör, och vad som
väntar.

## Var sajten står

| | |
|---|---|
| Adress | cellotrion.se |
| Repo | `teyrow/cellotrion.se`, publiceras från `main` |
| Senaste ändring | 5 september 2026 (`a68480f`) |
| Publicering | push till `main` → `pages-build-deployment`, klart på en minut |
| Domän | `CNAME` i reporoten pekar ut cellotrion.se. **Raderas den slutar domänen fungera.** |

**Det mest akuta: sajten har inte visat någon kommande konsert sedan den 23
augusti.** Startsidan har bara rubriken Tidigare evenemang, med fem konserter
från mars till augusti. En besökare som hittar hit ser en grupp som inte
verkar spela längre. Lägg in nästa datum så fort det finns.

## Hur den är byggd

Jekyll utan tema. Layouter, stilmall och sökfunktion ligger i repot och ägs av
er – det finns inget `remote_theme` att hålla i synk.

Fram till september användes temat Minimal Mistakes. Det byttes ut i september
2026 eftersom det stod för 105 kB CSS (83 kB oanvänd) och 156 kB JavaScript
för sju ikoner och en sökruta, och eftersom tre filer var kopior av temats som
behövde jämföras med upstream vid varje uppgradering. Efter bytet:

| | Med tema | Nu |
|---|---|---|
| Lighthouse performance | 77 | 93 |
| First contentful paint | 2,8 s | 1,2 s |
| CSS / JavaScript | 105 / 156 kB | 18 / 2 kB |

Mätt lokalt mot en okomprimerad server. Live bör vara bättre, men **har aldrig
mätts** – mätningen behöver göras från en vanlig dator, se Öppna punkter.

## Det återkommande arbetet: lägga in en konsert

Det här är det enda som görs regelbundet. En fil räcker.

1. Skapa `_posts/ÅÅÅÅ-MM-DD-kortnamn.md` – kopiera en befintlig konsert och
   ändra. Fälten som styr något:
   - `permalink` – sätt alltid en egen, t.ex. `/musikcafe-i-vreta/`
   - `ev_date` och `ev_end_date` – med tidszon, `+01:00` vinter, `+02:00` sommar
   - `ev_location` med `title`, `street`, `locality`
   - `ev_offers` – namn och pris, `0` för fri entré
   - `image_path` (affischen) och `header.overlay_image` (sidhuvudet)
   - `excerpt` och `description` – syns i sökresultat och vid delning
2. Lägg affischen i `assets/images/` och kör `bundle exec ruby tools/responsive_images.rb`
   (se `CLAUDE.md`, skriptet städar inte efter sig).
3. Committa och pusha till `main`.

Allt annat sköter sig: startsidan, sitemap, RSS, kalenderfil, strukturerad
data och bildvarianter.

## Mekanismer som inte syns i koden

**Konserterna sorterar sig själva.** Startsidan jämför varje konserts
`ev_date` med tidpunkten för bygget. Ingen manuell kategori behövs – men
flytten sker bara **när sajten byggs om**, alltså vid en push. En konsert som
passerat ligger kvar under Kommande tills någon rör repot. Ett nattligt bygge
diskuterades men byggdes aldrig.

**Adresserna innehåller inte kategorier.** `permalink: /:title/` är medvetet.
Med kategorier i adressen bytte en konsert URL så fort den slutade vara
"kommande", och alla delade länkar dog. Sju omdirigeringar från gamla adresser
ligger i `redirect_from` och i tre stubbsidor under `_pages/`.

**`kommande.ics`** byggs av Jekyll och innehåller bara konserter som inte
varit. Knappen "Lägg till i kalendern" visas bara på kommande konserter. Just
nu är filen tom, vilket är rätt.

**Strukturerad data.** `_includes/schema.html` beskriver gruppen på
startsidan, `event_schema.html` varje konsert som `MusicEvent` med tid, plats
och pris. Det är det som kan ge evenemangsresultat i Google.

## Beslut som är värda att inte riva upp

- **Ikonerna är inbäddad SVG som CSS-mask**, inte Font Awesome. Sju ikoner mot
  ett helt bibliotek från en CDN. Ny ikon kräver en ny regel i `main.css`.
- **Typsnittet ligger lokalt**, två varianter av Averia Serif Libre. Google
  Fonts var en render-blockerande begäran till två extra domäner.
- **`main.css` är ren CSS utan Sass.** GitHub Pages Sass-motor är så gammal
  att den inte klarar CSS-variabler. Utan Sass-steg fungerar modern CSS.
- **Plugins måste finnas i GitHub Pages godkända lista.** `jekyll-redirect-from`,
  `jekyll-sitemap` och `jekyll-feed` gör det. Ett plugin utanför listan körs
  helt enkelt inte, utan felmeddelande.

## Öppna punkter

**Innehåll**

1. **Nästa konsert.** Se ovan – det viktigaste.
2. **Konsertfoton saknas helt.** Det finns inga bilder på gruppen som spelar
   inför publik, varken för sajten eller för Google-profilen. Be någon
   fotografera nästa gång.

**Google**

3. **Search Console är inte verifierad.** Koden som togs fram i augusti kom
   från DNS-metoden och fungerar inte som metatagg. Hämta koden under fliken
   HTML-tagg och lägg den som `google_site_verification` i `_config.yml`, eller
   kör DNS-vägen och strunta i taggen. Därefter: skicka in
   `https://cellotrion.se/sitemap.xml`.
4. **Google Företagsprofil** – status okänd. Färdig verksamhetsbeskrivning på
   695 tecken och beskurna bilder för logotyp och omslag togs fram i augusti och
   ligger i chatthistoriken, inte i repot.
5. **Facebook-adressen `facebook.com/Cellotrion/`** har aldrig verifierats i en
   webbläsare. Den används i sidfoten och i `sameAs` i strukturerad data, där en
   trasig länk är sämre än ingen.

**Underhåll**

6. **11,2 MB av 13,8 MB i `assets/images/` används inte** – gamla pressbilder,
   en PNG på 4,2 MB och `unsplash-*` från temamallen. De laddas aldrig av
   besökare men ligger i varje klon.
7. **Fem grenar kan städas.** `claude/bevaka-temaversion` (bevakar ett tema som
   inte finns kvar) och `claude/plan-utan-jekyll` (beslutsunderlag, kan sparas
   om ni vill ha historiken) är omergade. `gh-pages` och `koranyi-del2` är
   gamla och publicerar ingenting – `gh-pages` innehåller källkod från maj och
   är bara vilseledande.
8. **Lighthouse mot den publicerade sajten.** Kör `pagespeed.web.dev` mot
   cellotrion.se. SEO-poängen bör ligga på 92 av en känd orsak: tre
   "Läs mer"-knappar har `aria-label` med konsertens namn, men Lighthouse
   tittar på den synliga texten. Att nå 100 kräver längre knapptexter.

## Om arbetet sker via Claude Code

Två spärrar i den miljön är värda att känna till, båda policybeslut som inte
går att kringgå:

- **cellotrion.se går inte att nå** utifrån sessionen, så den publicerade
  sajten kan aldrig mätas eller kontrolleras därifrån. Bygg och mät lokalt.
- **Fjärrgrenar går inte att radera** (`git push --delete` ger 403). Grenar
  måste städas från en vanlig dator eller i GitHubs gränssnitt.
