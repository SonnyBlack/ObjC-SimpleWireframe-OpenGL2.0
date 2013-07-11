//
//  RenderEngine2.m
//  OpenglExercise1
//
//  Created by  Sonny Black on 26.06.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "RenderEngine2.h"
#import "Cone.h"
#import "Sphere.h"
#import "Torus.h"
#import "TrefoilKnot.h"
#import "MobiusStrip.h"
#import "KleinBottle.h"


@implementation RenderEngine2

-(id)init{
    self = [super init];
    if (self){
        glGenRenderbuffers(1, &_renderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    }
    return self;
}

-(void)setupEngineForWidth:(float)width height:(float)height figure:(NSMutableArray *)surfaces {
	
	_drawables = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [surfaces count]; i++){
		ParametricSurface *surface = [surfaces objectAtIndex:i];
		
		NSMutableData *data = [NSMutableData data];
		NSMutableData *indData = [NSMutableData data];
		
		[surface generateVertices:data];
		[surface generateLineIndices:indData];
		
		GLushort *d = (GLushort *)[indData bytes];
		GLKVector3 *vec = (GLKVector3 *)[data bytes];
		
		// Create the VBO for the vertices.
		GLuint vertexBuffer;
		glGenBuffers(1, &vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(GLKVector3) * [surface getVertexCount], &vec[0], GL_STATIC_DRAW);
		
		// Create the VBO for the indices.
		GLuint indicesBuffer;
		glGenBuffers(1, &indicesBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER,
					 sizeof(GLushort) * [surface getLineIndexCount],
					 &d[0],
					 GL_STATIC_DRAW);
		
		Drawable *draw = [[Drawable alloc] init];
		draw.vertexBuffer = vertexBuffer;
		draw.indexBuffer = indicesBuffer;
		draw.indexCount = [surface getLineIndexCount];
		[_drawables addObject:draw];
	}
	
	


    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16,
						  width,
						  height);
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    
    _shaderProgram = [self buildProgramWithVertex:@"SimpleShader" andFragment:@"SimpleShader"];
    glUseProgram(_shaderProgram);
	

	
	
	
//     m_colorSlot = glGetAttribLocation(_shaderProgram, "SourceColor");
//    positionSlot = glGetAttribLocation(_shaderProgram, "Position");
//    glEnableVertexAttribArray(positionSlot);
}

-(void)render:(NSMutableArray *)visuals {
    _projectionUniform = glGetUniformLocation(_shaderProgram, "Projection");
	m_colorSlot = glGetAttribLocation(_shaderProgram, "SourceColor");
    positionSlot = glGetAttribLocation(_shaderProgram, "Position");
	 glEnableVertexAttribArray(positionSlot);
	_modelviewUniform = glGetUniformLocation(_shaderProgram, "Modelview");
	
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT );
	
	for (int i = 0; i < [visuals count]; i++) {
		
		// Set the viewport transform.
		Visual *visual_ = visuals[i];
		GLKVector2 size = visual_.viewportSize;
		GLKVector2 lowerLeft = visual_.lowerLeft;
		glViewport(lowerLeft.x, lowerLeft.y, size.x, size.y);
		
		GLKMatrix4 rotation = GLKMatrix4MakeWithQuaternion(visual_.orientation);
		GLKMatrix4 translate = GLKMatrix4MakeTranslation(0.0, 0.0, -7.0);
		GLKMatrix4 result = GLKMatrix4Multiply(translate, rotation);
		glUniformMatrix4fv(_modelviewUniform, 1, 0, result.m);
		
		float h = 4.0f * size.y / size.x;
		GLKMatrix4 projection = GLKMatrix4MakeFrustum(-2, 2, -h / 2, h / 2, 5, 10);
		glUniformMatrix4fv(_projectionUniform, 1, 0, projection.m);

		// Set the color.
        GLKVector3 color = visual_.color;
        glVertexAttrib4f(m_colorSlot, color.x, color.y, color.z, 1);
        
        // Draw the wireframe.
        int stride = sizeof(GLKVector3);
		Drawable *drawable = _drawables[i];
        glBindBuffer(GL_ARRAY_BUFFER, drawable.vertexBuffer);
        glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, stride, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, drawable.indexBuffer);
        glDrawElements(GL_LINES, drawable.indexCount, GL_UNSIGNED_SHORT, 0);
	}
	
	

    
