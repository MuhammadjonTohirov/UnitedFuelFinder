#import "TMGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Type of event used when subscribing to and unsubscribing from an `TMGLObservable`.
 */
typedef NSString *TMGLEventType NS_TYPED_EXTENSIBLE_ENUM;

// TODO: Doc
FOUNDATION_EXPORT TMGL_EXPORT TMGLEventType const TMGLEventTypeResourceRequest;


/**
 Generic Event used when notifying an `TMGLObserver`. This is not intended nor
 expected to be created by the application developer. It will be provided as
 part of an `TMGLObservable` notification.
 */
TMGL_EXPORT
@interface TMGLEvent: NSObject

/// Type of an event. Matches an original event type used for a subscription.
@property (nonatomic, readonly, copy) TMGLEventType type;

/// Timestamp taken at the time of an event creation, relative to the Unix epoch.
@property (nonatomic, readonly) NSTimeInterval begin;

/// Timestamp taken at the time of an event completion. For a non-interval
/// (single-shot) events, migth be equal to an event's `begin` timestamp.
/// Relative to the Unix epoch.
@property (nonatomic, readonly) NSTimeInterval end;

/// Generic property for the event's data. Supported types are: `NSNumber` (int64,
/// uint64, bool, double), `NSString`, `NSArray`, `NSDictionary`.
@property (nonatomic, readonly, copy) id data;

/// Test for equality. Note this compares all properties except `data`.
- (BOOL)isEqualToEvent:(TMGLEvent *)otherEvent;
@end

NS_ASSUME_NONNULL_END
