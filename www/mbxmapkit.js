var argscheck = require('cordova/argscheck'),
    exec      = require('cordova/exec');

function MBXMapKit() {
  this.view = null;

  this.annotations = [];
  this.layers = [];
};

MBXMapKit.prototype = {
  create: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to create native map view."); },
         "CDVMBXMapKit", "create", []);
  },

  destroy: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to destroy native map view."); },
         "CDVMBXMapKit", "destroy", []);
  },

  show: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to show native map view."); },
         "CDVMBXMapKit", "show", []);
  },

  hide: function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to hide native map view."); },
         "CDVMBXMapKit", "hide", []);
  },

  move: function(movementType, x, y) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to move native map view."); },
         "CDVMBXMapKit", "move", [movementType, x, y]);
  },

  resize: function(width, height) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to resize native map view."); },
         "CDVMBXMapKit", "resize", [width, height]);
  },

  changeType: function(mapType) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to change the type of native map view."); },
         "CDVMBXMapKit", "changeType", [mapType]);
  },

  addAnnotation: function() {},
  removeAnnotation: function() {}
};


module.exports = new MBXMapKit();
