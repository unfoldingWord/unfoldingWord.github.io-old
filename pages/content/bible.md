---
layout: default
title:  Unlocked Bible
permalink: /bible/index.html
---

{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'bundle' %}
<div class="row">
 <div class="col-md-3 text-center hidden-print">
  <a href="/{{ y.dublin_core.identifier }}/" class="list-item-image">
   <img src="/assets/img/icon-{{ y.dublin_core.identifier }}.png" alt="{{ y.dublin_core.identifier | upcase }}">
  </a>
 </div>
 <div class="col-md-9">
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier | upcase }})</a> – {{ y.dublin_core.description | split: "." | first }}.
 </div>
</div>
{% endif %} {% endfor %} {% endfor %}


Browse the latest versions online in the [unfoldingWord Bible Web
App](https://bible.unfoldingword.org/). Download the [English
ULB or UDB](/en/).
