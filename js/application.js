/**
 * Store sitewide Javascript in this file
 */
var langProgressUrl = 'https://door43.org/{0}/obs';
/**
 * Extend Javascript with some helpers
 */
/**
 * Adds a .format() method to string that replaces string params
 * @example "{0} {1}".format("Fruit", "Cake") = "Fruit Cake"
 *
 * @return {String} A formatted string
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
String.prototype.format = function() {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{'+i+'\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};
/**
 * Setup the Available translations
 *
 * @param  {Array} stories An array of available translations JSON objects (This is a backup if we cannot get the API)
 * ex. {"language":"am","string":"አማርኛ","status": {"version":"3.3.1","checking_level":"3"}}
 *
 * @return {null}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setupAvailableTranslations(stories) {
  /**
   * Try to get the list of story languages from api.unfoldingword.org. If not successful, use the saved list.
   */
  $.getJSON('https://api.unfoldingword.org/obs/txt/1/obs-catalog.json')
    .done(function(data) {
      setStoryList(data);
    })
    .fail(function() {
      setStoryList(stories);
    });
}
/**
 * Setup the in progress OBS stories
 *
 * @param  {Array} languages An array of languages that are in progress JSON Object (This is a backup if we cannot get the API)
 * ex. {"lc": "aaa", "ln": "Ghotuo"}
 *
 * @return {null}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setupInProgressTranslations(languages) {
  /**
   * Try to get the list of story languages from api.unfoldingword.org. If not successful, use the saved list.
   */
  $.getJSON('https://api.unfoldingword.org/obs/txt/1/obs-in-progress.json')
    .done(function(data) {
      setInProgressList(data);
    })
    .fail(function() {
      setInProgressList(languages);
    });
}
/**
 * Setup the in progress list for OBS stories in progress
 *
 * @param  {Array} languages An array of JSON objects representing each language in progress
 * ex. {"lc": "aaa", "ln": "Ghotuo"}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setInProgressList(languages) {
  var cleanedLanguages = cleanLanguages(languages);
  // sort by language code
  cleanedLanguages.sort(function(a, b) {
    return a.lc === b.lc ? 0 : +(a.lc > b.lc) || -1;
  });

  var chunkedLanguages = arrayToChuncks(cleanedLanguages, 3);
  var template = $('#obs-in-progress-template');

  // Issue #100, 13 OCT 2015, Phil Hopper: check for valid data
  var reCheckLanguageCode = /^[a-z]{2}/;  // all language codes start with at least 2 lower-case characters

  for (var i = 0; i < chunkedLanguages.length; i++) {
    var langs = chunkedLanguages[i];
    var elementNumber = i+1;
    var ul = $('ul#obs-in-progress-list-' + elementNumber);
    for (var l = 0; l < langs.length; l++) {
      var langCode = langs[l].lc;

      // Issue #100, 13 OCT 2015, Phil Hopper: check for valid data
      if (!reCheckLanguageCode.test(langCode)) {
        continue;
      }

      var li = $(template.html());

      var span = li.find('span[data-span-type="langString"]');
      span.attr('lang', langCode).html(langs[l].ln);

      var link = li.find('a[data-link-type="langLink"]');
      link.attr('href', langProgressUrl.format(langCode));

      // language code
      li.find('span[data-span-type="langLanguage"]').html(langCode);

      ul.append(li);
    }
  }
}
/**
 * Setup the story list for OBS translations
 *
 * @param  {Array} stories An array of story objects
 * ex. {"language":"am","string":"አማርኛ","status": {"version":"3.3.1","checking_level":"3"}}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setStoryList(stories) {

  // sort by language code
  stories.sort(function(a, b) {
    return a.language === b.language ? 0 : +(a.language > b.language) || -1;
  });

  // get the template for story items
  var body = $('body');
  var ul = body.find('#story-languages');
  var template = body.find('#obs-language-template');

  for (var i=0; i<stories.length; i++) {

    var langCode = stories[i].language;

    // create a new li
    var li = $(template.html());

    // language name
    var span = li.find('span[data-span-type="langString"]');
    span.attr('lang', langCode);
    span.html(stories[i].string);

    // language code
    li.find('span[data-span-type="langLanguage"]').html(langCode);

    // link URLs
    var links = li.find('a.img_swap');
    links[0].href = 'https://api.unfoldingword.org/obs/txt/1/' + langCode + '/slides/360px/01/';
    links[1].href = 'https://api.unfoldingword.org/obs/txt/1/' + langCode + '/slides/2160px/01/';
    links[2].href = 'https://api.unfoldingword.org/obs/txt/1/' + langCode + '/obs-' + langCode + '-v' + stories[i].status.version.replace(/\./g, '_') + '.pdf';
    // links[3].href = 'https://api.unfoldingword.org/obs/txt/1/' + langCode + '/obs-' + langCode + '-' + stories[i].status.publish_date + '.docx';
    // links[4].href = 'https://api.unfoldingword.org/obs/txt/1/' + langCode + '/obs-' + langCode + '-' + stories[i].status.publish_date + '.odt';

    // checking level
    li.addClass('checking-level-' + stories[i].status.checking_level);

    ul.append(li);
  }
}
/**
 * Remove any data that is not a language (The feed sends a date_modified in the same array)
 *
 * @param  {Array} languages The languages array to clean
 *
 * @return {Array}           A cleaned array
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function cleanLanguages(languages) {
  var cleaned = [];

  for (var i = 0; i < languages.length; i++) {
    if ('lc' in languages[i]) {
      cleaned.push(languages[i]);
    }
  }
  return cleaned;
}
/**
 * Break an array (data) into n (total) number of arrays
 *
 * @param  {Array}    data  The array to break up
 * @param  {int}  total How many arrays you want back
 *
 * @return {Array}          An array of all the seperate arrays
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function arrayToChuncks(data, total) {
  var final = [];
  var size = Math.ceil(data.length/total);
  while (data.length > 0) {
    final.push(data.splice(0, size));
  }
  return final;
}

/**
 * Gets the translation academy json from the api endpoint
 */
