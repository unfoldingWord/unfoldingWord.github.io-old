---
layout: default
title: Open-licensed Resources
permalink: /resources/index.html
---

The resources available through the unfoldingWord network include [biblical content](#content), [translation tools](#tools), and [training](#training) resources.

## Content

### Scripture

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'bundle' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier }})</a> {% case y.checking.checking_level %} {% when '3' %}– Stable {% else %}– In progress {% endcase %} (ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) – {{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

### Translation Helps

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'help' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier }})</a> {% case y.checking.checking_level %} {% when '3' %}– Stable {% else %}– In progress {% endcase %} (ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) – {{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

### Discipleship Books

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'book' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier }})</a> {% case y.checking.checking_level %} {% when '3' %}– Stable {% else %}– In progress {% endcase %} (ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) – {{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

### Dictionaries

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'dict' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier }})</a> {% case y.checking.checking_level %} {% when '3' %}– Stable {% else %}– In progress {% endcase %} (ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) – {{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

## Tools

<ul>
{% for resource in site.data.tools %}
  <li><a href="{{ resource.url | prepend: site.baseurl }}">{{ resource.name }}
   {% if resource.abbreviation %}
    ({{ resource.abbreviation }})
   {% endif %}
  </a> – {{ resource.what }} It {{ resource.why }}</li>
{% endfor %}
</ul>

## Training

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'man' %}
 <li>
  <a href="{{ y.dublin_core.identifier | prepend: site.baseurl }}"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier }})</a> {% case y.checking.checking_level %} {% when '3' %}– Stable {% else %}– In progress {% endcase %} (ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) – {{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
 <li>
  <a href="{{ "audio/" | prepend: site.baseurl }}">Audio Engineering</a> – A modular handbook containing best practices and recommended equipment for audio recording. It enables audio recordists and engineers to cost-effectively create the highest possible quality recordings.
 </li>
</ul>
