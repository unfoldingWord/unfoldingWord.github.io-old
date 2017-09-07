---
layout: default
title: Autographa
permalink: /autographa/index.html
header_image_layout: icon
header_image: icon-autographa.png
---

{% for resource in site.data.tools %}
 {% if resource.name == 'Autographa' %}
  {{ resource.description }}
 {% endif %}
{% endfor %}

Find out more at [www.autographa.com](http://www.autographa.com).

* * * * *

{% include apps.html %}
