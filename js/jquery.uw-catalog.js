/**
 * This JQuery plugin provides access to the uW Catalog, and various stats.  To use,  add the following code
 * to your JQuery ready function:
 *
 * $.uwCatalog();
 *
 * Then, you can add a data-uw-catalog tag to any element, with the following values, and the text of the element
 * will be replaced witht the correct stat value:
 *
 * bible-published-languages  - The total number of unique languages that have published Bibles
 * bible-published-resources  - The total number of unique Bible resources that have been published
 * obs-in-progress-languages  - The total number of unique languages that have Open Bible Stories in progress
 * obs-published-languages    - The total number of unique languages that have published Open Bible Stories
 * obs-published-resources    - The total number of unique Open Bible Stories resources that have been published
 *
 */
(function ($) {
    $.extend({
        uwCatalog: function () {
          /**
           * Stores the cache for the unfoldingWord API Catalog
           *
           * @type {Object|Null}
           * @access private
           */
          var catalogData = null;
          /**
           * Stores the cache for the Open Bible Stories In Progess Data
           * @type {Object|Null}
           * @access private
           */
          var obsInProgressData = null;
          /**
           * The unfoldingWord API Catalog URL
           *
           * @type {String}
           * @access private
           */
          var catalogUrl = 'https://api.unfoldingword.org/uw/txt/2/catalog.json';
          /**
           * The Open Bible Stories In Progess URL
           *
           * @type {String}
           * @access private
           */
          var obsInProgressUrl = 'https://api.unfoldingword.org/obs/txt/1/obs-in-progress.json';
          /**
           * The function that is returned
           */
          var uwCatalog = {
            /**
             * Initialize the function.
             *
             * @return {Void}
             * @access public
             */
            initialize: function() {
              var self = this;
              $.when(this.getCatalog(), this.getOBSInProgress())
                .then(function() {
                  self.loadTags()
                });
            },
            /**
             * Get the catalog data from the unfoldingWord API, and store it in a cache variable.
             *
             * @return {Object} A JSON Object of the catalog data
             * @access public
             */
            getCatalog: function() {
              var deferred = $.Deferred();
              if (catalogData === null) {
                $.ajax({ url: catalogUrl, dataType: 'json' })
                .done(function(results) {
                  catalogData = results;
                  deferred.resolve(catalogData);
                })
                .fail(function() {
                  catalogData = null;
                  deferred.reject({});
                });
              } else {
                deferred.resolve(catalogData);
              }
              return deferred.promise();
            },
            /**
             * Get the in progress data for the Open Bible Stories project, and store it in a cache variable.
             *
             * @return {Object} The JSON Object with the in progress data
             * @access public
             */
            getOBSInProgress: function() {
              var deferred = $.Deferred();
              if (obsInProgressData === null) {
                $.ajax({ url: obsInProgressUrl, dataType: 'json' })
                .done(function(results) {
                  obsInProgressData = results;
                  deferred.resolve(obsInProgressData);
                })
                .fail(function() {
                  obsInProgressData = null;
                  deferred.reject({});
                });
              } else {
                deferred.resolve(obsInProgressData);
              }
              return deferred.promise();
            },
            /**
             * load any data tags that are on the page
             *
             * @return {Void}
             * @access public
             */
            loadTags: function() {
              $('[data-uw-catalog]').each(function() {
                var $element = $(this);
                var value = '0';
                switch ($element.data('uw-catalog')) {
                  case 'obs-in-progress-languages':
                    value = getInProgressOBSLanguagesCount().toString();
                    break;
                  case 'obs-published-languages':
                    value = getPublishedLanguagesCount('obs').toString();
                    break;
                  case 'obs-published-resources':
                    value = getPublishedResourcesCount('obs').toString();
                    break;
                  case 'bible-published-languages':
                    value = getPublishedLanguagesCount('bible').toString();
                    break;
                  case 'bible-published-resources':
                    value = getPublishedResourcesCount('bible').toString();
                    break;
                }
                $element.text(value);
              });
            }
          };
          /**
           * Get the total number of unique in progress Open Bible Stories languages
           *
           * @return {Number} The total number of languages
           * @access private
           */
          function getInProgressOBSLanguagesCount() {
            var languages = [];
            $.each(obsInProgressData, function(index, lang) {
              if ($.inArray(lang.lc, languages) == -1) {
                languages.push(lang.lc);
              }
            });
            return languages.length;
          };
          /**
           * Get the total number of published languages for the given slug
           * @param   {String}  slug  The slug of the resource
           * @return  {Number}  The total number of unique languages
           * @access  private
           */
          function getPublishedLanguagesCount(slug) {
            var languages = [];
            $.each(catalogData.cat, function(index, resource) {
              if (resource.slug === slug) {
                $.each(resource.langs, function(index, lang) {
                  if ($.inArray(lang.lc, languages) == -1) {
                    languages.push(lang.lc);
                  }
                });
              }
            });
            return languages.length;
          };

          /**
           * Get the total number of resources that were published under the given slug
           *
           * @param  {String} slug The slug of the resource
           * @return {Number}      The total number of unique resources
           * @access private
           */
          function getPublishedResourcesCount(slug) {
            var resources = [];
            $.each(catalogData.cat, function(index, resource) {
              if (resource.slug === slug) {
                $.each(resource.langs, function(index, lang) {
                  $.each(lang.vers, function(index, version) {
                    var id = lang.lc + '-' + version.slug;
                    if ($.inArray(id, resources) == -1) {
                      resources.push(id);
                    }
                  });
                });
              }
            });
            return resources.length;
          }

          uwCatalog.initialize();
        }
    });
})(jQuery);
