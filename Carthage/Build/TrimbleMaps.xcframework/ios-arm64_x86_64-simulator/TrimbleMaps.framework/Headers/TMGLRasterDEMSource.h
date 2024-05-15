#import "TMGLFoundation.h"

#import "TMGLRasterTileSource.h"

/**
 An `NSNumber` object containing an unsigned integer that specifies the encoding
 formula for raster-dem tilesets. The integer corresponds to one of
 the constants described in `TMGLDEMEncoding`.
 
 The default value for this option is `TMGLDEMEncodingMapbox`.
 
 This option cannot be represented in a TileJSON or style JSON file. It is used
 with the `TMGLRasterDEMSource` class and is ignored when creating an
 `TMGLRasterTileSource` or `TMGLVectorTileSource` object.
 */
FOUNDATION_EXTERN TMGL_EXPORT const TMGLTileSourceOption TMGLTileSourceOptionDEMEncoding;

/**
 `TMGLRasterDEMSource` is a map content source that supplies rasterized
 <a href="https://en.wikipedia.org/wiki/Digital_elevation_model">digital elevation model</a>
 (DEM) tiles to be shown on the map. The location of and metadata about the
 tiles are defined either by an option dictionary or by an external file that
 conforms to the
 <a href="https://github.com/mapbox/tilejson-spec/">TileJSON specification</a>.
 A raster DEM source is added to an `TMGLStyle` object along with one or more
 `TMGLHillshadeStyleLayer` objects. Use a hillshade style layer to control the
 appearance of content supplied by the raster DEM source.

 Each raster-dem source defined by the style JSON file is represented at runtime by an
 `TMGLRasterDEMSource` object that you can use to initialize new style layers.
 You can also add and remove sources dynamically using methods such as
 `-[TMGLStyle addSource:]` and `-[TMGLStyle sourceWithIdentifier:]`.
 
 */
TMGL_EXPORT
@interface TMGLRasterDEMSource : TMGLRasterTileSource

@end
