//
//  Animation.m
//  OpenglExercise1
//
//  Created by  Sonny Black on 07.07.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "Animation.h"

@implementation Animation

- (id)init
{
    self = [super init];
    if (self) {
        if(self) {
            self.startingVisuals = [[NSMutableArray alloc] initWithCapacity:6];
            for (int i = 0; i < 6; i++){
                Visual *v = [[Visual alloc] init];
                [self.startingVisuals addObject:v];
            }
            
            self.endingVisuals = [[NSMutableArray alloc] initWithCapacity:6];
            for (int i = 0; i < 6; i++){
                Visual *v = [[Visual alloc] init];
                [self.endingVisuals addObject:v];
            }
        }
    }
    return self;
}
@end
