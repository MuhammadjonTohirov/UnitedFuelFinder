#import <Foundation/Foundation.h>

#ifndef NS_ARRAY_OF
    // Foundation collection classes adopted lightweight generics in iOS 9.0 and OS X 10.11 SDKs.
    #if __has_feature(objc_generics) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 || __MAC_OS_X_VERSION_MAX_ALLOWED >= 101100)
    /** Inserts a type specifier for a pointer to a lightweight generic with the given collection and object classes. Use a `*` for any non-`id` object classes but no `*` for the collection class. */
        #define NS_ARRAY_OF(ObjectClass...)                 NSArray <ObjectClass>
        #define NS_MUTABLE_ARRAY_OF(ObjectClass...)         NSMutableArray <ObjectClass>
        #define NS_SET_OF(ObjectClass...)                   NSSet <ObjectClass>
        #define NS_MUTABLE_SET_OF(ObjectClass...)           NSMutableSet <ObjectClass>
        #define NS_DICTIONARY_OF(ObjectClass...)            NSDictionary <ObjectClass>
        #define NS_MUTABLE_DICTIONARY_OF(ObjectClass...)    NSMutableDictionary <ObjectClass>
    #else
        #define NS_ARRAY_OF(ObjectClass...)                 NSArray
        #define NS_MUTABLE_ARRAY_OF(ObjectClass...)         NSMutableArray
        #define NS_SET_OF(ObjectClass...)                   NSSet
        #define NS_MUTABLE_SET_OF(ObjectClass...)           NSMutableSet
        #define NS_DICTIONARY_OF(ObjectClass...)            NSDictionary
        #define NS_MUTABLE_DICTIONARY_OF(ObjectClass...)    NSMutableDictionary
    #endif
#endif

typedef NS_DICTIONARY_OF(NSString *, id) TMMEEventAttributes;
typedef NS_MUTABLE_DICTIONARY_OF(NSString *, id) TMMEMutableEventAttributes;

#ifdef TMME_DEPRECATION_WARNINGS

#ifndef TMME_DEPRECATED
    #define TMME_DEPRECATED __attribute__((deprecated))
#endif

#ifndef TMME_DEPRECATED_MSG
    #define TMME_DEPRECATED_MSG(msg) __attribute((deprecated((msg))))
#endif

#ifndef TMME_DEPRECATED_GOTO
    #define TMME_DEPRECATED_GOTO(msg,label) __attribute((deprecated((msg),(label))))
#endif

#else

#ifndef TMME_DEPRECATED
    #define TMME_DEPRECATED
#endif

#ifndef TMME_DEPRECATED_MSG
    #define TMME_DEPRECATED_MSG(msg)
#endif

#ifndef TMME_DEPRECATED_GOTO
    #define TMME_DEPRECATED_GOTO(msg,label)
#endif

#endif // TMME_DEPRECATION_WARNINGS
