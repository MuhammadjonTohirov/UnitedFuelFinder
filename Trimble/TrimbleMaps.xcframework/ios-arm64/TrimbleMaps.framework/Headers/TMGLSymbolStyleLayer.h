// This file is generated.
// Edit platform/darwin/scripts/generate-style-code.js, then run `make darwin-style-code`.

#import "TMGLFoundation.h"
#import "TMGLVectorStyleLayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Part of the icon placed closest to the anchor.

 Values of this type are used in the `TMGLSymbolStyleLayer.iconAnchor`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLIconAnchor) {
    /**
     The center of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorCenter,
    /**
     The left side of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorLeft,
    /**
     The right side of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorRight,
    /**
     The top of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorTop,
    /**
     The bottom of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorBottom,
    /**
     The top left corner of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorTopLeft,
    /**
     The top right corner of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorTopRight,
    /**
     The bottom left corner of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorBottomLeft,
    /**
     The bottom right corner of the icon is placed closest to the anchor.
     */
    TMGLIconAnchorBottomRight,
};

/**
 Orientation of icon when map is pitched.

 Values of this type are used in the `TMGLSymbolStyleLayer.iconPitchAlignment`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLIconPitchAlignment) {
    /**
     The icon is aligned to the plane of the map.
     */
    TMGLIconPitchAlignmentMap,
    /**
     The icon is aligned to the plane of the viewport.
     */
    TMGLIconPitchAlignmentViewport,
    /**
     Automatically matches the value of
     `TMGLSymbolStyleLayer.iconRotationAlignment`.
     */
    TMGLIconPitchAlignmentAuto,
};

/**
 In combination with `TMGLSymbolStyleLayer.symbolPlacement`, determines the
 rotation behavior of icons.

 Values of this type are used in the `TMGLSymbolStyleLayer.iconRotationAlignment`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLIconRotationAlignment) {
    /**
     When `symbolPlacement` is set to `TMGLSymbolPlacementPoint`, aligns icons
     east-west. When `symbolPlacement` is set to `TMGLSymbolPlacementLine` or
     `TMGLSymbolPlacementLineCenter`, aligns icon x-axes with the line.
     */
    TMGLIconRotationAlignmentMap,
    /**
     Produces icons whose x-axes are aligned with the x-axis of the viewport,
     regardless of the value of `TMGLSymbolStyleLayer.symbolPlacement`.
     */
    TMGLIconRotationAlignmentViewport,
    /**
     When `symbolPlacement` is set to `TMGLSymbolPlacementPoint`, this is
     equivalent to `TMGLIconRotationAlignmentViewport`. When `symbolPlacement` is
     set to `TMGLSymbolPlacementLine` or `TMGLSymbolPlacementLineCenter`, this is
     equivalent to `TMGLIconRotationAlignmentMap`.
     */
    TMGLIconRotationAlignmentAuto,
};

/**
 The directions in which the icon stretches to fit around the text. If the icon
 image is a resizable image, the resizable areas may be stretched, while the cap
 insets are always drawn at the original scale.

 Values of this type are used in the `TMGLSymbolStyleLayer.iconTextFit`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLIconTextFit) {
    /**
     The icon is displayed at its intrinsic aspect ratio.
     */
    TMGLIconTextFitNone,
    /**
     The icon is scaled in the x-dimension to fit the width of the text.
     */
    TMGLIconTextFitWidth,
    /**
     The icon is scaled in the y-dimension to fit the height of the text.
     */
    TMGLIconTextFitHeight,
    /**
     The icon is scaled in both x- and y-dimensions.
     */
    TMGLIconTextFitBoth,
};

/**
 Label placement relative to its geometry.

 Values of this type are used in the `TMGLSymbolStyleLayer.symbolPlacement`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLSymbolPlacement) {
    /**
     The label is placed at the point where the geometry is located.
     */
    TMGLSymbolPlacementPoint,
    /**
     The label is placed along the line of the geometry. Can only be used on
     `LineString` and `Polygon` geometries.
     */
    TMGLSymbolPlacementLine,
    /**
     The label is placed at the center of the line of the geometry. Can only be
     used on `LineString` and `Polygon` geometries. Note that a single feature
     in a vector tile may contain multiple line geometries.
     */
    TMGLSymbolPlacementLineCenter,
};

/**
 Controls the order in which overlapping symbols in the same layer are rendered

 Values of this type are used in the `TMGLSymbolStyleLayer.symbolZOrder`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLSymbolZOrder) {
    /**
     If `TMGLSymbolStyleLayer.symbolSortKey` is set, sort based on that.
     Otherwise sort symbols by their y-position relative to the viewport.
     */
    TMGLSymbolZOrderAuto,
    /**
     Specify this z order if symbols’ appearance relies on lower features
     overlapping higher features. For example, symbols with a pin-like
     appearance would require this z order.
     */
    TMGLSymbolZOrderViewportY,
    /**
     Specify this z order if the order in which features appear in the source is
     significant.
     */
    TMGLSymbolZOrderSource,
};

