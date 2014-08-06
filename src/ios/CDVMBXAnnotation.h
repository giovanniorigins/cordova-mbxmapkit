#import <MapKit/MapKit.h>
#import "CDVMBXAnnotationType.h"

@interface CDVMBXAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CDVMBXAnnotationType *type;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *identifier;

- (void)setIdentifier:(NSString *)identifier;
- (void)setType:(CDVMBXAnnotationType *)type;
- (void)setTitle:(NSString *)title;
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;
@end