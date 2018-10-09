---
layout: default
title: unfoldingWord Simplified Text
permalink: /ust/index.html
header_image_layout:
header_image:
credits: >
  The "unfoldingWord Simplified Text" is a revision of "[Translation for Translators](https://git.door43.org/Door43/T4T)" (by Ellis W. Deibler Jr. made available under a [Creative Commons Attribution-ShareAlike 4.0 International](http://creativecommons.org/licenses/by-sa/4.0) license), designed by unfoldingWord and revised by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% assign y = 'ust' | get_by_dc_id %}
<p>{{ y.dublin_core.description }}</p>
<p>The unfoldingWord Simplified Text is intended to be used together with the [unfoldingWord Literal Text][ult] to provide a more robust view of both the form and function of the original texts.</p>

<ul>
 <li>Version: {{ y.dublin_core.version }}</li>
 <li>Release Date: {{ y.dublin_core.issued | date: "%e %B %y" }}</li>
 <li>Status: In progress</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="{{ y.dublin_core.url }}" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
</p>
</div>

[ult]: {{ '/ult' | prepend: site.baseurl }} "unfoldingWord Literal Text"