/**
 Part of the text placed closest to the anchor.

 Values of this type are used in the `TMGLSymbolStyleLayer.textAnchor`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextAnchor) {
    /**
     The center of the text is placed closest to the anchor.
     */
    TMGLTextAnchorCenter,
    /**
     The left side of the text is placed closest to the anchor.
     */
    TMGLTextAnchorLeft,
    /**
     The right side of the text is placed closest to the anchor.
     */
    TMGLTextAnchorRight,
    /**
     The top of the text is placed closest to the anchor.
     */
    TMGLTextAnchorTop,
    /**
     The bottom of the text is placed closest to the anchor.
     */
    TMGLTextAnchorBottom,
    /**
     The top left corner of the text is placed closest to the anchor.
     */
    TMGLTextAnchorTopLeft,
    /**
     The top right corner of the text is placed closest to the anchor.
     */
    TMGLTextAnchorTopRight,
    /**
     The bottom left corner of the text is placed closest to the anchor.
     */
    TMGLTextAnchorBottomLeft,
    /**
     The bottom right corner of the text is placed closest to the anchor.
     */
    TMGLTextAnchorBottomRight,
};

/**
 Text justification options.

 Values of this type are used in the `TMGLSymbolStyleLayer.textJustification`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextJustification) {
    /**
     The text is aligned towards the anchor position.
     */
    TMGLTextJustificationAuto,
    /**
     The text is aligned to the left.
     */
    TMGLTextJustificationLeft,
    /**
     The text is centered.
     */
    TMGLTextJustificationCenter,
    /**
     The text is aligned to the right.
     */
    TMGLTextJustificationRight,
};

/**
 Orientation of text when map is pitched.

 Values of this type are used in the `TMGLSymbolStyleLayer.textPitchAlignment`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextPitchAlignment) {
    /**
     The text is aligned to the plane of the map.
     */
    TMGLTextPitchAlignmentMap,
    /**
     The text is aligned to the plane of the viewport.
     */
    TMGLTextPitchAlignmentViewport,
    /**
     Automatically matches the value of
     `TMGLSymbolStyleLayer.textRotationAlignment`.
     */
    TMGLTextPitchAlignmentAuto,
};

/**
 In combination with `TMGLSymbolStyleLayer.symbolPlacement`, determines the
 rotation behavior of the individual glyphs forming the text.

 Values of this type are used in the `TMGLSymbolStyleLayer.textRotationAlignment`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextRotationAlignment) {
    /**
     When `symbolPlacement` is set to `TMGLSymbolPlacementPoint`, aligns text
     east-west. When `symbolPlacement` is set to `TMGLSymbolPlacementLine` or
     `TMGLSymbolPlacementLineCenter`, aligns text x-axes with the line.
     */
    TMGLTextRotationAlignmentMap,
    /**
     Produces glyphs whose x-axes are aligned with the x-axis of the viewport,
     regardless of the value of `TMGLSymbolStyleLayer.symbolPlacement`.
     */
    TMGLTextRotationAlignmentViewport,
    /**
     When `symbolPlacement` is set to `TMGLSymbolPlacementPoint`, this is
     equivalent to `TMGLTextRotationAlignmentViewport`. When `symbolPlacement` is
     set to `TMGLSymbolPlacementLine` or `TMGLSymbolPlacementLineCenter`, this is
     equivalent to `TMGLTextRotationAlignmentMap`.
     */
    TMGLTextRotationAlignmentAuto,
};

/**
 Specifies how to capitalize text.

 Values of this type are used in the `TMGLSymbolStyleLayer.textTransform`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextTransform) {
    /**
     The text is not altered.
     */
    TMGLTextTransformNone,
    /**
     Forces all letters to be displayed in uppercase.
     */
    TMGLTextTransformUppercase,
    /**
     Forces all letters to be displayed in lowercase.
     */
    TMGLTextTransformLowercase,
};

/**
 The property allows control over a symbol's orientation. Note that the property
 values act as a hint, so that a symbol whose language doesn’t support the
 provided orientation will be laid out in its natural orientation. Example:
 English point symbol will be rendered horizontally even if array value contains
 single 'vertical' enum value. The order of elements in an array define priority
 order for the placement of an orientation variant.

 Values of this type are used in the `TMGLSymbolStyleLayer.textWritingModes`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextWritingMode) {
    /**
     If a text's language supports horizontal writing mode, symbols with point
     placement would be laid out horizontally.
     */
    TMGLTextWritingModeHorizontal,
    /**
     If a text's language supports vertical writing mode, symbols with point
     placement would be laid out vertically.
     */
    TMGLTextWritingModeVertical,
};

/**
 Controls the frame of reference for `TMGLSymbolStyleLayer.iconTranslation`.

 Values of this type are used in the `TMGLSymbolStyleLayer.iconTranslationAnchor`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLIconTranslationAnchor) {
    /**
     Icons are translated relative to the map.
     */
    TMGLIconTranslationAnchorMap,
    /**
     Icons are translated relative to the viewport.
     */
    TMGLIconTranslationAnchorViewport,
};

/**
 Controls the frame of reference for `TMGLSymbolStyleLayer.textTranslation`.

 Values of this type are used in the `TMGLSymbolStyleLayer.textTranslationAnchor`
 property.
 */
typedef NS_ENUM(NSUInteger, TMGLTextTranslationAnchor) {
    /**
     The text is translated relative to the map.
     */
    TMGLTextTranslationAnchorMap,
    /**
     The text is translated relative to the viewport.
     */
    TMGLTextTranslationAnchorViewport,
};

