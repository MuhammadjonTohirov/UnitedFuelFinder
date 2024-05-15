#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"
#import "TMGLTypes.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN TMGL_EXPORT TMGLExceptionName const TMGLInvalidStyleSourceException;

/**
 `TMGLSource` is an abstract base class for map content sources. A map content
 source supplies content to be shown on the map. A source is added to an
 `TMGLStyle` object along with an `TMGLForegroundStyleLayer` object. The
 foreground style layer defines the appearance of any content supplied by the
 source.

 Each source defined by the style JSON file is represented at runtime by an
 `TMGLSource` object that you can use to refine the map’s content. You can also
 add and remove sources dynamically using methods such as
 `-[TMGLStyle addSource:]` and `-[TMGLStyle sourceWithIdentifier:]`.

 Create instances of `TMGLShapeSource`, `TMGLComputedShapeSource`,
 `TMGLImageSource`, and the concrete subclasses of `TMGLTileSource`
 (`TMGLVectorTileSource` and `TMGLRasterTileSource`) in order to use `TMGLSource`’s
 properties and methods. Do not create instances of `TMGLSource` directly, and do
 not create your own subclasses of this class.
 */
TMGL_EXPORT
@interface TMGLSource : NSObject

#pragma mark Initializing a Source

- (instancetype)init __attribute__((unavailable("Use -initWithIdentifier: instead.")));

/**
 Returns a source initialized with an identifier.

 After initializing and configuring the source, add it to a map view’s style
 using the `-[TMGLStyle addSource:]` method.

 @param identifier A string that uniquely identifies the source in the style to
    which it is added.
 @return An initialized source.
 */
- (instancetype)initWithIdentifier:(NSString *)identifier;

#pragma mark Identifying a Source

/**
 A string that uniquely identifies the source in the style to which it is added.
 */
@property (nonatomic, copy) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
