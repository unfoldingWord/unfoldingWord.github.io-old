---
layout: default
title: Our Network
permalink: /network/index.html
---
The following organizations have contributed to the free & open world
missions movement, of which unfoldingWord is a part.

{::options parse_block_html="false" /}
{% assign nodes = site.data.networks | sort: 'name' %}
<div class="grid-custom">
  <div class="row">
  {% for node in nodes %}
    {% if node.logo %}
      <div class="col-sm-4 col-xs-6">
          <div class="hover-effect">
            <img src="{{ node.logo }}" alt="{{ node.name }}">
            <div class="overlay">
               <h2>{{ node.name }}</h2>
               <a class="info" href="{{ node.url }}" target="_blank">Visit Website</a>
            </div>
          </div>
      </div>
    {% endif %}
  {% endfor %}
  </div>
  <div class="row">
    <div class="col-sm-12">
      <ul>
        {% for node in nodes %}
          <li><a class="info" href="{{ node.url }}" title="Visit Website" target="_blank">{{ node.name }}</a></li>
        {% endfor %}
      </ul>
    </div>
  </div>
</div>
