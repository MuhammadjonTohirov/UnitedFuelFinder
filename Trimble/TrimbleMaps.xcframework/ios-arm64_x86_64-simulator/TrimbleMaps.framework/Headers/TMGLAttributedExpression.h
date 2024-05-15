#import "TMGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/** Options for `TMGLAttributedExpression.attributes`. */
typedef NSString * TMGLAttributedExpressionKey NS_TYPED_ENUM;

/** The font name string array expression used to format the text. */
FOUNDATION_EXTERN TMGL_EXPORT TMGLAttributedExpressionKey const TMGLFontNamesAttribute;

/** The font scale number expression relative to `TMGLSymbolStyleLayer.textFontSize` used to format the text. */
FOUNDATION_EXTERN TMGL_EXPORT TMGLAttributedExpressionKey const TMGLFontScaleAttribute;

/** The font color expression used to format the text. */
FOUNDATION_EXTERN TMGL_EXPORT TMGLAttributedExpressionKey const TMGLFontColorAttribute;

/**
 An `TMGLAttributedExpression` object associates text formatting attibutes (such as font size or
 font names) to an `NSExpression`.
 
 ### Example
 ```swift
 let redColor = UIColor.red
 let expression = NSExpression(forConstantValue: "Foo")
 let attributes: [TMGLAttributedExpressionKey: NSExpression] = [.fontNamesAttribute : NSExpression(forConstantValue: ["DIN Offc Pro Italic",
                                                                                                                     "Arial Unicode MS Regular"]),
                                                               .fontScaleAttribute: NSExpression(forConstantValue: 1.2),
                                                               .fontColorAttribute: NSExpression(forConstantValue: redColor)]
 let attributedExpression = TMGLAttributedExpression(expression, attributes:attributes)
 ```
 
 */
TMGL_EXPORT
@interface TMGLAttributedExpression : NSObject

/**
 The expression content of the receiver as `NSExpression`.
 */
@property (strong, nonatomic) NSExpression *expression;

#if TARGET_OS_IPHONE
/**
 The formatting attributes dictionary.
 Key | Value Type
 --- | ---
 `TMGLFontNamesAttribute` | An `NSExpression` evaluating to an `NSString` array.
 `TMGLFontScaleAttribute` | An `NSExpression` evaluating to an `NSNumber` value.
 `TMGLFontColorAttribute` | An `NSExpression` evaluating to an `UIColor`.

 */
@property (strong, nonatomic, readonly) NSDictionary<TMGLAttributedExpressionKey, NSExpression *> *attributes;
#else
/**
 The formatting attributes dictionary.
 Key | Value Type
 --- | ---
 `TMGLFontNamesAttribute` | An `NSExpression` evaluating to an `NSString` array.
 `TMGLFontScaleAttribute` | An `NSExpression` evaluating to an `NSNumber` value.
 `TMGLFontColorAttribute` | An `NSExpression` evaluating to an `NSColor` on macos.
 */
@property (strong, nonatomic, readonly) NSDictionary<TMGLAttributedExpressionKey, NSExpression *> *attributes;
#endif


/**
 Returns an `TMGLAttributedExpression` object initialized with an expression and no attribute information.
 */
- (instancetype)initWithExpression:(NSExpression *)expression;

/** 
 Returns an `TMGLAttributedExpression` object initialized with an expression and text format attributes.
 */
- (instancetype)initWithExpression:(NSExpression *)expression attributes:(nonnull NSDictionary <TMGLAttributedExpressionKey, NSExpression *> *)attrs;

/**
 Creates an `TMGLAttributedExpression` object initialized with an expression and the format attributes for font names and font size.
 */
+ (instancetype)attributedExpression:(NSExpression *)expression fontNames:(nullable NSArray<NSString*> *)fontNames fontScale:(nullable NSNumber *)fontScale;

/**
 Creates an `TMGLAttributedExpression` object initialized with an expression and the format attributes dictionary.
 */
+ (instancetype)attributedExpression:(NSExpression *)expression attributes:(nonnull NSDictionary <TMGLAttributedExpressionKey, NSExpression *> *)attrs;

@end

NS_ASSUME_NONNULL_END
