//
//  TXFloatView.m
//  ____
//
//  Created by Thinkey on 9/9/12.
//  Copyright (c) 2012 Thinkey. All rights reserved.
//

#import "TXFloatView.h"


@implementation TXFloatView
@synthesize label;

- (id)initWithSuperview:(UIView *)superview {
    self = [super initWithFrame:CGRectMake(0, 0, superview.frame.size.width, superview.frame.size.height)];
    if (self) {
        self.exclusiveTouch = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(90, 180, 140, 80)];
        bg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, 120, 30)];
		label.text = NSLocalizedString(@"Loading...", nil);
		label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		[bg addSubview:label];
		UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		spin.center = CGPointMake(70, 25);
		[spin startAnimating];
		[bg addSubview:spin];
		bg.layer.cornerRadius = 8;
        //bg.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.85].CGColor;
        //bg.layer.borderWidth = 2.0;
        bg.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*2/5);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        bg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:bg];
        self.hidden = YES;
        [superview addSubview:self];
    }
    return self;
}

+ (id)viewInSuperview:(UIView *)superview
{
    return [[TXFloatView alloc] initWithSuperview:superview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showAnimated:(BOOL)animated withString:(NSString *)string {
    if (!string) {
        string = NSLocalizedString(@"Loading...", nil);
    }
    label.text = string;
    if (animated) {
        self.alpha = 0;
        self.hidden = NO;
        [UIView	animateWithDuration:0.2
                         animations:^{
                             self.alpha = 1;
                         }];
    } else {
        self.hidden = NO;
        self.alpha = 1.0;
    }
		
}

- (void)hideAnimated:(BOOL)animated thenCleanup:(BOOL)cleanup {
    if (animated) {
        [UIView	animateWithDuration:0.2
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             self.hidden = YES;
                             if (cleanup) {
                                 [self removeFromSuperview];
                             }
                         }];
    } else {
        self.hidden = YES;
        if (cleanup) {
            [self removeFromSuperview];
        }
    }
	
}



@end
