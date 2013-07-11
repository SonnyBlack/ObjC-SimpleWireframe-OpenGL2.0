//
//  ViewController.m
//  OpenglExercise1
//
//  Created by  Sonny Black on 26.06.13.
//  Copyright (c) 2013 SonnyBlack. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)loadView{
    [super loadView];
    
	GLView  *glView = [[GLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = glView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
