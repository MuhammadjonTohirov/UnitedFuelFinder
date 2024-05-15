#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@class TMGLNetworkConfiguration;

@protocol TMGLNetworkConfigurationDelegate <NSObject>
@optional

/**
 :nodoc:
 Provides an `NSURLSession` object for the specified `TMGLNetworkConfiguration`.
 This API should be considered experimental, likely to be removed or changed in
 future releases.

 This method is called from background threads, i.e. it is not called on the main
 thread.

 @note Background sessions (i.e. created with
 `-[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:]`)
 and sessions created with a delegate that conforms to `NSURLSessionDataDelegate`
 are not supported at this time.
 */
- (NSURLSession *)sessionForNetworkConfiguration:(TMGLNetworkConfiguration *)configuration;
@end


/**
 The `TMGLNetworkConfiguration` object provides a global way to set a base
 `NSURLSessionConfiguration`, and other resources.
 */
TMGL_EXPORT
@interface TMGLNetworkConfiguration : NSObject

/**
 :nodoc:
 Delegate for the `TMGLNetworkConfiguration` class.
 */
@property (nonatomic, weak) id<TMGLNetworkConfigurationDelegate> delegate;

/**
 Returns the shared instance of the `TMGLNetworkConfiguration` class.
 */
@property (class, nonatomic, readonly) TMGLNetworkConfiguration *sharedManager;

/**
 The session configuration object that is used by the `NSURLSession` objects
 in this SDK.
 
 If this property is set to nil or if no session configuration is provided this property
 is set to the default session configuration.
 
 Assign this object before instantiating any `TMGLMapView` object, or using
 `TMGLOfflineStorage`
 
 @note `NSURLSession` objects store a copy of this configuration. Any further changes
 to mutable properties on this configuration object passed to a session’s initializer
 will not affect the behavior of that session.

 @note Background sessions are not currently supported.
 */
@property (atomic, strong, null_resettable) NSURLSessionConfiguration *sessionConfiguration;

/**
 A Boolean value indicating whether the current `NSURLSessionConfiguration` stops
 making network requests.
 
 When this property is set to `NO` `TMGLMapView` will rely solely on pre-cached
 tiles.
  
 The default value of this property is `YES`.
 */
@property (atomic, assign) BOOL connected;

@end

NS_ASSUME_NONNULL_END
