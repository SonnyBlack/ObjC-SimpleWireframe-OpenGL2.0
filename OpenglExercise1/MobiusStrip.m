//
//  MobiusStrip.m
//  OpenglExercise1
//
//  Created by Sonny Black on 7/3/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "MobiusStrip.h"

@implementation MobiusStrip

- (id)init
{
    self = [super init];
    if (self) {
		m_scale = 1.0;
        
        ParametricInterval interval = { GLKVector2Make(40, 20),  GLKVector2Make(2 * M_PI, 2 * M_PI) };
		[self setInterval:interval];
    }
    return self;
}

-(GLKVector3)evaluate:(GLKVector2)domain;
{
    float u = domain.x;
    float t = domain.y;
    float major = 1.25;
    float a = 0.125f;
    float b = 0.5f;
    float phi = u / 2;
    
    // General equation for an ellipse where phi is the angle
    // between the major axis and the X axis.
    float x = a * cos(t) * cos(phi) - b * sin(t) * sin(phi);
    float y = a * cos(t) * sin(phi) + b * sin(t) * cos(phi);
    
    // Sweep the ellipse along a circle, like a torus.
    GLKVector3 range;
    range.x = (major + x) * cos(u);
    range.y = (major + x) * sin(u);
    range.z = y;

    
	return GLKVector3Make(range.x * m_scale, range.y * m_scale, range.z * m_scale);
}

@end
