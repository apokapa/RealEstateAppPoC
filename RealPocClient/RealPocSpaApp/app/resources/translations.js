/**
 * INSPINIA - Responsive Admin Theme
 *
 */
function config($translateProvider) {

    $translateProvider
        .translations('en', {

            // Define all menu elements



        })
        .translations('gr', {

            // Define all menu elements
 


        });

    $translateProvider.preferredLanguage('en');

}

angular    .module('realpoc')    .config(config);
