var NZapp = (function (Functions, loadingUrl) {

    var ViewInfo = {
        onFinish: function () { },
        onLoad: function () { },
        model: {}
    };

    var viewInfoList = Functions.cast([ViewInfo], []);

    var actions = {
        "nz-text": nzText,
        "nz-link": nzLink,
        "nz-src": nzSrc
    };

    /**
     * @param {HTMLElement} dom
     * @param {string} value
     * @returns {void}
     */
    function nzText(dom, value) {
        dom.innerText = value;
    }

    /**
     * @param {HTMLElement} dom
     * @param {string} value
     * @returns {void}
     */
    function nzLink(dom, value) {
        dom.setAttribute("href", value);
    }

    /**
     * @param {HTMLElement} dom
     * @param {string} value
     * @returns {void}
     */
    function nzSrc(dom, value) {
        dom.setAttribute("src", value);
    }

    /**
     * @param {HTMLElement} dom
     * @param {Object} model
     */
    function replaceText(dom, model) {
        var iterator = document.createNodeIterator(dom, NodeFilter.SHOW_TEXT);
        var regex = /[{][^}]{0,}[}]/g, node = undefined;
        while (node = iterator.nextNode()) {
            if (node.parentElement === dom) {
                node.textContent = node.textContent.replace(regex, valueReplace);
            }
        }
        /**@param {string} path
         * @returns {model} */
        function valueReplace(path) {
            path = path.substring(1, path.length - 1);
            return Functions.getObjectPath(model, path) || "";
        }
    }


    /**
     * @param {Event} event
     * @returns {void}
     */
    function activateElement(event) {
        var target = event.srcElement;
        var document = target.contentWindow.document;
        var info = viewInfoList[target.getAttribute("nz-id") - 0];
        info.onLoad();
        for (var dom of document.body.getElementsByTagName("*")) {
            for (var action in actions) {
                if (dom.hasAttribute(action)) {
                    var attr = dom.getAttribute(action); var value = null;
                    var value = Functions.getObjectPath(info.model, attr);
                    if (value !== null) actions[action](dom, value);
                }
            }
            replaceText(dom, info.model);
        }
        if (target.nextElementSibling) target.nextElementSibling.remove();
        target.style.height = (document.body.clientHeight + 5) + "px";
        target.style.width = (document.body.clientWidth + 5) + "px";
        target.style.display = "block";
        info.onFinish();
    }

    /**
     * @param {string} view
     * @param {Object} [model=]
     * @param {function(): void} [onLoad=]
     * @param {function(): void} [onFinish=]
     * @returns {string}
     */
    function createView(view, model, onLoad, onFinish) {
        var info = Functions.createObject(ViewInfo);
        info.onFinish = onFinish || function () { };
        info.onLoad = onLoad || function () { };
        info.model = model || {};
        var wrapper = document.createElement("div");
        var iFrame = document.createElement("iframe");
        iFrame.setAttribute("src", view);
        iFrame.setAttribute("nz-id", viewInfoList.push(info));
        iFrame.setAttribute("onload", "NZapp.activateElement(event)");
        iFrame.style.display = "none";
        iFrame.style.border = "none";
        var loader = document.createElement("img");
        loader.src = loadingUrl;
        loader.style.height = "20px";
        loader.style.width = "20px";
        wrapper.appendChild(iFrame);
        wrapper.appendChild(loader);
        return wrapper.outerHTML;
    }

    return {
        activateElement: activateElement,
        createView: createView
    };
})(Functions, "https://i.stack.imgur.com/kOnzy.gif");