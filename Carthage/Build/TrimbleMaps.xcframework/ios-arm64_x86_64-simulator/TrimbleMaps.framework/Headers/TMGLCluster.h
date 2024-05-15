#import "TMGLFoundation.h"

@protocol TMGLFeature;

NS_ASSUME_NONNULL_BEGIN

/**
 An `NSUInteger` constant used to indicate an invalid cluster identifier.
 This indicates a missing cluster feature.
 */
FOUNDATION_EXTERN TMGL_EXPORT const NSUInteger TMGLClusterIdentifierInvalid;

/**
 A protocol that feature subclasses (i.e. those already conforming to
 the `TMGLFeature` protocol) conform to if they represent clusters.
 
 Currently the only class that conforms to `TMGLCluster` is
 `TMGLPointFeatureCluster` (a subclass of `TMGLPointFeature`).
 
 To check if a feature is a cluster, check conformity to `TMGLCluster`, for
 example:
 
 ```swift
 let shape = try! TMGLShape(data: clusterShapeData, encoding: String.Encoding.utf8.rawValue)
 
 guard let pointFeature = shape as? TMGLPointFeature else {
     throw ExampleError.unexpectedFeatureType
 }
 
 // Check for cluster conformance
 guard let cluster = pointFeature as? TMGLCluster else {
     throw ExampleError.featureIsNotACluster
 }
 
 // Currently the only supported class that conforms to `TMGLCluster` is
 // `TMGLPointFeatureCluster`
 guard cluster is TMGLPointFeatureCluster else {
     throw ExampleError.unexpectedFeatureType
 }
 ```
 */
TMGL_EXPORT
@protocol TMGLCluster <TMGLFeature>

/** The identifier for the cluster. */
@property (nonatomic, readonly) NSUInteger clusterIdentifier;

/** The number of points within this cluster */
@property (nonatomic, readonly) NSUInteger clusterPointCount;

@end

NS_ASSUME_NONNULL_END
