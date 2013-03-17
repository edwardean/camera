//
//  FamousPeopleView.m
//  tvvitter
//
//  Created by Stephen Keep on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

@synthesize filters,delegate,highlight;

-(void)dealloc {
    [highlight release];
    [filters release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)loadFilterButtons {
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    [self addSubview:sv];
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    
    highlight = [[HighlightFilter alloc] initWithFrame:CGRectMake(0,0,70,90)];
    [sv addSubview:highlight];
    
    int i = 0;
    for (NSString *filter in filters) {
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((i*70)+10,12,50,50)];
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",filter]];
        UIImage *tileImage = [[UIImage alloc] initWithContentsOfFile:bundlePath];
        [iconView setImage:tileImage];
        [tileImage release];
        //[iconView setContentMode:UIViewContentModeScaleAspectFill];
        [sv addSubview:iconView];
        [iconView release];
        
        UILabel *rLabel = [[UILabel alloc] initWithFrame:CGRectMake((i*70)+10, 67, 50, 20)];
        rLabel.backgroundColor = [UIColor clearColor];
        rLabel.font = [UIFont systemFontOfSize:12.0];
        rLabel.textColor = [UIColor whiteColor];
        rLabel.textAlignment = UITextAlignmentCenter;
        [sv addSubview:rLabel];
        rLabel.text = filter;
        [rLabel release];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = iconView.frame;
        button.tag = 500+i;
        [button addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:button];
        
        i++;
        
    }
    
    [sv setContentSize:CGSizeMake((70*i)+5, 90)];
    [sv release];
    
}

-(void)annimateHighlight {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ 
                         highlight.frame = CGRectMake((highlight.selectedTag*70),0,70,90);
                         
                     }
                     completion:^(BOOL completed){
                         
                     }];
}

-(void)filterAction:(id)sender {
    if (delegate) {
        UIButton *button = (UIButton *)sender;
        highlight.selectedTag = button.tag-500;
        NSString *filter = [NSString stringWithFormat:@"%i",button.tag-500];
        [delegate didPressFilter:filter];
        [self annimateHighlight];
    }
}



- (void)drawRect:(CGRect)r
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithWhite:1.0f alpha:.2f];
	[backgroundColor set];
    CGRect rect = CGRectMake(0,0,r.size.width,1);
	CGContextFillRect(context, rect);
    
    backgroundColor = [UIColor colorWithWhite:0.0f alpha:.4f];
	[backgroundColor set];
    rect = CGRectMake(0,1,r.size.width,r.size.height-1);
	CGContextFillRect(context, rect);
    

    
    
}


@end
