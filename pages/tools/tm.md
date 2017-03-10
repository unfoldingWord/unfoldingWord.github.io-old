---
layout: default
title: translationManager
permalink: /tm/index.html
header_image_layout:
header_image:
---

{% for resource in site.data.resources %}
 {% if resource.abbreviation == 'tM' %}
  {{ resource.what }} It {{ resource.why }}
 {% endif %}
{% endfor %}

Under development.

* * * * *

{% include apps.html %}
