# Plan för att lämna Jekyll

Underlag för ett beslut, inte ett beslut. Skrivet augusti 2026.

> **Utfall, september 2026:** spår A valdes. Temat är borttaget och sajten har
> egna layouter, egen stilmall och egen sökfunktion, medan Jekyll är kvar.
> Arbetet ligger på grenen `claude/eget-tema`. Avsnittet om att pinna temat är
> därmed överspelat – det finns inget tema kvar att pinna.

## Först: sajten är redan statisk

Jekyll kör aldrig hos besökaren. Det som ligger på cellotrion.se är färdiga
HTML-filer som GitHub Pages serverar rakt av. Att sluta använda Jekyll ger
alltså **ingen skillnad för besökaren** – inte en byte snabbare, inte en
sekund tidigare.

Frågan handlar helt om hur sajten underhålls. Det är fortfarande en rimlig
fråga, men vinsten ligger någon annanstans än man först tror.

## Vad Jekyll faktiskt gör åt oss i dag

Utöver att sy ihop 13 sidor från ett gemensamt skal:

| Genereras vid bygget | Skulle bli manuellt |
|---|---|
| `sitemap.xml` | 13 adresser att hålla i synk |
| `feed.xml` | RSS per konsert |
| `kommande.ics` | Kalenderfil som måste rensas när konserter passerat |
| 4 omdirigeringssidor | Statiska filer, kan frysas som de är |
| JSON-LD per konsert | Handskriven strukturerad data, datum i två format |
| `<picture>` med 8 adresser per bild | Handskriven markup per bild |
| Indelningen kommande/tidigare | Manuell flytt igen, det vi just automatiserade |
| Sökfunktionen | Faller bort |

Var och en av dem är liten. Tillsammans är de skillnaden mellan att lägga in
en konsert som **en markdownfil** och att göra sju redigeringar på olika
ställen, där varje missad redigering går sönder tyst.

## Vad som faktiskt tynger sajten

Inte Jekyll. **Temat.**

| | Storlek | Kommentar |
|---|---|---|
| `main.css` | 105 kB | ca 83 kB oanvänd enligt Lighthouse |
| `main.min.js` | 121 kB | jQuery plus temats plugins |
| `lunr.min.js` | 30 kB | sökindex |

Drygt 250 kB per sidladdning för en sajt med fem konserter. Det är där de
återstående Lighthouse-poängen ligger.

Dessutom: vi har redan **tretton egna filer** som kopierar eller ersätter
temats – fem av dem med kommentaren "jämför med upstream vid uppgradering".
Det är en underhållsskuld som växer varje gång vi behöver komma åt något
temat inte har en inställning för.

## Akut, oavsett vilket spår som väljs

`_config.yml` har `remote_theme: mmistakes/minimal-mistakes` **utan version**.
Varje bygge hämtar temats senaste master. En ändring där kan slå sönder våra
fem kopior utan att någon rört repot – och GitHub Pages bygger om vid varje
push.

Fix: pinna versionen.

```yaml
remote_theme: mmistakes/minimal-mistakes@4.28.1
```

En rad, noll risk, tar bort en tickande bomb. Gör det oavsett hur resten av
den här planen landar.

## Tre spår

### A. Behåll Jekyll, kasta temat

Skriv egna layouter och egen CSS. Jekyll blir kvar som ren limmotor.

**Vinst:** de 250 kB försvinner, de fem synkberoende kopiorna blir onödiga
eftersom vi äger allt, CSS:en går att läsa i sin helhet. Allt som genereras
fortsätter genereras. Lighthouse rimligen 95+.

**Kostnad:** ungefär en arbetsdag. Sökfunktionen måste skrivas om, cirka 30
rader JavaScript kring lunr, eller strykas.

**Risk:** låg. Kan göras sidtyp för sidtyp, och varje steg verifieras genom
att jämföra den byggda HTML:en mot föregående bygge.

### B. Inget byggsteg alls, handskriven HTML

13 HTML-filer som redigeras direkt.

**Vinst:** ingen Ruby, ingen bundle, inget att installera. Vem som helst kan
öppna en fil i GitHubs webbeditor och ändra en rad.

**Kostnad:** varje gemensam ändring – ny menypost, ny fot, ändrad favicon –
blir 13 redigeringar. Och per ny konsert: skapa sidan, lägga in teasern på
startsidan, flytta föregående konsert till tidigare, uppdatera sitemap,
uppdatera ics, skriva JSON-LD för hand, klistra in bildmarkup. Sökfunktionen
försvinner.

**Risk:** hög på sikt, men inte akut. Det som går sönder gör det tyst –
sitemapen slutar stämma, ics-filen innehåller gamla konserter, en konsert
ligger kvar under Kommande i månader. Ingen får ett felmeddelande.

### C. Byt till Astro eller Eleventy

**Vinst:** modernare mallspråk, ekosystem, bättre bildhantering inbyggd.

**Kostnad:** Node, npm-beroenden som behöver uppdateras, och GitHub Pages
måste byta till Actions-bygge. Fler rörliga delar än i dag, inte färre.

**Risk:** medel. Ett npm-träd är mer underhåll än en pinnad Jekyll-version,
inte mindre.

## Rekommendation

**Spår A.**

Det ni vill komma åt – bloatet, den kopierade temakoden, känslan av att inte
äga sin egen sajt – sitter i temat. Jekyll är inte problemet; Jekyll är det
som gör att en ny konsert är en fil och inte en checklista.

Spår B låter enklare än det är. Den byter bort ett byggsteg som fungerar mot
sju manuella moment vid varje uppdatering, på en sajt som uppdateras av folk
som inte är utvecklare. Det är rätt val om ni är säkra på att sajten inte
kommer ändras nämnvärt mer – men då är det också svårt att motivera arbetet
med att bygga om den.

## Genomförande av spår A

Varje steg är en egen gren med eget bygge att jämföra mot.

1. **Pinna temat.** En rad. Gör direkt.
2. **Egen CSS.** Skriv ett eget stilark från grunden mot dagens utseende,
   ungefär 300 rader. Verifiera med skärmbilder sida för sida i två bredder.
3. **Egna layouter.** `default`, `sida`, `konsert`, `start`. Vi äger redan
   `feature`, `page__hero`, `head`, `footer`, `schema` och `event_schema` –
   de flesta byggstenar finns.
4. **Ta bort temat.** `remote_theme` bort, de fem synkkommentarerna bort.
5. **Sökfunktionen.** Behåll lunr med egen liten JavaScript, eller stryk.
   Beslut tas när kostnaden syns.
6. **Städa.** `_data/ui-text.yml`, arkivsidorna för kategorier och taggar,
   `jekyll-paginate`, `jekyll-gist`, `jemoji` – inget av det används.

Efter varje steg: bygg, jämför HTML mot föregående bygge, kör Lighthouse.
Det som inte ska ändras ska synas att det inte ändrats.

## Om det ändå blir spår B

Gör i så fall detta först, i den här ordningen:

1. Genomför spår A ändå. Då finns egna layouter och egen CSS.
2. Kopiera `_site` till repots rot. Nu är sajten handskriven HTML, med den
   design ni redan godkänt.
3. Behåll `tools/responsive_images.rb` men låt det skriva ut färdig
   `<picture>`-markup att klistra in.
4. Skriv ned checklistan för "lägga in en ny konsert" i README. Sju punkter
   som ingen får glömma är sju punkter som måste stå någonstans.

Vägen till B går genom A. Det är ytterligare ett skäl att börja där.
