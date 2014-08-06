#import <MapKit/MapKit.h>

@interface CDVMBXAnnotationType : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageUri;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *directory;

@property (nonatomic) BOOL isRemote;

-(void)loadImage;
@end