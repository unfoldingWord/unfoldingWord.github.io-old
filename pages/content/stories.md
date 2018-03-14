---
layout: default
title: unfoldingWord Open Bible Stories
permalink: /stories/index.html
header_image_layout: icon
header_image: icon-obs.png
credits: >
  "[Open Bible Stories](https://openbiblestories.com/)" is developed by [Distant Shores Media](https://distantshores.org/) and the [Door43 World Missions Community](https://door43.org/) and made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license. Attribution of artwork: All images used in "[Open Bible Stories](https://openbiblestories.com/)" are a revision of "[Bible Images from Sweet Publishing](http://pub.distantshores.org/resources/illustrations/sweet-publishing/)" (by [Sweet Publishing](http://www.sweetpublishing.com/) made available under a [Creative Commons Attribution-ShareAlike 3.0](http://creativecommons.org/licenses/by-sa/3.0) license) revised by [Distant Shores Media](https://distantshores.org/) and the [Door43 World Missions Community](https://door43.org/) made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% assign manifest = 'obs' | get_by_dc_id %}
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
  <a class="btn btn-dark btn-sm" href="https://openbiblestories.com/library" title="UGNT Version {{ manifest.dublin_core.version }} Source">
   <i class="fa fa-globe"></i> View on openbiblestories.com
  </a>
  <a class="btn btn-dark btn-sm" href="{{ manifest.dublin_core.url }}" title="{{ manifest.dublin_core.identifier | upcase }} Version {{ manifest.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
 </p>
</div>
<hr>
{% include obs/video.html %}
