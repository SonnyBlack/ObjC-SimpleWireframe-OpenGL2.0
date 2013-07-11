//
//  KleinBottle.m
//  OpenglExercise1
//
//  Created by Sonny Black on 7/3/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "KleinBottle.h"

@implementation KleinBottle

- (id)init
{
    self = [super init];
    if (self) {
		m_scale = 0.2;
        
        ParametricInterval interval = { GLKVector2Make(20, 20),  GLKVector2Make(2 * M_PI, 2 * M_PI) };
		[self setInterval:interval];
    }
    return self;
}

-(GLKVector3)evaluate:(GLKVector2)domain;
{
    float v = 1 - domain.x;
    float u = domain.y;
    
    float x0 = 3 * cos(u) * (1 + sin(u)) +
    (2 * (1 - cos(u) / 2)) * cos(u) * cos(v);
    
    float y0  = 8 * sin(u) + (2 * (1 - cos(u) / 2)) * sin(u) * cos(v);
    
    float x1 = 3 * cos(u) * (1 + sin(u)) +
    (2 * (1 - cos(u) / 2)) * cos(v + M_PI);
    
    float y1 = 8 * sin(u);
    
    GLKVector3 range;
    range.x = u < M_PI ? x0 : x1;
    range.y = u < M_PI ? -y0 : -y1;
    range.z = (-2 * (1 - cos(u) / 2)) * sin(v);

	return GLKVector3Make(range.x * m_scale, range.y * m_scale, range.z * m_scale);
}

@end
