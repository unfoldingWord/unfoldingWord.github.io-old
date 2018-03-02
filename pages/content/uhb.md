---
layout: default
title: Unlocked Hebrew Bible
permalink: /uhb/index.html
header_image_layout: icon
header_image: icon-uhb.png
credits: >
  The "[Unlocked Hebrew Bible](https://unfoldingword.org/uhb/)" is designed by unfoldingWord and developed by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) license. The UHB is based on the [Open Scriptures Hebrew Bible](https://github.com/openscriptures/morphhb).
---

{% assign manifest = 'uhb' | get_by_dc_id %}
<p>{{ manifest.dublin_core.description }}</p>

<ul>
 <li>Version: {{ manifest.dublin_core.version }}</li>
 <li>Status: {% case manifest.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="{{ manifest.dublin_core.url }}" title="UHB Version {{ manifest.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
 </p>
</div>
