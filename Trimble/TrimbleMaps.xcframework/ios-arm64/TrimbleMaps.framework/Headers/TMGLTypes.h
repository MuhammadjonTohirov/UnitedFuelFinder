#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "TMGLFoundation.h"

#pragma once

#if TARGET_OS_IPHONE
@class UIImage;
#define TMGLImage UIImage
#else
@class NSImage;
#define TMGLImage NSImage
#endif

#if TARGET_OS_IPHONE
@class UIColor;
#define TMGLColor UIColor
#else
@class NSColor;
#define TMGLColor NSColor
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NSString *TMGLExceptionName NS_TYPED_EXTENSIBLE_ENUM;

/**
 :nodoc: Generic exceptions used across multiple disparate classes. Exceptions
 that are unique to a class or class-cluster should be defined in those headers.
 */
FOUNDATION_EXTERN TMGL_EXPORT TMGLExceptionName const TMGLAbstractClassException;

/** Indicates an error occurred in the Mapbox SDK. */
FOUNDATION_EXTERN TMGL_EXPORT NSErrorDomain const TMGLErrorDomain;

/** Error constants for the Mapbox SDK. */
typedef NS_ENUM(NSInteger, TMGLErrorCode) {
    /** An unknown error occurred. */
    TMGLErrorCodeUnknown = -1,
    /** The resource could not be found. */
    TMGLErrorCodeNotFound = 1,
    /** The connection received an invalid server response. */
    TMGLErrorCodeBadServerResponse = 2,
    /** An attempt to establish a connection failed. */
    TMGLErrorCodeConnectionFailed = 3,
    /** A style parse error occurred while attempting to load the map. */
    TMGLErrorCodeParseStyleFailed = 4,
    /** An attempt to load the style failed. */
    TMGLErrorCodeLoadStyleFailed = 5,
    /** An error occurred while snapshotting the map. */
    TMGLErrorCodeSnapshotFailed = 6,
    /** Source is in use and cannot be removed */
    TMGLErrorCodeSourceIsInUseCannotRemove = 7,
    /** Source is in use and cannot be removed */
    TMGLErrorCodeSourceIdentifierMismatch = 8,
    /** An error occurred while modifying the offline storage database */
    TMGLErrorCodeModifyingOfflineStorageFailed = 9,
    /** Source is invalid and cannot be removed from the style (e.g. after a style change) */
    TMGLErrorCodeSourceCannotBeRemovedFromStyle  = 10,
    /** An error occurred while rendering */
    TMGLErrorCodeRenderingError = 11,
};

/** Options for enabling debugging features in an `TMGLMapView` instance. */
typedef NS_OPTIONS(NSUInteger, TMGLMapDebugMaskOptions) {
    /** Edges of tile boundaries are shown as thick, red lines to help diagnose
        tile clipping issues. */
    TMGLMapDebugTileBoundariesMask = 1 << 1,
    /** Each tile shows its tile coordinate (x/y/z) in the upper-left corner. */
    TMGLMapDebugTileInfoMask = 1 << 2,
    /** Each tile shows a timestamp indicating when it was loaded. */
    TMGLMapDebugTimestampsMask = 1 << 3,
    /** Edges of glyphs and symbols are shown as faint, green lines to help
        diagnose collision and label placement issues. */
    TMGLMapDebugCollisionBoxesMask = 1 << 4,
    /** Each drawing operation is replaced by a translucent fill. Overlapping
        drawing operations appear more prominent to help diagnose overdrawing.
        @note This option does nothing in Release builds of the SDK. */
    TMGLMapDebugOverdrawVisualizationMask = 1 << 5,
#if !TARGET_OS_IPHONE
    /** The stencil buffer is shown instead of the color buffer.
        @note This option does nothing in Release builds of the SDK. */
    TMGLMapDebugStencilBufferMask = 1 << 6,
    /** The depth buffer is shown instead of the color buffer.
        @note This option does nothing in Release builds of the SDK. */
    TMGLMapDebugDepthBufferMask = 1 << 7,
#endif
};

/**
 A structure containing information about a transition.
 */
typedef struct __attribute__((objc_boxable)) TMGLTransition {
    /**
     The amount of time the animation should take, not including the delay.
     */
    NSTimeInterval duration;
    
    /**
     The amount of time in seconds to wait before beginning the animation.
     */
    NSTimeInterval delay; 
} TMGLTransition;

NS_INLINE NSString *TMGLStringFromMGLTransition(TMGLTransition transition) {
    return [NSString stringWithFormat:@"transition { duration: %f, delay: %f }", transition.duration, transition.delay];
}

/**
 Creates a new `TMGLTransition` from the given duration and delay.
 
 @param duration The amount of time the animation should take, not including 
 the delay.
 @param delay The amount of time in seconds to wait before beginning the 
 animation.
 
 @return Returns a `TMGLTransition` struct containing the transition attributes.
 */
NS_INLINE TMGLTransition TMGLTransitionMake(NSTimeInterval duration, NSTimeInterval delay) {
    TMGLTransition transition;
    transition.duration = duration;
    transition.delay = delay;
    
    return transition;
}

/**
 Constants indicating the visibility of different map ornaments.
 */
typedef NS_ENUM(NSInteger, TMGLOrnamentVisibility) {
    /** A constant indicating that the ornament adapts to the current map state. */
    TMGLOrnamentVisibilityAdaptive,
    /** A constant indicating that the ornament is always hidden. */
    TMGLOrnamentVisibilityHidden,
    /** A constant indicating that the ornament is always visible. */
    TMGLOrnamentVisibilityVisible
};

NS_ASSUME_NONNULL_END
