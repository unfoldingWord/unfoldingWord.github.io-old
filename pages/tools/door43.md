---
layout: default
title: Door43
permalink: /door43/index.html
header_image_layout: icon
header_image: d43-152.png
---

A translation wiki configured for every language in the world, with automatic revision control and distributed backup, online at <https://door43.org>.

- All translated content in Door43 is stored in [Git][git] respositories (one per language) that provide revision control and form the basis of a distributed, high-availability architecture.

- The architecture of Door43 allows users to collaborate together online, as well as use tools like [translationStudio][tS] to work offline and then synchronize translated content to Door43 for checking and publishing.

This diagram shows the movement of content through Door43 and out to the unfoldingWord catalog where it is available in multiple formats, including web publishing and [mobile][uW-app].

![translationStudio]({{ '/assets/img/content-flow.jpg' | prepend: site.baseurl }})

* * * * *

{% include services.html %}

[git]: http://www.git-scm.com/
[tS]: {{ '/translationstudio' | prepend: site.baseurl }} "translationStudio app"
[uW-app]:  {{ '/app' | prepend: site.baseurl }} "unfoldingWord mobile app"
