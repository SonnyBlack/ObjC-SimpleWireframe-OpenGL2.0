//
//  GLView.m
//  OpenglExercise1
//
//  Created by  Sonny Black on 26.06.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "GLView.h"

@implementation GLView

+(Class)layerClass{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
//		self.layer.borderColor = [[UIColor redColor] CGColor];
//		self.layer.borderWidth = 1.0;
		
        // Initialization code
        _glLayer = (CAEAGLLayer *)self.layer;
        _glLayer.opaque = YES;
        
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
		NSLog (@"Using Open GL 2.0");
   
        
        _context = [[EAGLContext alloc] initWithAPI:api];
        if (!_context){
            NSLog (@"Fail in creating context");
            return nil;
        }
        
        [EAGLContext setCurrentContext:_context];
		
		_renderingEngine = [[RenderEngine2 alloc] init];
        _appEngine2 = [[ApplicationEngine2 alloc] init];
		[_appEngine2 setupEngineForWidth:frame.size.width height:frame.size.height];
        
      
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
        [_appEngine2 render];
        [_context presentRenderbuffer:GL_RENDERBUFFER];
		
		[self renderUpdating:nil];
		
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderUpdating:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		
	}
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void) renderUpdating:(CADisplayLink *)displayLink {
	
	if (displayLink){
		float elapsedSeconds = displayLink.timestamp - _timestamp;
		_timestamp = displayLink.timestamp;
        [_appEngine2 updateAnimation:elapsedSeconds];
	}
	
    [_appEngine2 render];
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
    UITouch* touch = [touches anyObject];
    CGPoint location  = [touch locationInView: self];
    
	GLKVector2 startLocation = GLKVector2Make(location.x, location.y);
    
	[_appEngine2 onFingerDown:startLocation];
}

- (void) touchesEnded: (NSSet*) touches withEvent: (UIEvent*) event
{
    UITouch* touch = [touches anyObject];
    CGPoint location  = [touch locationInView: self];
    
    GLKVector2 startLocation = GLKVector2Make(location.x, location.y);
    
	[_appEngine2 onFingerUp:startLocation];
}

- (void) touchesMoved: (NSSet*) touches withEvent: (UIEvent*) event
{
    UITouch* touch = [touches anyObject];
    CGPoint previous  = [touch previousLocationInView: self];
    CGPoint current = [touch locationInView: self];
	
    GLKVector2 prevLocation = GLKVector2Make(previous.x, previous.y);
    GLKVector2 newLocation = GLKVector2Make(current.x, current.y);
    
    [_appEngine2 onFingerMove:prevLocation newLocation:newLocation];
}


@end
