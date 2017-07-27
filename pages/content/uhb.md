---
layout: default
title: Unlocked Hebrew Bible
permalink: /uhb/index.html
header_image_layout: icon
header_image: icon-uhb.png
credits: >
  The "[Unlocked Hebrew Bible](https://unfoldingword.org/uhb/)" is designed by unfoldingWord and developed by the [Door43 World Missions Community](https://door43.org/). It is made available under a [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) license.
---

{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.identifier == 'uhb' %}
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

We use the excellent [Open Scriptures Hebrew Bible](https://github.com/openscriptures/morphhb) as the base text for our Unlocked Hebrew Bible.

The **Unlocked Hebrew Bible** is:

- **Free of copyright and licensing restrictions** (public domain / CC BY), permitting the entire global Church to use and build on it without hindrance.
- **Based on existing work** of excellent pedigree and academic repute.
- **Morphologically parsed** and **lexically tagged**.

The purpose of the project (together with the [Unlocked Hebrew & Aramaic Lexicon][uhal]) is two-fold:

1. So that these resources can be made available to pastors and Bible students that speak the Gateway Languages of the world (thereby covering every people group, see the [Gateway Languages page][gl])
1. So that these resources can be used to create robust tools for enabling Bible translators in the global Church (which we expect to soon number in the thousands) to check their translations with confidence, reliability, and without hindrance or dependency on outsiders to grant them a license to use the resources.

See also: [Unlocked Hebrew & Aramaic Lexicon][uhal]

[gl]: {{ '/gateway/' | prepend: site.baseurl }} "Gateway Languages Strategy"
[uhal]: {{ '/uhal/' | prepend: site.baseurl }} "Unlocked Hebrew & Aramaic Lexicon"
