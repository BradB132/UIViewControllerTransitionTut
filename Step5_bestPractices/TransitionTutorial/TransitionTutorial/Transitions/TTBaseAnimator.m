//
//  TTBaseAnimator.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 6/1/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTBaseAnimator.h"

@implementation TTBaseAnimator

-(id)init
{
	self = [super init];
	if(self)
	{
		_duration = 0.35;
	}
	return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return _duration;
}

@end
