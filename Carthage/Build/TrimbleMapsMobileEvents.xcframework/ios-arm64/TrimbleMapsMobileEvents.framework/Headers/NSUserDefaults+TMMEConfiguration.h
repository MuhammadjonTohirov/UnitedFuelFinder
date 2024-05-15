#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: -

@class TMMEDate;

@interface NSUserDefaults (TMMEConfiguration)

/// the shared NSUserDefaults object with the TMMEConfigurationDomain loaded and our defaults registered
+ (instancetype)tmme_configuration;

// MARK: - Event Manager Configuration

/// Interval to wait before starting up when the application launches
@property (nonatomic, readonly) NSTimeInterval tmme_startupDelay;

/// Number of events to put into a batch, the TMMEEventsManager will flush it's queue at this threshold
@property (nonatomic, readonly) NSUInteger tmme_eventFlushCount;

/// Maximum Time interval between event flush
@property (nonatomic, readonly) NSTimeInterval tmme_eventFlushInterval;

/// Interval at which we rotate the unique identifier for this SDK instance
@property (nonatomic, readonly) NSTimeInterval tmme_identifierRotationInterval;

/// Interval at which we check for updated configuration
@property (nonatomic, readonly) NSTimeInterval tmme_configUpdateInterval;

/// Tag for events
@property (nonatomic, readonly) NSString *tmme_eventTag;

// MARK: - Volatile Configuration

/// Access Token
@property (nonatomic, copy, setter=tmme_setAccessToken:) NSString *tmme_accessToken;

/// User-Agent Base
@property (nonatomic, copy, setter=tmme_setLegacyUserAgentBase:) NSString *tmme_legacyUserAgentBase;

/// Host SDK Version
@property (nonatomic, copy, setter=tmme_setLegacyHostSDKVersion:) NSString *tmme_legacyHostSDKVersion;

/// CN Region Setting
@property (nonatomic, assign, setter=tmme_setIsCNRegion:) BOOL tmme_isCNRegion;

// MARK: - Service Configuration

/// API Service URL for the current region
@property (nonatomic, readonly) NSURL *tmme_APIServiceURL;

/// Events Service URL for the current region
@property (nonatomic, readonly) NSURL *tmme_eventsServiceURL;

/// Config Service URL for the current region
@property (nonatomic, readonly) NSURL *tmme_configServiceURL;

/// Reformed User-Agent String
@property (nonatomic, readonly) NSString *tmme_userAgentString;

/// Legacy User-Agent String
@property (nonatomic, readonly) NSString *tmme_legacyUserAgentString;

// MARK: - Update Configuration

@property (nonatomic, nullable, setter=tmme_setConfigUpdateDate:) TMMEDate *tmme_configUpdateDate;

// MARK: - Location Collection

/// This property is only settable by the end user
@property (nonatomic, setter=tmme_setIsCollectionEnabled:) BOOL tmme_isCollectionEnabled;

/// This property is volatile
@property (nonatomic, readonly) BOOL tmme_isCollectionEnabledInSimulator;

// MARK: - Background Collection

/// Bool, is background collection enabled
@property (nonatomic, readonly) BOOL tmme_isCollectionEnabledInBackground;

/// Interval to wait before starting telemetry collection in the background
@property (nonatomic, readonly) NSTimeInterval tmme_backgroundStartupDelay;

/// Distance to set for the background collection geo-fence
@property (nonatomic, readonly) CLLocationDistance tmme_backgroundGeofence;

/// Horizontal accuracy value set for filtering locations
@property (nonatomic, readonly) CLLocationAccuracy tmme_horizontalAccuracy;

// MARK: - Certificate Pinning and Revocation

/// An array of revoked public key hashes
@property (nonatomic, readonly) NSArray<NSString *>*tmme_certificateRevocationList;

/// The Certificate Pinning config
@property (nonatomic, readonly) NSDictionary *tmme_certificatePinningConfig;

@end

NS_ASSUME_NONNULL_END
