// This file is generated.
// Edit platform/darwin/scripts/generate-style-code.js, then run `make darwin-style-code`.

#import "TMGLFoundation.h"
#import "TMGLForegroundStyleLayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Direction of light source when map is rotated.

 Values of this type are used in the `TMGLHillshadeStyleLayer.hillshadeIlluminationAnchor`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLHillshadeIlluminationAnchor) {
    /**
     The hillshade illumination is relative to the north direction.
     */
    TMGLHillshadeIlluminationAnchorMap,
    /**
     The hillshade illumination is relative to the top of the viewport.
     */
    TMGLHillshadeIlluminationAnchorViewport,
};

/**
 An `TMGLHillshadeStyleLayer` is a style layer that renders raster <a
 href="https://en.wikipedia.org/wiki/Digital_elevation_model">digital elevation
 model</a> (DEM) tiles on the map.
 
 Use a hillshade style layer to configure the color parameters of raster tiles
 loaded by an `TMGLRasterDEMSource` object.

 You can access an existing hillshade style layer using the
 `-[TMGLStyle layerWithIdentifier:]` method if you know its identifier;
 otherwise, find it using the `TMGLStyle.layers` property. You can also create a
 new hillshade style layer and add it to the style using a method such as
 `-[TMGLStyle addLayer:]`.

 ### Example

 ```swift
 let layer = TMGLHillshadeStyleLayer(identifier: "hills", source: source)
 layer.hillshadeExaggeration = NSExpression(forConstantValue: 0.6)
 if let canalShadowLayer = mapView.style?.layer(withIdentifier: "waterway-river-canal-shadow") {
     mapView.style?.insertLayer(layer, below: canalShadowLayer)
 }
 ```
 */
TMGL_EXPORT
@interface TMGLHillshadeStyleLayer : TMGLForegroundStyleLayer

/**
 Returns a hillshade style layer initialized with an identifier and source.

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

#pragma mark - Accessing the Paint Attributes

#if TARGET_OS_IPHONE
/**
 The shading color used to accentuate rugged terrain like sharp cliffs and
 gorges.
 
 The default value of this property is an expression that evaluates to
 `UIColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeAccentColor;
#else
/**
 The shading color used to accentuate rugged terrain like sharp cliffs and
 gorges.
 
 The default value of this property is an expression that evaluates to
 `NSColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeAccentColor;
#endif

/**
 The transition affecting any changes to this layer’s `hillshadeAccentColor` property.

 This property corresponds to the `hillshade-accent-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition hillshadeAccentColorTransition;

/**
 Intensity of the hillshade
 
 The default value of this property is an expression that evaluates to the float
 `0.5`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeExaggeration;

/**
 The transition affecting any changes to this layer’s `hillshadeExaggeration` property.

 This property corresponds to the `hillshade-exaggeration-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition hillshadeExaggerationTransition;

#if TARGET_OS_IPHONE
/**
 The shading color of areas that faces towards the light source.
 
 The default value of this property is an expression that evaluates to
 `UIColor.whiteColor`. Set this property to `nil` to reset it to the default
 value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeHighlightColor;
#else
/**
 The shading color of areas that faces towards the light source.
 
 The default value of this property is an expression that evaluates to
 `NSColor.whiteColor`. Set this property to `nil` to reset it to the default
 value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeHighlightColor;
#endif

/**
 The transition affecting any changes to this layer’s `hillshadeHighlightColor` property.

 This property corresponds to the `hillshade-highlight-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition hillshadeHighlightColorTransition;

/**
 Direction of light source when map is rotated.
 
 The default value of this property is an expression that evaluates to
 `viewport`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLHillshadeIlluminationAnchor` values
 * Any of the following constant string values:
   * `map`: The hillshade illumination is relative to the north direction.
   * `viewport`: The hillshade illumination is relative to the top of the
 viewport.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeIlluminationAnchor;

/**
 The direction of the light source used to generate the hillshading with 0 as
 the top of the viewport if `hillshadeIlluminationAnchor` is set to
 `TMGLHillshadeIlluminationAnchorViewport` and due north if
 `hillshadeIlluminationAnchor` is set to `TMGLHillshadeIlluminationAnchorMap`.
 
 The default value of this property is an expression that evaluates to the float
 `335`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 359 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeIlluminationDirection;

#if TARGET_OS_IPHONE
/**
 The shading color of areas that face away from the light source.
 
 The default value of this property is an expression that evaluates to
 `UIColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeShadowColor;
#else
/**
 The shading color of areas that face away from the light source.
 
 The default value of this property is an expression that evaluates to
 `NSColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *hillshadeShadowColor;
#endif

/**
 The transition affecting any changes to this layer’s `hillshadeShadowColor` property.

 This property corresponds to the `hillshade-shadow-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition hillshadeShadowColorTransition;

@end

/**
 Methods for wrapping an enumeration value for a style layer attribute in an
 `TMGLHillshadeStyleLayer` object and unwrapping its raw value.
 */
@interface NSValue (TMGLHillshadeStyleLayerAdditions)

#pragma mark Working with Hillshade Style Layer Attribute Values

/**
 Creates a new value object containing the given `TMGLHillshadeIlluminationAnchor` enumeration.

 @param hillshadeIlluminationAnchor The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLHillshadeIlluminationAnchor:(TMGLHillshadeIlluminationAnchor)hillshadeIlluminationAnchor;

/**
 The `TMGLHillshadeIlluminationAnchor` enumeration representation of the value.
 */
@property (readonly) TMGLHillshadeIlluminationAnchor TMGLHillshadeIlluminationAnchorValue;

@end

NS_ASSUME_NONNULL_END
