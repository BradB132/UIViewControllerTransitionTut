//
//  TTPopController.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 6/1/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTPopController.h"
#import "TTPopAnimator.h"

@interface TTPopController ()

@property (nonatomic, strong) TTInteractivePinchTransition* transition;
@property (nonatomic, strong) UIPinchGestureRecognizer* pinch;

@end

@implementation TTPopController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.transition = [[TTInteractivePinchTransition alloc] init];
	_transition.delegate = self;
	_transition.pinchFilter = PinchFilter_RecognizeCloseOnly;
	
	self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:_transition action:@selector(handlePinch:)];
	[self.view addGestureRecognizer:_pinch];
}

#pragma mark - TTInteractivePinchTransitionDelegate

-(void)delegateShouldPerformSegue:(TTInteractivePinchTransition*)transition
							pinch:(UIPinchGestureRecognizer*)pinch
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
	if([animationController isKindOfClass:[TTBaseAnimator class]])
		return ((TTBaseAnimator*)animationController).percentDrivenTransition;
	return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
	if(operation == UINavigationControllerOperationPop)
	{
		TTPopAnimator* anim = [[TTPopAnimator alloc] init];
		
		//we can determine here if this transition should be interactive
		BOOL transitionCausedByGesture = YES;
		anim.percentDrivenTransition = transitionCausedByGesture ? _transition : nil;
		
		return anim;
	}
	return nil;
}

@end
