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

{% for post in site.posts -%}
  {% if post.categories contains "evenemang" -%}    
    {% include feature.html post=post -%}
  {% endif %}
{% endfor %}
