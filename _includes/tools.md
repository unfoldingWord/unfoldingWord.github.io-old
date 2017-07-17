<ul>
{% for resource in site.data.tools %}
 <li><a href="{{ resource.url | prepend: site.baseurl }}">{{ resource.name }}
   {% if resource.abbreviation %}({{ resource.abbreviation }}){% endif %}
  </a> – <a href="{{ resource.dev }}">{{ resource.status }}</a> – {{ resource.description }}
 </li>
{% endfor %}
</ul>
