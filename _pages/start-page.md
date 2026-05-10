---
title: "Cellotrion"
layout: splash
permalink: /index.html
date: 2026-03-14T12:00:00+00:00
header:
  overlay_color: "#000"
  overlay_filter: "0.5"
  overlay_image: /assets/images/tre_celli.png
excerpt: "Vi har plockat fram essensen i skön musik och består av endast cellister. Upplevelsen kröner vi gärna med kaffe och gott fika. Välkommen till vår sida!"
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
