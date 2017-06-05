var MapController = (function (Functions, Services, MapHelper, Models, NZapp) {
    var defaultLon = 23.7300974;
    var defaultLat = 37.991087;
    var isLoading = false;
    var defaultZoom = 12;
    var canMove = true;
    var delay = 0; //1500;

    Functions.makeGlobal("initMap", function () {
        MapHelper.reset(defaultLat, defaultLon, defaultZoom);
        MapHelper.onMove(onReload);
        MapHelper.stopLoad();
        onReload(defaultLat, defaultLon, MapHelper.zoomToRange(defaultZoom));
    });

    /**
     * @param {string} res
     * @returns {void}
     */
    function onDataLoad(res) {
        setTimeout(function () {
            var model = Functions.getModel(Models.OfferList, res);
            for (var item of model) {
                var parseModel = {
                    link: "/Offer/" + "Index" + "/" + item.OfferId,
                    thumb: "data:image/jpg;base64," + item.FeaturedImage,
                    apartment: item.PropertySubCategory,
                    location: item.PropertyLocation,
                    sale: item.OfferCategory,
                    price: item.Price,
                    area: item.Area,
                    more: "More"
                };
                var text = NZapp.createView("/Content/Mapview/views/offer-view/component.html", parseModel, onNewViewLoaded, onNewViewRendered);
                MapHelper.newPin(item.PropertyLat, item.PropertyLng, item.Title, text, 250);
            }
            MapHelper.addCluster();
            MapHelper.stopLoad();
            isLoading = false;
        }, delay);
    }

    /**
     * @param {string} err
     * @returns {void}
     */
    function showBadRequest(err) {
        console.error(err);
        MapHelper.stopLoad();
        isLoading = false;
    }

    function onReload(latitude, longitude, zoom) {
        if (canMove) {
            MapHelper.clearItems();
            MapHelper.newCircle(latitude, longitude, zoom);
            if (!isLoading && canMove) {
                isLoading = true;
                MapHelper.startLoad();
                zoom = Functions.round(zoom, 0);
                latitude = Functions.round(latitude, 5);
                longitude = Functions.round(longitude, 5);
                Services.getPropertiesInRange(latitude, longitude, zoom, 0)
                    .then(onDataLoad).catch(showBadRequest);
            }
        }
        canMove = true;
    }

    function onNewViewLoaded() {
        canMove = false;
    }

    function onNewViewRendered() {
        setTimeout(function () { canMove = true; }, 500);
    }

})(Functions, Services, MapHelper, Models, NZapp);