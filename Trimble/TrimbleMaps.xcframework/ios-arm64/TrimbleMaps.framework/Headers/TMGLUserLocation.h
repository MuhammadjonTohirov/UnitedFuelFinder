#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TMGLFoundation.h"
#import "TMGLAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The TMGLUserLocation class defines a specific type of annotation that identifies
 the user’s current location. You do not create instances of this class
 directly. Instead, you retrieve an existing `TMGLUserLocation` object from the
 `userLocation` property of the map view displayed in your application.
 
 #### Related examples
 See the <a href="https://docs.mapbox.com/ios/maps/examples/user-location-annotation/">
 Customize the user location annotation</a> example to learn how to overide the
 default user location annotation.
 */
TMGL_EXPORT
@interface TMGLUserLocation : NSObject <TMGLAnnotation, NSSecureCoding>

#pragma mark Determining the User’s Position

/**
 The current location of the device. (read-only)

 This property returns `nil` if the user’s location has not yet been determined.
 */
@property (nonatomic, readonly, nullable) CLLocation *location;

/**
 A Boolean value indicating whether the user’s location is currently being
 updated. (read-only)
 */
@property (nonatomic, readonly, getter=isUpdating) BOOL updating;

/**
 The heading of the user location. (read-only)

 This property is `nil` if the user location tracking mode is not
 `TMGLUserTrackingModeFollowWithHeading` or if
 `TMGLMapView.showsUserHeadingIndicator` is disabled.
 */
@property (nonatomic, readonly, nullable) CLHeading *heading;

#pragma mark Accessing the User Annotation Text

/** The title to display for the user location annotation. */
@property (nonatomic, copy) NSString *title;

/** The subtitle to display for the user location annotation. */
@property (nonatomic, copy, nullable) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
