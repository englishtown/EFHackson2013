//
//  TXFloatView.h
//  ____
//
//  Created by Thinkey on 9/9/12.
//  Copyright (c) 2012 Thinkey. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface TXFloatView : UIView {
    UILabel *label;
}

@property (nonatomic, strong) UILabel *label;

+ (id)viewInSuperview:(UIView *)superview;
- (void)showAnimated:(BOOL)animated withString:(NSString *)string;
- (void)hideAnimated:(BOOL)animated thenCleanup:(BOOL)cleanup;

@end