---
layout: default
title: Open-licensed Content, Tools, and Training Resources
permalink: /resources/index.html
---

The resources available include biblical content, translation tools, and translation training resources.

## Content

<ul>
{% for resource in site.data.resources %}
 {% if resource.category == 'content' %}
  <li>{{ resource.name }}</li>
 {% endif %}
{% endfor %}
</ul>
