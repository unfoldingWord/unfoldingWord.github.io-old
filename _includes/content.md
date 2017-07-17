### Scripture

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'bundle' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier | upcase }})</a> –
  <a href="{{ y.dublin_core.url }}">
{% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}
  </a> –
{% case y.dublin_core.version %}
{% when '0' %}(not released) –{% else %}
(ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) –
{% endcase %}
{{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

### Translation Helps

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'help' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier | upcase | replace_first: 'T', 't' }})</a> –
  <a href="{{ y.dublin_core.url }}">
{% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}
  </a> –
{% case y.dublin_core.version %}
{% when '0' %}(not released) –{% else %}
(ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) –
{% endcase %}
{{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

### Discipleship Books

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'book' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier | upcase }})</a> –
  <a href="{{ y.dublin_core.url }}">
{% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}
  </a> –
{% case y.dublin_core.version %}
{% when '0' %}(not released) –{% else %}
(ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) –
{% endcase %}
{{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>

### Dictionaries

<ul>
{% for x in site.data.content %} {% for y in x %} {% if y.dublin_core.type == 'dict' %}
 <li>
  <a href="/{{ y.dublin_core.identifier }}/"> {{ y.dublin_core.title }} ({{ y.dublin_core.identifier | upcase | replace_first: 'T', 't' }})</a> –
  <a href="{{ y.dublin_core.url }}">
{% case y.checking.checking_level %}
{% when '3' %}Stable {% else %}In progress
{% endcase %}
  </a> –
{% case y.dublin_core.version %}
{% when '0' %}(not released) –{% else %}
(ver. {{ y.dublin_core.version }}, {{ y.dublin_core.modified | date: "%e %B %y" }}) –
{% endcase %}
{{ y.dublin_core.description }}
 </li>
{% endif %} {% endfor %} {% endfor %}
</ul>
