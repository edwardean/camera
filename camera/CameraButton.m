//
//  CameraButton.m
//  MultiViewFilterExample
//
//  Created by Stephen Keep on 28/02/2012.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "CameraButton.h"
#import <QuartzCore/QuartzCore.h>



@implementation CameraButton

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        

        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 32)];
        [iconView setImage:image];
        //[iconView setContentMode:UIViewContentMode];
        [self addSubview:iconView];
        [self bringSubviewToFront:iconView];
        [iconView release];
        
        CALayer *layer = [self layer];
        [layer setBackgroundColor:[[UIColor colorWithWhite:1.0f alpha:.5f] CGColor]];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor]];
        [layer setCornerRadius:15.f];
        
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CALayer *layer = [self layer];
    [layer setBackgroundColor:[[UIColor colorWithWhite:1.0f alpha:0.25] CGColor]];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor]];
    [layer setCornerRadius:15.f];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    CALayer *layer = [self layer];
    [layer setBackgroundColor:[[UIColor colorWithWhite:1.0f alpha:.5f] CGColor]];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor]];
    [layer setCornerRadius:15.f];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];

    CALayer *layer = [self layer];
    [layer setBackgroundColor:[[UIColor colorWithWhite:1.0f alpha:.5f] CGColor]];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor]];
    [layer setCornerRadius:15.f];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    CALayer *layer = [self layer];
    [layer setBackgroundColor:[[UIColor colorWithWhite:1.0f alpha:.5f] CGColor]];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[[UIColor colorWithWhite:0.0f alpha:1.0f] CGColor]];
    [layer setCornerRadius:15.f];

}


@end