/**
 An `TMGLSymbolStyleLayer` is a style layer that renders icon and text labels at
 points or along lines on the map.
 
 Use a symbol style layer to configure the visual appearance of feature labels.
 These features can come from vector tiles loaded by an `TMGLVectorTileSource`
 object, or they can be `TMGLShape` or `TMGLFeature` instances in an
 `TMGLShapeSource` or `TMGLComputedShapeSource` object.

 You can access an existing symbol style layer using the
 `-[TMGLStyle layerWithIdentifier:]` method if you know its identifier;
 otherwise, find it using the `TMGLStyle.layers` property. You can also create a
 new symbol style layer and add it to the style using a method such as
 `-[TMGLStyle addLayer:]`.

 ### Example

 ```swift
 let layer = TMGLSymbolStyleLayer(identifier: "coffeeshops", source: pois)
 layer.sourceLayerIdentifier = "pois"
 layer.iconImageName = NSExpression(forConstantValue: "coffee")
 layer.iconScale = NSExpression(forConstantValue: 0.5)
 layer.text = NSExpression(forKeyPath: "name")
 layer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 10, dy: 0)))
 layer.textJustification = NSExpression(forConstantValue: "left")
 layer.textAnchor = NSExpression(forConstantValue: "left")
 layer.predicate = NSPredicate(format: "%K == %@", "venue-type", "coffee")
 mapView.style?.addLayer(layer)
 ```
 */
TMGL_EXPORT
@interface TMGLSymbolStyleLayer : TMGLVectorStyleLayer

/**
 Returns a symbol style layer initialized with an identifier and source.

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
 If true, the icon will be visible even if it collides with other previously
 drawn symbols.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
  
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
@property (nonatomic, null_resettable) NSExpression *iconAllowsOverlap;


@property (nonatomic, null_resettable) NSExpression *iconAllowOverlap __attribute__((unavailable("Use iconAllowsOverlap instead.")));

/**
 Part of the icon placed closest to the anchor.
 
 The default value of this property is an expression that evaluates to `center`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLIconAnchor` values
 * Any of the following constant string values:
   * `center`: The center of the icon is placed closest to the anchor.
   * `left`: The left side of the icon is placed closest to the anchor.
   * `right`: The right side of the icon is placed closest to the anchor.
   * `top`: The top of the icon is placed closest to the anchor.
   * `bottom`: The bottom of the icon is placed closest to the anchor.
   * `top-left`: The top left corner of the icon is placed closest to the
 anchor.
   * `top-right`: The top right corner of the icon is placed closest to the
 anchor.
   * `bottom-left`: The bottom left corner of the icon is placed closest to the
 anchor.
   * `bottom-right`: The bottom right corner of the icon is placed closest to
 the anchor.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconAnchor;

/**
 If true, other symbols can be visible even if they collide with the icon.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
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
@property (nonatomic, null_resettable) NSExpression *iconIgnoresPlacement;


@property (nonatomic, null_resettable) NSExpression *iconIgnorePlacement __attribute__((unavailable("Use iconIgnoresPlacement instead.")));

/**
 Name of a style image to use for drawing an image background.
 
 Use the `+[TMGLStyle setImage:forName:]` method to associate an image with a
 name that you can set this property to.
 
 Within a constant string value, a feature attribute name enclosed in curly
 braces (e.g., `{token}`) is replaced with the value of the named attribute.
 Tokens inside non-constant expressions are ignored; instead, use `tmgl_join:`
 and key path expressions.
 
 You can set this property to an expression containing any of the following:
 
 * Constant string values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes

 */
@property (nonatomic, null_resettable) NSExpression *iconImageName;


@property (nonatomic, null_resettable) NSExpression *iconImage __attribute__((unavailable("Use iconImageName instead.")));

