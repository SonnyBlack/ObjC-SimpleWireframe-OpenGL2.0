//
//  ApplicationSurface.m
//  OpenglExercise1
//
//  Created by Sonny Black on 7/5/13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "ApplicationEngine2.h"
#import "RenderEngine2.h"

#import "Cone.h"
#import "Sphere.h"
#import "Torus.h"
#import "TrefoilKnot.h"
#import "MobiusStrip.h"
#import "KleinBottle.h"

@interface ApplicationEngine2()
{
    float           _trackballRadius;
    GLKVector2      _screenSize;
    GLKVector2      _centerPoint;
    GLKVector2      _fingerStart;
    BOOL            _spinning;
    GLKQuaternion   _orientation;
    GLKQuaternion   _previousOrientation;
    int             _currentSurface;
    GLKVector2      _buttonSize;
    int             _pressedButton;
    NSMutableArray  *_buttonSurfaces;
    Animation       *_animation;
    RenderEngine2   *_renderEngine;
	
	NSMutableArray	*_visuals;
}

@property (nonatomic, strong) Animation       *animation;

-(void) populateVisuals:(NSMutableArray *)visuals;
-(int) mapToButton:(GLKVector2) touchpoint;
-(GLKVector3)mapToSphere:(GLKVector2) touchpoint;

@end

@implementation ApplicationEngine2

- (id)init
{
    self = [super init];
    if (self) {
        _renderEngine = [[RenderEngine2 alloc] init];
		_animation = [[Animation alloc] init];
		
        _spinning = NO;
        _pressedButton = -1;
       
        _animation.active = NO;
        
        _buttonSurfaces = [[NSMutableArray alloc] init];
        _buttonSurfaces[0] = @0;
        _buttonSurfaces[1] = @1;
        _buttonSurfaces[2] = @4;
        _buttonSurfaces[3] = @3;
        _buttonSurfaces[4] = @2;
        _currentSurface = 5;
    }
    return self;
}

-(void)setupEngineForWidth:(float)width height:(float)height{
    _trackballRadius = width / 3;
    _buttonSize.y = height / 10;
    _buttonSize.x = 4 * _buttonSize.y / 3;
    _screenSize = GLKVector2Make(width, height - _buttonSize.y);
    _centerPoint = GLKVector2Make(_screenSize.x / 2, _screenSize.y / 2);
    
    _orientation = GLKQuaternionMake(0, 0, 0, 1);
    
	NSMutableArray *surfaces = [NSMutableArray array];
	
    surfaces[0] = [[Cone alloc] init];
    surfaces[1] = [[Sphere alloc] init];
    surfaces[2] = [[Torus alloc] init];
    surfaces[3] = [[TrefoilKnot alloc] init];
    surfaces[4] = [[KleinBottle alloc] init];
    surfaces[5] = [[MobiusStrip alloc] init];
   
//    m_renderingEngine->Initialize(surfaces);
	
    [_renderEngine setupEngineForWidth:width height:height figure:surfaces];
}

-(void)populateVisuals:(NSMutableArray *)visuals{
    
    for (int buttonIndex = 0; buttonIndex < ButtonCount; buttonIndex++) {
        int visualIndex = [[_buttonSurfaces objectAtIndex:buttonIndex] intValue];
  
        Visual *visual_ = [visuals objectAtIndex:visualIndex];
        
        visual_.color = GLKVector3Make(0.25f, 0.25f, 0.25f);
        if (_pressedButton == buttonIndex)
            visual_.color = GLKVector3Make(0.5f, 0.5f, 0.5f);
        
        visual_.viewportSize = _buttonSize;
        visual_.lowerLeft = GLKVector2Make(buttonIndex * _buttonSize.x, 0);
        visual_.orientation = GLKQuaternionMake(0, 0, 0, 1);

    }
 
    Visual *curVisual = [visuals objectAtIndex:_currentSurface];
	
    curVisual.color = _spinning ? GLKVector3Make(1, 1, 0.75f) : GLKVector3Make(1, 1, 0.5f);
    curVisual.lowerLeft = GLKVector2Make(0, _buttonSize.y);
    curVisual.viewportSize = GLKVector2Make(_screenSize.x, _screenSize.y);
    curVisual.orientation = _orientation;
}

-(void)render {

    NSMutableArray  *visuals = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++){
        Visual *v = [[Visual alloc] init];
        [visuals addObject:v];
    }
    
    
    if (!_animation.active) {
       [self populateVisuals:visuals];
    } else {
        float t = _animation.elapsed / _animation.duration;
        
        for (int i = 0; i < SurfaceCount; i++) {
            
			Visual *start = _animation.startingVisuals[i];
			Visual *end = _animation.endingVisuals[i];
            Visual *tweened = [visuals objectAtIndex:i];
            
            tweened.color =  [self vector3Lerp:t v1:start.color v2:end.color];
            tweened.lowerLeft =  [self vector2Lerp:t v1:start.lowerLeft v2:end.lowerLeft];
            tweened.viewportSize = [self vector2Lerp:t v1:start.viewportSize v2:end.viewportSize];
            tweened.orientation = GLKQuaternionSlerp(start.orientation, end.orientation, t);
        }
    }
    
