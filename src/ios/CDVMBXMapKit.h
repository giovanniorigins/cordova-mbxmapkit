#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <Cordova/CDVPlugin.h>

@interface CDVMBXMapKit : CDVPlugin <MKMapViewDelegate> {
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

- (void)changeType:(CDVInvokedUrlCommand*)command;

- (void)addAnnotation:(CDVInvokedUrlCommand*)command;
- (void)removeAnnotation:(CDVInvokedUrlCommand*)command;
@end
