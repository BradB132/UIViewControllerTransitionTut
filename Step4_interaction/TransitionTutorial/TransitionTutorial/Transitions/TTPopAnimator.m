//
//  TTPopAnimator.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 4/14/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTPopAnimator.h"

#define kTransitionDuration 0.35

@implementation TTPopAnimator

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
	UIView* snapshot = [toController.view snapshotViewAfterScreenUpdates:YES];
	UIView* snapshotTop = [snapshot resizableSnapshotViewFromRect:topFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
	UIView* snapshotBottom = [snapshot resizableSnapshotViewFromRect:bottomFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
	
	//start the frames with an offset
	CGRect offsetTopFrame = topFrame;
	CGRect offsetBottomFrame = bottomFrame;
	offsetTopFrame.origin.y -= topFrame.size.height;
	offsetBottomFrame.origin.y += bottomFrame.size.height;
	snapshotTop.frame = offsetTopFrame;
	snapshotBottom.frame = offsetBottomFrame;
	
	//add our snapshots on top
	[container addSubview:snapshotTop];
	[container addSubview:snapshotBottom];
	
	[UIView animateKeyframesWithDuration:kTransitionDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
		
		//animate the top first
		[UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
			snapshotTop.frame = topFrame;
		}];
		
		//animate the bottom second
		[UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
			snapshotBottom.frame = bottomFrame;
		}];
		
	} completion:^(BOOL finished) {
		
		//don't forget to clean up
		[snapshotTop removeFromSuperview];
		[snapshotBottom removeFromSuperview];
		[fromController.view removeFromSuperview];
		[container addSubview:toController.view];
		
		[transitionContext completeTransition:finished];
	}];
}

@end
