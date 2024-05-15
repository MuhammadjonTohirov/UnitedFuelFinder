#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TMGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `TMGLDistanceFormatter` implements a formatter object meant to be used for
 geographic distances. The user’s current locale will be used by default
 but it can be overriden by changing the locale property of the numberFormatter.
 */
TMGL_EXPORT
@interface TMGLDistanceFormatter : NSLengthFormatter

/**
 Returns a localized formatted string for the provided distance.
 
 @param distance The distance, measured in meters.
 @return A localized formatted distance string including units.
 */
- (NSString *)stringFromDistance:(CLLocationDistance)distance;

@end

NS_ASSUME_NONNULL_END
