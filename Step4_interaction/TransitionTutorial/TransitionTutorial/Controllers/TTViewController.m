//
//  TTNavigationController.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 4/14/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTViewController.h"
#import "TTPushAnimator.h"
#import "TTPopAnimator.h"

@interface TTViewController ()

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition* transition;
@property (nonatomic, strong) UIPinchGestureRecognizer* pinch;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[self.view addGestureRecognizer:_pinch];
	
	self.transition = [[UIPercentDrivenInteractiveTransition alloc] init];
	
	self.navigationController.delegate = self;
}

-(float)percentForPinch:(UIPinchGestureRecognizer*)pinch
{
	return (pinch.scale - 1.0f)/2.0f;//denominator is just a fudge factor to get the 'feel' right
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinch
{
	switch (pinch.state)
	{
		case UIGestureRecognizerStateBegan:
			
			//we only want pinches that are 'opening'
			if(pinch.velocity < 0.0f)
				return;
			
			//don't trigger push unless we're pushing from this controller
			if(self.navigationController.topViewController == self)
				[self performSegueWithIdentifier:@"push" sender:pinch];
			
			break;
		case UIGestureRecognizerStateChanged:
			
			[_transition updateInteractiveTransition:[self percentForPinch:pinch]];
			
			break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded:
			
			//find some natural-feeling way to detect if the user wants to cancel the transition
			if([self percentForPinch:pinch] < 0.25f)
				[_transition cancelInteractiveTransition];
			else
				[_transition finishInteractiveTransition];
			
			break;
		default:
			break;
	}
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
	if([animationController isKindOfClass:[TTPushAnimator class]])
		return _transition;
	return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
	switch(operation)
	{
		case UINavigationControllerOperationPush:
			return [[TTPushAnimator alloc] init];
		case UINavigationControllerOperationPop:
			return [[TTPopAnimator alloc] init];
		default:
			return nil;
	}
}

@end
