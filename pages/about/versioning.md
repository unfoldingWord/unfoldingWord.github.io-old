---
layout: default
title: Version Numbers in unfoldingWord
permalink: /versioning/index.html
---


![Versioning]({{ '/assets/img/versioning.jpg' | prepend: site.baseurl }})

*Starting August 1, 2015, unfoldingWord will begin using a new,
simpler, more consistent versioning system to help identify each
resource we publish. This versioning system will be used for all
resources that are published in the unfoldingWord catalogue which in
turn populates the unfoldingWord mobile app. The version number consists
of one or more digits separated by periods.*


Source Language
---------------

The first digit will always indicate the source version. Let's take Open
Bible Stories as an example. Since the Open Bible Stories started in
English, there is only one digit in the version number for the English
OBS:

**OBS (en) version 4**

If the English OBS gets republished for whatever reason, the new version
number will never add a period plus a new number, the same number will
increase:

**OBS version 4 → OBS version 5** *(Not version 4.1)*


Translation of Source Language
------------------------------

For any translation of a source text, the version number of the source
will remain the same, then a period and a new digit will be used to
distinguish the translation. That digit will always begin at 1. For
instance, if English OBS version 4 is translated into Arabic:

**OBS (en) version 4 → OBS (ar) version 4.1** *(Not version 5, Not
version 4.0, Not version 4.2)*

If a translation is republished for whatever reason (including checking
to a new level), the digit(s) corresponding to the source text remain
the same, only the digit referring to the translation increases. In this
case, the first digit (4, referring to the English version it was
translated from) remains the same. The second digit (1, referring to the
revision of the Arabic translation) increases by one.

**OBS (ar) version 4.1 → OBS (ar) version 4.2** *(Not version 5, Not
version 4.1.1, Not version 4.3)*


Updating a Version
------------------

If a translation (or source) is updated, all the “downstream” versions
are able to see at a glance that one of their source texts has been
updated.

In our example above, if English OBS version 4 is updated to version 5,
any of the downstream languages (Arabic at version 4.2 or Sudanese Arabic
at 4.2.1) will immediately be able to see that
English is now at version 5 and all of their translations are based on
the English version 4 of OBS and its subsequent translations.

To update their version, Arabic would first have to update their text to
match the English OBS version 5.

**OBS (en) version 5 → OBS (ar) version 5.1**

*Note: The digit corresponding to Arabic (the second digit) does not
keep increasing (e.g. NOT version 4.2 → version 5.3) but rather
“re-sets” when an “upstream” version is updated (e.g. (ar) version 4.2 →
(ar) version 5.1).*

In this example, Sudanese Arabic would need to update their translation
to match the Arabic:

**OBS (ar) version 5.1 → OBS (apd) 5.1.1**


Conclusion
----------

On August 1, everything published in the unfoldingWord
catalogue will be republished using the new versioning system. This change will include changing of version numbers and a few updates to some images. It will not require any change in content downstream.

For example in August:

**OBS (en) version 3.2.1 → OBS (en) version 4**

**OBS (pt-BR) version 3.2.3 → OBS (pt-BR) version 4.1** (since it was
translated from the latest English version)

**OBS (ru) version 3.3.1 → OBS (ru) version 4.1** (since it was
translated from the latest English version)

<br />

* * * * *

<br />

Technical Details
-----------------

**PUBLISHED RESOURCES - VERSIONS**

1.  All resources published by unfoldingWord follow these
    guidelines.

2.  All published resources must have a version number. 

3.  Any changes to a published resource results in a new version
    number.

    -  The only possible exception are typographical errors that will
        not affect the meaning (e.g. punctuation, misspellings). Typos
        that inadvertently change the meaning should be included in a
        new version (e.g. "sin on more" instead of "sin no more")

4.  Version numbers increase numerically. 


**DRAFTED RESOURCES - REVISIONS**

1.  Resources that are in a state of flux (e.g. being created, revised,
    or checked) may be given a revision number to facilitate
    communication. 

2.  Revision numbers are full integers and follow the version
    number (e.g. ver 2 → rev 3, OR ver 3.3.1 → rev 4). 

3.  Once a resource is published, all revisions must be removed as all
    of the revisions are now incorporated in the new version number
    (e.g. when ver 12 rev 3 is published → ver 13). 

4.  If revisions are needed on the re-published version, the revision
    numbering restarts at 1 (e.g. when ver 2 rev 3 is published →
    ver 3, the first revision is ver 3 rev 1 (not ver 3 rev 4)). 


**SOURCE LANGUAGE**

1.  All version numbers are based on the source language. 

    -  A notable exception is the Bible, where the source language
        becomes the language translated from the Greek & Hebrew. The
        original autographs are stagnant and adding a level to the
        version number corresponding to these originals only stands to
        increase the complexity of the versioning system while adding
        very little benefit. (e.g. the English ULB → ver 1 or ver 8,
        not ver 1.1 nor ver 1.8)

2.  The version of the source language must be a non-negative integer
    and should not have a decimal (e.g. ver 13, NOT ver 13.0)

3.  Upon the first publishing, the version number must be greater than
    zero. (e.g. ver 1)

    -  Conversely, if desired an unpublished draft may be considered
        ver 0 rev 1 → ver 0 rev 2, etc. 


**TRANSLATIONS**

1.  All translations must keep the version number of the resource it was
    translated from and add a decimal to that version 

    -  e.g. English OBS ver 4 is translated into Swahili. The Swahili
        translation becomes ver 4.1. If the Swahili translation becomes
        the source text for a Datooga translation, the Datooga
        translation becomes ver 4.1.1

    -  e.g. Van Dyke version was created in Arabic, thus the Arabic
        would be ver 1. An English translation would become ver 1.1. 

2.  If a resource is updated, the updated resource must update its
    version number, all "downstream" translations must not change their
    version number until their translation is updated to reflect the
    changes made to the "upstream" resources. 

    -  e.g. In the example above, if the English OBS is updated to ver
        5, the Swahili remains ver 4.1 and the Datooga remains 4.1.1.
        Swahili becomes ver 5.1 only when it has updated its text to
        match English ver 5. And Datooga will only become ver 5.1.1
        after it updates its text to match the Swahili ver 5.1. 

    -  e.g. If after updating its text to ver 5.1 the Swahili
        translators realize that it needs still further revision, then
        the new published version would become 5.2. If the Datooga
        updated their translation to match the Swahili ver 5.2, then
        their translation would be version 5.2.1. 


**RECOMMENDATIONS**

1.  It is strongly recommended that change logs be kept between each
    publishing to ensure ease of update for all "downstream" languages.

2.  It is recommended that large resources be divided into smaller
    sections that each have its own version (e.g. each book of the Bible
    instead of one version for the whole Bible).


**BENEFITS**

1.  This system allows for easy identification of needed update (if an
    "upstream" language has a higher version, then the text needs to be
    updated). 

2.  This system shows how far "downstream" a translation is from the
    source text (the more decimals, the farther away).

3.  This system begins to show the linguistic "genealogy". 

4.  This system should be simple enough for anyone to understand. 

**DRAWBACKS**

1.  This system assumes only one primary source language. 

2.  All minor changes require a complete version change (which runs
    contrary to normal versioning methodology). 


