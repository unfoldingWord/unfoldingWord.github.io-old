---
layout: default
title: unfoldingWord Literal Text
permalink: /ult/index.html
header_image_layout:
header_image:
credits: >
  "unfoldingWord Literal Text" is a revision of the Public Domain "[1901 American Standard Version](http://ebible.org/asv/eng-asv_usfm.zip)" revised by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.

---

{% assign y = 'ult' | get_by_dc_id %}
<p>{{ y.dublin_core.description }}</p>
<p>The {{ y.dublin_core.title }} is intended to be used together with the [unfoldingWord Simplified Text][ust] to provide a more robust view of both the form and function of the original texts.</p>

<ul>
 <li>Version: {{ y.dublin_core.version }}</li>
 <li>Release Date: {{ y.dublin_core.issued | date: "%e %B %y" }}</li>
 <li>Status: In progress</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="https://door43.org/u/Door43-Catalog/en_ult/" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Web">
   <i class="fa fa-globe"></i> View on the Web
  </a>
  <a class="btn btn-dark btn-sm" href="{{ y.dublin_core.url }}" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
</p>
</div>

[ust]: {{ '/ust' | prepend: site.baseurl }} "unfoldingWord Simplified Text"
