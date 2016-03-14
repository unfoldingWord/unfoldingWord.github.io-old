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
var languagePageUrl = '{0}/{1}/?resource=open-bible-stories';
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
 * A list of Right to Left Languages
 *
 * @type {Array}
 */
var rtlLanguages = ['ar', 'arc', 'dv', 'ha', 'he', 'khw', 'ks', 'ku', 'ps', 'ur', 'yi'];
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
  siteBaseUrl = baseUrl;
}
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
}
/**
 * Array.sort function for sorting by the given language code
 *
 * @param  {Object} a The first JSON object to compare
 * @param  {Object} b The second object to
 *
 * @return {int}  The order to sort in
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function sortByLanguageCode(a, b) {
  return a.language_code === b.language_code ? 0 : +(a.language_code > b.language_code) || -1;
}
//noinspection JSUnusedGlobalSymbols
/**
 * Setup the accordions
 *
 * @return {null}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function setupAccordion() {
  $('.accordion').accordion({'transitionSpeed': 400});
  var $body = $('body');
  $body.on('accordion.open', function() {
    $(this).find('i.fa-toggle').removeClass('fa-caret-right').addClass('fa-caret-down');
  });
  $body.on('accordion.close', function() {
    $(this).find('i.fa-toggle').removeClass('fa-caret-down').addClass('fa-caret-right');
  });
  /**
   * Check the hash, open it
   */
  var resource = getURLParameter('resource');
  if (resource) {
    $('.'+resource+'-accordion .control').trigger('click');
    if ($('#'+resource).length > 0) {
      $('html, body').animate({
          scrollTop: ($('#'+resource).offset().top - 70)
      }, 1200);
    }
  }
  /**
   * Handle clicking inside nav
   */
  $('.open-accordion').click(function() {
    var hash = $(this).attr('href').substring(1);
    var accordion = $('.'+hash+'-accordion');
    /**
     * Is it open?
     */
    if (accordion.find('.accordion-content').css('max-height') == '0px') {
      accordion.find('.control').trigger('click');
    }
  });
}
/**
 * Setup the search for translations
 *
 * @param  {Array} fallbackData An array of JSON Objects of translated data to be used if we cannot access the API data
 *
 * @return {null}
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
    }, 1200, 'swing', function() {
      $('input#search-language').focus();
    });
    event.preventDefault();
    return false;
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
          var cleanedTranslations = cleanLanguages(translations);
          $.each(cleanedTranslations, function(index, translation) {
            var data = {
              'language_code':      translation.lc,
              'language_direction': 'ltr',
              'language_text':      translation.ln,
              'status':             'in-progress',
              'checking_level':     ''
            };
            if($.inArray(translation.lc, rtlLanguages) !== -1) {
              data['language_direction'] = 'rtl';
            }
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
}
/**
 * Iterate over translations and filter the results
 *
 * @var {String} The term to filter by
 * @return {null}
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
}
/**
 * Display the given translations
 *
 * @return {null}
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
}
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
  var languageDetails = '<p>' + translation.language_code + '</p>';
  languageDetails += '<p class="' + translation.status + '-translation language-text" lang="' + translation.language_code + '" dir="' + translation.language_direction + '">';
  languageDetails += translation.language_text;
  var checkingImagePath = checkingLevelIcon.format(siteBaseUrl, translation.checking_level);
  var checkingDetails = '<div class="checking-level-' + translation.checking_level + '"><img src="' + checkingImagePath + '" alt="checking level"></div>';

  translationElement.find('.language-details').append(languageDetails);
  translationElement.find('.checking-and-download').append(checkingDetails);
  translationElement.find('a.translation-link').attr('href', languagePageUrl.format(siteBaseUrl, translation.language_code));

  return translationElement;
}
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
  var languageDetails = '<p>' + translation.language_code + '</p>';
  languageDetails += '<p class="' + translation.status + '-translation language-text" lang="' + translation.language_code + '" dir="' + translation.language_direction + '">' + translation.language_text + '</p>';

  translationElement.find('.language-details').append(languageDetails);
  translationElement.find('a.translation-link').attr('href', door43Url.format(translation.language_code));

  return translationElement;
}
/**
 * Get the parameter from the string
 *
 * @param  {String} requested The parameter to grab
 *
 * @return {String}           The value
 * @{@link  http://www.jquerybyexample.net/2012/06/get-url-parameters-using-jquery.html}
 *
 * @author Johnathan Pulos <johnathan@missionaldigerati.org>
 */
function getURLParameter (requested) {
  var pageURL = window.location.search.substring(1);
  var urlParams = pageURL.split('&');
  for (var i = 0; i < urlParams.length; i++) {
    var parameterName = urlParams[i].split('=');
    if (parameterName[0] == requested) {
      return parameterName[1];
    }
  }
}
/**
 * Setup global javascript
 */
$(document).ready(function() {
  $('.scroll-to').click(function(event) {
    var link = $(this).attr('href');
    $('html, body').animate({
        scrollTop: ($(link).offset().top - 70)
    }, 1200);
    event.preventDefault();
    return false;
  });
  /**
   * Handle the sidebar nav
   */
  $('#sidebar-nav').affix({
    offset: {
      top: 680
    }
  });

  /* activate scrollspy menu */
  var $body   = $(document.body);
  var navHeight = $('.navbar').outerHeight(true);

  $body.scrollspy({ target: '#right-col', offset: navHeight});

    /* smooth scrolling sections */
    $("ul#sidebar-nav li a[href^='#']").on('click', function(e) {

      // prevent default anchor click behavior
      e.preventDefault();

      // store hash
      var hash = this.hash;

      // animate
      $('html, body').animate({
      scrollTop: $(hash).offset().top - 50
      }, 300, function(){

      // when done, add hash to url
      // (default click behaviour)
      window.location.hash = hash;
    });

  });
});
