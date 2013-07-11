//
//  GLView.h
//  OpenglExercise1
//
//  Created by  Sonny Black on 26.06.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import "RenderEngine2.h"
#import "ApplicationEngine2.h"

@interface GLView : UIView
{
    CAEAGLLayer			*_glLayer;
    EAGLContext			*_context;
    RenderEngine2		*_renderingEngine;
	ApplicationEngine2	*_appEngine2;
    CADisplayLink		*_displayLink;
	
	float				_timestamp;
}
@end
