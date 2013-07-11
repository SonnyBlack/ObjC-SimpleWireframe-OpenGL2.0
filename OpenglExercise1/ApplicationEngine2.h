//
//  ApplicationSurface.h
//  OpenglExercise1
//
//  Created by Sonny Black on 7/5/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"



static const int SurfaceCount = 6;
static const int ButtonCount = SurfaceCount - 1;




@interface ApplicationEngine2 : NSObject
{
    
}

-(void) setupEngineForWidth:(float)width height:(float) height;
-(void) render;
-(void) updateAnimation:(float)dt;
-(void) onFingerUp:(GLKVector2) location;
-(void) onFingerDown:(GLKVector2) location;
-(void) onFingerMove:(GLKVector2)oldLocation newLocation:(GLKVector2)newLocation;

@end
