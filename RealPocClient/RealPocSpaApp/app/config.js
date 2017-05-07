
function config($stateProvider, $urlRouterProvider ) {
    $urlRouterProvider.otherwise("/index/main");

  

    $stateProvider

        .state('index', {
            abstract: true,
            url: "/index",
            templateUrl: "app/views/common/content.html",
            controller: 'MainCtrl'
        })
        .state('index.main', {
            url: "/main",
            templateUrl: "app/views/main.html",
            controller: 'MainCtrl',
            data: { pageTitle: 'Real Poc' }
        })
        .state('index.results', {
            url: "/searchresults",
            templateUrl: "app/views/searchresults.html",
            controller: 'MainCtrl',
            data: { pageTitle: 'Search Results' }
        });

        

}
angular
    .module('realpoc')
    .config(config)
    .run(function($rootScope, $state) {
        $rootScope.$state = $state;
    });
