//
//  RenderEngine2.h
//  OpenglExercise1
//
//  Created by  Sonny Black on 26.06.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"
#import "Visual.h"

@class ParametricSurface;

@interface RenderEngine2 : NSObject
{
	GLuint              _frameBuffer;
    GLuint              _renderBuffer;
	GLuint              _shaderProgram;
    GLuint              _depthBuffer;
//	GLuint              _vertexBuffer;
//	GLuint              _indexBuffer;
    

    GLint				_projectionUniform;
    GLint				_modelviewUniform;
    GLuint              m_colorSlot;
    GLuint              positionSlot;
    
    GLuint              _bodyIndexCount;
	GLuint              _diskIndexCount;
	NSMutableArray		*_drawables;
}


-(void) setupEngineForWidth:(float)width height:(float) height figure:(NSMutableArray *) surfaces;
-(void)render:(NSMutableArray *)visuals;



@end
