cordova-mbxmapkit
=================

An Apache Cordova plugin for MapBox's MBXMapKit (for iOS only)

### Requirements

**NOTE: This plugin is designed to run a single instance of a native map.**

* Apache Cordova (3.5+)
* iOS (7.1+)

### Dependencies

* MapKit.framework
* libsqlite3.dylib
* [MBXMapKit](https://github.com/mapbox/mbxmapkit) (vendored)

# Installation

Run this from the root directory of your cordova project to install the plugin:

    cordova plugin add com.alakra.cordova.mbxmapkit

After installing into your project, you can access all functionality
through the global `mbxmapkit` object.

# Quickstart

```javascript
var width = 640;
var height = 480;
var x = width / 2;
var y = height / 2;

mbxmapkit.create();
mbxmapkit.setSize( width, height );
mbxmapkit.setCenter( x, y )
mbxmapkit.show();
```

**NOTE**: This library only intends to serve a single map. Calling
  `create` subsequent times will have no effect after the first call.

## Using online mapbox tile layer

## Using mapbox markers annotations

## Using custom annotations

## Utilizing performance caching

## Utilizing offline mode support

## Using Apple maps only

## Falling back on web-based maps

# Events

# API

# Support & Bugs

# Contributing

# Credits

### Authors

* Angelo Lakra <angelo.lakra@gmail.com>

# License

`cordova-mbxmapkit` and `q` are licensed under the MIT license and are
copyrighted to their respective authors.  However, the code for
`mbxmapkit` has it's own license that is described in [LICENSE](LICENSE).
