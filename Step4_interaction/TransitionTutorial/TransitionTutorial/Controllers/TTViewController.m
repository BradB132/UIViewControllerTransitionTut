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
	
	//add gesture recognizer to navigation controller instead of any views in our own view heirarchy so that gesture won't cancel when we start the transition
	self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[self.navigationController.view addGestureRecognizer:_pinch];
	
	self.navigationController.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
	self.transition = [[UIPercentDrivenInteractiveTransition alloc] init];
}

-(void)dealloc
{
	[self.navigationController.view removeGestureRecognizer:_pinch];
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
			
			[self performSegueWithIdentifier:@"push" sender:pinch];
			
			break;
		case UIGestureRecognizerStateChanged:
		{
			float percent = [self percentForPinch:pinch];
			[_transition updateInteractiveTransition:(percent < 0.0f) ? 0.0f : percent];
		}
			break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded:
			
			//find some natural-feeling way to detect if the user wants to cancel the transition
			if([self percentForPinch:pinch] < 0.25f)
			{
				[_transition cancelInteractiveTransition];
			}
			else
			{
				[_transition finishInteractiveTransition];
			
				//nulling out the transition object prevents the same object from being used in subsequent transitions
				_transition = nil;
			}
			
			break;
		default:
			break;
	}
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
	return _transition;
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