#if TARGET_OS_IPHONE
/**
 Offset distance of icon from its anchor.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 rightward and 0
 downward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconOffset;
#else
/**
 Offset distance of icon from its anchor.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 rightward and 0
 upward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconOffset;
#endif

/**
 If true, text will display without their corresponding icons when the icon
 collides with other symbols and the text does not.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`, and
 `text` is non-`nil`. Otherwise, it is ignored.
 
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
@property (nonatomic, null_resettable, getter=isIconOptional) NSExpression *iconOptional;

/**
 Size of the additional area around the icon bounding box used for detecting
 symbol collisions.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `2`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconPadding;

/**
 Orientation of icon when map is pitched.
 
 The default value of this property is an expression that evaluates to `auto`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLIconPitchAlignment` values
 * Any of the following constant string values:
   * `map`: The icon is aligned to the plane of the map.
   * `viewport`: The icon is aligned to the plane of the viewport.
   * `auto`: Automatically matches the value of `icon-rotation-alignment`.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconPitchAlignment;

/**
 Rotates the icon clockwise.
 
 This property is measured in degrees.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
  
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconRotation;


@property (nonatomic, null_resettable) NSExpression *iconRotate __attribute__((unavailable("Use iconRotation instead.")));

/**
 In combination with `symbolPlacement`, determines the rotation behavior of
 icons.
 
 The default value of this property is an expression that evaluates to `auto`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLIconRotationAlignment` values
 * Any of the following constant string values:
   * `map`: When `symbol-placement` is set to `point`, aligns icons east-west.
 When `symbol-placement` is set to `line` or `line-center`, aligns icon x-axes
 with the line.
   * `viewport`: Produces icons whose x-axes are aligned with the x-axis of the
 viewport, regardless of the value of `symbol-placement`.
   * `auto`: When `symbol-placement` is set to `point`, this is equivalent to
 `viewport`. When `symbol-placement` is set to `line` or `line-center`, this is
 equivalent to `map`.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconRotationAlignment;

/**
 Scales the original size of the icon by the provided factor. The new point size
 of the image will be the original point size multiplied by `iconScale`. 1 is
 the original size; 3 triples the size of the image.
 
 This property is measured in factor of the original icon sizes.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconScale;


@property (nonatomic, null_resettable) NSExpression *iconSize __attribute__((unavailable("Use iconScale instead.")));

/**
 The directions in which the icon stretches to fit around the text. If the icon
 image is a resizable image, the resizable areas may be stretched, while the cap
 insets are always drawn at the original scale.
 
 The default value of this property is an expression that evaluates to `none`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`, and
 `text` is non-`nil`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLIconTextFit` values
 * Any of the following constant string values:
   * `none`: The icon is displayed at its intrinsic aspect ratio.
   * `width`: The icon is scaled in the x-dimension to fit the width of the
 text.
   * `height`: The icon is scaled in the y-dimension to fit the height of the
 text.
   * `both`: The icon is scaled in both x- and y-dimensions.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconTextFit;

#if TARGET_OS_IPHONE
/**
 Size of the additional area added to dimensions determined by `iconTextFit`.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing `UIEdgeInsetsZero`. Set this property to `nil` to
 reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`, and
 `text` is non-`nil`, and `iconTextFit` is set to an expression that evaluates
 to `TMGLIconTextFitBoth`, `TMGLIconTextFitWidth`, or `TMGLIconTextFitHeight`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIEdgeInsets` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconTextFitPadding;
#else
/**
 Size of the additional area added to dimensions determined by `iconTextFit`.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing `NSEdgeInsetsZero`. Set this property to `nil` to
 reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`, and
 `text` is non-`nil`, and `iconTextFit` is set to an expression that evaluates
 to `TMGLIconTextFitBoth`, `TMGLIconTextFitWidth`, or `TMGLIconTextFitHeight`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSEdgeInsets` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconTextFitPadding;
#endif

/**
 If true, the icon may be flipped to prevent it from being rendered upside-down.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`, and
 `iconRotationAlignment` is set to an expression that evaluates to `map`, and
 `symbolPlacement` is set to an expression that evaluates to either
 `TMGLSymbolPlacementLine` or `TMGLSymbolPlacementLineCenter`. Otherwise, it is
 ignored.
 
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
@property (nonatomic, null_resettable) NSExpression *keepsIconUpright;


@property (nonatomic, null_resettable) NSExpression *iconKeepUpright __attribute__((unavailable("Use keepsIconUpright instead.")));

/**
 If true, the text may be flipped vertically to prevent it from being rendered
 upside-down.
 
 The default value of this property is an expression that evaluates to `YES`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `textRotationAlignment` is set to an expression that evaluates to `map`, and
 `symbolPlacement` is set to an expression that evaluates to either
 `TMGLSymbolPlacementLine` or `TMGLSymbolPlacementLineCenter`. Otherwise, it is
 ignored.
  
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
@property (nonatomic, null_resettable) NSExpression *keepsTextUpright;


@property (nonatomic, null_resettable) NSExpression *textKeepUpright __attribute__((unavailable("Use keepsTextUpright instead.")));

/**
 Maximum angle change between adjacent characters.
 
 This property is measured in degrees.
 
 The default value of this property is an expression that evaluates to the float
 `45`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `symbolPlacement` is set to an expression that evaluates to either
 `TMGLSymbolPlacementLine` or `TMGLSymbolPlacementLineCenter`. Otherwise, it is
 ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *maximumTextAngle;


@property (nonatomic, null_resettable) NSExpression *textMaxAngle __attribute__((unavailable("Use maximumTextAngle instead.")));

/**
 The maximum line width for text wrapping.
 
 This property is measured in ems.
 
 The default value of this property is an expression that evaluates to the float
 `10`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *maximumTextWidth;


@property (nonatomic, null_resettable) NSExpression *textMaxWidth __attribute__((unavailable("Use maximumTextWidth instead.")));

/**
 Whether symbols in this layer avoid colliding with symbols in adjacent tiles.
 
 If this property is set to `true`, symbols in this layer avoid crossing the
 edge of a tile. You should set this property to `true` if the backing vector
 tiles don’t have enough padding to prevent collisions, or if this layer’s
 `symbolPlacement` property is set to `TMGLSymbolPlacementPoint` but this layer
 is above a symbol layer whose `symbolPlacement` property is set to
 `TMGLSymbolPlacementLine`. You do not need to enable this property to prevent
 clipped labels at tile boundaries.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
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
@property (nonatomic, null_resettable) NSExpression *symbolAvoidsEdges;


@property (nonatomic, null_resettable) NSExpression *symbolAvoidEdges __attribute__((unavailable("Use symbolAvoidsEdges instead.")));

/**
 Label placement relative to its geometry.
 
 The default value of this property is an expression that evaluates to `point`.
 Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLSymbolPlacement` values
 * Any of the following constant string values:
   * `point`: The label is placed at the point where the geometry is located.
   * `line`: The label is placed along the line of the geometry. Can only be
 used on `LineString` and `Polygon` geometries.
   * `line-center`: The label is placed at the center of the line of the
 geometry. Can only be used on `LineString` and `Polygon` geometries. Note that
 a single feature in a vector tile may contain multiple line geometries.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *symbolPlacement;

/**
 Sorts features in ascending order based on this value. Features with lower sort
 keys are drawn and placed first.  When `iconAllowsOverlap` or
 `textAllowsOverlap` is `false`, features with a lower sort key will have
 priority during placement. When `iconAllowsOverlap` or `textAllowsOverlap` is
 set to `YES`, features with a higher sort key will overlap over features with a
 lower sort key.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *symbolSortKey;

/**
 Distance between two symbol anchors.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `250`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `symbolPlacement` is set to an
 expression that evaluates to `line`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 1
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *symbolSpacing;

/**
 Controls the order in which overlapping symbols in the same layer are rendered
 
 The default value of this property is an expression that evaluates to `auto`.
 Set this property to `nil` to reset it to the default value.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLSymbolZOrder` values
 * Any of the following constant string values:
   * `auto`: If `symbol-sort-key` is set, sort based on that. Otherwise sort
 symbols by their y-position relative to the viewport.
   * `viewport-y`: Specify this z order if symbols’ appearance relies on lower
 features overlapping higher features. For example, symbols with a pin-like
 appearance would require this z order.
   * `source`: Specify this z order if the order in which features appear in the
 source is significant.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *symbolZOrder;

/**
 Value to use for a text label.
 
 Within a constant string value, a feature attribute name enclosed in curly
 braces (e.g., `{token}`) is replaced with the value of the named attribute.
 Tokens inside non-constant expressions are ignored; instead, use `tmgl_join:`
 and key path expressions.
 
 The default value of this property is an expression that evaluates to the empty
 string. Set this property to `nil` to reset it to the default value.
  
 You can set this property to an expression containing any of the following:
 
 * Constant string values
 * Formatted expressions.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes

 */
