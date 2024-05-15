#import <Foundation/Foundation.h>
#import "TMMETypes.h"

extern NSString * const TMMEAPIClientBaseEventsURL;
extern NSString * const TMMEAPIClientBaseAPIURL;
extern NSString * const TMMEAPIClientBaseChinaEventsURL;
extern NSString * const TMMEAPIClientBaseChinaAPIURL;
extern NSString * const TMMEAPIClientEventsPath;
extern NSString * const TMMEAPIClientEventsConfigPath;
extern NSString * const TMMEAPIClientAttachmentsPath;
extern NSString * const TMMEAPIClientHeaderFieldUserAgentKey;
extern NSString * const TMMEAPIClientHeaderFieldContentTypeKey;
extern NSString * const TMMEAPIClientHeaderFieldContentTypeValue;
extern NSString * const TMMEAPIClientAttachmentsHeaderFieldContentTypeValue;
extern NSString * const TMMEAPIClientHeaderFieldContentEncodingKey;
extern NSString * const TMMEAPIClientHTTPMethodPost;
extern NSString * const TMMEAPIClientHTTPMethodGet;

// Debug types
extern NSString * const TMMEDebugEventType;
extern NSString * const TMMEDebugEventTypeError;
extern NSString * const TMMEDebugEventTypeFlush;
extern NSString * const TMMEDebugEventTypePush;
extern NSString * const TMMEDebugEventTypePost;
extern NSString * const TMMEDebugEventTypePostFailed;
extern NSString * const TMMEDebugEventTypeTurnstile;
extern NSString * const TMMEDebugEventTypeTurnstileFailed;
extern NSString * const TMMEDebugEventTypeBackgroundTask;
extern NSString * const TMMEDebugEventTypeMetricCollection;
extern NSString * const TMMEDebugEventTypeLocationManager;
extern NSString * const TMMEDebugEventTypeTelemetryMetrics;
extern NSString * const TMMEDebugEventTypeCertPinning;

// Event types
extern NSString * const TMMEEventTypeAppUserTurnstile;
extern NSString * const TMMEEventTypeTelemetryMetrics;
extern NSString * const TMMEEventTypeMapLoad;
extern NSString * const TMMEEventTypeLocation;
extern NSString * const TMMEEventTypeVisit;
extern NSString * const TMMEEventTypeLocalDebug;
extern NSString * const TMMEventTypeOfflineDownloadStart;
extern NSString * const TMMEventTypeOfflineDownloadEnd;

