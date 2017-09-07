---
layout: default
title: translationManager
permalink: /tm/index.html
header_image_layout:
header_image:
---

{% for resource in site.data.tools %}
 {% if resource.name == 'translationManager' %}
  {{ resource.description }}

  <a href="{{ resource.dev }}">{{ resource.status }}</a>
 {% endif %}
{% endfor %}

* * * * *

{% include apps.html %}
