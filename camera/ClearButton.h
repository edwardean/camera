//
//  ClearButton.h
//  pathway
//
//  Created by Quipack on 27/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClearButton : UIButton {
    BOOL highlighted;
    NSString *text;
    int fontSize;
    UIImageView *iconView;
    BOOL whiteText;
    BOOL whiteBorder;
}

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) int fontSize;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, assign) BOOL whiteText;
@property (nonatomic, assign) BOOL whiteBorder;

-(void)setIconViewImage:(UIImage *)image;

@end
