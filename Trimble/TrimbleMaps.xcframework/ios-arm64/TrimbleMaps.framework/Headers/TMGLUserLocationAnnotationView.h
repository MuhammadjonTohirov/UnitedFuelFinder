#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "TMGLFoundation.h"
#import "TMGLAnnotationView.h"

NS_ASSUME_NONNULL_BEGIN

@class TMGLMapView;
@class TMGLUserLocation;

/** View representing an `TMGLUserLocation` on screen. */
TMGL_EXPORT
@interface TMGLUserLocationAnnotationView : TMGLAnnotationView

/**
 Returns the associated map view.

 The value of this property is nil during initialization.
 */
@property (nonatomic, readonly, weak, nullable) TMGLMapView *mapView;

/**
 Returns the annotation object indicating the user’s current location.

 The value of this property is nil during initialization and while user tracking
 is inactive.
 
 #### Related examples
 See the <a href="https://docs.mapbox.com/ios/maps/examples/user-location-annotation/">
 Customize the user location annotation</a> example to learn how to customize
 the default user location annotation object.
 */
@property (nonatomic, readonly, weak, nullable) TMGLUserLocation *userLocation;

/**
 Returns the layer that should be used for annotation selection hit testing.

 The default value of this property is the presentation layer of the view’s Core
 Animation layer. When subclassing, you may override this property to specify a
 different layer to be used for hit testing. This can be useful when you wish to
 limit the interactive area of the annotation to a specific sublayer.
 */
@property (nonatomic, readonly, weak) CALayer *hitTestLayer;

/**
 Updates the user location annotation.

 Use this method to update the appearance of the user location annotation. This
 method is called by the associated map view when it has determined that the
 user location annotation needs to be updated. This can happen in response to
 user interaction, a change in the user’s location, when the user tracking mode
 changes, or when the viewport changes.

 @note During user interaction with the map, this method may be called many
 times to update the user location annotation. Therefore, your implementation of
 this method should be as lightweight as possible to avoid negatively affecting
 performance.
 */
- (void)update;

@end

NS_ASSUME_NONNULL_END
