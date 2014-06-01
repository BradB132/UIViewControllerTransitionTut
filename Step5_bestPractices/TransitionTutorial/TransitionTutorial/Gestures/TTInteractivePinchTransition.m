//
//  TTInteractivePinchTransition.m
//  TransitionTutorial
//
//  Created by Brad Bambara on 5/31/14.
//  Copyright (c) 2014 Brad Bambara. All rights reserved.
//

#import "TTInteractivePinchTransition.h"

@interface TTInteractivePinchTransition ()

@property (nonatomic, assign) PinchFilterMask lockedPinchMask;

@end

@implementation TTInteractivePinchTransition

-(id)init
{
	self = [super init];
	if(self)
	{
		_pinchFilter = PinchFilter_RecognizeBoth;
		_sensitivity = 1.0f;
		_cancelThreshold = 0.3f;
	}
	return self;
}

-(float)percentForPinch:(UIPinchGestureRecognizer*)pinch
{
	float scale = pinch.scale;
	if((!(_lockedPinchMask & PinchFilter_RecognizeCloseOnly) && scale < 1.0f) ||
	   (!(_lockedPinchMask & PinchFilter_RecognizeOpenOnly) && scale > 1.0f) )
	{
		scale = 1.0f;
	}
	
	return fabsf(1.0f - scale)*_sensitivity;
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinch
{
    switch (pinch.state)
    {
        case UIGestureRecognizerStateBegan:
			
			//only take pinches that match the opening or closing setting
            if(((_pinchFilter & PinchFilter_RecognizeCloseOnly) && pinch.velocity < 0.0f) ||
			   ((_pinchFilter & PinchFilter_RecognizeOpenOnly) && pinch.velocity > 0.0f) )
			{
				//any single performance of the gesture can only be pinching open OR closed, not both
				_lockedPinchMask = (pinch.velocity > 0.0f) ? PinchFilter_RecognizeOpenOnly : PinchFilter_RecognizeCloseOnly;
				
				[_delegate delegateShouldPerformSegue:self pinch:pinch];
			}
			
            break;
        case UIGestureRecognizerStateChanged:
			
            [self updateInteractiveTransition:[self percentForPinch:pinch]];
			
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
			
            //find some natural-feeling way to detect if the user wants to cancel the transition
            if([self percentForPinch:pinch] < _cancelThreshold)
                [self cancelInteractiveTransition];
            else
                [self finishInteractiveTransition];
			
            break;
        default:
            break;
    }
}

@end
