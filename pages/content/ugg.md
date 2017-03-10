---
layout: default
title: Unlocked Greek Grammar
permalink: /ugg/index.html
header_image_layout:
header_image:
credits: >
  The "[Unlocked Greek Grammar](https://unfoldingword.org/ugg/)" is designed by unfoldingWord and developed by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% for resource in site.data.resources %}
 {% if resource.abbreviation == 'UGG' %}
  {{ resource.what }} It {{ resource.why }}
 {% endif %}
{% endfor %}

* * * * *

{% include content.html %}
