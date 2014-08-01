#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBXMapKit.h"

#import <Cordova/CDVPlugin.h>

@interface CDVMBXMapKit : CDVPlugin <MKMapViewDelegate, MBXRasterTileOverlayDelegate> {
}

@property (strong, nonatomic) UIView *childView;
@property (strong, nonatomic) MKMapView *mapView;

- (void)create:(CDVInvokedUrlCommand*)command;
- (void)destroy:(CDVInvokedUrlCommand*)command;

- (void)show:(CDVInvokedUrlCommand*)command;
- (void)hide:(CDVInvokedUrlCommand*)command;

- (void)getSize:(CDVInvokedUrlCommand*)command;
- (void)setSize:(CDVInvokedUrlCommand*)command;
- (void)getCenter:(CDVInvokedUrlCommand*)command;
- (void)setCenter:(CDVInvokedUrlCommand*)command;
- (void)getMapId:(CDVInvokedUrlCommand*)command;
- (void)setMapId:(CDVInvokedUrlCommand*)command;

@end
