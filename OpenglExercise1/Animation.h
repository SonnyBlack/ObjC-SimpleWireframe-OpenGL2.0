//
//  Animation.h
//  OpenglExercise1
//
//  Created by  Sonny Black on 07.07.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Visual.h"

@interface Animation : NSObject

@property (nonatomic, assign)    BOOL            active;
@property (nonatomic, assign)    float           elapsed;
@property (nonatomic, assign)    float           duration;
@property (nonatomic, strong)	NSMutableArray	*startingVisuals;
@property (nonatomic, strong)	NSMutableArray	*endingVisuals;

@end
