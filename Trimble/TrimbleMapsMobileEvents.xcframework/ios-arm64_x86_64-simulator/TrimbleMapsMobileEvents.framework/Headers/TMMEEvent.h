#import <Foundation/Foundation.h>
#import "TMMETypes.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMECommonEventData;

/*! @brief represents a telemetry event, with a name, date and attributes */
@interface TMMEEvent : NSObject <NSCopying,NSSecureCoding>

/*! @brief date on which the event occured - TMMEEventKeyDateCreated */
@property (nonatomic, readonly, copy) NSDate *date;

/*! @brief name of the event, from TMMEConstants.h - TMMEEventKeyEvent */
@property (nonatomic, readonly, copy) NSString *name;

/*! @brief attributes of the event, a dictionary for which [NSJSONSerialization isValidJSONObject:] returns YES */
@property (nonatomic, readonly, copy) NSDictionary *attributes;

/*! @brief Designated Initilizer for events
    @param eventAttributes attributes of the event
    @param error present if the event could not be created with the properties provided
    @return a new event with the date, name and attributes provided
*/
- (instancetype)initWithAttributes:(NSDictionary *)eventAttributes error:(NSError **)error NS_DESIGNATED_INITIALIZER;

#pragma mark - Generic Events

/*! @brief eventWithAttributes: - initilization errors are reported to the EventsManagerDelegate
    @param attributes attrs
    @return event
*/
+ (instancetype)eventWithAttributes:(NSDictionary *)attributes;

/*! @brief eventWithAttributes: - initilization errors are reported to the EventsManagerDelegate
    @param attributes attrs
    @return event
*/
+ (instancetype)eventWithAttributes:(NSDictionary *)attributes error:(NSError **)error;

#pragma mark - Custom Events

/*! @brief turnstileEventWithAttributes:
    @param attributes event attrs
    @return turnstile event
*/
+ (instancetype)turnstileEventWithAttributes:(NSDictionary *)attributes;

/*! @brief visitEventWithAttributes:
    @param attributes attrs
    @return event
*/
+ (instancetype)visitEventWithAttributes:(NSDictionary *)attributes;

#pragma mark - Crash Events

/*! @brief crashEventReporting:error:
    @param eventsError error to report
    @param createError pointer to an error creating the report
    @return event
*/
+ (instancetype)crashEventReporting:(NSError *)eventsError error:(NSError **)createError;

#pragma mark - Debug Devents

/*! @brief debugEventWithAttributes: debug logging event with attributes provided
    @param attributes attrs
    @return event
*/
+ (instancetype)debugEventWithAttributes:(NSDictionary *)attributes TMME_DEPRECATED;

/*! @brief debugEventWithError: debug logging event with the error provided
    @param error error
    @return event
*/
+ (instancetype)debugEventWithError:(NSError *)error TMME_DEPRECATED;

/*! @brief debugEventWithException: debug logging event the the exception provided
    @param except exception
    @return event
*/
+ (instancetype)debugEventWithException:(NSException *)except TMME_DEPRECATED;

#pragma mark - Deprecated

#pragma mark - Deprecated (TMMECommonEventData)

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithAttributes:error:
*/
+ (instancetype)locationEventWithAttributes:(NSDictionary *)attributes instanceIdentifer:(NSString *)instanceIdentifer commonEventData:(TMMECommonEventData *)commonEventData
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note replacment TBD
*/
+ (instancetype)mapLoadEventWithDateString:(NSString *)dateString commonEventData:(TMMECommonEventData *)commonEventData
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

#pragma mark - Deprecated (Event Name)

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithAttributes:error:
*/
+ (instancetype)eventWithName:(NSString *)eventName attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithAttributes:error:
*/
+ (instancetype)navigationEventWithName:(NSString *)name attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithAttributes:error:
*/
+ (instancetype)visionEventWithName:(NSString *)name attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithAttributes:error:
*/
+ (instancetype)searchEventWithName:(NSString *)name attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithAttributes:error:
*/
+ (instancetype)carplayEventWithName:(NSString *)name attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

#pragma mark - Deprecated (Date String)

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithName:attributes:
*/
+ (instancetype)telemetryMetricsEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note map gesture events are no longer supported
*/
+ (instancetype)mapTapEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_MSG("map gesture events are no longer supported");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note map gesture events are no longer supported
*/
+ (instancetype)mapDragEndEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_MSG("map gesture events are no longer supported");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithName:attributes:
*/
+ (instancetype)mapOfflineDownloadStartEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithName:attributes:
*/
+ (instancetype)mapOfflineDownloadEndEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

/*! @brief deprecated in MabboxMobileEvents 1.0.0 or later
    @note please use eventWithName:attributes:
*/
+ (instancetype)eventWithDateString:(NSString *)dateString name:(NSString *)name attributes:(NSDictionary *)attributes
    TMME_DEPRECATED_GOTO("use eventWithAttributes:error:", "-eventWithAttributes:error:");

@end

NS_ASSUME_NONNULL_END
