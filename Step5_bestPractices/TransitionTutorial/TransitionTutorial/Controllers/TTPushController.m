//
//  TTNavigationController.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 4/14/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTPushController.h"
#import "TTPushAnimator.h"
#import "TTPopAnimator.h"

@interface TTPushController ()

@property (nonatomic, strong) TTInteractivePinchTransition* transition;
@property (nonatomic, strong) UIPinchGestureRecognizer* pinch;

@end

@implementation TTPushController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.transition = [[TTInteractivePinchTransition alloc] init];
	_transition.delegate = self;
	_transition.sensitivity = 0.5f;
	_transition.pinchFilter = PinchFilter_RecognizeOpenOnly;
	
	self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:_transition action:@selector(handlePinch:)];
	[self.view addGestureRecognizer:_pinch];
}

#pragma mark - TTInteractivePinchTransitionDelegate

-(void)delegateShouldPerformSegue:(TTInteractivePinchTransition*)transition
							pinch:(UIPinchGestureRecognizer*)pinch
{
	[self performSegueWithIdentifier:@"push" sender:pinch];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
	if([animationController isKindOfClass:[TTBaseAnimator class]])
		return ((TTBaseAnimator*)animationController).interactiveTransitioning;
	return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
	if(operation == UINavigationControllerOperationPush)
	{
		TTPushAnimator* anim = [[TTPushAnimator alloc] init];
		
		//we can determine here if this transition should be interactive
		BOOL transitionCausedByGesture = YES;
		anim.percentDrivenTransition = transitionCausedByGesture ? _transition : nil;
		
		return anim;
	}
	return nil;
}

@end
