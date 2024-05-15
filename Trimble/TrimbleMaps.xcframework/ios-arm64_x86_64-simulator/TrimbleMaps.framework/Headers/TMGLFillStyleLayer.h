// This file is generated.
// Edit platform/darwin/scripts/generate-style-code.js, then run `make darwin-style-code`.

#import "TMGLFoundation.h"
#import "TMGLVectorStyleLayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Controls the frame of reference for `TMGLFillStyleLayer.fillTranslation`.

 Values of this type are used in the `TMGLFillStyleLayer.fillTranslationAnchor`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLFillTranslationAnchor) {
    /**
     The fill is translated relative to the map.
     */
    TMGLFillTranslationAnchorMap,
    /**
     The fill is translated relative to the viewport.
     */
    TMGLFillTranslationAnchorViewport,
};

/**
 An `TMGLFillStyleLayer` is a style layer that renders one or more filled (and
 optionally stroked) polygons on the map.
 
 Use a fill style layer to configure the visual appearance of polygon or
 multipolygon features. These features can come from vector tiles loaded by an
 `TMGLVectorTileSource` object, or they can be `TMGLPolygon`, `TMGLPolygonFeature`,
 `TMGLMultiPolygon`, or `TMGLMultiPolygonFeature` instances in an `TMGLShapeSource`
 or `TMGLComputedShapeSource` object.

 You can access an existing fill style layer using the
 `-[TMGLStyle layerWithIdentifier:]` method if you know its identifier;
 otherwise, find it using the `TMGLStyle.layers` property. You can also create a
 new fill style layer and add it to the style using a method such as
 `-[TMGLStyle addLayer:]`.

 ### Example

 ```swift
 let layer = TMGLFillStyleLayer(identifier: "parks", source: parks)
 layer.sourceLayerIdentifier = "parks"
 layer.fillColor = NSExpression(forConstantValue: UIColor.green)
 layer.predicate = NSPredicate(format: "type == %@", "national-park")
 mapView.style?.addLayer(layer)
 ```
 */
TMGL_EXPORT
@interface TMGLFillStyleLayer : TMGLVectorStyleLayer

/**
 Returns a fill style layer initialized with an identifier and source.

 After initializing and configuring the style layer, add it to a map view’s
 style using the `-[TMGLStyle addLayer:]` or
 `-[TMGLStyle insertLayer:belowLayer:]` method.

 @param identifier A string that uniquely identifies the source in the style to
    which it is added.
 @param source The source from which to obtain the data to style. If the source
    has not yet been added to the current style, the behavior is undefined.
 @return An initialized foreground style layer.
 */
- (instancetype)initWithIdentifier:(NSString *)identifier source:(TMGLSource *)source;

#pragma mark - Accessing the Layout Attributes

/**
 Sorts features in ascending order based on this value. Features with a higher
 sort key will appear above features with a lower sort key.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillSortKey;

#pragma mark - Accessing the Paint Attributes

/**
 Whether or not the fill should be antialiased.
 
 The default value of this property is an expression that evaluates to `YES`.
 Set this property to `nil` to reset it to the default value.
  
 You can set this property to an expression containing any of the following:
 
 * Constant Boolean values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable, getter=isFillAntialiased) NSExpression *fillAntialiased;

@property (nonatomic, null_resettable) NSExpression *fillAntialias __attribute__((unavailable("Use fillAntialiased instead.")));

#if TARGET_OS_IPHONE
/**
 The color of the filled part of this layer.
 
 The default value of this property is an expression that evaluates to
 `UIColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `fillPattern` is set to `nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillColor;
#else
/**
 The color of the filled part of this layer.
 
 The default value of this property is an expression that evaluates to
 `NSColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `fillPattern` is set to `nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillColor;
#endif

/**
 The transition affecting any changes to this layer’s `fillColor` property.

 This property corresponds to the `fill-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition fillColorTransition;

/**
 The opacity of the entire fill layer. In contrast to the `fillColor`, this
 value will also affect the 1pt stroke around the fill, if the stroke is used.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillOpacity;

/**
 The transition affecting any changes to this layer’s `fillOpacity` property.

 This property corresponds to the `fill-opacity-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition fillOpacityTransition;

#if TARGET_OS_IPHONE
/**
 The outline color of the fill. Matches the value of `fillColor` if unspecified.
 
 This property is only applied to the style if `fillPattern` is set to `nil`,
 and `fillAntialiased` is set to an expression that evaluates to `YES`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillOutlineColor;
#else
/**
 The outline color of the fill. Matches the value of `fillColor` if unspecified.
 
 This property is only applied to the style if `fillPattern` is set to `nil`,
 and `fillAntialiased` is set to an expression that evaluates to `YES`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillOutlineColor;
#endif

/**
 The transition affecting any changes to this layer’s `fillOutlineColor` property.

 This property corresponds to the `fill-outline-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition fillOutlineColorTransition;

/**
 Name of image in sprite to use for drawing image fills. For seamless patterns,
 image width and height must be a factor of two (2, 4, 8, ..., 512). Note that
 zoom-dependent expressions will be evaluated only at integer zoom levels.
 
 You can set this property to an expression containing any of the following:
 
 * Constant string values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *fillPattern;

/**
 The transition affecting any changes to this layer’s `fillPattern` property.

 This property corresponds to the `fill-pattern-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition fillPatternTransition;

#if TARGET_OS_IPHONE
/**
 The geometry's offset.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 points rightward and 0
 points downward. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *fillTranslation;
#else
/**
 The geometry's offset.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 points rightward and 0
 points upward. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *fillTranslation;
#endif

/**
 The transition affecting any changes to this layer’s `fillTranslation` property.

 This property corresponds to the `fill-translate-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition fillTranslationTransition;

@property (nonatomic, null_resettable) NSExpression *fillTranslate __attribute__((unavailable("Use fillTranslation instead.")));

/**
 Controls the frame of reference for `fillTranslation`.
 
 The default value of this property is an expression that evaluates to `map`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `fillTranslation` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLFillTranslationAnchor` values
 * Any of the following constant string values:
   * `map`: The fill is translated relative to the map.
   * `viewport`: The fill is translated relative to the viewport.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *fillTranslationAnchor;

@property (nonatomic, null_resettable) NSExpression *fillTranslateAnchor __attribute__((unavailable("Use fillTranslationAnchor instead.")));

@end

/**
 Methods for wrapping an enumeration value for a style layer attribute in an
 `TMGLFillStyleLayer` object and unwrapping its raw value.
 */
@interface NSValue (TMGLFillStyleLayerAdditions)

#pragma mark Working with Fill Style Layer Attribute Values

/**
 Creates a new value object containing the given `TMGLFillTranslationAnchor` enumeration.

 @param fillTranslationAnchor The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLFillTranslationAnchor:(TMGLFillTranslationAnchor)fillTranslationAnchor;

/**
 The `TMGLFillTranslationAnchor` enumeration representation of the value.
 */
@property (readonly) TMGLFillTranslationAnchor TMGLFillTranslationAnchorValue;

@end

NS_ASSUME_NONNULL_END
