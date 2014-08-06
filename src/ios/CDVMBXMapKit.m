#import "CDVMBXMapKit.h"


@interface CDVMBXMapKit () { }

@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;
@property (nonatomic) NSString *onlineMapId;
@property (nonatomic) int annotationIdCount;
@property (nonatomic) NSMutableDictionary *annotations;
@property (nonatomic) NSMutableDictionary *annotationTypes;

@end

@implementation CDVMBXMapKit

- (void)pluginInitialize
{
  self.annotations     = [NSMutableDictionary new];
  self.annotationTypes = [NSMutableDictionary new];
  self.annotationIdCount = 0;
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
  [self.mapView removeAnnotations:[self.annotations allValues]];
  [self.annotations removeAllObjects];
  [self.mapView removeOverlays:self.mapView.overlays];
  [self.annotationTypes removeAllObjects];

  self.mapView = nil;

  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Destroyed the map."];
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

- (void)registerAnnotationType:(CDVInvokedUrlCommand*)command
{
  NSString* name      = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
  NSString* uri       = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:1]];
  BOOL isRemote       = [[command.arguments objectAtIndex:2] boolValue];
  NSString* directory = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:3]];

  CDVMBXAnnotationType* type = [CDVMBXAnnotationType new];
  [type setName:name];
  [type setImageUri:uri];
  [type setIsRemote:isRemote];
  [type setDirectory:directory];

  [type loadImage];

  [self.annotationTypes setObject:type forKey:name];

  NSDictionary* params = @{@"name":name, @"uri":uri};
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addAnnotation:(CDVInvokedUrlCommand*)command
{
  NSString* title = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];

  CLLocationDegrees latitude  = [[command.arguments objectAtIndex:1] doubleValue];
  CLLocationDegrees longitude = [[command.arguments objectAtIndex:2] doubleValue];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

  NSString* type  = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:3]];
  CDVMBXAnnotationType* annotationType = [self.annotationTypes objectForKey:type];

  NSString* identifier = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:4]];

  CDVPluginResult* pluginResult;
  CDVMBXAnnotation* annotation = [CDVMBXAnnotation new];

  if (annotationType) {
    [annotation setType:annotationType];
  }

  [annotation setIdentifier:identifier];
  [annotation setTitle:title];
  [annotation setCoordinate:coordinate];

  [self.mapView addAnnotation:annotation];
  [self.annotations setObject:annotation forKey:identifier];

  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:identifier];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)removeAnnotation:(CDVInvokedUrlCommand*)command
{
  NSString* identifier = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:0]];
  [self.mapView removeAnnotation:[self.annotations objectForKey:identifier]];
  [self.annotations removeObjectForKey:identifier];
}

- (void)removeAllAnnotations:(CDVInvokedUrlCommand*)command
{
  [self.mapView removeAnnotations:[self.annotations allValues]];
  [self.annotations removeAllObjects];

  [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Removed all annotations."];
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

- (NSString *)generateAnnotationId
{
  self.annotationIdCount = self.annotationIdCount + 1;
  return [NSString stringWithFormat:@"%d", self.annotationIdCount];
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
  if ([annotation isKindOfClass:[MBXPointAnnotation class]]) {
    static NSString *MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];

    if (!view) {
      view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
    }

    view.image = ((MBXPointAnnotation *)annotation).image;
    view.canShowCallout = YES;
    return view;

  } else if ([annotation isKindOfClass:[CDVMBXAnnotation class]] && ((CDVMBXAnnotation *)annotation).type) {
    CDVMBXAnnotationType *annotationType = ((CDVMBXAnnotation *)annotation).type;
    CDVMBXAnnotationView *view = [[CDVMBXAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationType.name];
    view.image = annotationType.image;
    return view;
  } else {
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return view;
  }
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
