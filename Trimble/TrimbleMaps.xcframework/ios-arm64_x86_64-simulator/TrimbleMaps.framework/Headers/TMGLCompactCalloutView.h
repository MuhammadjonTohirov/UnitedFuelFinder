#import "SMCalloutView.h"
#import "TMGLCalloutView.h"
#import "TMGLFoundation.h"

/**
 A concrete implementation of `TMGLCalloutView` based on
 <a href="https://github.com/nfarina/calloutview">SMCalloutView</a>. This
 callout view displays the represented annotation’s title, subtitle, and
 accessory views in a compact, two-line layout.
 */
TMGL_EXPORT
@interface TMGLCompactCalloutView : TMGLSMCalloutView <TMGLCalloutView>

+ (instancetype)platformCalloutView;

@end
