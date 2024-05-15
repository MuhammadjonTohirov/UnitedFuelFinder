#import <Foundation/Foundation.h>

#import "TMGLGeometry.h"
#import "TMGLLight.h"
#import "TMGLOfflinePack.h"
#import "TMGLTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Methods for round-tripping values for Mapbox-defined types.
 */
@interface NSValue (TMGLAdditions)

#pragma mark Working with Geographic Coordinate Values

/**
 Creates a new value object containing the specified Core Location geographic
 coordinate structure.

 @param coordinate The value for the new object.
 @return A new value object that contains the geographic coordinate information.
 */
+ (instancetype)valueWithTMGLCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 The Core Location geographic coordinate structure representation of the value.
 */
@property (readonly) CLLocationCoordinate2D TMGLCoordinateValue;

/**
 Creates a new value object containing the specified Mapbox map point structure.

 @param point The value for the new object.
 @return A new value object that contains the coordinate and zoom level information.
 */
+ (instancetype)valueWithTMGLMapPoint:(TMGLMapPoint)point;

/**
 The Mapbox map point structure representation of the value.
 */
@property (readonly) TMGLMapPoint TMGLMapPointValue;

/**
 Creates a new value object containing the specified Mapbox coordinate span
 structure.

 @param span The value for the new object.
 @return A new value object that contains the coordinate span information.
 */
+ (instancetype)valueWithTMGLCoordinateSpan:(TMGLCoordinateSpan)span;

/**
 The Mapbox coordinate span structure representation of the value.
 */
@property (readonly) TMGLCoordinateSpan TMGLCoordinateSpanValue;

/**
 Creates a new value object containing the specified Mapbox coordinate bounds
 structure.

 @param bounds The value for the new object.
 @return A new value object that contains the coordinate bounds information.
 */
+ (instancetype)valueWithTMGLCoordinateBounds:(TMGLCoordinateBounds)bounds;

/**
 The Mapbox coordinate bounds structure representation of the value.
 */
@property (readonly) TMGLCoordinateBounds TMGLCoordinateBoundsValue;

/**
 Creates a new value object containing the specified Mapbox coordinate 
 quad structure.

 @param quad The value for the new object.
 @return A new value object that contains the coordinate quad information.
 */
+ (instancetype)valueWithTMGLCoordinateQuad:(TMGLCoordinateQuad)quad;

/**
 The Mapbox coordinate quad structure representation of the value.
 */
- (TMGLCoordinateQuad)TMGLCoordinateQuadValue;

#pragma mark Working with Offline Map Values

/**
 Creates a new value object containing the given `TMGLOfflinePackProgress`
 structure.

 @param progress The value for the new object.
 @return A new value object that contains the offline pack progress information.
 */
+ (NSValue *)valueWithTMGLOfflinePackProgress:(TMGLOfflinePackProgress)progress;

/**
 The `TMGLOfflinePackProgress` structure representation of the value.
 */
@property (readonly) TMGLOfflinePackProgress TMGLOfflinePackProgressValue;

#pragma mark Working with Transition Values

/**
 Creates a new value object containing the given `TMGLTransition`
 structure.
 
 @param transition The value for the new object.
 @return A new value object that contains the transition information.
 */
+ (NSValue *)valueWithTMGLTransition:(TMGLTransition)transition;

/**
 The `TMGLTransition` structure representation of the value.
 */
@property (readonly) TMGLTransition TMGLTransitionValue;

/**
 Creates a new value object containing the given `TMGLSphericalPosition`
 structure.
 
 @param lightPosition The value for the new object.
 @return A new value object that contains the light position information.
 */
+ (instancetype)valueWithTMGLSphericalPosition:(TMGLSphericalPosition)lightPosition;

/**
 The `TMGLSphericalPosition` structure representation of the value.
 */
@property (readonly) TMGLSphericalPosition TMGLSphericalPositionValue;

/**
 Creates a new value object containing the given `TMGLLightAnchor`
 enum.
 
 @param lightAnchor The value for the new object.
 @return A new value object that contains the light anchor information.
 */
+ (NSValue *)valueWithTMGLLightAnchor:(TMGLLightAnchor)lightAnchor;

/**
 The `TMGLLightAnchor` enum representation of the value.
 */
@property (readonly) TMGLLightAnchor TMGLLightAnchorValue;

@end

NS_ASSUME_NONNULL_END
