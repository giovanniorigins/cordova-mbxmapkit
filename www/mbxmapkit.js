var argscheck = require('cordova/argscheck'),
    exec      = require('cordova/exec'),
    q         = require('com.alakra.cordova.mbxmapkit.q');

function MBXMapKit() {
  this.events = {
    'mapRegionWillChange'           : null,
    'mapRegionChanged'              : null,
    'mapWillStartLoading'           : null,
    'mapFinishedLoading'            : null,
    'mapFailedToLoad'               : null,
    'mapWillStartRendering'         : null,
    'mapFinishedRendering'          : null,
    'mapWillStartLocatingUser'      : null,
    'mapStoppedLocatingUser'        : null,
    'mapUpdatedUserLocation'        : null,
    'mapFailedToLocateUser'         : null,
    'mapChangedUserTrackingMode'    : null,
    'mapRequestedAnnotation'        : null,
    'mapAddedAnnotations'           : null,
    'mapAnnotationCalloutTapped'    : null,
    'mapChangedAnnotationDragState' : null,
    'mapAnnotationSelected'         : null,
    'mapAnnotationDeselected'       : null,
    'mapOverlayRequested'           : null,
    'mapAddedOverlays'              : null
  };

  // Store all events for later firing
  for (var key in this.events) {
    if (this.events.hasOwnProperty(key)) {
      this.events[key] = new CustomEvent(key, { map: {} });
    }
  }
};

MBXMapKit.prototype = {
  create: function() {
    this._callNative('create', [], 'Failed to create native map view.');
  },

  destroy: function() {
    this._callNative('destroy', [], 'Failed to destroy native map view.');
  },

  show: function() {
    this._callNative('show', [], 'Failed to show native map view.');
  },

  hide: function() {
    this._callNative('hide', [], 'Failed to hide native map view.');
  },

  setMapId: function(id) {
    this._callNative('setMapId', [id], 'Failed to set the map id.');
  },

  getMapId: function() {
    return this._callNativeAndReturnPromise('getMapId', [], 'Failed to retrieve the map id.');
  },

  getCenter: function() {
    return this._callNativeAndReturnPromise('getCenter', [], 'Failed to retrieve origin coordinate of native map view.');
  },

  setCenter: function(x, y) {
    this._callNative('setCenter', [x, y], 'Failed to move native map view.');
  },

  getSize: function() {
    return this._callNativeAndReturnPromise('getSize', [], 'Failed to retrieve size of native map view.');
  },

  setSize: function(width, height) {
    this._callNative('setSize', [width, height], 'Failed to resize native map view.');
  },

  changeType: function(mapType) {
    this._callNative('changeType', [mapType], 'Failed to change the type of native map view.');
  },

  /*
   * @see https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/occ/instp/NSString/boolValue
   */
  registerAnnotationType: function(title, options) {
    var isRemote = (options.remote) ? 'Y' : 'N';
    var params = [title, options.image_uri, isRemote, options.directory];
    return this._callNativeAndReturnPromise('registerAnnotationType', params, 'Failed to register a new annotation type.');
  },

  addAnnotation: function(options) {
    var title     = options.title;
    var latitude  = options.coordinates.latitude;
    var longitude = options.coordinates.longitude;
    var type      = options.type || '';

    // Generating ID for annotation
    var id = (title + latitude + longitude + type)
          .trim()
          .replace(/([A-Z])/g, '-$1')
          .replace(/[-_\s]+/g, '-')
          .toLowerCase();

    var params = [title, latitude, longitude, type, id];

    return this._callNativeAndReturnPromise('addAnnotation', params, 'Failed to add annotation.');
  },

  removeAnnotation: function(id) {
    return this._callNativeAndReturnPromise('removeAnnotation', [id], 'Failed to remove annotation.');
  },

  removeAllAnnotations: function() {
    return this._callNativeAndReturnPromise('removeAllAnnotations', [], 'Failed to remove all annotations.');
  },

  _callNative: function(method, args, errorMsg) {
    exec(function(params) { return null; },
         function(error)  { console.error(errorMsg); },
         "MBXMapKit", method, args);
  },

  _callNativeAndReturnPromise: function(method, args, errorMsg) {
    var deferred = q.defer();

    exec(
      function(params) { deferred.resolve(params); },
      function(error)  {
        console.error(errorMsg);
        deferred.reject(error);
      },

      "MBXMapKit", method, args
    );

    return deferred.promise;
  }
};


module.exports = new MBXMapKit();
