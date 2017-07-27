---
layout: default
title: Unlocked Greek New Testament
permalink: /ugnt/index.html
header_image_layout: icon
header_image: icon-ugnt.png
credits: >
  The "[Unlocked Greek New Testament](https://unfoldingword.org/ugnt/)" is developed by unfoldingWord and developed by [Roma Bible Society](http://romabiblesociety.org), [Wycliffe Associates](http://wycliffeassociates.org), and the [Door43 World Missions Community](https://door43.org/). The Greek text is made available under a [CC0](http://creativecommons.org/publicdomain/zero/1.0/) license and the textual apparatus is made available under a [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) license.
---

{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.identifier == 'ugnt' %}
<p>{{ y.dublin_core.description }}</p>
<!--
# Wait until version 1 is released
<ul>
 <li>Version: {{ y.dublin_core.version }}</li>
 <li>Release Date: {{ y.dublin_core.issued | date: "%e %B %y" }}</li>
 <li>Status: {% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}</li>
</ul>

<div class="text-center">
 <p>
  <a class="btn btn-dark btn-sm" href="http://cdn.door43.org/en/{{ y.dublin_core.identifier }}/v{{ y.dublin_core.version }}/pdf/en_{{ y.dublin_core.identifier }}_v{{ y.dublin_core.version }}.pdf" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} PDF">
   <i class="fa fa-file-pdf-o"></i> Download PDF
  </a>
  <a class="btn btn-dark btn-sm" href="https://bible.unfoldingword.org/" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Web">
   <i class="fa fa-globe"></i> View on the Web
  </a>
  <a class="btn btn-dark btn-sm" href="{{ y.dublin_core.url }}" title="{{ y.dublin_core.identifier | upcase }} Version {{ y.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
</p>
</div>
-->

{% endif %} {% endfor %} {% endfor %}
The **Unlocked Greek New Testament** is:

- **Free of copyright and licensing restrictions** ([public domain][pd] / [CC0][cc0]), permitting the entire global Church to use and build on it without hindrance.
- **Based on existing work** of excellent pedigree and academic repute.
- **Morphologically parsed** and **lexically tagged**.

The purpose of the project (together with the [Unlocked Greek Lexicon][ugl]) is two-fold:

1. So that these resources can be made available to pastors and Bible students that speak the Gateway Languages of the world (thereby covering every people group, see the [Gateway Languages page][gl])
1. So that these resources can be used to create robust tools for enabling Bible translators in the global Church (which we expect to soon number in the thousands) to check their translations with confidence, reliability, and without hindrance or dependency on outsiders to grant them a license to use the resources.

The project is online at: <https://git.door43.org/Door43/ugnt>

See also: [Unlocked Greek Lexicon][ugl]

[cc0]: http://creativecommons.org/publicdomain/zero/1.0/
[gl]: {{ '/gateway' | prepend: site.baseurl }} "Gateway Languages Strategy"
[pd]: http://creativecommons.org/publicdomain/mark/1.0/
[ugl]: {{ '/ugl' | prepend: site.baseurl }} "Unlocked Greek Lexicon"
