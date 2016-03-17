---
layout: default
title: Our Network
permalink: /network/index.html
---
{::options parse_block_html="false" /}
{% assign nodes = site.data.networks | sort: 'name' %}
<div class="grid-custom">
  <div class="row">
  {% for node in nodes %}
    {% if node.logo %}
      <div class="col-sm-6 col-xs-12">
        <div class="hovereffect">
          <img src="{{ node.logo }}" alt="{{ node.name }}" class="img-responsive">
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