function getTranslationAcademy() {

  // get the tA text from the tD endpoint
  $.getJSON('http://td-demo.unfoldingword.org/publishing/ta-en.json')
      .done(function(data) {
        buildTranslationAcademy(data);
      })
      .fail(function(jqXHR) {

        // remove the Loading message
        $('#loading-h3').text('');

        // let the user know there was an error
        var msg = 'Not able to load translationAcademy';
        var code = jqXHR['status'];

        // a CORS error will not return a status, and the statusText will just be 'error'
        if (code) {
          msg += ': ' + code + ', ' + jqXHR['statusText'];
        }
        alert(msg);

        // log the response for debugging
        console.log(jqXHR);
      });
}

/**
 * Uses the translation academy data to build the tA page
 *
 * @param {object} data
 */
function buildTranslationAcademy(data) {

  // remove the Loading message
  $('#loading-h3').text('');

  var pagesDiv = $('#ta-pages-div');
  var chapters = data['chapters'];
  var sections = {};

  // first section is the TOC, which we don't need, so start at index 1
  for (var i = 1; i < chapters.length; i++) {
    for (var j = 0; j < chapters[i]['frames'].length; j++) {

      // add the text to the page
      var currentPage = $('<div class="bs-docs-section"></div>');
      currentPage.html(chapters[i]['frames'][j]['text']);
      pagesDiv.append(currentPage);

      // get the section info for the TOC
      var ref = chapters[i]['ref'].split('/');
      var section_name = ref[ref.length - 2];
      if (!sections[section_name]) {
        sections[section_name] = [];
      }

      // add the page id to the list for the TOC
      sections[section_name].push([chapters[i]['frames'][j]['id'], chapters[i]['title']]);
    }
  }

  // now build the TOC
  var tocUl = $('#ta-toc-ul');

  // remember any existing items
  var existing = tocUl.html();
  tocUl.html('');

  for (var key in sections) {

    if (sections.hasOwnProperty(key)) {

      // build the section heading
      var currentSection = $('<li><a href="#' + sections[key][0][0] + '">' + getSectionTitle(key) + '</a></li>');
      var subItems = $('<ul class="nav"><ul></ul>');

      // add the sub-items
      for (var k = 0; k < sections[key].length; k++) {
        console.log(sections[key][k]);
        subItems.append($('<li><a href="#' + sections[key][k][0] + '">' + sections[key][k][1] + '</a></li>'));
      }

      currentSection.append(subItems);
      tocUl.append(currentSection);
    }
  }

  // now add existing items back in
  if (existing) {
    tocUl.append($(existing));
  }

}

/**
 * Get the title to display for th given key
 * @param {string} key
 */
function getSectionTitle(key) {

  switch (key.substr(0, 4)) {
    case 'intr':
      return 'Introduction';

    case 'tran':
      return 'Translation';

    case 'chec':
      return 'Checking';

    case 'tech':
      return 'Technology';

    case 'proc':
      return 'Process';

    default:
      return 'None';
  }
}