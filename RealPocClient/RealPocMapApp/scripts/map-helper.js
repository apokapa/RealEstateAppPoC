var MapHelper = (function (mapElement, pinPath) {
    var clusterStyles = [
        {
            url: 'images/cluster-1.png',
            textColor: 'white',
            textSize: 16,
            height: 52,
            width: 52
        }, {
            url: 'images/cluster-2.png',
            textColor: 'white',
            textSize: 17,
            height: 55,
            width: 56
        }, {
            url: 'images/cluster-3.png',
            textColor: 'white',
            textSize: 18,
            height: 65,
            width: 66
        }, {
            url: 'images/cluster-4.png',
            textColor: 'white',
            textSize: 19,
            height: 89,
            width: 90
        }, {
            url: 'images/cluster-5.png',
            textColor: 'white',
            textSize: 20,
            height: 77,
            width: 78
        },
    ];
    var infowindowList = [];
    var clusterList = [];
    var map = undefined;
    var circleList = [];
    var pinList = [];

    /**
     * @param {number} latitude 
     * @param {number} longitude 
     * @param {object} map 
     * @param {string} [title=]
     * @param {string} [text=]
     * @param {number} [width=]
     * @returns {void}
     */
    function newPin(latitude, longitude, title, text, width) {
        var position = {
            lat: latitude,
            lng: longitude
        };
        var pin = new google.maps.Marker({
            title: title || undefined,
            position: position,
            icon: pinPath,
            map: map
        });
        pinList.push(pin);
        if (typeof text === "string") {
            var infowindow = new google.maps.InfoWindow({
                maxWidth: (isNaN(width) ? 200 : width) + 20,
                content: text
            });
            pin.addListener("click", function () {
                infowindow.open(map, pin);
            });
            infowindowList.push(infowindow);
        }
    }

    /**
     * @param {number} latitude 
     * @param {number} longitude 
     * @param {number} radius 
     * @returns {void}
     */
    function newCircle(latitude, longitude, radius) {
        var position = {
            lat: latitude,
            lng: longitude
        };
        var circle = new google.maps.Circle({
            strokeColor: '#CCCCCC',
            fillColor: '#CCCCCC',
            strokeOpacity: 0.8,
            fillOpacity: 0.35,
            center: position,
            strokeWeight: 2,
            radius: radius,
            map: map
        });
        circleList.push(circle);
    }

    /**
     * @param {number} latitude 
     * @param {number} longitude 
     * @param {number} zoom
     * @returns {void}
     */
    function reset(latitude, longitude, zoom) {
        var old = google.maps.InfoWindow.prototype.open;
        google.maps.InfoWindow.prototype.open = function (a, b) {
            for (var item of infowindowList) item.close();
            old.call(this, a, b);
        }
        var position = {
            lat: latitude,
            lng: longitude
        };
        map = new google.maps.Map(mapElement, {
            center: position,
            zoom: zoom
        });
        var loader = document.createElement("div");
        loader.innerText = "Loading ...";
        mapElement.appendChild(loader);
        loader.className = "loader";
    }

    /**
     * @param {function(number, number, number): void} callBack
     * @returns {void}
     */
    function onMove(callBack) {
        map.addListener('idle', function () {
            if (typeof callBack === "function") {
                var now = Date.now();
                callBack(map.center.lat(), map.center.lng(), zoomToRange(map.zoom));
            }
        });
    }

    /**
     * @param {number} zoom
     * @returns {number}
     */
    function zoomToRange(zoom) {
        var gradZoom = Math.pow(2, 22 - zoom);
        var width = mapElement.clientWidth;
        var ratio = 0.0145;
        return width * ratio * gradZoom;
    }

    /**
     * @returns {void}
     */
    function clearItems() {
        for (var item of pinList) item.setMap(null); pinList = [];
        for (var item of clusterList) item.clearMarkers(); clusterList = [];
        for (var item of circleList) item.setMap(null); circleList = [];
        infowindowList = [];
    }

    /**
     * @returns {void}
     */
    function startLoad() {
        mapElement.classList.add("loading");
    }

    /**
     * @returns {void}
     */
    function stopLoad() {
        mapElement.classList.remove("loading");
    }

    /**
     * @returns {void}
     */
    function addCluster() {
        var cluster = new MarkerClusterer(map, pinList, { styles: clusterStyles });
        clusterList.push(cluster);
    }

    return {
        zoomToRange: zoomToRange,
        addCluster: addCluster,
        clearItems: clearItems,
        newCircle: newCircle,
        startLoad: startLoad,
        stopLoad: stopLoad,
        onMove: onMove,
        newPin: newPin,
        reset: reset
    };
})(document.getElementById("map"), "images/pin.png");