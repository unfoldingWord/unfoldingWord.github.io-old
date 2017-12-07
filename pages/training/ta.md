---
layout: default
title: translationAcademy
permalink: /academy/index.html
header_image_layout: icon
header_image: icon-ta.png
credits: >
  "[translationAcademy](https://unfoldingword.org/academy/)" is designed by unfoldingWord and developed by the [Door43 World Missions Community](https://door43.org/) made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% assign y = 'ta' | get_by_dc_id %}
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
  <a class="btn btn-dark btn-sm" href="https://cdn.door43.org/en/ta/v{{ y.dublin_core.version }}/pdf/en_ta_v{{ y.dublin_core.version }}.pdf" title="tA Version {{ y.dublin_core.version }} PDF">
   <i class="fa fa-file-pdf-o"></i> Download PDF
  </a>
  <a class="btn btn-dark btn-sm" href="https://door43.org/u/Door43/en_ta/dcae73d489/index.html" title="tA Version {{ y.dublin_core.version }} Web">
   <i class="fa fa-globe"></i> View on the Web
  </a>
  <a class="btn btn-dark btn-sm" href="{{ y.dublin_core.url }}" title="tA Version {{ y.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
</p>
</div>
