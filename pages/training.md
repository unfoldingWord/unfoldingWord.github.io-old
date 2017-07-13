---
layout: default
title: Training
permalink: /training/index.html
---

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.identifier == 'ta' %}
 <li>
  <a href="/academy/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier }})</a> {% case y.checking.checking_level %} {% when '3' %}– Stable {% else %}– In progress {% endcase %} (ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) – {{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
 <li>
  <a href="/audio/">Audio Engineering</a> – A modular handbook containing best practices and recommended equipment for audio recording. It enables audio recordists and engineers to cost-effectively create the highest possible quality recordings.
 </li>
</ul>