//    m_renderingEngine->Render(visuals);
	[_renderEngine render:visuals];
}

-(void)updateAnimation:(float)dt{
    if (_animation.active) {
        _animation.elapsed += dt;
        if (_animation.elapsed > _animation.duration)
            _animation.active = NO;
    }
}

#pragma mark -
#pragma mark Touch events


-(void) onFingerUp:(GLKVector2) location {
    _spinning = NO;
    
    if (_pressedButton != -1 && _pressedButton == [self mapToButton:location] &&
        !_animation.active)
    {
        _animation.active = YES;
        _animation.elapsed = 0;
        _animation.duration = 0.25f;
        
		[self populateVisuals:_animation.startingVisuals];
      
        NSNumber *newNum = [NSNumber numberWithInt:_currentSurface];
         NSNumber *oldNum = [_buttonSurfaces objectAtIndex:_pressedButton];
        
        [_buttonSurfaces replaceObjectAtIndex:_pressedButton withObject:newNum];
        _currentSurface = [oldNum intValue];
        
//        [_animation.endingVisuals removeAllObjects];
		[self populateVisuals:_animation.endingVisuals];
        
    }
    
    _pressedButton = -1;
}

-(void) onFingerDown:(GLKVector2) location {
	_fingerStart = location;
    _previousOrientation = _orientation;
    _pressedButton = [self mapToButton:location];
    if (_pressedButton == -1)
        _spinning = YES;
}

-(void) onFingerMove:(GLKVector2)oldLocation newLocation:(GLKVector2)newLocation {
     if (_spinning) {
         GLKVector3 start = [self mapToSphere:_fingerStart];
         GLKVector3 end =  [self mapToSphere:newLocation];
         GLKQuaternion delta = [self createFromVectors3:start v1:end];
         //	_previousOrientation = delta;
	
         _orientation =  [self createRotation:delta q1:_previousOrientation];
     }
    
    if (_pressedButton != -1 && _pressedButton != [self mapToButton:newLocation])
        _pressedButton = -1;
	
}

-(GLKVector3)mapToSphere:(GLKVector2)touchpoint {
	GLKVector2 p = GLKVector2Make(touchpoint.x - _centerPoint.x, touchpoint.y - _centerPoint.y);
    p.y = -p.y;
	
	const float radius = _trackballRadius;
    const float safeRadius = radius - 1;
    
	if (GLKVector2Length(p) > safeRadius){
        float theta = atan2(p.y, p.x);
        p.x = safeRadius * cos(theta);
        p.y = safeRadius * sin(theta);
    }
    
    float z = sqrt(radius * radius - (p.x * p.x + p.y * p.y));
    GLKVector3 mapped = GLKVector3Make(p.x / radius, p.y / radius, z / radius);
    return mapped;
}

-(GLKQuaternion)createFromVectors3:(GLKVector3)v0 v1:(GLKVector3)v1 {
	if (v0.x == -v1.x && v0.y == -v1.y && v0.z == -v1.z )
        return  GLKQuaternionMakeWithAngleAndVector3Axis(M_PI, GLKVector3Make(1, 0, 0));
	
	GLKVector3 c = GLKVector3CrossProduct(v0, v1);
	float d = GLKVector3DotProduct(v0, v1);
	float s = sqrtf((1 + d) * 2);
	
	GLKQuaternion q = GLKQuaternionMake(c.x / s, c.y / s, c.z / s, s / 2.0f);
	return q;
}


-(GLKQuaternion)createRotation:(GLKQuaternion)q0 q1:(GLKQuaternion)q1 {
	GLKQuaternion q;
	
	q.w = q0.w * q1.w - q0.x * q1.x - q0.y * q1.y - q0.z * q1.z;
    q.x = q0.w * q1.x + q0.x * q1.w + q0.y * q1.z - q0.z * q1.y;
    q.y = q0.w * q1.y + q0.y * q1.w + q0.z * q1.x - q0.x * q1.z;
    q.z = q0.w * q1.z + q0.z * q1.w + q0.x * q1.y - q0.y * q1.x;
    
	
	return GLKQuaternionNormalize(q);
	
}

-(int)mapToButton:(GLKVector2)touchpoint {
    if (touchpoint.y  < _screenSize.y - _buttonSize.y)
        return -1;
    
    int buttonIndex = touchpoint.x / _buttonSize.x;
    if (buttonIndex >= ButtonCount)
        return -1;
    
    return buttonIndex;
}


#pragma private

-(GLKVector3)vector3Lerp:(float)t v1:(GLKVector3) v1  v2:(GLKVector3) v2{
    return GLKVector3Make(v1.x * (1 - t) + v2.x * t,
                          v1.y * (1 - t) + v2.y * t,
                          v1.z * (1 - t) + v2.z * t);
}

-(GLKVector2)vector2Lerp:(float)t v1:(GLKVector2) v1  v2:(GLKVector2) v2{
    return GLKVector2Make(v1.x * (1 - t) + v2.x * t,
                          v1.y * (1 - t) + v2.y * t);
}

@end
