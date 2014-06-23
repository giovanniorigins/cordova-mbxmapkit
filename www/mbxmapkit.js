var argscheck = require('cordova/argscheck'),
    exec      = require('cordova/exec');

function MBXMapKit() {
  this.view = null;

  this.annotations = [];
  this.layers = [];
};

MBXMapKit.prototype = {
  this.create  = function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to create native map view."); },
         "CDVMBXMapKit", "create", []);
  };

  this.destroy = function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to destroy native map view."); },
         "CDVMBXMapKit", "destroy", []);
  };

  this.show    = function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to show native map view."); },
         "CDVMBXMapKit", "show", []);
  };

  this.hide    = function() {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to hide native map view."); },
         "CDVMBXMapKit", "hide", []);
  };

  this.move    = function(movementType, x, y) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to move native map view."); },
         "CDVMBXMapKit", "move", [movementType, x, y]);
  };

  this.resize  = function(width, height) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to resize native map view."); },
         "CDVMBXMapKit", "resize", [width, height]);
  };

  this.changeType = function(mapType) {
    exec(function(params) { return null; },
         function(error)  { console.error("Failed to change the type of native map view."); },
         "CDVMBXMapKit", "changeType", [mapType]);
  };

  this.addAnnotation = function() {};
  this.removeAnnotation = function() {};
};


module.exports = new MBXMapKit();
