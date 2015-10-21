/**
 * Store sitewide Javascript in this file
 * 
 * @type {String}
 */
var langProgressUrl = 'https://door43.org/{0}/obs';
/**
 * The path for the checking image
 *
 * @type {String}
 */
var checkingLevelIcon = '{0}/assets/img/uW-Level{1}-16px.png';
/**
 * The base url for the site
 *
 * @type {String}
 */
var siteBaseUrl = '';
/**
 * An array of the current translations
 *
 * @type {Array}
 */
var currentTranslations = [];
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
 * Break an array (data) into n (total) number of arrays
 *
 * @param  {Array}    data  The array to break up
 * @param  {Integer}  total How many arrays you want back
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
};
/**
 * Set the base URL for the site
 *
 * @param  {String} baseUrl The URL to set it to
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setBaseUrl(baseUrl) {
  siteBaseUrl = baseUrl;
};
/**
 * Setup the search for translations
 *
 * @param  {Array} fallbackData An array of JSON Objects of translated data to be used if we cannot access the API data
 *
 * @return {void}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setupSearchTranslations(fallbackData) {
  currentTranslations = fallbackData;
  $('input#search-language').keyup(function() {
    filterResults($(this).val());
  });
  displayTranslations(fallbackData);
};
/**
 * Iterate over translations and filter the results
 *
 * @var {String} The term to filter by
 * @return {void}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function filterResults(filter) {
  var filterRegEx = new RegExp(filter, "i");
  var newResults = [];
  $.each(currentTranslations, function(index, translation) {
    /**
     * Filter out bad results
     */
    if ((translation.language_code.search(filterRegEx) < 0) && (translation.language_text.search(filterRegEx) < 0)) {
      /**
       * Do not add to results
       */
    } else {
      /**
       * Add to results
       */
      newResults.push(translation);
    }
  });
  displayTranslations(newResults);
};
/**
 * Display the given translations
 *
 * @param  {Array} translations An array of JSON Objects of translated data
 *
 * @return {void}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function displayTranslations(translations) {
  var resultsElement = $('#search-results');
  resultsElement.removeClass('loading').html('');
  var templateWithChecking = $('#obs-translation-with-checking-template');
  var templateWithOutChecking = $('#obs-translation-wo-checking-template');
  var translationParentElement = null;
  for (var i = 0; i < translations.length; i++) {
    var translation = translations[i];
    var languageDetails = '<p>' + translation.language_code + '</p>';
    languageDetails += '<p class="' + translation.status + '-translation language-text">' + translation.language_text + '</p>';
    if (translation.checking_level === '') {
      translationElement = $(templateWithOutChecking.html());
    } else {
      translationElement = $(templateWithChecking.html());
    }
    translationElement.find('.language-details').append(languageDetails);
    if (translation.checking_level !== '') {
      var checkingImagePath = checkingLevelIcon.format(siteBaseUrl, translation.checking_level);
      var checkingDetails = '<div class="checking-level-' + translation.checking_level + '"><img src="' + checkingImagePath + '" alt="checking level"></div>';
      checkingDetails += '<div class="download available-translation"><i class="fa fa-download"></i></div>';
      translationElement.find('.checking-and-download').append(checkingDetails);
    }
    if (i && (i % 3 === 2)) {
      /**
       * Every third element
       */
      translationElement.addClass('last');
    } else if(i % 3 === 0) {
      /**
       * Every first element
       */
      translationElement.addClass('first');
      translationParentElement = null;
      translationParentElement = $('<div/>').addClass('row translations-box');
    }
    translationParentElement.append(translationElement);
    if (i && (i % 3 === 2)) {
      /**
       * Every third element
       */
      translationParentElement.append($('<div/>').addClass('clearfix'));
    }
    resultsElement.append(translationParentElement);
    translationElement = null;
  }
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
};
