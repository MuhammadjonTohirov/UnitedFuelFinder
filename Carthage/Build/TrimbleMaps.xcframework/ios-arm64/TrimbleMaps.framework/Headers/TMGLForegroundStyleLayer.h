#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"
#import "TMGLStyleLayer.h"

NS_ASSUME_NONNULL_BEGIN

@class TMGLSource;

/**
 `TMGLForegroundStyleLayer` is an abstract superclass for style layers whose
 content is defined by an `TMGLSource` object.

 Create instances of `TMGLRasterStyleLayer`, `TMGLHillshadeStyleLayer`, and the
 concrete subclasses of `TMGLVectorStyleLayer` in order to use
 `TMGLForegroundStyleLayer`'s methods. Do not create instances of
 `TMGLForegroundStyleLayer` directly, and do not create your own subclasses of
 this class.
 */
TMGL_EXPORT
@interface TMGLForegroundStyleLayer : TMGLStyleLayer

#pragma mark Initializing a Style Layer

- (instancetype)init __attribute__((unavailable("Use -init methods of concrete subclasses instead.")));

#pragma mark Specifying a Style Layer’s Content

/**
 Identifier of the source from which the receiver obtains the data to style.
 */
@property (nonatomic, readonly, nullable) NSString *sourceIdentifier;

@end

NS_ASSUME_NONNULL_END
