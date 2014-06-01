//
//  TTBaseAnimator.h
//  TransitionTutorial
//
//  Created by Brad Bambara on 6/1/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

@import UIKit;

@interface TTBaseAnimator : NSObject

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition* percentDrivenTransition;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;

@end
