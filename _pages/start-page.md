---
title: "Cellotrion – cellotrio i Linköping"
layout: splash
permalink: /
description: "Cellotrion är en cellotrio i Linköping som ger nära och varma konserter med klassisk musik – Bach, Chopin, Piazzolla med mera. Se kommande konserter och boka oss."
header:
  hero_title: "Cellotrion" # rubriken på sidan; page.title används i <title>-taggen
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/tre_celli.jpg
excerpt: "Vi har plockat fram essensen i skön musik och består av endast cellister. Upplevelsen kröner vi gärna med fika. Välkommen till vår sida!"
---

{%- comment -%}
  Konserterna sorteras efter ev_date i förhållande till tidpunkten för bygget,
  inte efter någon manuell kategori. En konsert flyttar sig alltså själv till
  Tidigare evenemang nästa gång sajten byggs om.

  Varje konsert behöver ev_date i sin front matter. Saknas den hamnar den
  under Tidigare evenemang, så inget försvinner om fältet glöms bort.
{%- endcomment -%}
{%- assign nu = site.time | date: '%s' | plus: 0 -%}
{%- assign daterade = site.categories.evenemang | where_exp: "p", "p.ev_date" | sort: 'ev_date' -%}
{%- assign odaterade = site.categories.evenemang | where_exp: "p", "p.ev_date == nil" -%}

{%- assign antal_kommande = 0 -%}
{%- for post in daterade -%}
  {%- assign slut = post.ev_end_date | default: post.ev_date | date: '%s' | plus: 0 -%}
  {%- if slut > nu -%}{%- assign antal_kommande = antal_kommande | plus: 1 -%}{%- endif -%}
{%- endfor -%}

{% if antal_kommande > 0 %}
## Evenemang

{% for post in daterade -%}
  {%- assign slut = post.ev_end_date | default: post.ev_date | date: '%s' | plus: 0 -%}
  {%- if slut > nu -%}{% include feature.html post=post %}{%- endif -%}
{% endfor %}
{% endif %}

## Tidigare evenemang

{% assign tidigare = daterade | reverse -%}
{% for post in tidigare -%}
  {%- assign slut = post.ev_end_date | default: post.ev_date | date: '%s' | plus: 0 -%}
  {%- if slut <= nu -%}{% include feature.html post=post %}{%- endif -%}
{% endfor -%}
{% for post in odaterade -%}
  {% include feature.html post=post %}
{%- endfor %}
