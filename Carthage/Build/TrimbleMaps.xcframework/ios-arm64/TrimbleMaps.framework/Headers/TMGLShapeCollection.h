#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"
#import "TMGLShape.h"

#import "TMGLTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 An `TMGLShapeCollection` object represents a shape consisting of zero or more
 distinct but related shapes that are instances of `TMGLShape`. The constituent
 shapes can be a mixture of different kinds of shapes.

 `TMGLShapeCollection` is most commonly used to add multiple shapes to a single
 `TMGLShapeSource`. Configure the appearance of an `TMGLShapeSource`’s or
 `TMGLVectorTileSource`’s shape collection collectively using an
 `TMGLSymbolStyleLayer` object, or use multiple instances of
 `TMGLCircleStyleLayer`, `TMGLFillStyleLayer`, and `TMGLLineStyleLayer` to
 configure the appearance of each kind of shape inside the collection.

 You cannot add an `TMGLShapeCollection` object directly to a map view as an
 annotation. However, you can create individual `TMGLPointAnnotation`,
 `TMGLPolyline`, and `TMGLPolygon` objects from the `shapes` array and add those
 annotation objects to the map view using the `-[TMGLMapView addAnnotations:]`
 method.

 To represent a collection of point, polyline, or polygon shapes, it may be more
 convenient to use an `TMGLPointCollection`, `TMGLMultiPolyline`, or
 `TMGLMultiPolygon` object, respectively. To access a shape collection’s
 attributes, use the corresponding `TMGLFeature` object.

 A shape collection is known as a
 <a href="https://tools.ietf.org/html/rfc7946#section-3.1.8">GeometryCollection</a>
 geometry in GeoJSON.
 */
TMGL_EXPORT
@interface TMGLShapeCollection : TMGLShape

/**
 An array of shapes forming the shape collection.
 */
@property (nonatomic, copy, readonly) NSArray<TMGLShape *> *shapes;

/**
 Creates and returns a shape collection consisting of the given shapes.

 @param shapes The array of shapes defining the shape collection. The data in
    this array is copied to the new object.
 @return A new shape collection object.
 */
+ (instancetype)shapeCollectionWithShapes:(NSArray<TMGLShape *> *)shapes;

@end

NS_ASSUME_NONNULL_END
