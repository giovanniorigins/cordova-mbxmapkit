var argscheck = require('cordova/argscheck'),
    exec      = require('cordova/exec'),
    q         = require('./q.min');

function MBXMapKit() {
  this.view = null;

  this.annotations = [];
  this.layers = [];
};

MBXMapKit.prototype = {
  create: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to create native map view."); },
         "MBXMapKit", "create", []);
  },

  destroy: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to destroy native map view."); },
         "MBXMapKit", "destroy", []);
  },

  show: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to show native map view."); },
         "MBXMapKit", "show", []);
  },

  hide: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to hide native map view."); },
         "MBXMapKit", "hide", []);
  },

  move: function(movementType, x, y) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to move native map view."); },
         "MBXMapKit", "move", [movementType, x, y]);
  },

  size: function() {
    var deferred = q.defer();

    return exec(
      function(params) {
        deferred.resolve(params);
      },

      function(error)  {
        console.error("Failed to retrieve size of native map view.");
        deferred.reject(error);
      },

      "MBXMapKit", "size", []
    );

    return deferred.promise;
  },

  resize: function(width, height) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to resize native map view."); },
         "MBXMapKit", "resize", [width, height]);
  },

  changeType: function(mapType) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to change the type of native map view."); },
         "MBXMapKit", "changeType", [mapType]);
  },

  addAnnotation: function() {},
  removeAnnotation: function() {}
};


module.exports = new MBXMapKit();