@property (nonatomic, null_resettable) NSExpression *text;


@property (nonatomic, null_resettable) NSExpression *textField __attribute__((unavailable("Use text instead.")));

/**
 If true, the text will be visible even if it collides with other previously
 drawn symbols.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
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
@property (nonatomic, null_resettable) NSExpression *textAllowsOverlap;


@property (nonatomic, null_resettable) NSExpression *textAllowOverlap __attribute__((unavailable("Use textAllowsOverlap instead.")));

/**
 Part of the text placed closest to the anchor.
 
 The default value of this property is an expression that evaluates to `center`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `textVariableAnchor` is set to `nil`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextAnchor` values
 * Any of the following constant string values:
   * `center`: The center of the text is placed closest to the anchor.
   * `left`: The left side of the text is placed closest to the anchor.
   * `right`: The right side of the text is placed closest to the anchor.
   * `top`: The top of the text is placed closest to the anchor.
   * `bottom`: The bottom of the text is placed closest to the anchor.
   * `top-left`: The top left corner of the text is placed closest to the
 anchor.
   * `top-right`: The top right corner of the text is placed closest to the
 anchor.
   * `bottom-left`: The bottom left corner of the text is placed closest to the
 anchor.
   * `bottom-right`: The bottom right corner of the text is placed closest to
 the anchor.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textAnchor;

/**
 An array of font face names used to display the text.
 
 The first font named in the array is applied to the text. For each character in
 the text, if the first font lacks a glyph for the character, the next font is
 applied as a fallback, and so on.
 
 See the “[Customizing Fonts](../customizing-fonts.html)” guide for details on
 how this SDK chooses and renders fonts based on the value of this property.
 
 The default value of this property is an expression that evaluates to the array
 `Open Sans Regular`, `Arial Unicode MS Regular`. Set this property to `nil` to
 reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
  
 You can set this property to an expression containing any of the following:
 
 * Constant array values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textFontNames;


@property (nonatomic, null_resettable) NSExpression *textFont __attribute__((unavailable("Use textFontNames instead.")));

/**
 Font size.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `16`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
  
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textFontSize;


@property (nonatomic, null_resettable) NSExpression *textSize __attribute__((unavailable("Use textFontSize instead.")));

/**
 If true, other symbols can be visible even if they collide with the text.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
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
@property (nonatomic, null_resettable) NSExpression *textIgnoresPlacement;


@property (nonatomic, null_resettable) NSExpression *textIgnorePlacement __attribute__((unavailable("Use textIgnoresPlacement instead.")));

/**
 Text justification options.
 
 The default value of this property is an expression that evaluates to `center`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextJustification` values
 * Any of the following constant string values:
   * `auto`: The text is aligned towards the anchor position.
   * `left`: The text is aligned to the left.
   * `center`: The text is centered.
   * `right`: The text is aligned to the right.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textJustification;


@property (nonatomic, null_resettable) NSExpression *textJustify __attribute__((unavailable("Use textJustification instead.")));

/**
 Text tracking amount.
 
 This property is measured in ems.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textLetterSpacing;

/**
 Text leading value for multi-line text.
 
 This property is measured in ems.
 
 The default value of this property is an expression that evaluates to the float
 `1.2`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textLineHeight;

#if TARGET_OS_IPHONE
/**
 Offset distance of text from its anchor.
 
 This property is measured in ems.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 ems rightward and 0
 ems downward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `textRadialOffset` is set to `nil`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textOffset;
#else
/**
 Offset distance of text from its anchor.
 
 This property is measured in ems.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 ems rightward and 0
 ems upward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `textRadialOffset` is set to `nil`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textOffset;
#endif

/**
 If true, icons will display without their corresponding text when the text
 collides with other symbols and the icon does not.
 
 The default value of this property is an expression that evaluates to `NO`. Set
 this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `iconImageName` is non-`nil`. Otherwise, it is ignored.
 
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
@property (nonatomic, null_resettable, getter=isTextOptional) NSExpression *textOptional;

/**
 Size of the additional area around the text bounding box used for detecting
 symbol collisions.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `2`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textPadding;

/**
 Orientation of text when map is pitched.
 
 The default value of this property is an expression that evaluates to `auto`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextPitchAlignment` values
 * Any of the following constant string values:
   * `map`: The text is aligned to the plane of the map.
   * `viewport`: The text is aligned to the plane of the viewport.
   * `auto`: Automatically matches the value of `text-rotation-alignment`.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textPitchAlignment;

/**
 Radial offset of text, in the direction of the symbol's anchor. Useful in
 combination with `textVariableAnchor`, which defaults to using the
 two-dimensional `textOffset` if present.
 
 This property is measured in ems.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textRadialOffset;

/**
 Rotates the text clockwise.
 
 This property is measured in degrees.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
  
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textRotation;


@property (nonatomic, null_resettable) NSExpression *textRotate __attribute__((unavailable("Use textRotation instead.")));

/**
 In combination with `symbolPlacement`, determines the rotation behavior of the
 individual glyphs forming the text.
 
 The default value of this property is an expression that evaluates to `auto`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextRotationAlignment` values
 * Any of the following constant string values:
   * `map`: When `symbol-placement` is set to `point`, aligns text east-west.
 When `symbol-placement` is set to `line` or `line-center`, aligns text x-axes
 with the line.
   * `viewport`: Produces glyphs whose x-axes are aligned with the x-axis of the
 viewport, regardless of the value of `symbol-placement`.
   * `auto`: When `symbol-placement` is set to `point`, this is equivalent to
 `viewport`. When `symbol-placement` is set to `line` or `line-center`, this is
 equivalent to `map`.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textRotationAlignment;

/**
 Specifies how to capitalize text.
 
 The default value of this property is an expression that evaluates to `none`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextTransform` values
 * Any of the following constant string values:
   * `none`: The text is not altered.
   * `uppercase`: Forces all letters to be displayed in uppercase.
   * `lowercase`: Forces all letters to be displayed in lowercase.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textTransform;

/**
 To increase the chance of placing high-priority labels on the map, you can
 provide an array of `textAnchor` locations: the renderer will attempt to place
 the label at each location, in order, before moving onto the next label. Use
 `textJustify: auto` to choose justification based on anchor position. To apply
 an offset, use the `textRadialOffset` or the two-dimensional `textOffset`.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `symbolPlacement` is set to an expression that evaluates to or
 `TMGLSymbolPlacementPoint`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextAnchor` array values
 * Constant array, in which each element is any of the following constant string
 values:
   * `center`: The center of the text is placed closest to the anchor.
   * `left`: The left side of the text is placed closest to the anchor.
   * `right`: The right side of the text is placed closest to the anchor.
   * `top`: The top of the text is placed closest to the anchor.
   * `bottom`: The bottom of the text is placed closest to the anchor.
   * `top-left`: The top left corner of the text is placed closest to the
 anchor.
   * `top-right`: The top right corner of the text is placed closest to the
 anchor.
   * `bottom-left`: The bottom left corner of the text is placed closest to the
 anchor.
   * `bottom-right`: The bottom right corner of the text is placed closest to
 the anchor.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textVariableAnchor;

/**
 The property allows control over a symbol's orientation. Note that the property
 values act as a hint, so that a symbol whose language doesn’t support the
 provided orientation will be laid out in its natural orientation. Example:
 English point symbol will be rendered horizontally even if array value contains
 single 'vertical' enum value. The order of elements in an array define priority
 order for the placement of an orientation variant.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `symbolPlacement` is set to an expression that evaluates to or
 `TMGLSymbolPlacementPoint`. Otherwise, it is ignored.
  
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextWritingMode` array values
 * Constant array, in which each element is any of the following constant string
 values:
   * `horizontal`: If a text's language supports horizontal writing mode,
 symbols with point placement would be laid out horizontally.
   * `vertical`: If a text's language supports vertical writing mode, symbols
 with point placement would be laid out vertically.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textWritingModes;


@property (nonatomic, null_resettable) NSExpression *textWritingMode __attribute__((unavailable("Use textWritingModes instead.")));

#pragma mark - Accessing the Paint Attributes

#if TARGET_OS_IPHONE
/**
 The tint color to apply to the icon. The `iconImageName` property must be set
 to a template image.
 
 The default value of this property is an expression that evaluates to
 `UIColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconColor;
#else
/**
 The tint color to apply to the icon. The `iconImageName` property must be set
 to a template image.
 
 The default value of this property is an expression that evaluates to
 `NSColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconColor;
#endif

/**
 The transition affecting any changes to this layer’s `iconColor` property.

 This property corresponds to the `icon-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition iconColorTransition;

/**
 Fade out the halo towards the outside.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconHaloBlur;

/**
 The transition affecting any changes to this layer’s `iconHaloBlur` property.

 This property corresponds to the `icon-halo-blur-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition iconHaloBlurTransition;

#if TARGET_OS_IPHONE
/**
 The color of the icon’s halo. The `iconImageName` property must be set to a
 template image.
 
 The default value of this property is an expression that evaluates to
 `UIColor.clearColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconHaloColor;
#else
/**
 The color of the icon’s halo. The `iconImageName` property must be set to a
 template image.
 
 The default value of this property is an expression that evaluates to
 `NSColor.clearColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconHaloColor;
#endif

/**
 The transition affecting any changes to this layer’s `iconHaloColor` property.

 This property corresponds to the `icon-halo-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition iconHaloColorTransition;

/**
 Distance of halo to the icon outline.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconHaloWidth;

/**
 The transition affecting any changes to this layer’s `iconHaloWidth` property.

 This property corresponds to the `icon-halo-width-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition iconHaloWidthTransition;

/**
 The opacity at which the icon will be drawn.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *iconOpacity;

/**
 The transition affecting any changes to this layer’s `iconOpacity` property.

 This property corresponds to the `icon-opacity-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition iconOpacityTransition;

#if TARGET_OS_IPHONE
/**
 Distance that the icon's anchor is moved from its original placement.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 points rightward and 0
 points downward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconTranslation;
#else
/**
 Distance that the icon's anchor is moved from its original placement.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 points rightward and 0
 points upward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`.
 Otherwise, it is ignored.
  
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconTranslation;
#endif

/**
 The transition affecting any changes to this layer’s `iconTranslation` property.

 This property corresponds to the `icon-translate-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition iconTranslationTransition;

@property (nonatomic, null_resettable) NSExpression *iconTranslate __attribute__((unavailable("Use iconTranslation instead.")));

/**
 Controls the frame of reference for `iconTranslation`.
 
 The default value of this property is an expression that evaluates to `map`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `iconImageName` is non-`nil`, and
 `iconTranslation` is non-`nil`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLIconTranslationAnchor` values
 * Any of the following constant string values:
   * `map`: Icons are translated relative to the map.
   * `viewport`: Icons are translated relative to the viewport.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *iconTranslationAnchor;

@property (nonatomic, null_resettable) NSExpression *iconTranslateAnchor __attribute__((unavailable("Use iconTranslationAnchor instead.")));

#if TARGET_OS_IPHONE
/**
 The color with which the text will be drawn.
 
 The default value of this property is an expression that evaluates to
 `UIColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textColor;
#else
/**
 The color with which the text will be drawn.
 
 The default value of this property is an expression that evaluates to
 `NSColor.blackColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textColor;
#endif

/**
 The transition affecting any changes to this layer’s `textColor` property.

 This property corresponds to the `text-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition textColorTransition;

/**
 The halo's fadeout distance towards the outside.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textHaloBlur;

/**
 The transition affecting any changes to this layer’s `textHaloBlur` property.

 This property corresponds to the `text-halo-blur-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition textHaloBlurTransition;

#if TARGET_OS_IPHONE
/**
 The color of the text's halo, which helps it stand out from backgrounds.
 
 The default value of this property is an expression that evaluates to
 `UIColor.clearColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `UIColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textHaloColor;
#else
/**
 The color of the text's halo, which helps it stand out from backgrounds.
 
 The default value of this property is an expression that evaluates to
 `NSColor.clearColor`. Set this property to `nil` to reset it to the default
 value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `NSColor` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textHaloColor;
#endif

/**
 The transition affecting any changes to this layer’s `textHaloColor` property.

 This property corresponds to the `text-halo-color-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition textHaloColorTransition;

/**
 Distance of halo to the font outline. Max text halo width is 1/4 of the
 font-size.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to the float
 `0`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values no less than 0
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textHaloWidth;

/**
 The transition affecting any changes to this layer’s `textHaloWidth` property.

 This property corresponds to the `text-halo-width-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition textHaloWidthTransition;

/**
 The opacity at which the text will be drawn.
 
 The default value of this property is an expression that evaluates to the float
 `1`. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant numeric values between 0 and 1 inclusive
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable and/or
 feature attributes
 */
