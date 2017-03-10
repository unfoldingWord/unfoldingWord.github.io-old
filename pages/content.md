---
layout: default
title: Biblical Content
permalink: /content/index.html
---

<ul>
{% for resource in site.data.resources %}
 {% if resource.category == 'content' %}
  <li><a href="{{ resource.url | prepend: site.baseurl }}">{{ resource.name }} ({{ resource.abbreviation }})</a> – {{ resource.what }} It {{ resource.why }}</li>
 {% endif %}
{% endfor %}
</ul>