// Event keys
extern NSString * const TMMEEventKeyArrivalDate;
extern NSString * const TMMEEventKeyDepartureDate;
extern NSString * const TMMEEventKeyLatitude;
extern NSString * const TMMEEventKeyLongitude;
extern NSString * const TMMEEventKeyZoomLevel;
extern NSString * const TMMEEventKeyMaxZoomLevel;
extern NSString * const TMMEEventKeyMinZoomLevel;
extern NSString * const TMMEEventKeyEvent;
extern NSString * const TMMEEventKeyCreated;
extern NSString * const TMMEEventKeyStyleURL;
extern NSString * const TMMEEventKeySpeed;
extern NSString * const TMMEEventKeyCourse;
extern NSString * const TMMEEventKeySpeedAccuracy;
extern NSString * const TMMEEventKeyCourseAccuracy;
extern NSString * const TMMEEventKeyVerticalAccuracy;
extern NSString * const TMMEEventKeyFloor;
extern NSString * const TMMEEventKeyVendorId;
extern NSString * const TMMEEventKeyModel;
extern NSString * const TMMEEventKeyDevice;
extern NSString * const TMMEEventKeyConfig;
extern NSString * const TMMEEventKeySkuId;
extern NSString * const TMMEEventKeyEnabledTelemetry;
extern NSString * const TMMEEventKeyOperatingSystem;
extern NSString * const TMMEEventKeyResolution;
extern NSString * const TMMEEventKeyAccessibilityFontScale;
extern NSString * const TMMEEventKeyOrientation;
extern NSString * const TMMEEventKeyPluggedIn;
extern NSString * const TMMEEventKeyWifi;
extern NSString * const TMMEEventKeyShapeForOfflineRegion;
extern NSString * const TMMEEventKeySource;
extern NSString * const TMMEEventKeySessionId;
extern NSString * const TMMEEventKeyApplicationState;
extern NSString * const TMMEEventKeyAltitude;
extern NSString * const TMMEEventKeyLocationAuthorization;
extern NSString * const TMMEEventKeyLocationEnabled;
extern NSString * const TMMEEventKeyAccuracyAuthorization;
extern NSString * const TMMEEventHorizontalAccuracy;
extern NSString * const TMMEEventSDKIdentifier;
extern NSString * const TMMEEventSDKVersion;
extern NSString * const TMMEEventKeyLocalDebugDescription;
extern NSString * const TMMEEventKeyErrorCode;
extern NSString * const TMMEEventKeyErrorDomain;
extern NSString * const TMMEEventKeyErrorDescription;
extern NSString * const TMMEEventKeyErrorFailureReason;
extern NSString * const TMMEEventKeyErrorNoReason;
extern NSString * const TMMEEventKeyErrorNoDomain;
extern NSString * const TMMEEventKeyFailedRequests;
extern NSString * const TMMEEventKeyHeader;
extern NSString * const TMMEEventKeyPlatform;
extern NSString * const TMMEEventKeyUserAgent;
extern NSString * const TMMEEventKeyiOS;
extern NSString * const TMMEEventKeyMac;
extern NSString * const TMMEEventKeyApproximate;
extern NSString * const TMMEEventKeyLocationsForeground;
extern NSString * const TMMEEventKeyLocationsBackground;
extern NSString * const TMMEEventKeyLocationsWithApproximateValues;
extern NSString * const TMMEEventKeyLocationsDroppedBecauseOfHAF;
extern NSString * const TMMEEventKeyLocationsDroppedDueTimeout;
extern NSString * const TMMEEventKeyLocationsConvertedIntoEvents;
extern NSString * const TMMENavigationEventPrefix;
extern NSString * const TMMEVisionEventPrefix;
extern NSString * const TMMEEventTypeNavigationDepart;
extern NSString * const TMMEEventTypeNavigationArrive;
extern NSString * const TMMEEventTypeNavigationCancel;
extern NSString * const TMMEEventTypeNavigationFeedback;
extern NSString * const TMMEEventTypeNavigationReroute;
extern NSString * const TMMEventTypeNavigationCarplayConnect;
extern NSString * const TMMEventTypeNavigationCarplayDisconnect;
extern NSString * const TMMEEventTypeSearchSelected;
extern NSString * const TMMEEventTypeSearchFeedback;
extern NSString * const TMMESearchEventPrefix;
extern NSString * const TMMEEventDateUTC;
extern NSString * const TMMEEventRequests;
extern NSString * const TMMEEventTotalDataSent;
extern NSString * const TMMEEventCellDataSent;
extern NSString * const TMMEEventWiFiDataSent;
extern NSString * const TMMEEventTotalDataReceived;
extern NSString * const TMMEEventCellDataReceived;
extern NSString * const TMMEEventWiFiDataReceived;
extern NSString * const TMMEEventAppWakeups;
extern NSString * const TMMEEventEventCountPerType;
extern NSString * const TMMEEventEventCountFailed;
extern NSString * const TMMEEventEventCountTotal;
extern NSString * const TMMEEventEventCountMax;
extern NSString * const TMMEEventDeviceLat;
extern NSString * const TMMEEventDeviceLon;
extern NSString * const TMMEEventDeviceTimeDrift;
extern NSString * const TMMEEventConfigResponse;
extern NSString * const TMMEEventStatusDenied;
extern NSString * const TMMEEventStatusRestricted;
extern NSString * const TMMEEventStatusNotDetermined;
extern NSString * const TMMEEventStatusAuthorizedAlways;
extern NSString * const TMMEEventStatusAuthorizedWhenInUse;
extern NSString * const TMMEEventUnknown;
extern NSString * const TMMEAccuracyAuthorizationFull;
extern NSString * const TMMEAccuracyAuthorizationReduced;

extern NSString * const TMMEResponseKey;