@property (nonatomic, null_resettable) NSExpression *textOpacity;

/**
 The transition affecting any changes to this layer’s `textOpacity` property.

 This property corresponds to the `text-opacity-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition textOpacityTransition;

#if TARGET_OS_IPHONE
/**
 Distance that the text's anchor is moved from its original placement.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 points rightward and 0
 points downward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textTranslation;
#else
/**
 Distance that the text's anchor is moved from its original placement.
 
 This property is measured in points.
 
 The default value of this property is an expression that evaluates to an
 `NSValue` object containing a `CGVector` struct set to 0 points rightward and 0
 points upward. Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`. Otherwise,
 it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `CGVector` values
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Interpolation and step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation or step functions to
 feature attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textTranslation;
#endif

/**
 The transition affecting any changes to this layer’s `textTranslation` property.

 This property corresponds to the `text-translate-transition` property in the style JSON file format.
*/
@property (nonatomic) TMGLTransition textTranslationTransition;

@property (nonatomic, null_resettable) NSExpression *textTranslate __attribute__((unavailable("Use textTranslation instead.")));

/**
 Controls the frame of reference for `textTranslation`.
 
 The default value of this property is an expression that evaluates to `map`.
 Set this property to `nil` to reset it to the default value.
 
 This property is only applied to the style if `text` is non-`nil`, and
 `textTranslation` is non-`nil`. Otherwise, it is ignored.
 
 You can set this property to an expression containing any of the following:
 
 * Constant `TMGLTextTranslationAnchor` values
 * Any of the following constant string values:
   * `map`: The text is translated relative to the map.
   * `viewport`: The text is translated relative to the viewport.
 * Predefined functions, including mathematical and string operators
 * Conditional expressions
 * Variable assignments and references to assigned variables
 * Step functions applied to the `$zoomLevel` variable
 
 This property does not support applying interpolation functions to the
 `$zoomLevel` variable or applying interpolation or step functions to feature
 attributes.
 */
