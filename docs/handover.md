# Handover: cellotrion.se

Läget 24 november 2026, uppdaterad samma kväll. Kompletterar `README.md`
(installation och lokal körning) och `CLAUDE.md` (bilder, sidhuvudsbilder, layouter) – här står
sammanhanget: var sajten står, varför den ser ut som den gör, och vad som
väntar.

## Var sajten står

| | |
|---|---|
| Adress | cellotrion.se |
| Repo | `teyrow/cellotrion.se`, publiceras från `main` |
| Senaste ändring | 24 november 2026 |
| Publicering | push till `main` → `pages-build-deployment`, klart på en minut |
| Domän | `CNAME` i reporoten pekar ut cellotrion.se. **Raderas den slutar domänen fungera.** |

**Nästa konsert: julotta i Askeby 25 december kl. 9.** Den ligger uppe sedan
24 november och är sajtens enda kommande evenemang. Dessförinnan hade
startsidan stått utan kommande konsert sedan augusti, vilket får en besökare
att tro att gruppen slutat spela. Lägg in nästa datum så fort det finns.

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
   - `ev_offers` – namn och pris, `0` för fri entré. Utelämnas när priset
     inte är känt eller när någon annan arrangerar
   - `ev_organizer` – bara när någon annan bjuder in, t.ex. en församling.
     Utan fältet står Cellotrion som arrangör
   - `ev_type` – bara när evenemanget inte är en konsert. Julottan är ett
     `Event`, en konsert är standardvärdet `MusicEvent`
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

1. **Nästa konsert efter julottan.** Julottan 25 december är inlagd. Därefter
   står startsidan tom igen om inget nytt datum kommer.
2. **Konsertfoton saknas helt.** Det finns inga bilder på gruppen som spelar
   inför publik, varken för sajten eller för Google-profilen. Julottan är ett
   bra tillfälle: levande ljus, cello och publik.
3. **Länkar utifrån.** Elimförsamlingen arrangerar julottan och sprider den i
   sina kanaler. En länk därifrån till `/julotta-askeby/` gör mer för
   synligheten än något som går att ändra i koden.

**Google**

4. **Search Console är verifierad** sedan 24 november, via en TXT-post i DNS.
   Det ger en domänegenskap som täcker http, https, www och alla underdomäner.
   **Ta aldrig bort TXT-posten** – Google kontrollerar den med jämna mellanrum
   och verifieringen faller när den försvinner. Sitemapen är inskickad och
   lästes senast 18 november, då med nio sidor. Julottan kom till den 24:e, så
   siffran blir tio vid nästa läsning. Ingen åtgärd behövs.
5. **Indexering av julottan.** Kör URL-inspektion på
   `https://cellotrion.se/julotta-askeby/` och begär indexering. Konserten är
   tidskritisk på ett sätt sidorna annars inte är.
6. **Google Företagsprofil** – status okänd. Färdig verksamhetsbeskrivning på
   695 tecken och beskurna bilder för logotyp och omslag togs fram i augusti och
   ligger i chatthistoriken, inte i repot.
7. **Facebook-adressen `facebook.com/Cellotrion/`** har aldrig verifierats i en
   webbläsare. Den används i sidfoten och i `sameAs` i strukturerad data, där en
   trasig länk är sämre än ingen.

**Underhåll**

8. **Grenar att städa.** Allt arbete är mergat till `main`, men sju grenar
   ligger kvar: `claude/bevaka-temaversion` (bevakar ett tema som inte finns),
   `claude/plan-utan-jekyll` (beslutsunderlag, kan sparas för historiken),
   `claude/julotta`, `claude/julotta-sluttid`, `claude/stadning`, samt de gamla
   `gh-pages` och `koranyi-del2`. `gh-pages` publicerar ingenting – den
   innehåller källkod från maj och är bara vilseledande.
9. **Lighthouse mot den publicerade sajten.** Kör `pagespeed.web.dev` mot
   cellotrion.se. SEO-poängen bör ligga på 92 av en känd orsak: tre
   "Läs mer"-knappar har `aria-label` med konsertens namn, men Lighthouse
   tittar på den synliga texten. Att nå 100 kräver längre knapptexter.

**Avklarat sedan handoveren skrevs**

Oanvända bilder borttagna, 11,2 MB. Två kommentarer i `_config.yml` som
beskrev det gamla temat rättade. Search Console verifierad.

## Om arbetet sker via Claude Code

Två spärrar i den miljön är värda att känna till, båda policybeslut som inte
går att kringgå:

- **cellotrion.se går inte att nå** utifrån sessionen, så den publicerade
  sajten kan aldrig mätas eller kontrolleras därifrån. Bygg och mät lokalt.
- **Fjärrgrenar går inte att radera** (`git push --delete` ger 403). Grenar
  måste städas från en vanlig dator eller i GitHubs gränssnitt.
