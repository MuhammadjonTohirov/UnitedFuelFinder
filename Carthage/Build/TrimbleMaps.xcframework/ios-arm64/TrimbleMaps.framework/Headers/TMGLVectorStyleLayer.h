#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"
#import "TMGLForegroundStyleLayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `TMGLVectorStyleLayer` is an abstract superclass for style layers whose content
 is defined by an `TMGLShapeSource` or `TMGLVectorTileSource` object.

 Create instances of `TMGLCircleStyleLayer`, `TMGLFillStyleLayer`,
 `TMGLFillExtrusionStyleLayer`, `TMGLHeatmapStyleLayer`, `TMGLLineStyleLayer`, and
 `TMGLSymbolStyleLayer` in order to use `TMGLVectorStyleLayer`'s properties and
 methods. Do not create instances of `TMGLVectorStyleLayer` directly, and do not
 create your own subclasses of this class.
 */
TMGL_EXPORT
@interface TMGLVectorStyleLayer : TMGLForegroundStyleLayer

#pragma mark Refining a Style Layer’s Content

/**
 Identifier of the layer within the source identified by the `sourceIdentifier`
 property from which the receiver obtains the data to style.
 */
@property (nonatomic, nullable) NSString *sourceLayerIdentifier;

/**
 The style layer’s predicate.
 
 See the “<a href="../predicates-and-expressions.html">Predicates and Expressions</a>”
 guide for details about the predicate syntax supported by this class.

 ### Example

 To filter the layer to include only the features whose `index` attribute is 5
 or 10 and whose `ele` attribute is at least 1,500, you could create an
 `NSCompoundPredicate` along these lines:

 ```swift
 let layer = TMGLLineStyleLayer(identifier: "contour", source: terrain)
 layer.sourceLayerIdentifier = "contours"
 layer.predicate = NSPredicate(format: "(index == 5 || index == 10) && CAST(ele, 'NSNumber') >= 1500.0")
 mapView.style?.addLayer(layer)
 ```
 */
@property (nonatomic, nullable) NSPredicate *predicate;

@end

NS_ASSUME_NONNULL_END
