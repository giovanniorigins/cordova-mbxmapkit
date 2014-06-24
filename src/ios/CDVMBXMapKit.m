#import "CDVMBXMapKit.h"


@interface CDVMBXMapKit () { }
@end

@implementation CDVMBXMapKit

- (void)pluginInitialize
{
  // Nothing yet
}

- (void)create:(CDVInvokedUrlCommand*)command
{
  if (self.mapView != nil) { return; }

  CGRect frame = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y, self.webView.bounds.size.width, self.webView.bounds.size.height);
  self.childView = [[UIView alloc] initWithFrame:frame];

  self.mapView                       = [[MKMapView alloc] initWithFrame:self.childView.bounds];
  self.mapView.delegate              = self;
  self.mapView.mapType               = MKMapTypeStandard;
  self.mapView.zoomEnabled           = YES;
  self.mapView.rotateEnabled         = NO;
  self.mapView.scrollEnabled         = YES;
  self.mapView.pitchEnabled          = NO;
  self.mapView.showsPointsOfInterest = NO;
  self.mapView.autoresizingMask      = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  self.childView.autoresizingMask    = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.childView.contentMode         = UIViewContentModeRedraw;

  [self.childView addSubview:self.mapView];
}

- (void)destroy:(CDVInvokedUrlCommand*)command
{
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView removeOverlays:self.mapView.overlays];

  self.mapView = nil;
}

- (void)show:(CDVInvokedUrlCommand*)command
{
  [[[ self viewController ] view ] addSubview:self.childView];
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
  [self.childView removeFromSuperview];
}

- (void)size:(CDVInvokedUrlCommand*)command
{
  NSDictionary* params = @{ @"width" : [NSNumber numberWithFloat:self.childView.frame.size.width],
                            @"height" : [NSNumber numberWithFloat: self.childView.frame.size.height] };

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)resize:(CDVInvokedUrlCommand*)command
{
  NSInteger width  = [[command.arguments objectAtIndex:0] floatValue];
  NSInteger height = [[command.arguments objectAtIndex:1] floatValue];

  CGRect frame = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y, width, height);

  self.childView.frame = frame;
}

- (void)position:(CDVInvokedUrlCommand*)command
{
}

- (void)move:(CDVInvokedUrlCommand*)command
{
}

- (void)changeType:(CDVInvokedUrlCommand*)command
{
}

- (void)addAnnotation:(CDVInvokedUrlCommand*)command
{
}

- (void)removeAnnotation:(CDVInvokedUrlCommand*)command
{
}

@end
