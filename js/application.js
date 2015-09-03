/**
 * Store sitewide Javascript in this file
 */

/**
 * Setup the Available translations
 *
 * @param  {Array} stories An array of available translations (This is a backup if we cannot get the API)
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
 * Setup the story ist for OBS translations
 *
 * @param  {Array} stories An array of story objects
 *
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

    // checking level
    li.addClass('checking-level-' + stories[i].status.checking_level);

    ul.append(li);
  }
};
