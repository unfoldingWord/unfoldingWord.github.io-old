/**
 * The path for the checking image
 *
 * @type {String}
 */
var checkingLevelIcon = '{0}/assets/img/uW-Level{1}-16px.png';
/**
 * The Door43 Page URL for each language
 *
 * @type {String}
 */
var door43Url = 'https://door43.org/{0}/obs';
/**
 * The url for obs resources on the language page
 *
 * @type {String}
 */
var languagePageUrl = '{0}/{1}#obs-resources';
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
 * Set the base URL for the site
 *
 * @param  {String} baseUrl The URL to set it to
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setBaseUrl(baseUrl) {
  /**
   * Temporarily use my local domain
   *
   * @author Johnathan Pulos <johnathan@missionaldigerati.org>
   */
  if (window.location.host === 'uw.mainsite.local') {
    siteBaseUrl = 'http://uw.mainsite.local';
  } else {
    siteBaseUrl = baseUrl;
  }
};
/**
 * Remove any data that is not a language (The feed for in progress translations sends a date_modified in the same array)
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
 * Array.sort function for sorting by the given language code
 *
 * @param  {Object} a The first JSON object to compare
 * @param  {Object} b The second object to 
 *
 * @return {Integer}  The order to sort in
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function sortByLanguageCode(a, b) {
  return a.language_code === b.language_code ? 0 : +(a.language_code > b.language_code) || -1;
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
  var retrievedTranslations = [];
  $('input#search-language').keyup(function() {
    filterResults($(this).val());
  }); 
  $('.search-link').click(function(event) {
    $('html, body').animate({
        scrollTop: ($('#search-container').offset().top - 55)
    }, 1200);
    event.preventDefault();
    return false;
  });
  /**
   * Add click event to all language boxes
   *
   * @author Johnathan Pulos <johnathan@missionaldigerati.org>
   */
  $('body').on('click', '.single-translation', function(event) {
    event.preventDefault();
    var url = $(this).attr('data-target-url');
    window.location.href = url;
  });
  /**
   * We need to get results from both urls
   */
  $.getJSON('https://api.unfoldingword.org/obs/txt/1/obs-catalog.json')
    .done(function(translations) {
      $.each(translations, function(index, translation) {
        var data = {
          'language_code':      translation.language,
          'language_direction': translation.direction,
          'language_text':      translation.string,
          'status':             'available',
          'checking_level':     translation.status.checking_level
        };
        retrievedTranslations.push(data);
      });
      $.getJSON('https://api.unfoldingword.org/obs/txt/1/obs-in-progress.json')
        .done(function(translations) {
          cleanedTranslations = cleanLanguages(translations);
          $.each(cleanedTranslations, function(index, translation) {
            var data = {
              'language_code':      translation.lc,
              'language_direction': '',
              'language_text':      translation.ln,
              'status':             'in-progress',
              'checking_level':     ''
            };
            retrievedTranslations.push(data);
          });
          // sort by language code
          retrievedTranslations.sort(sortByLanguageCode);
          currentTranslations = retrievedTranslations;
          displayTranslations(currentTranslations);
        })
        .fail(function() {
          currentTranslations = fallbackData;
          displayTranslations(currentTranslations);
        });
      
    })
    .fail(function() {
      currentTranslations = fallbackData;
      displayTranslations(currentTranslations);
    });
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
  var translationElement = null;
  for (var i = 0; i < translations.length; i++) {
    var translation = translations[i];
    if (translation.checking_level === '') {
      translationElement = createInProgressTranslationBox(templateWithOutChecking, translation);
    } else {
      translationElement = createAvailableTranslationBox(templateWithChecking, translation);
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
    if (i && ((i % 3 === 2) || (i === translations.length - 1))) {
      /**
       * Every third element or the very last element
       */
      translationParentElement.append($('<div/>').addClass('clearfix'));
    }
    resultsElement.append(translationParentElement);
    translationElement = null;
  }
  resultsElement.append($('<div/>').addClass('clearfix'));
};

/**
 * Create the translation box for an available translation
 *
 * @param  {Object} template    The JQuery Object of the template
 * @param  {Object} translation The JSON object of the translation
 *
 * @return {Object}             The final translation box JQuery object
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function createAvailableTranslationBox(template, translation) {
  var translationElement = $(template.html());
  translationElement.attr('data-target-url', languagePageUrl.format(siteBaseUrl, translation.language_code));
  var languageDetails = '<p>' + translation.language_code + '</p>';
  languageDetails += '<p class="' + translation.status + '-translation language-text">';
  languageDetails += translation.language_text;
  var checkingImagePath = checkingLevelIcon.format(siteBaseUrl, translation.checking_level);
  var checkingDetails = '<div class="checking-level-' + translation.checking_level + '"><img src="' + checkingImagePath + '" alt="checking level"></div>';
  
  translationElement.find('.language-details').append(languageDetails);
  translationElement.find('.checking-and-download').append(checkingDetails);

  return translationElement;
};
/**
 * Create the translation box for an in progress translation
 *
 * @param  {Object} template    The JQuery Object of the template
 * @param  {Object} translation The JSON object of the translation
 *
 * @return {Object}             The final translation box JQuery object
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function createInProgressTranslationBox(template, translation) {
  var translationElement = $(template.html());
  translationElement.attr('data-target-url', door43Url.format(translation.language_code));
  var languageDetails = '<p>' + translation.language_code + '</p>';
  languageDetails += '<p class="' + translation.status + '-translation language-text">' + translation.language_text + '</p>';
  
  translationElement.find('.language-details').append(languageDetails);
  
  return translationElement;
};
