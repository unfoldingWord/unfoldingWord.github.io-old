---
layout: default
title: IETF Language Tags
permalink: /ietf/index.html
---

Languages in the unfoldingWord digital publishing system are identified using **Internet Engineering Task Force (IETF) language tags**. IETF tags provide an abbreviated language code that uses  modern computing standards and is backward compatible with ISO 639 language codes but provides a standardized means of identifying additional information, including language variants and scripts.

In the IETF standard, macro languages are identified using two-letter codes (from ISO 639-1) while all other languages use the three-letter "Ethnologue code" (ISO 639-3) where this code exists. The language tags are comprised of subtags separated by hyphens. The IETF standard also provides a flexible means of adding new language variants, through the use of "-x" to indicate a private use tag (not in the official registry).

These are examples of language tags:

  -  `hi`: Hindi language
  -  `en-AU`: English language, as written and spoken in Australia
  -  `az-Latn-IR`: Azeri language, written in the Latin script, as used in Iran
  -  `ttt-x-ismai`: Tat language, Ismaili variant (not yet in official registry)

IETF language tags are used in many protocols, including **HTTP** (the browser can indicate the user's language preference to the server, the server can indicate to the browser the language and script in which the content is served) and **XML** (through the xml:lang attribute).

**Resources:**

  -  The [IETF Wikipedia article][ietf-wp].
  -  The [registry][ietf-registry] of existing language tags.
  -  A utility to [look up tags][ietf-utility].
  -  [Additional information][langtag].
  

[ietf-registry]: http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
[ietf-utility]: http://r12a.github.io/apps/subtags/
[ietf-wp]: https://en.wikipedia.org/wiki/IETF_language_tag
[langtag]: http://www.langtag.net/