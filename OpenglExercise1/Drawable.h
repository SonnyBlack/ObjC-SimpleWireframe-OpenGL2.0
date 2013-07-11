//
//  Drawable.h
//  OpenglExercise1
//
//  Created by  Sonny Black on 06.07.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drawable : NSObject

@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint indexBuffer;
@property (nonatomic, assign) int indexCount;

@end
