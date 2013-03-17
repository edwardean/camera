//
//  ClearButton.m
//  pathway
//
//  Created by Quipack on 27/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClearButton.h"


@implementation ClearButton

@synthesize highlighted, text, fontSize, iconView,whiteText,whiteBorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    highlighted = YES;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    highlighted = NO;
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    highlighted = NO;
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    highlighted = NO;
    [self setNeedsDisplay];
}

- (CGGradientRef)backgroundGradient {
    
    CGFloat colors[16] = {0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.025,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.05,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.1,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.125,};
    CGFloat colorStops[4] = {0.0, 0.5, 0.5, 1.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef background = CGGradientCreateWithColorComponents(colorSpace, colors, colorStops, 4);
    
    CGColorSpaceRelease(colorSpace);
    
    return background;
}

- (CGGradientRef)backgroundHighlightedGradient {
    CGFloat colors[16] = {0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.225,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.25,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.3,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.325,};
    CGFloat colorStops[4] = {0.0, 0.5, 0.5, 1.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef background = CGGradientCreateWithColorComponents(colorSpace, colors, colorStops, 4);
    
    CGColorSpaceRelease(colorSpace);
    
    return background;
}

-(void)setIconViewImage:(UIImage *)image {
    
    if (iconView) {
        [iconView removeFromSuperview];
		[iconView release];
		iconView = nil;
        
    }
    
    if (text) {
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5,7,20,20)];
    } else iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-20)/2,7,20,20)];
    
    [iconView setImage:image];
    [self addSubview:iconView];

    
}



- (void)drawRect:(CGRect)rect
{
     
    if (!fontSize) {
        fontSize = 12;
    }
    
    CGRect r;
    
    if (whiteBorder) {
        
        if (self.bounds.size.height == 44.0f) {
            r = CGRectMake(2, 1,self.bounds.size.width-4, 31);
        } else r = CGRectMake(2, 1,self.bounds.size.width-4, self.bounds.size.height-3);
        
        CGSize s = CGSizeMake(6,6);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:r byRoundingCorners:UIRectCornerAllCorners cornerRadii:s];
        [path setLineWidth:1.0f];
        [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25] setStroke];
        [[UIColor clearColor] setFill];
        [path fill];
        [path stroke];
        
        if (self.bounds.size.height == 44.0f) {
            r = CGRectMake(2, 2,self.bounds.size.width-4, 30);
        } else r = CGRectMake(2, 2,self.bounds.size.width-4, self.bounds.size.height-4);
        
        s = CGSizeMake(6,6);
        path = [UIBezierPath bezierPathWithRoundedRect:r byRoundingCorners:UIRectCornerAllCorners cornerRadii:s];
        [path setLineWidth:1.0f];
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75] setStroke];
        [path fill];
        [path stroke];
        [path addClip];
    } else {
        
        if (self.bounds.size.height == 44.0f) {
            r = CGRectMake(2, 2,self.bounds.size.width-4, 31);
        } else r = CGRectMake(2, 2,self.bounds.size.width-4, self.bounds.size.height-3);
        
        CGSize s = CGSizeMake(6,6);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:r byRoundingCorners:UIRectCornerAllCorners cornerRadii:s];
        [path setLineWidth:1.0f];
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25] setStroke];
        [[UIColor clearColor] setFill];
        [path fill];
        [path stroke];
        
        if (self.bounds.size.height == 44.0f) {
            r = CGRectMake(2, 2,self.bounds.size.width-4, 30);
        } else r = CGRectMake(2, 2,self.bounds.size.width-4, self.bounds.size.height-4);
        
        s = CGSizeMake(6,6);
        path = [UIBezierPath bezierPathWithRoundedRect:r byRoundingCorners:UIRectCornerAllCorners cornerRadii:s];
        [path setLineWidth:1.0f];
        [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] setStroke];
        [path fill];
        [path stroke];
        [path addClip];
    }
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint topCenter = CGPointMake(0.0, 0.0);
    CGPoint midCenter = CGPointMake(0.0, self.bounds.size.height-8);
    CGGradientRef background;
    if (highlighted) {
        background = [self backgroundHighlightedGradient];
    }
    else background = [self backgroundGradient];
    
    CGContextDrawLinearGradient(ctx , background, topCenter, midCenter, 0);
    CGGradientRelease(background);
    
    if (whiteText) {
        if (highlighted) {
            [[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00] set];
        } else [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.00] set];
        
        
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, -1), 0, [UIColor colorWithWhite:0.0f alpha:0.45f].CGColor);
        
    } else {
        if (highlighted) {
            [[UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.00] set];
        } else [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.00] set];
        
        
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0, [UIColor colorWithWhite:1.0f alpha:0.45f].CGColor);
    }
    
    CGRect textRect;
    if (iconView) {
        textRect = CGRectMake(20, (r.size.height/2)-((fontSize/2)), self.bounds.size.width-20, fontSize);
    }else textRect = CGRectMake(0, (r.size.height/2)-((fontSize/2)), self.bounds.size.width, fontSize);
    [text drawInRect:textRect withFont:[UIFont boldSystemFontOfSize:fontSize] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];

}



- (void)dealloc
{
    [iconView release];
    [text release];
    [super dealloc];
}


@end
