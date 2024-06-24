#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TMGLFoundation.h"
#import "TMGLShape.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An `TMGLPointAnnotation` object represents a one-dimensional shape located at a
 single geographical coordinate. Depending on how it is used, an
 `TMGLPointAnnotation` object is known as a point annotation or point shape. For
 example, you could use a point shape to represent a city at low zoom levels, an
 address at high zoom levels, or the location of a long press gesture.

 You can add point shapes to the map by adding them to an `TMGLShapeSource`
 object. Configure the appearance of an `TMGLShapeSource`’s or
 `TMGLVectorTileSource`’s point shapes collectively using an `TMGLCircleStyleLayer` or
 `TMGLSymbolStyleLayer` object.

 For more interactivity, add a selectable point annotation to a map view using
 the `-[TMGLMapView addAnnotation:]` method. Alternatively, define your own model
 class that conforms to the `TMGLAnnotation` protocol. Configure a point
 annotation’s appearance using
 `-[TMGLMapViewDelegate mapView:imageForAnnotation:]` or
 `-[TMGLMapViewDelegate mapView:viewForAnnotation:]` (iOS only). A point
 annotation’s `TMGLShape.title` and `TMGLShape.subtitle` properties define the
 default content of the annotation’s callout (on iOS) or popover (on macOS).

 To group multiple related points together in one shape, use an
 `TMGLPointCollection` or `TMGLShapeCollection` object. To access
 a point’s attributes, use an `TMGLPointFeature` object.

 A point shape is known as a
 <a href="https://tools.ietf.org/html/rfc7946#section-3.1.2">Point</a> geometry
 in GeoJSON.
 
 #### Related examples
 See the <a href="https://docs.mapbox.com/ios/maps/examples/marker/">
 Mark a place on the map with an annotation</a>, <a href="https://docs.mapbox.com/ios/maps/examples/marker-image/">
 Mark a place on the map with an image</a>, and <a href="https://docs.mapbox.com/ios/maps/examples/default-callout/">
 Default callout usage</a> examples to learn how to add `TMGLPointAnnotation`
 objects to your map.
 */
TMGL_EXPORT
@interface TMGLPointAnnotation : TMGLShape

/**
 The coordinate point of the shape, specified as a latitude and longitude.
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

NS_ASSUME_NONNULL_END
