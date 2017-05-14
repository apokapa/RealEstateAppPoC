var Models = (function (Functions) {

    /**
     * @typedef {Object} OfferDto
     * @prop {string} PropertySubCategory
     * @prop {string} PropertyCategory
     * @prop {string} PropertyLocation
     * @prop {string} FeaturedImage
     * @prop {string} OfferCategory
     * @prop {string} Geolocation
     * @prop {number} PropertyLat
     * @prop {number} PropertyLng
     * @prop {number} OfferId
     * @prop {string} Title
     * @prop {number} Price
     * @prop {number} Area
     */

    /**
     * @typedef {Object} Models
     * @prop {Array<OfferDto>} OfferList
     * @prop {OfferDto} Offer
     */

    /** @type {OfferDto} */
    var OfferDto = {
        PropertySubCategory: "",
        PropertyCategory: "",
        PropertyLocation: "",
        OfferCategory: "",
        FeaturedImage: "",
        Geolocation: "",
        PropertyLat: 0,
        PropertyLng: 0,
        OfferId: 0,
        Title: "",
        Price: 0,
        Area: 0
    };

    /** @type {Models} */
    var Models = {
        OfferList: [Functions.createObject(OfferDto)],
        Offer: Functions.createObject(OfferDto)
    };

    return Models;
})(Functions);