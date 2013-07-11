//
//  Visual.h
//  OpenglExercise1
//
//  Created by  Sonny Black on 07.07.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Visual : NSObject

@property (nonatomic, assign) GLKVector3	color;
@property (nonatomic, assign) GLKVector2	lowerLeft;
@property (nonatomic, assign) GLKVector2	viewportSize;
@property (nonatomic, assign) GLKQuaternion	orientation;

@end
