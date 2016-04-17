//
//  IGViewControllerTransitioning.m
//  IgoonaDoc
//
//  Created by porco on 16/4/17.
//  Copyright © 2016年 Porco. All rights reserved.
//

#import "IGViewControllerTransitioning.h"

@implementation IGViewControllerTransitioningPushFromLeft

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView=[transitionContext viewForKey: UITransitionContextToViewKey];
    UIView *cView=[transitionContext containerView];
    [cView addSubview:toView];
    
    toView.frame=CGRectOffset(cView.bounds, -cView.bounds.size.width,0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toView.frame=cView.bounds;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end



@implementation IGViewControllerTransitioningPopToLeft

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *fromView=[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *cView=[transitionContext containerView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromView.frame=CGRectOffset(cView.bounds, -cView.bounds.size.width,0);
                     } completion:^(BOOL finished){
                         [transitionContext completeTransition:YES];
                     }];
    
}

@end