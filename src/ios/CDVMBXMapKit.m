#import "CDVMBXMapKit.h"


@interface CDVMBXMapKit () { }

@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;
@property (nonatomic) NSString *onlineMapId;

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

- (void)setMapId:(CDVInvokedUrlCommand*)command
{
  _onlineMapId = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
  if ([_onlineMapId length] != 0) { [self addOnlineMapLayer:_onlineMapId]; }
}

- (void)getMapId:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:_onlineMapId];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getSize:(CDVInvokedUrlCommand*)command
{
  NSDictionary* params = @{ @"width" : [NSNumber numberWithFloat:self.childView.frame.size.width],
                            @"height" : [NSNumber numberWithFloat: self.childView.frame.size.height] };

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setSize:(CDVInvokedUrlCommand*)command
{
  NSInteger width  = [[command.arguments objectAtIndex:0] floatValue];
  NSInteger height = [[command.arguments objectAtIndex:1] floatValue];

  CGRect frame = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y, width, height);

  self.childView.frame = frame;
}

- (void)getCenter:(CDVInvokedUrlCommand*)command
{
  NSDictionary* params = @{ @"x" : [NSNumber numberWithFloat: self.childView.center.x],
                            @"y" : [NSNumber numberWithFloat: self.childView.center.y] };

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setCenter:(CDVInvokedUrlCommand*)command
{
  NSInteger x = [[command.arguments objectAtIndex:0] floatValue];
  NSInteger y = [[command.arguments objectAtIndex:1] floatValue];

  self.childView.center = CGPointMake(x, y);
}

#pragma mark - Helper Methods

- (void)addOnlineMapLayer:(NSString *)mapId
{
  // remove old overlay if it exists
  if (_rasterOverlay != nil) {
    [self.mapView removeOverlay:_rasterOverlay];
  }

  // add new overlay
  _rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:mapId];
  _rasterOverlay.delegate = self;
  [self.mapView addOverlay:_rasterOverlay];
}


#pragma mark - MKMapViewDelegate protocol implementation

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  // This is boilerplate code to connect tile overlay layers with suitable renderers
  //
  if ([overlay isKindOfClass:[MBXRasterTileOverlay class]]) {
    MKTileOverlayRenderer *renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    return renderer;
  }

  return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  // This is boilerplate code to connect annotations with suitable views
  //
  if ([annotation isKindOfClass:[MBXPointAnnotation class]]) {
    static NSString *MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];

    if (!view) {
      view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
    }

    view.image = ((MBXPointAnnotation *)annotation).image;
    view.canShowCallout = YES;
    return view;
  }

  return nil;
}

#pragma mark - MBXRasterTileOverlayDelegate implementation

- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMetadata:(NSDictionary *)metadata withError:(NSError *)error
{
  // This delegate callback is for centering the map once the map metadata has been loaded
  //
  if (error) {
    NSLog(@"Failed to load metadata for map ID %@ - (%@)", overlay.mapID, error?error:@"");
  } else {
    [self.mapView mbx_setCenterCoordinate:overlay.center zoomLevel:overlay.centerZoom animated:NO];
  }
}


- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMarkers:(NSArray *)markers withError:(NSError *)error
{
  // This delegate callback is for adding map markers to an MKMapView once all the markers for the tile overlay have loaded
  //
  if (error) {
    NSLog(@"Failed to load markers for map ID %@ - (%@)", overlay.mapID, error?error:@"");
  }
  else {
    [self.mapView addAnnotations:markers];
  }
}

- (void)tileOverlayDidFinishLoadingMetadataAndMarkers:(MBXRasterTileOverlay *)overlay
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
