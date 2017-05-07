(function(){
	
    var dataSrvc = function ($http) {

	    var domain = "http://realpocapi.azurewebsites.net"
	    //var domain = "http://localhost:60694"



		var getFeatProperties = function () {
	    return $http.get(domain + "/api/propertyOffers")
		.then(function (response) {
		    return response.data;
		});
	};



	return{	
	    getFeatProperties: getFeatProperties
	};
	};
	
	
	var module = angular.module("realpoc");
	module.factory("dataSrvc", dataSrvc);
	
}());