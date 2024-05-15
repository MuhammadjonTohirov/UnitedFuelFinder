#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "TMGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/** Defines the area spanned by an `TMGLCoordinateBounds`. */
typedef struct __attribute__((objc_boxable)) TMGLCoordinateSpan {
    /** Latitudes spanned by an `TMGLCoordinateBounds`. */
    CLLocationDegrees latitudeDelta;
    /** Longitudes spanned by an `TMGLCoordinateBounds`. */
    CLLocationDegrees longitudeDelta;
} TMGLCoordinateSpan;

/* Defines a point on the map in Mercator projection for a specific zoom level. */
typedef struct __attribute__((objc_boxable)) TMGLMapPoint {
    /** X coordinate representing a longitude in Mercator projection. */
    CGFloat x;
    /** Y coordinate representing  a latitide in Mercator projection. */
    CGFloat y;
    /** Zoom level at which the X and Y coordinates are valid. */
    CGFloat zoomLevel;
} TMGLMapPoint;

/* Defines a 4x4 matrix. */
typedef struct TMGLMatrix4 {
    double m00, m01, m02, m03;
    double m10, m11, m12, m13;
    double m20, m21, m22, m23;
    double m30, m31, m32, m33;
} TMGLMatrix4;

/**
 Creates a new `TMGLCoordinateSpan` from the given latitudinal and longitudinal
 deltas.
 */
