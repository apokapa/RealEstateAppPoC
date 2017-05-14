var Functions = (function FunctionsIIFE(global) {

    /**
     * @param {string} json
     * @returns {Object}
     */
    function fromJson(json) {
        try { return JSON.parse(json); }
        catch (err) { return null; }
    }

    /**
     * @param {T} prototype
     * @template T
     * @returns {T}
     */
    function createObject(prototype) {
        if ("function" === typeof prototype) return Object.create(prototype.prototype);
        else return Object.create(prototype);
    }

    /**
     * @param {T} prototype
     * @param {*} value
     * @template T
     * @returns {T}
     */
    function cast(prototype, value) {
        return value;
    }


    /**
     * @param {T} prototype
     * @param {string} json
     * @template T
     * @returns {T}
     */
    function getModel(prototype, json) {
        var object = fromJson(json);
        var type = typeof prototype;
        if (prototype === null) {
            return null;
        } else if (type === "string") {
            if (typeof object === "string") return object;
            else if (object === undefined) return undefined;
            else if (object === null) return null;
            else return json;
        }
        else if (type === "boolean") {
            return object ? true : false;
        }
        else if (type === "number") {
            if (typeof object === "number") return object;
            else return object - 0;
        }
        else if (type === "function") {
            return prototype;
        }
        else if (type === "object") {
            var constructor = prototype ? prototype.constructor : undefined;
            if (constructor === undefined) {
                return null;
            } else if (constructor === Array) {
                if (!object || object.constructor !== Array) return []; var list = [];
                for (var item of object) list.push(getModel(prototype[0], JSON.stringify(item)));
                return list;
            } else if (constructor === Date) {
                var date = new Date(object);
                if (date.valueOf() === NaN) return new Date();
                else return date;
            } else if (constructor === Object) {
                var emptyObject = {};
                if (!object) return null;
                for (var key in prototype) {
                    var objectKey = object[key];
                    var prototypeKey = prototype[key];
                    emptyObject[key] = getModel(prototypeKey, JSON.stringify(objectKey));
                }
                return emptyObject;
            }
        } else if (type === "function") {
            return null;
        } else if (type === "undefined") {
            return undefined;
        }
        return null;
    }

    /**
     * @param {string} name
     * @param {*} object
     * @returns {void}
     */
    function makeGlobal(name, object) {
        global[name] = object;
    }

    /**
     * @param {string} text
     * @returns {string}
     */
    function removeAllSpaces(text) {
        return String(text || "").replace(/ /g, remove);
        function remove() { return "_"; }
    }

    /**
     * @param {number} number
     * @param {number} decimalPoint
     */
    function round(number, decimalPoint) {
        if (decimalPoint < 0 || decimalPoint > 10) decimalPoint = 2;
        var multiply = Math.pow(10, decimalPoint);
        return Math.round(number * multiply) / multiply;
    }

    /**
     * @param {Object} object
     * @param {string} path
     * @returns {*}
     */
    function getObjectPath(object, path) {
        if (object instanceof Object) {
            var list = String(path).split(".");
            var size = list.length;
            if (size === 0) return null;
            else if (size == 1) return object[path];
            else {
                var currentObject = object; var index = 0;
                while (index < size && currentObject) currentObject = currentObject[list[index++]];
                return index === size ? currentObject : null;
            }
        }
        return null;
    }


    (function AddMissingObjectsIIFE() {
        if (typeof global["Promise"] !== "function") {
            makeGlobal("Promise", function (callBack) {
                var catchList = cast([function () { }], []);
                var thenList = cast([function () { }], []);
                this.then = function (callBack) {
                    if (typeof callBack === "function") thenList.push(callBack);
                    return this;
                };
                this.catch = function (callBack) {
                    if (typeof callBack === "function") thenList.push(callBack);
                    return this;
                };
                function resolve(result) { for (var item of thenList) item(result); }
                function reject(error) { for (var item of catchList) item(error); }
                callBack(resolve, reject);
            });
        }
    })();

    return {
        removeAllSpaces: removeAllSpaces,
        getObjectPath: getObjectPath,
        createObject: createObject,
        makeGlobal: makeGlobal,
        fromJson: fromJson,
        getModel: getModel,
        round: round,
        cast: cast
    };
})(window);