//
//  Visual.m
//  OpenglExercise1
//
//  Created by  Sonny Black on 07.07.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "Visual.h"

@implementation Visual


-(NSString *)description {
    return [NSString stringWithFormat:@"Low. L: %@, viewp. size: %@, orient: %@", NSStringFromGLKVector2(self.lowerLeft), NSStringFromGLKVector2(self.viewportSize), NSStringFromGLKQuaternion(self.orientation)];
            
}

@end
