var Services = (function (Http, url) {

    /**
     * @param {number} latitude 
     * @param {number} longitude 
     * @param {number} range 
     * @param {number} zoom
     * @returns {Promise<string>}
     */
    function getPropertiesInRange(latitude, longitude, range, zoom) {
        return Http.post(url + "getPropertyOffersByRange", JSON.stringify({
            "lat": latitude,
            "lng": longitude,
            "range": range,
            "zoom": zoom
        }));
    }

    return {
        getPropertiesInRange: getPropertiesInRange
    };
})(Http, "http://realpocapi.azurewebsites.net/api/");