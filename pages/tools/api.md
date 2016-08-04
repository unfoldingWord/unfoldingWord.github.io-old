---
layout: default
title: Application Programming Interface
permalink: /api/index.html
header_image_layout: icon
header_image: icon-uw.png
---

The unfoldingWord project supports several APIs to provide access to our content.  The documentation for the current iteration is at [API README](https://api.unfoldingword.org/README.html).

* **Door43 Catalog** - This catalog provides links to all of our content and is the recommended starting point for anyone trying to gain programmatic access to it.  Documentation for the forthcoming version 3 is at [API Drafts](http://discourse.door43.org/c/api-drafts).  Note that version 3 will deprecate the translationStudio and unfoldingWord catalogs referenced in the [API README](https://api.unfoldingword.org/README.html).

* **Gogs API** - Our [git.door43.org](https://git.door43.org/) server provides an API for interacting with source repositories, issues, users, etc.  This API is aimed to be very similar to Github's API.  Documentation is at [https://github.com/gogits/go-gogs-client/wiki](https://github.com/gogits/go-gogs-client/wiki).

* **tD API** - translationDatabase provides a `langnames.json` endpoint that supplies basic information for every language in the world, keyed to [IETF language tags][ietf].  See the [langnames.json endpoint](http://td.unfoldingword.org/exports/langnames.json).

* **tK API** - The translationKeyboard API provides access to keyboard layouts that have been defined in [translationKeyboard][tk].

* * * * *

{% include services.html %}
[ietf]: {{ '/ietf/' | prepend: site.baseurl }} "IETF Language Tags"
[tk]: {{ '/tk/' | prepend: site.baseurl }} "translationKeyboard"
