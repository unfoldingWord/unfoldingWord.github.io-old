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
  <div class="accordion open-bible-stories-accordion" data-accordion>
      <div class="control" data-control><img src="{{ page.lang.resources.obs.checking_level_image | prepend: site.baseurl }}" class="checking"> Open Bible Stories<i class="fa fa-caret-right"></i></div>
      <div class="accordion-content" data-content>
        <div class="content-item">
          <a class="download-resource-icon" href="{{ page.lang.resources.obs.low_res_video_url }}" title="Low Resolution Presentation">
            <img class="languages" src="{{ '/assets/img/obs/low_res_h.png' | prepend: site.baseurl }}" class="low-res"> Low Resolution Presentation
          </a>
        </div>
        <div class="content-item">
          <a class="download-resource-icon" href="{{ page.lang.resources.obs.high_res_video_url }}" title="Low Resolution Presentation">
            <img class="languages" src="{{ '/assets/img/obs/high_res_h.png' | prepend: site.baseurl }}" class="high-res"> High Resolution Presentation
          </a>
        </div>
        <div class="content-item">
          <a class="download-resource-icon" href="{{ page.lang.resources.obs.pdf_url }}" title="Low Resolution Presentation">
            <i class="fa fa-file-pdf-o"></i> PDF Document
          </a>
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
      <div class="control" data-control>Bible Translations<i class="fa fa-caret-right"></i></div>
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
  });
</script>