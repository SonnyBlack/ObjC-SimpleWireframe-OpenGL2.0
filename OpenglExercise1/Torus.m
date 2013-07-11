//
//  Torus.m
//  OpenglExercise1
//
//  Created by Sonny Black on 7/3/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "Torus.h"

@implementation Torus

- (id)init
{
    self = [super init];
    if (self) {
		m_majorRadius = 1.4;
		m_minorRadius = 0.3;
        
        ParametricInterval interval = { GLKVector2Make(20, 20),  GLKVector2Make(2 * M_PI, 2 * M_PI) };
		[self setInterval:interval];
    }
    return self;
}

-(GLKVector3)evaluate:(GLKVector2)domain;
{
    const float major = m_majorRadius;
    const float minor = m_minorRadius;
    float u = domain.x, v = domain.y;
    float x = (major + minor * cosf(v)) * cosf(u);
    float y = (major + minor * cosf(v)) * sinf(u);
    float z = minor * sinf(v);
	return GLKVector3Make(x, y, z);
}

@end
