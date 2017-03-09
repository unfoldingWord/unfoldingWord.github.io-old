---
layout: default
title: Unlocked Bible Commentary
permalink: /ubc/index.html
header_image_layout: icon
header_image: icon-uw.png
credits: >
  The "[Unlocked Bible Commentary](https://unfoldingword.org/ubc/)" is designed by unfoldingWord and developed by [Wycliffe Associates](https://wycliffeassociates.org/) and the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% for resource in site.data.resources %}
 {% if resource.abbreviation == 'UBC' %}
  {{ resource.what }} It {{ resource.why }}
 {% endif %}
{% endfor %}

The **Unlocked Bible Commentary** is:

- **Free of copyright and licensing restrictions** ([CC BY-SA][license]), permitting the entire global Church to use and build on it without hindrance.
- **Based on existing work** of excellent pedigree and academic repute.
- **Translated** into all the [Gateway Languages][gl] of the world, and any other language in which the Church desires to have a Bible commentary.

The project is online at: <https://git.door43.org/Door43/en-ubc>

[gl]: {{ '/gateway' | prepend: site.baseurl }} "Gateway Languages Strategy"
[license]: {{ '/license/' | prepend: site.baseurl }} "License"
