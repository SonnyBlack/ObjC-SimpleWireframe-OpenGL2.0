//
//  Sphere.m
//  OpenglExercise1
//
//  Created by Sonny Black on 7/2/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "Sphere.h"

@implementation Sphere

- (id)init
{
    self = [super init];
    if (self) {
		m_radius = 1.4;
		
        ParametricInterval interval = { GLKVector2Make(20, 20),  GLKVector2Make(M_PI, 2 * M_PI) };
		[self setInterval:interval];
    }
    return self;
}

-(GLKVector3)evaluate:(GLKVector2)domain;
{
    float u = domain.x, v = domain.y;
    float x = m_radius * sinf(u) * cosf(v);
    float y = m_radius * cosf(u);
    float z = m_radius * -sinf(u) * sinf(v);
	return GLKVector3Make(x, y, z);
}

@end
