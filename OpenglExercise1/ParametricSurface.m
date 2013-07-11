//
//  ParametricSurface.m
//  OpenglExercise1
//
//  Created by Sonny Black on 6/26/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "ParametricSurface.h"

@implementation ParametricSurface

-(void)setInterval:(ParametricInterval)interval {
    _divisions = interval.divisions;
    _upperBound = interval.upperBound;
//    _textureCount = interval.textureCount;
    _slices =  GLKVector2Make(_divisions.x - 1.0, _divisions.y - 1.0);
	
	
}

-(int)getVertexCount {
    return _divisions.x * _divisions.y;
}

-(int)getLineIndexCount {
    return 4 * _slices.x * _slices.y;
}

-(GLKVector2)computeDomain:(float)i j:(float)j {
    return GLKVector2Make(i * _upperBound.x / _slices.x, j * _upperBound.y / _slices.y);
}


-(void)generateVertices:(NSMutableData *)vertices {

    for (int j = 0; j < _divisions.y; j++) {
        for (int i = 0; i < _divisions.x; i++) {
            GLKVector2  domain = [self computeDomain:i j:j];
            GLKVector3 range = [self evaluate:domain];
            [vertices appendBytes:&range length:sizeof(GLKVector3)];
        }
    }
}

-(void)generateLineIndices:(NSMutableData *)indices {
	
	GLushort index;
	
    for (int j = 0, vertex = 0; j < _slices.y; j++) {
        for (int i = 0; i < _slices.x; i++) {
            int next = (i + 1) % (int) _divisions.x;
			
			index = vertex + i;
			[indices appendBytes:&index length:sizeof(GLushort)];
			
			index = vertex + next;
			[indices appendBytes:&index length:sizeof(GLushort)];
			
			index = vertex + i;
			[indices appendBytes:&index length:sizeof(GLushort)];
			
			index = vertex + i + _divisions.x;
			[indices appendBytes:&index length:sizeof(GLushort)];
        }
        vertex += _divisions.x;
    }
}

@end
