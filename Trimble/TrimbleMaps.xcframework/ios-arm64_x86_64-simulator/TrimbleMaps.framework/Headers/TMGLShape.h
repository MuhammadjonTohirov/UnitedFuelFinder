#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"
#import "TMGLAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `TMGLShape` is an abstract class that represents a shape or annotation. Shapes
 constitute the content of a map — not only the overlays atop the map, but also
 the content that forms the base map.

 Create instances of `TMGLPointAnnotation`, `TMGLPointCollection`, `TMGLPolyline`,
 `TMGLMultiPolyline`, `TMGLPolygon`, `TMGLMultiPolygon`, or `TMGLShapeCollection` in
 order to use `TMGLShape`'s methods. Do not create instances of `TMGLShape`
 directly, and do not create your own subclasses of this class. The shape
 classes correspond to the
 <a href="https://tools.ietf.org/html/rfc7946#section-3.1">Geometry</a> object
 types in the GeoJSON standard, but some have nonstandard names for backwards
 compatibility.

 Although you do not create instances of this class directly, you can use its
 `+[TMGLShape shapeWithData:encoding:error:]` factory method to create one of the
 concrete subclasses of `TMGLShape` noted above from GeoJSON data. To access a
 shape’s attributes, use the corresponding `TMGLFeature` class instead.

 You can add shapes to the map by adding them to an `TMGLShapeSource` object.
 Configure the appearance of an `TMGLShapeSource`’s or `TMGLVectorTileSource`’s
 shapes collectively using a concrete instance of `TMGLVectorStyleLayer`.
 Alternatively, you can add some kinds of shapes directly to a map view as
 annotations or overlays.
 
 You can filter the features in a `TMGLVectorStyleLayer` or vary their layout or
 paint attributes based on the features’ geographies. Pass an `TMGLShape` into an
 `NSPredicate` with the format `SELF IN %@` or `%@ CONTAINS SELF` and set the
 `TMGLVectorStyleLayer.predicate` property to that predicate, or set a layout or
 paint attribute to a similarly formatted `NSExpression`.
 */
TMGL_EXPORT
@interface TMGLShape : NSObject <TMGLAnnotation, NSSecureCoding>

#pragma mark Creating a Shape

/**
 Returns an `TMGLShape` object initialized with the given data interpreted as a
 string containing a GeoJSON object.

 If the GeoJSON object is a geometry, the returned value is a kind of
 `TMGLShape`. If it is a feature object, the returned value is a kind of
 `TMGLShape` that conforms to the `TMGLFeature` protocol. If it is a feature
 collection object, the returned value is an instance of
 `TMGLShapeCollectionFeature`.

 ### Example

 ```swift
 let url = mainBundle.url(forResource: "amsterdam", withExtension: "geojson")!
 let data = try! Data(contentsOf: url)
 let feature = try! TMGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! TMGLShapeCollectionFeature
 ```

 @param data String data containing GeoJSON source code.
 @param encoding The encoding used by `data`.
 @param outError Upon return, if an error has occurred, a pointer to an
    `NSError` object describing the error. Pass in `NULL` to ignore any error.
 @return An `TMGLShape` object representation of `data`, or `nil` if `data` could
    not be parsed as valid GeoJSON source code. If `nil`, `outError` contains an
    `NSError` object describing the problem.
 */
+ (nullable TMGLShape *)shapeWithData:(NSData *)data encoding:(NSStringEncoding)encoding error:(NSError * _Nullable *)outError;

#pragma mark Accessing the Shape Attributes

/**
 The title of the shape annotation.

 The default value of this property is `nil`.

 This property is ignored when the shape is used in an `TMGLShapeSource`. To name
 a shape used in a shape source, create an `TMGLFeature` and add an attribute to
 the `TMGLFeature.attributes` property.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 The subtitle of the shape annotation. The default value of this property is
 `nil`.

 This property is ignored when the shape is used in an `TMGLShapeSource`. To
 provide additional information about a shape used in a shape source, create an
 `TMGLFeature` and add an attribute to the `TMGLFeature.attributes` property.
 */
@property (nonatomic, copy, nullable) NSString *subtitle;

#if !TARGET_OS_IPHONE

/**
 The tooltip of the shape annotation.

 The default value of this property is `nil`.

 This property is ignored when the shape is used in an `TMGLShapeSource`.
 */
@property (nonatomic, copy, nullable) NSString *toolTip;

#endif

#pragma mark Creating GeoJSON Data

/**
 Returns the GeoJSON string representation of the shape encapsulated in a data
 object.

 @param encoding The string encoding to use.
 @return A data object containing the shape’s GeoJSON string representation.
 */
- (NSData *)geoJSONDataUsingEncoding:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
