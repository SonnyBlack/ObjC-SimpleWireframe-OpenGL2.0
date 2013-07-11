//
//  Cone.m
//  OpenglExercise1
//
//  Created by  Sonny Black on 01.07.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "Cone.h"

@implementation Cone


- (id)init
{
    self = [super init];
    if (self) {
		m_height = 3.0;
		m_radius = 1.0;
		
        ParametricInterval interval = { GLKVector2Make(20, 20),  GLKVector2Make(2 * M_PI, 1) };
		[self setInterval:interval];
    }
    return self;
}

-(GLKVector3)evaluate:(GLKVector2)domain;
{
	float u = domain.x, v = domain.y;
	float x = m_radius * (1 - v) * cosf(u);
	float y = m_height * (v - 0.5f);
	float z = m_radius * (1 - v) * -sinf(u);
	return GLKVector3Make(x, y, z);
}


@end
