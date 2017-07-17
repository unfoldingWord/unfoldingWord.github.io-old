<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.identifier == 'ta' %}
 <li>
  <a href="/academy/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier | upcase | replace_first: 'T', 't' }})</a> –
  <a href="{{ y.dublin_core.url }}">
{% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}
  </a> –
{% case y.dublin_core.version %}
{% when '0' %}(not released){% else %}
(ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) –
{% endcase %}
{{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
{% for resource in site.data.training %}
 <li><a href="{{ resource.url | prepend: site.baseurl }}">{{ resource.name }}
   {% if resource.abbreviation %}({{ resource.abbreviation }}){% endif %}
  </a> – {{ resource.status }} – ({{ resource.modified | date: "%e %B %y" }}) – {{ resource.description }}
 </li>
{% endfor %}
</ul>