/*! @brief SDK event source */
extern NSString * const TMMEEventSource;

#pragma mark - mobile.crash Keys

extern NSString * const TMMEEventMobileCrash;
extern NSString * const TMMEEventKeyOSVersion;
extern NSString * const TMMEEventKeyBuildType;
extern NSString * const TMMEEventKeyIsSilentCrash;
extern NSString * const TMMEEventKeyStackTrace;
extern NSString * const TMMEEventKeyStackTraceHash;
extern NSString * const TMMEEventKeyInstallationId;
extern NSString * const TMMEEventKeyThreadDetails;
extern NSString * const TMMEEventKeyAppId;
extern NSString * const TMMEEventKeyAppVersion;
extern NSString * const TMMEEventKeyAppStartDate;
extern NSString * const TMMEEventKeyCustomData;

#pragma mark - TMMEErrorDomain

/*! @brief NSErrorDomain for TrimbleMapsMobileEvents */
extern NSErrorDomain const TMMEErrorDomain;

/*! @brief TMMEErrorDomain Error Numbers
    - TMMENoError: No Error
    - TMMEErrorException for exceptions
    - TMMEErrorEventInit for errors when initlizing events
    - TMMEErrorEventInitMissingKey if the event attributes dictionary does not include the event key,
    - TMMEErrorEventInitException if an exception occured durring initWithAttributes:error:,
    - TMMEErrorEventInitInvalid if the provided eventAttributes cannot be converted to JSON objects
*/
typedef NS_ENUM(NSInteger, TMMEErrorNumber) {
    TMMENoError                  = 0,
    TMMEErrorException           = 10001,
    TMMEErrorEventInit           = 10002,
    TMMEErrorEventInitMissingKey = 10003,
    TMMEErrorEventInitException  = 10004,
    TMMEErrorEventInitInvalid    = 10005,
    TMMEErrorEventEncoding       = 10006,
    TMMEErrorEventCounting       = 10007,
    TMMEErrorConfigUpdateError   = 10008
};

/*! @brief key for TMMEErrorEventInit userInfo dictionary containing the attributes which failed to create the event */
extern NSString * const TMMEErrorEventAttributesKey;

/*! @brief key for TMMEErrorDomain userInfo dictionary containing the underlying exception which triggered the error */
extern NSString * const TMMEErrorUnderlyingExceptionKey;

#pragma mark - Deprecated

extern NSString * const TMMEAPIClientBaseURL TMME_DEPRECATED_MSG("Use TMMEAPIClientBaseEventsURL");

extern NSString * const TMMEErrorDescriptionKey TMME_DEPRECATED_MSG("Use NSLocalizedDescriptionKey");

extern NSString * const TMMEEventKeyVendorID TMME_DEPRECATED_MSG("Use TMMEEventKeyVendorId");
extern NSString * const TMMEEventKeyInstallationID TMME_DEPRECATED_MSG("Use TMMEEventKeyInstallationId");
extern NSString * const TMMEEventKeyAppID TMME_DEPRECATED_MSG("Use TMMEEventKeyInstallationId");

extern NSString * const TMMEEventKeyGestureId TMME_DEPRECATED;
extern NSString * const TMMEEventKeyGestureID TMME_DEPRECATED;
extern NSString * const TMMEEventGestureSingleTap TMME_DEPRECATED;
extern NSString * const TMMEEventGestureDoubleTap TMME_DEPRECATED;
extern NSString * const TMMEEventGestureTwoFingerSingleTap TMME_DEPRECATED;
extern NSString * const TMMEEventGestureQuickZoom TMME_DEPRECATED;
extern NSString * const TMMEEventGesturePanStart TMME_DEPRECATED;
extern NSString * const TMMEEventGesturePinchStart TMME_DEPRECATED;
extern NSString * const TMMEEventGestureRotateStart TMME_DEPRECATED;
extern NSString * const TMMEEventGesturePitchStart TMME_DEPRECATED;
extern NSString * const TMMEEventTypeMapTap TMME_DEPRECATED;
extern NSString * const TMMEEventTypeMapDragEnd TMME_DEPRECATED;
