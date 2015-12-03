---
layout: layered
title: 
permalink: 
footer_layer_widget: obs/footer_widget.html
credits: >
  Attribution of artwork: All images used in Open Bible Stories are
  © [Sweet Publishing](http://www.sweetpublishing.com) and are made available under a
  [Creative Commons Attribution-Share Alike 3.0 License](http://creativecommons.org/licenses/by-sa/3.0).
---
<div class="language-page-banner">
  <div class="one-half first">
    <div class="navigation">
        <ul>
            <li><a href="#open-bible-stories" class="scroll-to open-accordion">Open Bible Stories</a></li>
            <li><a href="#bible-translations" class="scroll-to open-accordion">Bible</a></li>
            <li><a href="#translation-resources" class="scroll-to">Translation Resources</a></li>
        </ul>
    </div>
  </div>
  <div class="one-half language-page-title last">
    <h1><span class="highlight" lang="{{ page.lang.code }}" dir="{{ page.lang.direction }}">{{ page.lang.string }}</span></h1>
  </div>
  <div class="clearfix"></div>
</div>

#####Open Bible Stories

Open Bible Stories are a set of 50 key stories covering Creation to Revelation that are suitable for evangelism and discipleship.  They are available in text, audio, and video on mobile or desktop.  You can view or download Open Bible Stories for free in <span lang="{{ page.lang.code }}" dir="{{ page.lang.direction }}">{{ page.lang.string }}</span> on this page.  For other languages,  please go to [Open Bible Stories]({{ '/stories/' | prepend: site.baseurl }}) and search for the desired language.
{% if page.lang.resources.obs %}
  <div class="presentations row">
    <div class="one-half txt-center first">
      <a class="download-resource-icon slideshow-btn" href="{{ page.lang.resources.obs.low_res_slideshow_url }}" title="View Low Resolution">
        <i class="fa fa-desktop"></i> View Low Resolution
      </a>
    </div>
    <div class="one-half txt-center last">
      <a class="download-resource-icon slideshow-btn" href="{{ page.lang.resources.obs.high_res_slideshow_url }}" title="View High Resolution">
        <i class="fa fa-desktop"></i> View High Resolution
      </a>
    </div>
    <div class="clearfix"></div>
  </div>
  <div class="accordion open-bible-stories-accordion" data-accordion>
      <div class="control" data-control>
        <img src="{{ page.lang.resources.obs.checking_level_image | prepend: site.baseurl }}" class="checking"> Download Open Bible Stories<i class="fa fa-toggle fa-caret-right"></i>
      </div>
      <div class="accordion-content" style="position: relative;" data-content>
        <div class="content-item">
          <div class="row">
            <div class="one-half first">
              All Open Bible Stories
            </div>
            <div class="one-half last txt-right">
              <a class="download-resource-icon" href="{{ page.lang.resources.obs.pdf_url }}" title="PDF Document"><i class="fa fa-file-pdf-o"></i></a>
              {% unless page.lang.resources.obs.audio_urls.low == empty %}
                <a href="#popup_dropdown_all_audio" class="download-resource-icon popup_dropdown_all_audio_open" title="Audio Files"><i class="fa fa-volume-up"></i></a>
              {% endunless %}
              {% unless page.lang.resources.obs.video_urls.low == empty %}
                <a class="download-resource-icon popup_dropdown_all_video_open" href="#popup_dropdown_all_video" title="Video Files"><i class="fa fa-film"></i></a>
              {% endunless %}
            </div>
            <div class="clearfix"></div>
          </div>
        </div>
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

<img src="{{ '/assets/img/obs/obs-homepage-web.jpg' | prepend: site.baseurl }}" alt="Open Bible Stories" class="full-width-image">

<script type="application/javascript">
  $().ready(function() {
    setupAccordion();
    $('#popup_dropdown_all_audio, #popup_dropdown_all_video').popup({type: 'tooltip'});
  });
</script>

<div id="popup_dropdown_all_audio" class="popup-overlay">
  <div class="popup-title">
    <p>Audio Files</p>
  </div>
  <div class="popup-nav">
    <ul>
      {% unless page.lang.resources.obs.audio_urls.low == empty %}
        <li><a href="{{ page.lang.resources.obs.audio_urls.low }}" title="Low Resolution Audio">Low Resolution</a></li>
      {% endunless %}
      {% unless page.lang.resources.obs.audio_urls.med == empty %}
        <li><a href="{{ page.lang.resources.obs.audio_urls.med }}" title="Medium Resolution Audio">Medium Resolution</a></li>
      {% endunless %}
      {% unless page.lang.resources.obs.audio_urls.high == empty %}
        <li><a href="{{ page.lang.resources.obs.audio_urls.high }}" title="High Resolution Audio">High Resolution</a></li>
      {% endunless %}
      <li><a href="#" title="Close" class="popup_dropdown_all_audio_close">Close</a></li>
    </ul>
  </div>
</div>

<div id="popup_dropdown_all_video" class="popup-overlay">
  <div class="popup-title">
    <p>Video Files</p>
  </div>
  <div class="popup-nav">
    <ul>
      {% unless page.lang.resources.obs.video_urls.low == empty %}
        <li><a href="{{ page.lang.resources.obs.video_urls.low }}" title="Low Resolution Video">Low Resolution</a></li>
      {% endunless %}
      {% unless page.lang.resources.obs.video_urls.high == empty %}
        <li><a href="{{ page.lang.resources.obs.video_urls.high }}" title="High Resolution Video">High Resolution</a></li>
      {% endunless %}
      <li><a href="#" title="Close" class="popup_dropdown_all_video_close">Close</a></li>
    </ul>
  </div>
</div>