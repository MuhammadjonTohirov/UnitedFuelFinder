// This file is generated.
// Edit platform/darwin/scripts/generate-style-code.js, then run `make darwin-style-code`.

#import "TMGLFoundation.h"
#import "TMGLForegroundStyleLayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The resampling/interpolation method to use for overscaling, also known as
 texture magnification filter

 Values of this type are used in the `TMGLRasterStyleLayer.rasterResamplingMode`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLRasterResamplingMode) {
    /**
     (Bi)linear filtering interpolates point values using the weighted average
     of the four closest original source points creating a smooth but blurry
     look when overscaled
     */
    TMGLRasterResamplingModeLinear,
    /**
     Nearest neighbor filtering interpolates point values using the nearest
     original source point creating a sharp but pointated look when overscaled
     */
    TMGLRasterResamplingModeNearest,
};

/**
 An `TMGLRasterStyleLayer` is a style layer that renders georeferenced raster
 imagery on the map, especially raster tiles.
  
 Raster images may also be used as icons or patterns in a style layer. To
 register an image for use as an icon or pattern, use the `-[TMGLStyle
 setImage:forName:]` method. To configure a point annotation’s image, use the
 `TMGLAnnotationImage` class.

 You can access an existing raster style layer using the
 `-[TMGLStyle layerWithIdentifier:]` method if you know its identifier;
 otherwise, find it using the `TMGLStyle.layers` property. You can also create a
 new raster style layer and add it to the style using a method such as
 `-[TMGLStyle addLayer:]`.

 ### Example

 ```swift
 let layer = TMGLRasterStyleLayer(identifier: "clouds", source: source)
 layer.rasterOpacity = NSExpression(forConstantValue: 0.5)
 mapView.style?.addLayer(layer)
 ```
 */
TMGL_EXPORT
@interface TMGLRasterStyleLayer : TMGLForegroundStyleLayer

/**
 Returns a raster style layer initialized with an identifier and source.

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

/**
 Increase or reduce the brightness of the image. The value is the maximum
 brightness.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *maximumRasterBrightness;

/**
 The transition affecting any changes to this layer’s `maximumRasterBrightness` property.

 This property corresponds to the `raster-brightness-max-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition maximumRasterBrightnessTransition;

@property (nonatomic, null_resettable) NSExpression *rasterBrightnessMax __attribute__((unavailable("Use maximumRasterBrightness instead.")));

/**
 Increase or reduce the brightness of the image. The value is the minimum
 brightness.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *minimumRasterBrightness;

/**
 The transition affecting any changes to this layer’s `minimumRasterBrightness` property.

 This property corresponds to the `raster-brightness-min-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition minimumRasterBrightnessTransition;

@property (nonatomic, null_resettable) NSExpression *rasterBrightnessMin __attribute__((unavailable("Use minimumRasterBrightness instead.")));

/**
 Increase or reduce the contrast of the image.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between −1 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *rasterContrast;

/**
 The transition affecting any changes to this layer’s `rasterContrast` property.

 This property corresponds to the `raster-contrast-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition rasterContrastTransition;

/**
 Fade duration when a new tile is added.
 
 This property is measured in milliseconds.
 
 The default value of this property is an expression that evaluates to the float
 `300`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *rasterFadeDuration;

/**
 Rotates hues around the color wheel.
 
 This property is measured in degrees.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *rasterHueRotation;

/**
 The transition affecting any changes to this layer’s `rasterHueRotation` property.

 This property corresponds to the `raster-hue-rotate-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition rasterHueRotationTransition;

@property (nonatomic, null_resettable) NSExpression *rasterHueRotate __attribute__((unavailable("Use rasterHueRotation instead.")));

/**
 The opacity at which the image will be drawn.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *rasterOpacity;

/**
 The transition affecting any changes to this layer’s `rasterOpacity` property.

 This property corresponds to the `raster-opacity-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition rasterOpacityTransition;

/**
 The resampling/interpolation method to use for overscaling, also known as
 texture magnification filter
 
 The default value of this property is an expression that evaluates to `linear`.
 Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLRasterResamplingMode` values
 * Any of the following constant string values:
   * `linear`: (Bi)linear filtering interpolates pixel values using the weighted
 average of the four closest original source pixels creating a smooth but blurry
 look when overscaled
   * `nearest`: Nearest neighbor filtering interpolates pixel values using the
 nearest original source pixel creating a sharp but pixelated look when
 overscaled
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *rasterResamplingMode;

@property (nonatomic, null_resettable) NSExpression *rasterResampling __attribute__((unavailable("Use rasterResamplingMode instead.")));

/**
 Increase or reduce the saturation of the image.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between −1 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *rasterSaturation;

/**
 The transition affecting any changes to this layer’s `rasterSaturation` property.

 This property corresponds to the `raster-saturation-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition rasterSaturationTransition;

@end

/**
 Methods for wrapping an enumeration value for a style layer attribute in an
 `TMGLRasterStyleLayer` object and unwrapping its raw value.
 */
@interface NSValue (TMGLRasterStyleLayerAdditions)

#pragma mark Working with Raster Style Layer Attribute Values

/**
 Creates a new value object containing the given `TMGLRasterResamplingMode` enumeration.

 @param rasterResamplingMode The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLRasterResamplingMode:(TMGLRasterResamplingMode)rasterResamplingMode;

/**
 The `TMGLRasterResamplingMode` enumeration representation of the value.
 */
@property (readonly) TMGLRasterResamplingMode TMGLRasterResamplingModeValue;

@end

NS_ASSUME_NONNULL_END
