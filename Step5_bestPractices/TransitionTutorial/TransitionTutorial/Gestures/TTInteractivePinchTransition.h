//
//  TTInteractivePinchTransition.h
//  TransitionTutorial
//
//  Created by Brad Bambara on 5/31/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

@import UIKit;

@class TTInteractivePinchTransition;

typedef enum
{
	PinchFilter_RecognizeOpenOnly = 1 << 0,
	PinchFilter_RecognizeCloseOnly = 1 << 1,
	PinchFilter_RecognizeBoth = PinchFilter_RecognizeOpenOnly | PinchFilter_RecognizeCloseOnly,
}PinchFilterMask;

@protocol TTInteractivePinchTransitionDelegate <NSObject>
-(void)delegateShouldPerformSegue:(TTInteractivePinchTransition*)transition
							pinch:(UIPinchGestureRecognizer*)pinch;
@end

@interface TTInteractivePinchTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic) PinchFilterMask pinchFilter;
@property (nonatomic) CGFloat sensitivity;
@property (nonatomic) CGFloat cancelThreshold;
@property (nonatomic, weak) id<TTInteractivePinchTransitionDelegate> delegate;

-(void)handlePinch:(UIPinchGestureRecognizer*)pinch;

@end
