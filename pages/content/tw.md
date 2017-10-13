---
layout: default
title: translationWords
permalink: /tw/index.html
header_image_layout: icon
header_image: icon-tw.png
credits: >
  "[translationWords](https://unfoldingword.org/tw/)" is designed by unfoldingWord and developed by [Wycliffe Associates](http://wycliffeassociates.org) and the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% assign manifest = 'tw' | get_by_dc_id %}
<p>{{ manifest.dublin_core.description }}</p>

<ul>
 <li>Version: {{ manifest.dublin_core.version }}</li>
 <li>Release Date: {{ manifest.dublin_core.issued | date: "%e %B %y" }}</li>
 <li>Status: {% case manifest.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="https://cdn.door43.org/en/tw/v{{ manifest.dublin_core.version }}/pdf/en_tw_v{{ manifest.dublin_core.version }}.pdf" title="tW Version {{ manifest.dublin_core.version }} PDF">
   <i class="fa fa-file-pdf-o"></i> Download PDF
  </a>
  <!-- <a class="btn btn-dark btn-sm" href="https://door43.org/u/Door43/en_tw/4cead879a2/index.html" title="tW Version {{ manifest.dublin_core.version }} Web">
   <i class="fa fa-globe"></i> View on the Web
  </a> -->
  <a class="btn btn-dark btn-sm" href="{{ manifest.dublin_core.url }}" title="tW Version {{ manifest.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
 </p>
</div>
