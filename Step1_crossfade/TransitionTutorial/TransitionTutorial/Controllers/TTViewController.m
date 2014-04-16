//
//  TTNavigationController.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 4/14/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTViewController.h"
#import "TTFadeAnimator.h"

@interface TTViewController ()

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
	return [[TTFadeAnimator alloc] init];
}

@end
