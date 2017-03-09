---
layout: default
title: Open-licensed Resources
permalink: /resources/index.html
---

The resources available through the unfoldingWord network include [biblical content](#content), [translation tools](#tools), and [training](#training) resources.

## Content

<ul>
{% for resource in site.data.resources %}
 {% if resource.category == 'content' %}
  <li><a href="{{ resource.url }}">{{ resource.name }} ({{ resource.abbreviation }})</a> – {{ resource.what }} It {{ resource.why }}</li>
 {% endif %}
{% endfor %}
</ul>

## Tools

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

## Training

<ul>
{% for resource in site.data.resources %}
 {% if resource.category == 'training' %}
  <li><a href="{{ resource.url }}">{{ resource.name }}
   {% if resource.abbreviation %}
    ({{ resource.abbreviation }})
   {% endif %}
  </a> – {{ resource.what }} It {{ resource.why }}</li>
 {% endif %}
{% endfor %}
</ul>
