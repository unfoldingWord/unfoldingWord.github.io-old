---
layout: default
title: Autographa
permalink: /autographa/index.html
header_image_layout: icon
header_image: icon-autographa.png
---

{% for resource in site.data.resources %}
 {% if resource.name == 'Autographa' %}
  {{ resource.what }} It {{ resource.why }}
 {% endif %}
{% endfor %}

Find out more at [www.autographa.com](http://www.autographa.com).

* * * * *

{% include apps.html %}
