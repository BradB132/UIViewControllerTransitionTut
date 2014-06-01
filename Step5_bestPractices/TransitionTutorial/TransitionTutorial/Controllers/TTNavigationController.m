//
//  TTNavigationController.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 5/31/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTNavigationController.h"

@interface TTNavigationController ()

@property (nonatomic, weak) UIViewController* mostRecentController;

@end

@implementation TTNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.delegate = self;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
	if([_mostRecentController respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)])
	{
		return [(id<UINavigationControllerDelegate>)_mostRecentController navigationController:navigationController
												   interactionControllerForAnimationController:animationController];
	}
	return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
	SEL selector = @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:);
	id<UIViewControllerAnimatedTransitioning> result = nil;
	if([fromVC respondsToSelector:selector])
	{
		result = [(id<UINavigationControllerDelegate>)fromVC navigationController:navigationController
												  animationControllerForOperation:operation
															   fromViewController:fromVC
																 toViewController:toVC];
		if(result)
			self.mostRecentController = fromVC;
	}
	else if([toVC respondsToSelector:selector])
	{
		result = [(id<UINavigationControllerDelegate>)toVC navigationController:navigationController
												animationControllerForOperation:operation
															 fromViewController:fromVC
															   toViewController:toVC];
		if(result)
			self.mostRecentController = toVC;
	}
	
	return result;
}

@end
