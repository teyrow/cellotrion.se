---
title: "Cellotrion – cellotrio i Linköping"
layout: splash
permalink: /
description: "Cellotrion är en cellotrio i Linköping som ger nära och varma konserter med klassisk musik – Bach, Chopin, Piazzolla med mera. Se kommande konserter och boka oss."
header:
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/tre_celli.png
excerpt: "Vi har plockat fram essensen i skön musik och består av endast cellister. Upplevelsen kröner vi gärna med fika. Välkommen till vår sida!"
---

## Evenemang

{% for post in site.categories.kommande  -%}
    {% include feature.html post=post -%}
{% endfor %}


## Tidigare evenemang

{% for post in site.categories.evenemang  -%}
  {% unless post.categories contains 'kommande' %}
    {% include feature.html post=post -%}
  {% endunless %}
{% endfor %}
