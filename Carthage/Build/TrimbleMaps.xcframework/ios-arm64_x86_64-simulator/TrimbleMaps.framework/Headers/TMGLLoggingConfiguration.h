#import <Foundation/Foundation.h>

#import "TMGLFoundation.h"

#ifndef TMGL_LOGGING_DISABLED
    #ifndef TMGL_LOGGING_ENABLE_DEBUG
        #ifndef NDEBUG
            #define TMGL_LOGGING_ENABLE_DEBUG 1
        #endif
    #endif

NS_ASSUME_NONNULL_BEGIN

/**
 Constants indicating the message's logging level.
 */
typedef NS_ENUM(NSInteger, TMGLLoggingLevel) {
    /**
     None-level won't print any messages.
     */
    TMGLLoggingLevelNone = 0,
    /**
     Fault-level messages contain system-level error information.
     */
    TMGLLoggingLevelFault,
    /**
     Error-level messages contain information that is intended to aid in process-level
     errors.
    */
    TMGLLoggingLevelError,
    /**
     Warning-level messages contain warning information for potential risks.
     */
    TMGLLoggingLevelWarning,
    /**
     Info-level messages contain information that may be helpful for flow tracing
     but is not essential.
     */
    TMGLLoggingLevelInfo,
    /**
     Debug-level messages contain information that may be helpful for troubleshooting
     specific problems.
     */
#if TMGL_LOGGING_ENABLE_DEBUG
    TMGLLoggingLevelDebug,
#endif
    /**
     Verbose-level will print all messages.
     */
    TMGLLoggingLevelVerbose,
};

/**
 A block to be called once `loggingLevel` is set to a higher value than `TMGLLoggingLevelNone`.
 
 @param loggingLevel The message logging level.
 @param filePath The description of the file and method for the calling message.
 @param line The line where the message is logged.
 @param message The logging message.
 */
typedef void (^TMGLLoggingBlockHandler)(TMGLLoggingLevel loggingLevel, NSString *filePath, NSUInteger line, NSString *message);

/**
 The `TMGLLoggingConfiguration` object provides a global way to set this SDK logging levels
 and logging handler.
 */
TMGL_EXPORT
@interface TMGLLoggingConfiguration : NSObject

/**
 The handler this SDK uses to log messages.
 
 If this property is set to nil or if no custom handler is provided this property
 is set to the default handler.
 
 The default handler uses `os_log` and `NSLog` for iOS 10+ and iOS < 10 respectively.
 */
@property (nonatomic, copy, null_resettable) TMGLLoggingBlockHandler handler;

/**
 The logging level.
 
 The default value is `TMGLLoggingLevelNone`.
 
 Setting this property includes logging levels less than or equal to the set value.
 */
@property (assign, nonatomic) TMGLLoggingLevel loggingLevel;

/**
 Returns the shared logging object.
 */
@property (class, nonatomic, readonly) TMGLLoggingConfiguration *sharedConfiguration;

- (TMGLLoggingBlockHandler)handler UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
#endif
