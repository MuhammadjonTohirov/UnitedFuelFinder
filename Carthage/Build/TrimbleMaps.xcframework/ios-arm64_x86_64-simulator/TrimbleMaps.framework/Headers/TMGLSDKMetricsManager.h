#import <Foundation/Foundation.h>
#import "TMGLFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 :nodoc:
 The metrics type used to handle metrics events.
 */
typedef NS_ENUM(NSUInteger, TMGLMetricType) {
    /** :nodoc:
     Metric that measures performance.
     */
    TMGLMetricTypePerformance = 0,
};

FOUNDATION_EXTERN TMGL_EXPORT NSString* TMGLStringFromMetricType(TMGLMetricType metricType);

@class TMGLMetricsManager;

/**
 :nodoc:
 The `TMGLMetricsManagerDelegate` protocol defines a set of methods that you
 can use to receive metric events.
 */
@protocol TMGLMetricsManagerDelegate <NSObject>

/**
 :nodoc:
 Asks the delegate whether the metrics manager should handle metric events.
 
 @param metricsManager The metrics manager object.
 @param metricType The metric type event.
 */
- (BOOL)metricsManager:(TMGLMetricsManager *)metricsManager shouldHandleMetric:(TMGLMetricType)metricType;

/**
 :nodoc:
 Asks the delegate to handle metric events.
 
 @param metricsManager The metrics manager object.
 @param metricType The metric type event.
 @param attributes The metric attributes.
 */
- (void)metricsManager:(TMGLMetricsManager *)metricsManager didCollectMetric:(TMGLMetricType)metricType withAttributes:(NSDictionary *)attributes;

@end

/**
 :nodoc:
 The `TMGLMetricsManager` object provides a single poin to collect SDK metrics
 such as tile download latency.
 */
TMGL_EXPORT
@interface TMGLMetricsManager : NSObject

/**
 :nodoc:
 Returns the shared metrics manager object.
 */
@property (class, nonatomic, readonly) TMGLMetricsManager *sharedManager;

/**
 :nodoc:
 The metrics manager delegate that will recieve metric events.
 */
@property (nonatomic, weak) id<TMGLMetricsManagerDelegate> delegate;

#if TARGET_OS_IOS
/**
 :nodoc:
 Sends metric events to Mapbox.
 */
- (void)pushMetric:(TMGLMetricType)metricType withAttributes:(NSDictionary *)attributes;
#endif

@end

NS_ASSUME_NONNULL_END
