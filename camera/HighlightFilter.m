//
//  HighlightFilter.m
//  MultiViewFilterExample
//
//  Created by Stephen Keep on 29/02/2012.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "HighlightFilter.h"

@implementation HighlightFilter

@synthesize selectedTag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //draw selected box
    CGSize s = CGSizeMake(6,6);
    rect = CGRectMake((selectedTag*70)+5,7,60,60);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:s];
    [path setLineWidth:1.0f];
    [[UIColor clearColor] setStroke];
    [[UIColor colorWithRed:12.f/255.f green:122.f/255.f blue:204.f/255.f alpha:1.0f] setFill];
    [path fill];
    [path stroke];
    
    rect = CGRectMake((selectedTag*70)+5.5,7.5,59,59);
    path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:s];
    [path setLineWidth:1.0f];
    [[UIColor colorWithWhite:1.0f alpha:0.2f] setStroke];
    [[UIColor clearColor] setFill];
    [path fill];
    [path stroke];
}


@end
