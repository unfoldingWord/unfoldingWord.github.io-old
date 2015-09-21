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
 * @return {Void}
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
};
/**
 * Setup the in progress OBS stories
 *
 * @param  {Array} languages An array of languages that are in progress JSON Object (This is a backup if we cannot get the API)
 * ex. {"lc": "aaa", "ln": "Ghotuo"}
 *
 * @return {Void}
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
};
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

  for (var i = 0; i < chunkedLanguages.length; i++) {
    var languages = chunkedLanguages[i];
    var elementNumber = i+1;
    var ul = $('ul#obs-in-progress-list-' + elementNumber);
    for (var l = 0; l < languages.length; l++) {
      var langCode = languages[l].lc;
      var li = $(template.html());

      var span = li.find('span[data-span-type="langString"]');
      span.attr('lang', langCode).html(languages[l].ln);

      var link = li.find('a[data-link-type="langLink"]');
      link.attr('href', langProgressUrl.format(langCode));

      // language code
      li.find('span[data-span-type="langLanguage"]').html(langCode)

      ul.append(li);
    }
  }
};
/**
 * Setup the story ist for OBS translations
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
