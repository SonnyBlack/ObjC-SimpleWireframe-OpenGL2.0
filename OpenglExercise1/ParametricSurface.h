//
//  ParametricSurface.h
//  OpenglExercise1
//
//  Created by Sonny Black on 6/26/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//


typedef struct ParametricInterval {
    GLKVector2 divisions;
    GLKVector2 upperBound;
//    GLKVector2 textureCount;
} ParametricInterval;

@interface ParametricSurface : NSObject
{
    GLKVector2 _slices;
    GLKVector2 _divisions;
    GLKVector2 _upperBound;
    GLKVector2 _textureCount;
	
	
}

@property (nonatomic, assign) ParametricInterval  interval;

-(int) getVertexCount;
-(int) getLineIndexCount;
-(int) getTriangleIndexCount;
-(void) generateVertices:(NSMutableData *)vertices;
-(void) generateLineIndices:(NSMutableData *)indices;
-(GLKVector3)evaluate:(GLKVector2)domain;
-(GLKVector2)computeDomain:(float)i j:(float)j;

@end