//	GLKMatrix4 rotation = GLKMatrix4MakeWithQuaternion(_orientation);
//	GLKMatrix4 translate = GLKMatrix4MakeTranslation(0.0, 0.0, -7.0);
//    
//	GLKMatrix4 result = GLKMatrix4Multiply(translate, rotation);
//    glUniformMatrix4fv(modelViewUniform, 1, 0, result.m);
//	 
//    glClearColor(0.5, 0.5, 0.5, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    
////    GLsizei stride = sizeof(Vertex);
////    const GLvoid *colorOffset = (GLvoid *)(sizeof(Vertex) - sizeof(GLKVector4));
//    
//	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
////    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, stride, 0);
////    glVertexAttribPointer(m_colorSlot, 4, GL_FLOAT, GL_FALSE, stride, colorOffset);
//     glEnableVertexAttribArray(positionSlot);
////    const GLvoid *bodyOffset = 0;
////    const GLvoid *diskOffset = (GLvoid *)120;
//    
//	// Set the color.
//	glVertexAttrib4f(m_colorSlot, 0.8, 0.8, 0.8, 1);
//	
//	// Draw the wireframe.
//	int stride = sizeof(GLKVector3);
//
//	glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, stride, 0);
//
//	glDrawElements(GL_LINES, [_figure getLineIndexCount], GL_UNSIGNED_SHORT, 0);
	
//    glEnableVertexAttribArray(m_colorSlot);
//    glDrawElements(GL_TRIANGLES, 120, GL_UNSIGNED_BYTE, bodyOffset);
//    glDisableVertexAttribArray(m_colorSlot);
//    glVertexAttrib4f(m_colorSlot, 1, 1, 1, 1);
//    glDrawElements(GL_TRIANGLES, 120, GL_UNSIGNED_BYTE, diskOffset);
//    glDisableVertexAttribArray(positionSlot);
}

#pragma mark - Building shaders

-(GLuint)buildShaderWithName:(NSString *)name withType:(GLenum )type sourceType:(NSString *)fileExt {
    NSString    *shaderPath = [[NSBundle mainBundle] pathForResource:name ofType:fileExt];
    NSError     *error;
    NSString    *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    
    if (!shaderString){
        NSLog (@"Error in creating shader of type : %u", type);
        return 0;
    }
    
    GLuint      shaderHandle = glCreateShader(type);
    
    const char *shaderUTF8String = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    
    glShaderSource(shaderHandle, 1, &shaderUTF8String, &shaderStringLength);
    glCompileShader(shaderHandle);
    
    GLint success;
    
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE){
        GLchar message[256];
        glGetShaderInfoLog(shaderHandle, sizeof(message), 0, &message[0]);
        NSString *errorMessage = [NSString stringWithUTF8String:message];
        NSLog(@"Error : %@", errorMessage);
    }
    
    return shaderHandle;
}

-(GLuint)buildProgramWithVertex:(NSString *)vShader andFragment:(NSString *)fShader {
    
    GLuint vertexShader = [self buildShaderWithName:vShader withType:GL_VERTEX_SHADER sourceType:@"vsh"];
    GLuint fragmentShader = [self buildShaderWithName:fShader withType:GL_FRAGMENT_SHADER sourceType:@"fsh"];
    
    GLuint  programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint success;
    
    glGetShaderiv(programHandle, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE){
        GLchar message[256];
        glGetShaderInfoLog(programHandle, sizeof(message), 0, &message[0]);
        NSString *errorMessage = [NSString stringWithUTF8String:message];
        NSLog(@"Error : %@", errorMessage);
    }
    
    return programHandle;
}


@end
