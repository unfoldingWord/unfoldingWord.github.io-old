---
layout: default
title: Technology Tools
permalink: /tools/index.html
---

We are developing numerous open-source tools and web services to facilitate the translation of biblical content into every language in the world.

<ul>
{% for resource in site.data.resources %}
 {% if resource.category == 'tools' %}
  <li><a href="{{ resource.url }}">{{ resource.name }}
   {% if resource.abbreviation %}
    ({{ resource.abbreviation }})
   {% endif %}
  </a> – {{ resource.what }} It {{ resource.why }}</li>
 {% endif %}
{% endfor %}
</ul>
