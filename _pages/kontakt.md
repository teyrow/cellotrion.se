---
permalink: /kontakt/
title: "Kontakt"
excerpt: "Har du frågor eller vill boka en konsert, kontakta oss!"
description: "Boka Cellotrion till din konsert eller ditt evenemang i Linköping med omnejd. Här hittar du telefon, e-post och sociala medier."
header:
  image: assets/images/skrivmaskin.jpeg
  teaser: assets/images/skrivmaskin.jpeg
---

Skulle du vilja ha besök av Cellotrion och vårt koncept eller kanske bara anlita oss som musiker? Hör av dig och berätta om dina tankar!

{% for link in site.footer.links -%}
  [<i class="{{ link.icon }}" aria-hidden="true"></i> {{ link.label }}]( {{ link.url }} )  
{% endfor %}
