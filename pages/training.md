---
layout: default
title: Training
permalink: /training/index.html
---

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
