#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "TMGLFoundation.h"
#import "TMGLTypes.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *TMGLStyleFunctionOption NS_STRING_ENUM NS_UNAVAILABLE;

FOUNDATION_EXTERN TMGL_EXPORT const TMGLStyleFunctionOption TMGLStyleFunctionOptionInterpolationBase __attribute__((unavailable("Use NSExpression instead, applying the tmgl_interpolate:withCurveType:parameters:stops: function with a curve type of “exponential” and a non-nil parameter.")));

FOUNDATION_EXTERN TMGL_EXPORT const TMGLStyleFunctionOption TMGLStyleFunctionOptionDefaultValue __attribute__((unavailable("Use +[NSExpression expressionForConditional:trueExpression:falseExpression:] instead.")));

typedef NS_ENUM(NSUInteger, TMGLInterpolationMode) {
    TMGLInterpolationModeExponential __attribute__((unavailable("Use NSExpression instead, applying the tmgl_interpolate:withCurveType:parameters:stops: function with a curve type of “exponential”."))) = 0,
    TMGLInterpolationModeInterval __attribute__((unavailable("Use NSExpression instead, calling the tmgl_step:from:stops: function."))),
    TMGLInterpolationModeCategorical __attribute__((unavailable("Use NSExpression instead."))),
    TMGLInterpolationModeIdentity __attribute__((unavailable("Use +[NSExpression expressionForKeyPath:] instead.")))
} __attribute__((unavailable("Use NSExpression instead.")));

TMGL_EXPORT __attribute__((unavailable("Use NSExpression instead.")))
@interface TMGLStyleValue<T> : NSObject
@end

TMGL_EXPORT __attribute__((unavailable("Use +[NSExpression expressionForConstantValue:] instead.")))
@interface TMGLConstantStyleValue<T> : TMGLStyleValue<T>
@end

@compatibility_alias TMGLStyleConstantValue TMGLConstantStyleValue;

TMGL_EXPORT __attribute__((unavailable("Use NSExpression instead, calling the tmgl_step:from:stops: or tmgl_interpolate:withCurveType:parameters:stops: function.")))
@interface TMGLStyleFunction<T> : TMGLStyleValue<T>
@end

TMGL_EXPORT __attribute__((unavailable("Use NSExpression instead, applying the tmgl_step:from:stops: or tmgl_interpolate:withCurveType:parameters:stops: function to the $zoomLevel variable.")))
@interface TMGLCameraStyleFunction<T> : TMGLStyleFunction<T>
@end

TMGL_EXPORT __attribute__((unavailable("Use NSExpression instead, applying the tmgl_step:from:stops: or tmgl_interpolate:withCurveType:parameters:stops: function to a key path expression.")))
@interface TMGLSourceStyleFunction<T> : TMGLStyleFunction<T>
@end

TMGL_EXPORT __attribute__((unavailable("Use a NSExpression instead with nested tmgl_step:from:stops: or tmgl_interpolate:withCurveType:parameters:stops: function calls.")))
@interface TMGLCompositeStyleFunction<T> : TMGLStyleFunction<T>
@end

NS_ASSUME_NONNULL_END
