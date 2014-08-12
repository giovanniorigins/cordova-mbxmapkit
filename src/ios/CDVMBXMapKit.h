#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MBXMapKit.h"
#import "CDVMBXAnnotation.h"
#import "CDVMBXAnnotationType.h"
#import "CDVMBXAnnotationView.h"

#import <Cordova/CDVPlugin.h>

@interface CDVMBXMapKit : CDVPlugin <MKMapViewDelegate, MBXRasterTileOverlayDelegate>

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
- (void)addAnnotation:(CDVInvokedUrlCommand*)command;
- (void)removeAnnotation:(CDVInvokedUrlCommand*)command;
- (void)removeAllAnnotations:(CDVInvokedUrlCommand*)command;
- (void)setCenterCoordinate:(CDVInvokedUrlCommand*)command;
- (void)setRegion:(CDVInvokedUrlCommand*)command;
- (void)getRegion:(CDVInvokedUrlCommand*)command;

@end
