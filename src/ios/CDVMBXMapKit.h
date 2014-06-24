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

- (void)size:(CDVInvokedUrlCommand*)command;
- (void)resize:(CDVInvokedUrlCommand*)command;
- (void)position:(CDVInvokedUrlCommand*)command;
- (void)move:(CDVInvokedUrlCommand*)command;

- (void)changeType:(CDVInvokedUrlCommand*)command;

- (void)addAnnotation:(CDVInvokedUrlCommand*)command;
- (void)removeAnnotation:(CDVInvokedUrlCommand*)command;
@end
