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
            <li><a href="#open-bible-stories" class="scroll-to">Open Bible Stories</a></li>
            <li><a href="#bible-translations" class="scroll-to">Bible</a></li>
            <li><a href="#translation-resources" class="scroll-to">Translation Resources</a></li>
        </ul>
    </div>
  </div>
  <div class="one-half language-page-title last">
    <h1><span class="highlight">{{ page.lang.string }}</span></h1>
  </div>
  <div class="clearfix"></div>
</div>

#####Open Bible Stories

Open Bible Stories are a set of 50 key stories covering Creation to Revelation that are suitable for evangelism and discipleship.  They are available in text, audio, and video on mobile or desktop.  You can view or download Open Bible Stories for free in {{ page.lang.string }} on this page.  For other languages,  please go to [Open Bible Stories]({{ '/stories/' | prepend: site.baseurl }}) and search for the desired language.

<div class="accordion" data-accordion>
    <div class="control" data-control><img src="{{ '/assets/img/uW-Level3-64px.png' | prepend: site.baseurl }}" class="checking"> All Open Bible Stories<i class="fa fa-caret-right"></i></div>
    <div data-content>
      {% for story in page.stories %}
        <div class="content-item">
          <div class="one-half first">
            {{ story.title }}
          </div>
          <div class="one-half last">
            Links
          </div>
        </div>
      {% endfor %}
    </div>
</div>


#####Bible Translations

We have developed two translations of the Bible specifically to create a free open-licensed Bible to be distributed as widely as possible and to be freely available for translation.

* Unlocked Literal Bible - An open-licensed, form centric, literal version of the Bible.
* Unlocked Dynamic Bible - An open-licensed dynamic version of the Bible.

<div class="accordion" data-accordion>
    <div class="control" data-control><img src="{{ '/assets/img/uW-Level3-64px.png' | prepend: site.baseurl }}" class="checking"> Bible Translations<i class="fa fa-caret-right"></i></div>
    <div data-content>
        <div class="content-item"><a href="test">First Story</a></div>
        <div class="content-item"><a href="test">Second Story</a></div>
        <div class="content-item"><a href="test">Third Story</a></div>
    </div>
</div>

#####Translation Resources

unfoldingWord has developed a suite of translation resources that are freely available to anyone who wants to translate the Bible in their own language.  These resources comprise of three parts: translationNotes, translationWords and translationQuestions.  We are also currently developing [translationAcademy]({{ '/academy/' | prepend: site.baseurl }}).

<div class="accordion" data-accordion>
    <div class="control" data-control><img src="{{ '/assets/img/uW-Level3-64px.png' | prepend: site.baseurl }}" class="checking"> Translation Resources<i class="fa fa-caret-right"></i></div>
    <div data-content>
        <div class="content-item"><a href="test">First Story</a></div>
        <div class="content-item"><a href="test">Second Story</a></div>
        <div class="content-item"><a href="test">Third Story</a></div>
    </div>
</div>

<img src="{{ '/assets/img/obs/obs-homepage-web.jpg' | prepend: site.baseurl }}" alt="Open Bible Stories" class="full-width-image">

<script type="application/javascript">
  $().ready(function() {
    setupAccordion();
  });
</script>