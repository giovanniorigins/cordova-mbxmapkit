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
  CGRect frame = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y,self.webView.bounds.size.width,self.webView.bounds.size.height);
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

  self.childView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  [self.mapView setRegion:region animated:YES];
  [self.childView addSubview:self.mapView];

  [[[ self viewController ] view ] addSubview:self.childView];
}

- (void)destroy:(CDVInvokedUrlCommand*)command
{
}

- (void)show:(CDVInvokedUrlCommand*)command
{
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
}

- (void)resize:(CDVInvokedUrlCommand*)command
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
