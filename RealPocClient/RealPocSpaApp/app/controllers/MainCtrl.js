/**
 * INSPINIA - Responsive Admin Theme
 *
 */

/**
 * MainCtrl - controller
 */
function MainCtrl($scope, dataSrvc, $q, $translate, $stateParams, $filter, vcRecaptchaService) {


    $scope.featProperties = [];
    $scope.loadingVisible = true;
    $scope.featPropertiesVisible = false;

    var getFeatProperties = function () {

        $scope.loadingVisible = true //for a Load Panel
        $scope.featPropertiesVisible = false;

        var featPropertiesDeferred = $q.defer();
        var promisefeatProperties = featPropertiesDeferred.promise;
        featPropertiesDeferred.resolve(dataSrvc.getFeatProperties());
        $q.all({
            featProperties: promisefeatProperties
        })
        .then(function (results) {
            $scope.featProperties = results.featProperties;
            console.log('featProperties:', results.featProperties);
        })
        .finally(function () {

            $scope.featPropertiesVisible = true
            $scope.loadingVisible = false //for Load Panel
        });
    };

    getFeatProperties();


 


    


}
angular
    .module('realpoc')
    .controller('MainCtrl', MainCtrl)