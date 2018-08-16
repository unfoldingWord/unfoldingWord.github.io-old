---
layout: default
title: translationQuestions
permalink: /tq/index.html
header_image_layout: icon
header_image: icon-tq.png
credits: >
  "[translationQuestions](/tq/)" is designed by unfoldingWord and developed by the [Door43 World Missions Community](https://door43.org/) made available under a [Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
---

{% assign manifest = 'tq' | get_by_dc_id %}
{% assign projects = manifest | get_sorted_scripture_projects %}
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
  <a class="btn btn-dark btn-sm" href="https://cdn.door43.org/en/tq/v{{ manifest.dublin_core.version }}/pdf/en_tq_v{{ manifest.dublin_core.version }}.pdf" title="tQ Version {{ manifest.dublin_core.version }} PDF">
   <i class="fa fa-file-pdf-o"></i> Download PDF
  </a>
  <a class="btn btn-dark btn-sm" href="https://door43.org/u/Door43-Catalog/en_tq/66fba6b483/" title="tQ Version {{ manifest.dublin_core.version }} Web">
   <i class="fa fa-globe"></i> View on the Web
  </a>
  <a class="btn btn-dark btn-sm" href="{{ manifest.dublin_core.url }}" title="tQ Version {{ manifest.dublin_core.version }} Source">
   <i class="fa fa-archive"></i> View Source
  </a>
 </p>
</div>
<hr>

<p>Or, <a data-toggle="collapse" href="#collapseBooks" aria-expanded="false" aria-controls="collapseBooks">browse by book</a>.</p>

<div class="collapse" id="collapseBooks">
  <table class="table table-striped table-responsive">
   <tbody>
     {% for project in projects %}
     <tr>
      <td style="width: 100%">{{ project.title }}</td>
      <td style="white-space: nowrap"><a href="https://cdn.door43.org/en/tq/v{{ manifest.dublin_core.version }}/pdf/en_tq_{{ project.usfm_code }}_v{{ manifest.dublin_core.version }}.pdf" title="{{ project.title }} PDF"><i class="fa fa-file-pdf-o"></i> Download PDF</a></td>
     </tr>
     {% endfor %}
   </tbody>
  </table>
</div>