NS_INLINE TMGLCoordinateSpan TMGLCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta) {
    TMGLCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

/**
 Creates a new `TMGLMapPoint` from the given X and Y coordinates, and zoom level.
 */
NS_INLINE TMGLMapPoint TMGLMapPointMake(CGFloat x, CGFloat y, CGFloat zoomLevel) {
    TMGLMapPoint point;
    point.x = x;
    point.y = y;
    point.zoomLevel = zoomLevel;
    return point;
}

/**
 Returns `YES` if the two coordinate spans represent the same latitudinal change
 and the same longitudinal change.
 */
NS_INLINE BOOL TMGLCoordinateSpanEqualToCoordinateSpan(TMGLCoordinateSpan span1, TMGLCoordinateSpan span2) {
    return (span1.latitudeDelta == span2.latitudeDelta &&
            span1.longitudeDelta == span2.longitudeDelta);
}

/** An area of zero width and zero height. */
FOUNDATION_EXTERN TMGL_EXPORT const TMGLCoordinateSpan TMGLCoordinateSpanZero;

/** A rectangular area as measured on a two-dimensional map projection. */
typedef struct __attribute__((objc_boxable)) TMGLCoordinateBounds {
    /** Coordinate at the southwest corner. */
    CLLocationCoordinate2D sw;
    /** Coordinate at the northeast corner. */
    CLLocationCoordinate2D ne;
} TMGLCoordinateBounds;

/** 
 A quadrilateral area as measured on a two-dimensional map projection.
 `TMGLCoordinateQuad` differs from `TMGLCoordinateBounds` in that it allows
 representation of non-axis aligned bounds and non-rectangular quadrilaterals.
 The coordinates are described in counter clockwise order from top left.
 */
typedef struct TMGLCoordinateQuad {
    /** Coordinate at the top left corner. */
    CLLocationCoordinate2D topLeft;
    /** Coordinate at the bottom left corner. */
    CLLocationCoordinate2D bottomLeft;
    /** Coordinate at the bottom right corner. */
    CLLocationCoordinate2D bottomRight;
    /** Coordinate at the top right corner. */
    CLLocationCoordinate2D topRight;
} TMGLCoordinateQuad;


/**
 Creates a new `TMGLCoordinateBounds` structure from the given southwest and
 northeast coordinates.
 */
NS_INLINE TMGLCoordinateBounds TMGLCoordinateBoundsMake(CLLocationCoordinate2D sw, CLLocationCoordinate2D ne) {
    TMGLCoordinateBounds bounds;
    bounds.sw = sw;
    bounds.ne = ne;
    return bounds;
}

/**
 Creates a new `TMGLCoordinateQuad` structure from the given top left,
  bottom left, bottom right, and top right coordinates.
 */
NS_INLINE TMGLCoordinateQuad TMGLCoordinateQuadMake(CLLocationCoordinate2D topLeft, CLLocationCoordinate2D bottomLeft, CLLocationCoordinate2D bottomRight, CLLocationCoordinate2D topRight) {
    TMGLCoordinateQuad quad;
    quad.topLeft = topLeft;
    quad.bottomLeft = bottomLeft;
    quad.bottomRight = bottomRight;
    quad.topRight = topRight;
    return quad;
}

/**
 Creates a new `TMGLCoordinateQuad` structure from the given `TMGLCoordinateBounds`.
 The returned quad uses the bounds' northeast coordinate as the top right, and the
  southwest coordinate at the bottom left.
 */
NS_INLINE TMGLCoordinateQuad TMGLCoordinateQuadFromCoordinateBounds(TMGLCoordinateBounds bounds) {
    TMGLCoordinateQuad quad;
    quad.topLeft = CLLocationCoordinate2DMake(bounds.ne.latitude, bounds.sw.longitude);
    quad.bottomLeft = bounds.sw;
    quad.bottomRight = CLLocationCoordinate2DMake(bounds.sw.latitude, bounds.ne.longitude);
    quad.topRight = bounds.ne;
    return quad;
}

/** Returns `YES` if the two coordinate bounds are equal to each other. */
NS_INLINE BOOL TMGLCoordinateBoundsEqualToCoordinateBounds(TMGLCoordinateBounds bounds1, TMGLCoordinateBounds bounds2) {
    return (bounds1.sw.latitude == bounds2.sw.latitude &&
            bounds1.sw.longitude == bounds2.sw.longitude &&
            bounds1.ne.latitude == bounds2.ne.latitude &&
            bounds1.ne.longitude == bounds2.ne.longitude);
}

/** Returns `YES` if the two coordinate bounds intersect. */
NS_INLINE BOOL TMGLCoordinateBoundsIntersectsCoordinateBounds(TMGLCoordinateBounds bounds1, TMGLCoordinateBounds bounds2) {
    return (bounds1.ne.latitude  > bounds2.sw.latitude  &&
            bounds1.sw.latitude  < bounds2.ne.latitude  &&
            bounds1.ne.longitude > bounds2.sw.longitude &&
            bounds1.sw.longitude < bounds2.ne.longitude);
}

/**
 Returns `YES` if the coordinate is within the coordinate bounds.
 
 #### Related examples
 See the <a href="https://docs.mapbox.com/ios/maps/examples/constraining-gestures/">
 Restrict map panning to an area</a> example to learn how to use
 `TMGLCoordinateInCoordinateBounds` to determine if a point is within, or
 intersects, a given bounding box.
 */
NS_INLINE BOOL TMGLCoordinateInCoordinateBounds(CLLocationCoordinate2D coordinate, TMGLCoordinateBounds bounds) {
    return (coordinate.latitude  >= bounds.sw.latitude  &&
            coordinate.latitude  <= bounds.ne.latitude  &&
            coordinate.longitude >= bounds.sw.longitude &&
            coordinate.longitude <= bounds.ne.longitude);
}

/** Returns the area spanned by the coordinate bounds. */
NS_INLINE TMGLCoordinateSpan TMGLCoordinateBoundsGetCoordinateSpan(TMGLCoordinateBounds bounds) {
    return TMGLCoordinateSpanMake(bounds.ne.latitude - bounds.sw.latitude,
                                 bounds.ne.longitude - bounds.sw.longitude);
}

/**
 Returns a coordinate bounds with southwest and northeast coordinates that are
 offset from those of the source bounds.
 */
NS_INLINE TMGLCoordinateBounds TMGLCoordinateBoundsOffset(TMGLCoordinateBounds bounds, TMGLCoordinateSpan offset) {
    TMGLCoordinateBounds offsetBounds = bounds;
    offsetBounds.sw.latitude += offset.latitudeDelta;
    offsetBounds.sw.longitude += offset.longitudeDelta;
    offsetBounds.ne.latitude += offset.latitudeDelta;
    offsetBounds.ne.longitude += offset.longitudeDelta;
    return offsetBounds;
}

/**
 Returns `YES` if the coordinate bounds covers no area.

 @note A bounds may be empty but have a non-zero coordinate span (e.g., when its
    northeast point lies due north of its southwest point).
 */
NS_INLINE BOOL TMGLCoordinateBoundsIsEmpty(TMGLCoordinateBounds bounds) {
    TMGLCoordinateSpan span = TMGLCoordinateBoundsGetCoordinateSpan(bounds);
    return span.latitudeDelta == 0 || span.longitudeDelta == 0;
}

/** Returns a formatted string for the given coordinate bounds. */
NS_INLINE NSString *TMGLStringFromCoordinateBounds(TMGLCoordinateBounds bounds) {
    return [NSString stringWithFormat:@"{ sw = {%.1f, %.1f}, ne = {%.1f, %.1f}}",
            bounds.sw.latitude, bounds.sw.longitude,
            bounds.ne.latitude, bounds.ne.longitude];
}

/** Returns a formatted string for the given coordinate quad. */
NS_INLINE NSString *TMGLStringFromCoordinateQuad(TMGLCoordinateQuad quad) {
    return [NSString stringWithFormat:@"{ topleft = {%.1f, %.1f}, bottomleft = {%.1f, %.1f}}, bottomright = {%.1f, %.1f}, topright = {%.1f, %.1f}",
            quad.topLeft.latitude, quad.topLeft.longitude,
            quad.bottomLeft.latitude, quad.bottomLeft.longitude,
            quad.bottomRight.latitude, quad.bottomRight.longitude,
            quad.topRight.latitude, quad.topRight.longitude];
}

/** Returns radians, converted from degrees. */
NS_INLINE CGFloat TMGLRadiansFromDegrees(CLLocationDegrees degrees) {
    return (CGFloat)(degrees * M_PI) / 180;
}

/** Returns degrees, converted from radians. */
NS_INLINE CLLocationDegrees TMGLDegreesFromRadians(CGFloat radians) {
    return radians * 180 / M_PI;
}

/** Returns Mercator projection of a WGS84 coordinate at the specified zoom level. */
FOUNDATION_EXTERN TMGL_EXPORT TMGLMapPoint TMGLMapPointForCoordinate(CLLocationCoordinate2D coordinate, double zoomLevel);


/** Converts a map zoom level to a camera altitude.
 
 @param zoomLevel The zoom level to convert.
 @param pitch The camera pitch, measured in degrees.
 @param latitude The latitude of the point at the center of the viewport.
 @param size The size of the viewport.
 @return An altitude measured in meters. */
FOUNDATION_EXTERN TMGL_EXPORT CLLocationDistance TMGLAltitudeForZoomLevel(double zoomLevel, CGFloat pitch, CLLocationDegrees latitude, CGSize size);

/** Converts a camera altitude to a map zoom level.
 
 @param altitude The altitude to convert, measured in meters.
 @param pitch The camera pitch, measured in degrees.
 @param latitude The latitude of the point at the center of the viewport.
 @param size The size of the viewport.
 @return A zero-based zoom level. */
FOUNDATION_EXTERN TMGL_EXPORT double TMGLZoomLevelForAltitude(CLLocationDistance altitude, CGFloat pitch, CLLocationDegrees latitude, CGSize size);

NS_ASSUME_NONNULL_END
