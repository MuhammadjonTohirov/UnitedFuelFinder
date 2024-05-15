#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TMMETypes.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMEEvent;
@class TMMEAPIClient;
@protocol TMMEAPIClient;

@protocol TMMEEventsManagerDelegate;

/*! @brief Mapbox Mobile Events Manager */
@interface TMMEEventsManager : NSObject

/*! @brief events manager delegate */
@property (nonatomic, weak) id<TMMEEventsManagerDelegate> delegate;
@property (nonatomic, copy) NSString *skuId;
@property (nonatomic) id<TMMEAPIClient> apiClient TMME_DEPRECATED;

#pragma mark -

/*! @brief Shared Mapbox Mobile Events Manager */
+ (instancetype)sharedManager;

#pragma mark - Exception Free API

/*!
 @brief designated initilizer
 @param accessToken Mapbox Access Token
 @param userAgentBase UserAgent base string, in RFC 2616 format
 @param hostSDKVersion SDK version, in Semantic Versioning 2.0.0 format
 @throws no exceptions
*/
- (void)initializeWithAccessToken:(NSString *)accessToken userAgentBase:(NSString *)userAgentBase hostSDKVersion:(NSString *)hostSDKVersion;

/*! @brief pauseOrResumeMetricsCollectionIfRequired
    @throws no exceptions */
- (void)pauseOrResumeMetricsCollectionIfRequired;

/*! @brief flush the events pipeline, sending any pending events
    @throws no exceptions */
- (void)flush;

/*! @brief resetEventQueuing
    @throws no exceptions */
- (void)resetEventQueuing;

/*! @brief sendTurnstileEvent
    @throws no exceptions */
- (void)sendTurnstileEvent;

/*! @brief sendTelemetryMetricsEvent
    @throws no exceptions */
- (void)sendTelemetryMetricsEvent;

/*! @brief disableLocationMetrics */
- (void)disableLocationMetrics;

#pragma mark -

/*! @brief enqueueEventWithName:
    @param name event name */
- (void)enqueueEventWithName:(NSString *)name;

/*! @brief enqueueEventWithName:attributes:
    @param name event name
    @param attributes event attributes */
- (void)enqueueEventWithName:(NSString *)name attributes:(TMMEEventAttributes *)attributes;

/*! @brief postMetadata:filePaths:completionHander:
    @param metadata array of metadata
    @param filePaths array of file paths
    @param completionHandler completion handler block
*/
- (void)postMetadata:(NSArray *)metadata filePaths:(NSArray *)filePaths completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;

#pragma mark - Error & Exception Reporting

/*! @brief report an error to the telemetry service
    @return the report event, for inspection or logging
    @throws no exceptions */
- (TMMEEvent *)reportError:(NSError *)eventsError;

/*! @brief report an exception to the telemetry service
    @return the report event, for inspection or logging
    @throws no exceptions */
- (TMMEEvent *)reportException:(NSException *)eventException;

/*! @brief Sets the handler for debug logging in TMMEEventLogger. If this property is set to nil or if no custom handler is provided this property is set to the default handler.
    @param handler The handler this SDK uses to log messages.
*/
- (void)setDebugHandler:(void (^)(NSUInteger, NSString *, NSString *))handler;

@end

// MARK: -

/// Events Manager Delegate
@protocol TMMEEventsManagerDelegate <NSObject>
@optional

/*! @brief eventsManager:didUpdateLocations: reports location updates to the delegate
    @param eventsManager shared manager
    @param locations array of CLLocations
*/
- (void)eventsManager:(TMMEEventsManager *)eventsManager didUpdateLocations:(NSArray<CLLocation *> *)locations;

/*! @brief reports errors encountered by the Events Manager to the delegate
    @param eventsManager the shared events manager
    @param error the encountered NSError object
*/
- (void)eventsManager:(TMMEEventsManager *)eventsManager didEncounterError:(NSError *)error;

/*! @brief reports to the delegate when an event is added to the queue
    @param eventsManager the shared events manager
    @param enqueued the event that will be sent when the queue is flushed
*/
- (void)eventsManager:(TMMEEventsManager *)eventsManager didEnqueueEvent:(TMMEEvent *)enqueued;

/*! @brief reports to the delegate when events are successfully sent
    @param eventsManager the shared events manager
    @param events an array of events which were sent to the events service
*/
- (void)eventsManager:(TMMEEventsManager *)eventsManager didSendEvents:(NSArray<TMMEEvent *>*)events;

#if TARGET_OS_IOS
/*! @brief eventsManager:didVisit: reports visits to the delegate
    @param eventsManager shared manager
    @param visit CLVisit
*/
- (void)eventsManager:(TMMEEventsManager *)eventsManager didVisit:(CLVisit *)visit;
#endif

@end

NS_ASSUME_NONNULL_END