@property (nonatomic, null_resettable) NSExpression *textTranslationAnchor;

@property (nonatomic, null_resettable) NSExpression *textTranslateAnchor __attribute__((unavailable("Use textTranslationAnchor instead.")));

@end

/**
 Methods for wrapping an enumeration value for a style layer attribute in an
 `TMGLSymbolStyleLayer` object and unwrapping its raw value.
 */
@interface NSValue (TMGLSymbolStyleLayerAdditions)

#pragma mark Working with Symbol Style Layer Attribute Values

/**
 Creates a new value object containing the given `TMGLIconAnchor` enumeration.

 @param iconAnchor The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLIconAnchor:(TMGLIconAnchor)iconAnchor;

/**
 The `TMGLIconAnchor` enumeration representation of the value.
 */
@property (readonly) TMGLIconAnchor TMGLIconAnchorValue;

/**
 Creates a new value object containing the given `TMGLIconPitchAlignment` enumeration.

 @param iconPitchAlignment The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLIconPitchAlignment:(TMGLIconPitchAlignment)iconPitchAlignment;

/**
 The `TMGLIconPitchAlignment` enumeration representation of the value.
 */
@property (readonly) TMGLIconPitchAlignment TMGLIconPitchAlignmentValue;

/**
 Creates a new value object containing the given `TMGLIconRotationAlignment` enumeration.

 @param iconRotationAlignment The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLIconRotationAlignment:(TMGLIconRotationAlignment)iconRotationAlignment;

/**
 The `TMGLIconRotationAlignment` enumeration representation of the value.
 */
