---
layout: layered
title:
permalink:
background_image: /assets/img/home/monks21.jpg
footer_layer_widget: obs/footer_widget.html
content_layer_footer_widget: language_pages_footer_widget.html
credits: >
  Attribution of artwork: All images used in Open Bible Stories are
  © [Sweet Publishing](http://www.sweetpublishing.com) and are made available under a
  [Creative Commons Attribution-Share Alike 3.0 License](http://creativecommons.org/licenses/by-sa/3.0).
---
{::options parse_block_html="false" /}
<div class="language-page-banner">
  <div class="row">
    <div class="col-sm-6 first">
      <div class="navigation">
          <ul>
              <li><a href="#open-bible-stories" class="scroll-to open-accordion">Open Bible Stories</a></li>
              <li><a href="#bible-translations" class="scroll-to open-accordion">Bible</a></li>
              <li><a href="#translation-resources" class="scroll-to">Translation Resources</a></li>
          </ul>
      </div>
    </div>
    <div class="col-sm-6 language-page-title last">
      <h1><span class="highlight" lang="{{ page.lang.code }}" dir="{{ page.lang.direction }}">{{ page.lang.text }}</span></h1>
    </div>
  </div>
</div>

#####Open Bible Stories

Open Bible Stories are a set of 50 key stories covering Creation to Revelation that are suitable for evangelism and discipleship.  They are available in text, audio, and video on mobile or desktop.  You can view or download Open Bible Stories for free in <span lang="{{ page.lang.code }}" dir="{{ page.lang.direction }}">{{ page.lang.text }}</span> on this page.  For other languages,  please go to [Open Bible Stories]({{ '/stories/' | prepend: site.baseurl }}) and search for the desired language.
{% if page.lang.resources.obs %}
  <div class="presentations">
    <div class="row">
      <div class="col-sm-6 text-center first">
        <a class="btn btn-primary" href="{{ page.lang.resources.obs[0].low_res_slideshow_url }}" title="View Low Resolution">
          <i class="fa fa-desktop"></i> View Low Resolution
        </a>
      </div>
      <div class="col-sm-6 text-center last">
        <a class="btn btn-primary" href="{{ page.lang.resources.obs[0].high_res_slideshow_url }}" title="View High Resolution">
          <i class="fa fa-desktop"></i> View High Resolution
        </a>
      </div>
    </div>
  </div>
  <div class="accordion open-bible-stories-accordion" data-accordion>
      <div class="control" data-control>
        <img src="{{ page.lang.resources.obs[0].checking_level_image | prepend: site.baseurl }}" class="checking"> Download Open Bible Stories<i class="fa fa-toggle fa-caret-right"></i>
      </div>
      <div class="accordion-content" style="position: relative;" data-content>
        <div class="content-item">
          <div class="row">
            <div class="col-sm-6 first">
              All Open Bible Stories
            </div>
            <div class="col-sm-6 last text-right">
              <a class="download-resource-icon" href="{{ page.lang.resources.obs[0].pdf_url }}" title="PDF Document"><i class="fa fa-file-pdf-o"></i></a>
              {% unless page.lang.resources.obs[0].audio_urls == empty %}
                <a href="#popup_dropdown_all_audio" class="download-resource-icon popup_dropdown_all_audio_open" title="Audio Files"><i class="fa fa-volume-up"></i></a>
              {% endunless %}
              {% unless page.lang.resources.obs[0].video_urls == empty %}
                <a class="download-resource-icon popup_dropdown_all_video_open" href="#popup_dropdown_all_video" title="Video Files"><i class="fa fa-film"></i></a>
              {% endunless %}
            </div>
          </div>
        </div>
        {% unless page.lang.resources.obs[0].stories == empty %}
          {% for story in page.lang.resources.obs[0].stories %}
            <div class="content-item">
              <div class="row">
                <div class="col-sm-10 first">
                  {{story.chapter}}. {{ site.data.obs_stories[story.title_id]['title'] }}
                </div>
                <div class="col-sm-2 last text-right">
                  <a href="#popup_dropdown_audio_{{ story.title_id | downcase }}" class="download-resource-icon popup_dropdown_audio_{{ story.title_id | downcase }}_open" title="Audio Files"><i class="fa fa-volume-up"></i></a>
                </div>
              </div>
            </div>
          {% endfor %}
        {% endunless %}
      </div>
  </div>
{% else %}
  <div class="accordion open-bible-stories-accordion" data-accordion>
    <div class="control" data-control>Sorry, Not Available Yet!</div>
    <div class="accordion-content" data-content></div>
  </div>
{% endif %}

#####Bible Translations

We have developed two translations of the Bible specifically to create a free open-licensed Bible to be distributed as widely as possible and to be freely available for translation.

{% if page.lang.resources.bible %}
  <div class="accordion bible-translations-accordion" data-accordion>
      <div class="control" data-control>Bible Translations<i class="fa fa-toggle fa-caret-right"></i></div>
      <div class="accordion-content" data-content>
        {% for bible in page.lang.resources.bible %}
          <div class="content-item" lang="{{ page.lang.code }}" dir="{{ page.lang.direction }}">
            <a href="https://bible.unfoldingword.org/?w1=bible&t1=uw_{{ page.lang.code }}_{{ bible.slug }}&v1=GN1_1">
              <img src="{{ bible.checking_level_image | prepend: site.baseurl }}" class="checking"> {{ bible.name }}
            </a>
          </div>
        {% endfor %}
      </div>
  </div>
{% else %}
  <div class="accordion bible-translations-accordion" data-accordion>
      <div class="control" data-control>Sorry, Not Available Yet!</div>
      <div class="accordion-content" data-content></div>
  </div>
{% endif %}

#####Translation Resources

unfoldingWord has developed a suite of translation resources that are freely available to anyone who wants to translate the Bible in their own language.  These resources comprise of three parts: translationNotes, translationWords and translationQuestions.  We are also currently developing [translationAcademy]({{ '/academy/' | prepend: site.baseurl }}).

<script type="application/javascript">
  $().ready(function() {
    setupAccordion();
    $('#popup_dropdown_all_audio, #popup_dropdown_all_video').popup({type: 'tooltip'});
{% unless page.lang.resources.obs[0].stories == empty %}
  {% for story in page.lang.resources.obs[0].stories %}
    $('#popup_dropdown_audio_{{ story.title_id | downcase }}').popup({type: 'tooltip'});
  {% endfor %}
{% endunless %}
  });
</script>
{% unless page.lang.resources.obs[0].audio_urls == empty %}
  <div id="popup_dropdown_all_audio" class="popup-overlay">
    <div class="popup-title">
      <p>Audio Files</p>
    </div>
    <div class="popup-nav">
      <ul>
        {% unless page.lang.resources.obs[0].audio_urls.low == empty %}
          <li><a href="{{ page.lang.resources.obs[0].audio_urls.low }}" title="Low Resolution Audio">Low Resolution</a></li>
        {% endunless %}
        {% unless page.lang.resources.obs[0].audio_urls.med == empty %}
          <li><a href="{{ page.lang.resources.obs[0].audio_urls.med }}" title="Medium Resolution Audio">Medium Resolution</a></li>
        {% endunless %}
        {% unless page.lang.resources.obs[0].audio_urls.high == empty %}
          <li><a href="{{ page.lang.resources.obs[0].audio_urls.high }}" title="High Resolution Audio">High Resolution</a></li>
        {% endunless %}
        <li><a href="#" title="Close" class="popup_dropdown_all_audio_close">Close</a></li>
      </ul>
    </div>
  </div>
{% endunless %}
{% unless page.lang.resources.obs[0].video_urls == empty %}
  <div id="popup_dropdown_all_video" class="popup-overlay">
    <div class="popup-title">
      <p>Video Files</p>
    </div>
    <div class="popup-nav">
      <ul>
        {% unless page.lang.resources.obs[0].video_urls.low == empty %}
          <li><a href="{{ page.lang.resources.obs[0].video_urls.low }}" title="Low Resolution Video">Low Resolution</a></li>
        {% endunless %}
        {% unless page.lang.resources.obs[0].video_urls.high == empty %}
          <li><a href="{{ page.lang.resources.obs[0].video_urls.high }}" title="High Resolution Video">High Resolution</a></li>
        {% endunless %}
        <li><a href="#" title="Close" class="popup_dropdown_all_video_close">Close</a></li>
      </ul>
    </div>
  </div>
{% endunless %}
{% unless page.lang.resources.obs[0].stories == empty %}
  {% for story in page.lang.resources.obs[0].stories %}
  <div id="popup_dropdown_audio_{{ story.title_id | downcase }}" class="popup-overlay">
    <div class="popup-title">
      <p>Audio Files</p>
    </div>
    <div class="popup-nav">
      <ul>
        {% unless story.audio_urls.low == empty %}
          <li><a href="{{ story.audio_urls.low }}" title="Low Resolution Audio">Low Resolution</a></li>
        {% endunless %}
        {% unless story.audio_urls.high == empty %}
          <li><a href="{{ story.audio_urls.high }}" title="High Resolution Audio">High Resolution</a></li>
        {% endunless %}
        <li><a href="#" title="Close" class="popup_dropdown_audio_{{ story.title_id | downcase }}_close">Close</a></li>
      </ul>
    </div>
  </div>
  {% endfor %}
{% endunless %}
