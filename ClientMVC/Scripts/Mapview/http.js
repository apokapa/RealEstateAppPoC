var Http = (function (credentials) {

    /**
     * @param {string} url 
     * @returns {Promise<string>}
     */
    function get(url) {
        return new Promise(
            function httpPromise(resolve, reject) {
                var request = createCORSRequest("get", url);
                if (request) {
                    request.withCredentials = credentials;
                    request.setRequestHeader('Accept', 'application/json');
                    request.setRequestHeader('Content-Type', 'application/json');
                    request.onloadend = function () { onLoadEnd(request, resolve, reject); }
                    request.send();
                } else {
                    reject("CORS not supported");
                }
            }
        )
    }

    /**
     * @param {string} url 
     * @param {object} [data=]
     * @returns {Promise<string>}
     */
    function post(url, data) {
        return new Promise(
            function httpPromise(resolve, reject) {
                var request = createCORSRequest("post", url);
                if (request) {
                    request.withCredentials = credentials;
                    request.setRequestHeader('Accept', 'application/json');
                    request.setRequestHeader('Content-Type', 'application/json');
                    request.onloadend = function () { onLoadEnd(request, resolve, reject); }
                    request.send(data);
                } else {
                    reject("CORS not supported");
                }
            });
    }

    /**
     * @param {XMLHttpRequest} request 
     * @param {function(string):void} resolve 
     * @param {function(string):void} reject 
     * @returns {void}
     */
    function onLoadEnd(request, resolve, reject) {
        var status = request.status;
        var result = String(request.response);
        if (status >= 200 && status < 300) resolve(result);
        else reject(result);
    }

    /**
     * @param {string} method 
     * @param {string} url 
     * @returns {XMLHttpRequest}
     */
    function createCORSRequest(method, url) {
        var xhr = new XMLHttpRequest();
        if (xhr.withCredentials != undefined) {
            xhr.open(method, url, true);
        } else if (typeof XDomainRequest != "undefined") {
            xhr = new XDomainRequest();
            xhr.open(method, url);
        } else {
            xhr = null;
        }
        return xhr;
    }

    /**
     * @param {string} name 
     * @returns {string}
     */
    function getCookieByName(name) {
        var list = document.cookie.split("; ");
        for (var cookie of list) {
            var cookieList = cookie.split("=");
            if (cookieList[0] == name) {
                return cookieList[1];
            }
        }
        return null;
    }

    /**
     * @param {string} name
     */
    function deleteCookieByName(name) {
        document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    };

    return {
        deleteCookieByName: deleteCookieByName,
        getCookieByName: getCookieByName,
        post: post,
        get: get
    };
})(false);