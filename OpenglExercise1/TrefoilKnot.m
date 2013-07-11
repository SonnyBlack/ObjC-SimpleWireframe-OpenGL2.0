//
//  TrefoilKnot.m
//  OpenglExercise1
//
//  Created by Sonny Black on 7/3/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "TrefoilKnot.h"

@implementation TrefoilKnot

- (id)init
{
    self = [super init];
    if (self) {
		m_scale = 1.8;
        
        ParametricInterval interval = { GLKVector2Make(60, 15),  GLKVector2Make(2 * M_PI, 2 * M_PI) };
		[self setInterval:interval];
    }
    return self;
}

-(GLKVector3)evaluate:(GLKVector2)domain;
{
    const float a = 0.5f;
    const float b = 0.3f;
    const float c = 0.5f;
    const float d = 0.1f;
    float u = (2 * M_PI - domain.x) * 2;
    float v = domain.y;
    
    float r = a + b * cos(1.5f * u);
    float x = r * cos(u);
    float y = r * sin(u);
    float z = c * sin(1.5f * u);
    
    GLKVector3 dv;
    dv.x = -1.5f * b * sin(1.5f * u) * cos(u) -
    (a + b * cos(1.5f * u)) * sin(u);
    dv.y = -1.5f * b * sin(1.5f * u) * sin(u) +
    (a + b * cos(1.5f * u)) * cos(u);
    dv.z = 1.5f * c * cos(1.5f * u);
    
    GLKVector3 q = GLKVector3Normalize(dv);
    GLKVector3 qv =  GLKVector3Make(q.y, -q.x, 0);
    GLKVector3 qvn = GLKVector3Normalize(qv);      
    GLKVector3 ww = GLKVector3CrossProduct(q, qvn);
    
    GLKVector3 range;
    range.x = x + d * (qvn.x * cos(v) + ww.x * sin(v));
    range.y = y + d * (qvn.y * cos(v) + ww.y * sin(v));
    range.z = z + d * ww.z * sin(v);
    
	return GLKVector3Make(range.x * m_scale, range.y * m_scale, range.z * m_scale);
}

@end
