var argscheck = require('cordova/argscheck'),
    exec      = require('cordova/exec'),
    q         = require('com.alakra.cordova.mbxmapkit.q');

function MBXMapKit() {
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
