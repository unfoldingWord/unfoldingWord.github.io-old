---
layout: default
title: Unlocked Aramaic Grammar
permalink: /uag/index.html
header_image_layout:
header_image:
credits: >
  The "[Unlocked Aramaic Grammar](/uag/)" is designed by unfoldingWord and developed by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% assign manifest = 'uag' | get_by_dc_id %}
<p>{{ manifest.dublin_core.description }}</p>

<ul>
 <li>Version: {{ manifest.dublin_core.version }}</li>
 <li>Status: {% case manifest.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="{{ manifest.dublin_core.url }}" title="UAG Version {{ manifest.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
 </p>
</div>
