//
//  TTPushAnimator.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 4/14/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTPushAnimator.h"

#define kTransitionDuration 0.35

@implementation TTPushAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return kTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
	UIViewController* toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController* fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIView* container = [transitionContext containerView];
	
	//get rects that represent the top and bottom halves of the screen
	CGSize viewSize = fromController.view.bounds.size;
	CGRect topFrame = CGRectMake(0, 0, viewSize.width, viewSize.height/2);
	CGRect bottomFrame = CGRectMake(0, viewSize.height/2, viewSize.width, viewSize.height/2);
	
	//create snapshots
	UIView* snapshotTop = [fromController.view resizableSnapshotViewFromRect:topFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
	UIView* snapshotBottom = [fromController.view resizableSnapshotViewFromRect:bottomFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
	snapshotTop.frame = topFrame;
	snapshotBottom.frame = bottomFrame;
	
	//remove the original view from the container
	fromController.view.hidden = YES;
	
	//add our destination view
	[container addSubview:toController.view];
	
	//add our snapshots on top
	[container addSubview:snapshotTop];
	[container addSubview:snapshotBottom];
	
	[UIView animateKeyframesWithDuration:kTransitionDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
		
		//adjust the new frames
		CGRect newTopFrame = topFrame;
		CGRect newBottomFrame = bottomFrame;
		newTopFrame.origin.y -= topFrame.size.height;
		newBottomFrame.origin.y += bottomFrame.size.height;
		
		//animate the top first
		[UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
			snapshotTop.frame = newTopFrame;
		}];
		
		//animate the bottom second
		[UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
			snapshotBottom.frame = newBottomFrame;
		}];
		
	} completion:^(BOOL finished) {
		
		//don't forget to clean up
		[snapshotTop removeFromSuperview];
		[snapshotBottom removeFromSuperview];
		fromController.view.hidden = NO;
		
		//put the original stuff back in place if the user cancelled
		if(transitionContext.transitionWasCancelled)
		{
			[toController.view removeFromSuperview];
			[container addSubview:fromController.view];
		}
		
		[transitionContext completeTransition:!transitionContext.transitionWasCancelled];
		
	}];
}

@end
