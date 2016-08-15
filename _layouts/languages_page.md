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

##### Open Bible Stories

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
              {% unless page.lang.resources.obs[0].published_on == empty %}
                <p class="obs-published-date">Published on {{ page.lang.resources.obs[0].published_on | date: '%B %d, %Y' }}</p>
              {% endunless %}
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
                {% unless story.audio_urls == empty %}
                  <a href="#popup_dropdown_audio_{{ story.title_id | downcase }}" class="download-resource-icon popup_dropdown_audio_{{ story.title_id | downcase }}_open" title="Audio Files"><i class="fa fa-volume-up"></i></a>
                {% endunless %}
                {% unless story.video_urls == empty %}
                  <a href="#popup_dropdown_video_{{ story.title_id | downcase }}" class="download-resource-icon popup_dropdown_video_{{ story.title_id | downcase }}_open" title="Video Files"><i class="fa fa fa-film"></i></a>
                {% endunless %}
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

##### Bible Translations

We have developed two translations of the Bible specifically to create a free open-licensed Bible to be distributed as widely as possible and to be freely available for translation.

{% if page.lang.resources.bible %}
{% for bible in page.lang.resources.bible %}
  <div id="bible-translations-{{ bible.slug }}" class="accordion bible-translations-{{ bible.slug }}-accordion" data-accordion>
    <div class="control" lang="{{ page.lang.code }}" dir="{{ page.lang.direction }}" data-control>
      <img src="{{ bible.checking_level_image | prepend: site.baseurl }}" class="checking"> {{ bible.name }}<i class="fa fa-toggle fa-caret-right"></i>
    </div>
    <div class="accordion-content" data-content>
      <div class="content-item">
        <div class="row">
          <div class="col-sm-6 first">
            {{ bible.name }}
          </div>
          <div class="col-sm-6 last text-right">
            {% unless bible.pdf_urls == empty %}
              <a href="#popup_dropdown_pdfs_for_{{ bible.slug }}" class="download-resource-icon popup_dropdown_pdfs_for_{{ bible.slug }}_open" title="PDF Documents"><i class="fa fa-file-pdf-o"></i></a>
            {% endunless %}
            <a class="download-resource-icon" href="{{ bible.online_url }}" title="Web Browser"><i class="fa fa-desktop"></i></a>
          </div>
        </div>
      </div>
      {% unless bible.books == empty %}
        {% for book in bible.books %}
          {% include language_page_link.html link_name=book.name link_pdf=book.pdf_url link_url=book.online_url %}
        {% endfor %}
      {% endunless %}
    </div>
  </div>
{% endfor %}
{% else %}
  <div class="accordion bible-translations-accordion" data-accordion>
      <div class="control" data-control>Sorry, Not Available Yet!</div>
      <div class="accordion-content" data-content></div>
  </div>
{% endif %}

##### Translation Resources

unfoldingWord has developed a suite of translation resources that are freely available to anyone who wants to translate the Bible in their own language.  These resources comprise of three parts: translationNotes, translationWords and translationQuestions.  We are also currently developing [translationAcademy]({{ '/academy/' | prepend: site.baseurl }}).

{% if page.lang.resources.translation %}
<div id="translation-words" class="accordion translation-words-accordion" data-accordion>
  {% assign tw = page.lang.resources.translation.tW %}
  <div class="control" data-control>{{tw.name}}<i class="fa fa-toggle fa-caret-right"></i></div>
  <div class="accordion-content" data-content>
    {% include language_page_link.html link_name=tw.name link_pdf=tw.href %}
  </div>
</div>
<div id="translation-notes" class="accordion translation-notes-accordion" data-accordion>
  <div class="control" data-control>{{ page.lang.resources.translation.tN.name }}<i class="fa fa-toggle fa-caret-right"></i></div>
  <div class="accordion-content" data-content>
    {% for resource in page.lang.resources.translation.tN.files %}
      {% include language_page_link.html link_name=resource.name link_pdf=resource.href %}
    {% endfor %}
  </div>
</div>
<div id="translation-questions" class="accordion translation-questions-accordion" data-accordion>
  <div class="control" data-control>{{ page.lang.resources.translation.tQ.name }}<i class="fa fa-toggle fa-caret-right"></i></div>
  <div class="accordion-content" data-content>
    {% include language_page_link.html link_name=page.lang.resources.translation.tQ.name link_pdf=page.lang.resources.translation.tQ.href %}
    {% for resource in page.lang.resources.translation.tQ.files %}
      {% include language_page_link.html link_name=resource.name link_pdf=resource.href %}
    {% endfor %}
  </div>
</div>
{% else %}
<div class="accordion translation-resources-accordion" data-accordion>
  <div class="control" data-control>Sorry, Not Available Yet!</div>
  <div class="accordion-content" data-content></div>
</div>
{% endif %}

<script type="application/javascript">
  $().ready(function() {
    setupAccordion();
    $('#popup_dropdown_all_audio, #popup_dropdown_all_video').popup({type: 'tooltip'});
{% unless page.lang.resources.obs[0].stories == empty %}
  {% for story in page.lang.resources.obs[0].stories %}
  {% unless story.audio_urls == empty %}
    $('#popup_dropdown_audio_{{ story.title_id | downcase }}').popup({type: 'tooltip'});
  {% endunless %}
  {% unless story.video_urls == empty %}
    $('#popup_dropdown_video_{{ story.title_id | downcase }}').popup({type: 'tooltip'});
  {% endunless %}
  {% endfor %}
{% endunless %}
{% for bible in page.lang.resources.bible %}
  {% unless bible.pdf_urls == empty %}
    $('#popup_dropdown_pdfs_for_{{ bible.slug }}').popup({type: 'tooltip'});
  {% endunless %}
{% endfor %}
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
  {% unless story.audio_urls == empty %}
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
  {% endunless %}
  {% unless story.video_urls == empty %}
  <div id="popup_dropdown_video_{{ story.title_id | downcase }}" class="popup-overlay">
    <div class="popup-title">
      <p>Video Files</p>
    </div>
    <div class="popup-nav">
      <ul>
        {% unless story.video_urls.low == empty %}
          <li><a href="{{ story.video_urls.low }}" title="Low Resolution Video">Low Resolution</a></li>
        {% endunless %}
        {% unless story.video_urls.high == empty %}
          <li><a href="{{ story.video_urls.high }}" title="High Resolution Video">High Resolution</a></li>
        {% endunless %}
        <li><a href="#" title="Close" class="popup_dropdown_video_{{ story.title_id | downcase }}_close">Close</a></li>
      </ul>
    </div>
  </div>
  {% endunless %}
  {% endfor %}
{% endunless %}
{% if page.lang.resources.bible %}
  {% for bible in page.lang.resources.bible %}
  {% unless bible.pdf_urls == empty %}
  <div id="popup_dropdown_pdfs_for_{{ bible.slug }}" class="popup-overlay">
    <div class="popup-title">
      <p>PDF Files</p>
    </div>
    <div class="popup-nav">
      <ul>
        <li><a href="{{ bible.pdf_urls.old_testament }}" title="Old Testament">Old Testament</a></li>
        <li><a href="{{ bible.pdf_urls.new_testament }}" title="New Testament">New Testament</a></li>
        <li><a href="{{ bible.pdf_urls.full }}" title="Full Version">Full Version</a></li>
        <li><a href="#" title="Close" class="popup_dropdown_pdfs_for_{{ bible.slug }}_close">Close</a></li>
      </ul>
    </div>
  </div>
  {% endunless %}
  {% endfor %}
{% endif %}