@property (readonly) TMGLIconRotationAlignment TMGLIconRotationAlignmentValue;

/**
 Creates a new value object containing the given `TMGLIconTextFit` enumeration.

 @param iconTextFit The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLIconTextFit:(TMGLIconTextFit)iconTextFit;

/**
 The `TMGLIconTextFit` enumeration representation of the value.
 */
@property (readonly) TMGLIconTextFit TMGLIconTextFitValue;

/**
 Creates a new value object containing the given `TMGLSymbolPlacement` enumeration.

 @param symbolPlacement The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLSymbolPlacement:(TMGLSymbolPlacement)symbolPlacement;

/**
 The `TMGLSymbolPlacement` enumeration representation of the value.
 */
@property (readonly) TMGLSymbolPlacement TMGLSymbolPlacementValue;

/**
 Creates a new value object containing the given `TMGLSymbolZOrder` enumeration.

 @param symbolZOrder The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLSymbolZOrder:(TMGLSymbolZOrder)symbolZOrder;

/**
 The `TMGLSymbolZOrder` enumeration representation of the value.
 */
@property (readonly) TMGLSymbolZOrder TMGLSymbolZOrderValue;

/**
 Creates a new value object containing the given `TMGLTextAnchor` enumeration.

 @param textAnchor The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextAnchor:(TMGLTextAnchor)textAnchor;

/**
 The `TMGLTextAnchor` enumeration representation of the value.
 */
@property (readonly) TMGLTextAnchor TMGLTextAnchorValue;

/**
 Creates a new value object containing the given `TMGLTextJustification` enumeration.

 @param textJustification The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextJustification:(TMGLTextJustification)textJustification;

/**
 The `TMGLTextJustification` enumeration representation of the value.
 */
@property (readonly) TMGLTextJustification TMGLTextJustificationValue;

/**
 Creates a new value object containing the given `TMGLTextPitchAlignment` enumeration.

 @param textPitchAlignment The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextPitchAlignment:(TMGLTextPitchAlignment)textPitchAlignment;

/**
 The `TMGLTextPitchAlignment` enumeration representation of the value.
 */
@property (readonly) TMGLTextPitchAlignment TMGLTextPitchAlignmentValue;

/**
 Creates a new value object containing the given `TMGLTextRotationAlignment` enumeration.

 @param textRotationAlignment The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextRotationAlignment:(TMGLTextRotationAlignment)textRotationAlignment;

/**
 The `TMGLTextRotationAlignment` enumeration representation of the value.
 */
@property (readonly) TMGLTextRotationAlignment TMGLTextRotationAlignmentValue;

/**
 Creates a new value object containing the given `TMGLTextTransform` enumeration.

 @param textTransform The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextTransform:(TMGLTextTransform)textTransform;

/**
 The `TMGLTextTransform` enumeration representation of the value.
 */
@property (readonly) TMGLTextTransform TMGLTextTransformValue;

/**
 Creates a new value object containing the given `TMGLTextWritingMode` enumeration.

 @param textWritingModes The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextWritingMode:(TMGLTextWritingMode)textWritingModes;

/**
 The `TMGLTextWritingMode` enumeration representation of the value.
 */
@property (readonly) TMGLTextWritingMode TMGLTextWritingModeValue;

/**
 Creates a new value object containing the given `TMGLIconTranslationAnchor` enumeration.

 @param iconTranslationAnchor The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLIconTranslationAnchor:(TMGLIconTranslationAnchor)iconTranslationAnchor;

/**
 The `TMGLIconTranslationAnchor` enumeration representation of the value.
 */
@property (readonly) TMGLIconTranslationAnchor TMGLIconTranslationAnchorValue;

/**
 Creates a new value object containing the given `TMGLTextTranslationAnchor` enumeration.

 @param textTranslationAnchor The value for the new object.
 @return A new value object that contains the enumeration value.
 */
+ (instancetype)valueWithTMGLTextTranslationAnchor:(TMGLTextTranslationAnchor)textTranslationAnchor;

/**
 The `TMGLTextTranslationAnchor` enumeration representation of the value.
 */
@property (readonly) TMGLTextTranslationAnchor TMGLTextTranslationAnchorValue;

@end

NS_ASSUME_NONNULL_END
