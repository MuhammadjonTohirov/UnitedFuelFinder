#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#import "TMGLFoundation.h"
#import "TMGLStyleValue.h"
#import "TMGLStyleLayer.h"
#import "TMGLGeometry.h"

NS_ASSUME_NONNULL_BEGIN

@class TMGLMapView;
@class TMGLStyle;

typedef struct TMGLStyleLayerDrawingContext {
    CGSize size;
    CLLocationCoordinate2D centerCoordinate;
    double zoomLevel;
    CLLocationDirection direction;
    CGFloat pitch;
    CGFloat fieldOfView;
    TMGLMatrix4 projectionMatrix;
} TMGLStyleLayerDrawingContext;

TMGL_EXPORT
@interface TMGLOpenGLStyleLayer : TMGLStyleLayer

@property (nonatomic, weak, readonly) TMGLStyle *style;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#if TARGET_OS_IPHONE
@property (nonatomic, readonly) EAGLContext *context;
#else
@property (nonatomic, readonly) CGLContextObj context;
#endif
#pragma clang diagnostic pop

- (instancetype)initWithIdentifier:(NSString *)identifier;

- (void)didMoveToMapView:(TMGLMapView *)mapView;

- (void)willMoveFromMapView:(TMGLMapView *)mapView;

- (void)drawInMapView:(TMGLMapView *)mapView withContext:(TMGLStyleLayerDrawingContext)context;

- (void)setNeedsDisplay;

@end

NS_ASSUME_NONNULL_END
