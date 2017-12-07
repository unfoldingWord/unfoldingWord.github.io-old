---
layout: default
title: Unlocked English Bible
permalink: /ueb/index.html
header_image_layout: icon
header_image: icon-ueb.png
credits: >
  "Unlocked English Bible" is a revision of the Public Domain "[1901 American Standard Version](http://ebible.org/asv/eng-asv_usfm.zip)" revised by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.

---

{% assign y = 'ueb' | get_by_dc_id %}
<p>{{ y.dublin_core.description }}</p>

<ul>
 <li>Version: {{ y.dublin_core.version }}</li>
 <li>Release Date: {{ y.dublin_core.issued | date: "%e %B %y" }}</li>
 <li>Status: {% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="https://cdn.door43.org/en/{{ y.dublin_core.identifier }}/v{{ y.dublin_core.version }}/pdf/en_{{ y.dublin_core.identifier }}_v{{ y.dublin_core.version }}.pdf" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} PDF">
   <i class="fa fa-file-pdf-o"></i> Download PDF
  </a>
  <a class="btn btn-dark btn-sm" href="https://door43.org/u/Door43/en_ueb/" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Web">
   <i class="fa fa-globe"></i> View on the Web
  </a>
  <a class="btn btn-dark btn-sm" href="{{ y.dublin_core.url }}" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
</p>
</div>

