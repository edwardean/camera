//
//  FamousPeopleView.h
//  tvvitter
//
//  Created by Stephen Keep on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightFilter.h"

@class FilterView;

#pragma - FilterViewDelegate

@protocol FilterViewDelegate<NSObject>
@optional
- (void)didPressFilter:(NSString *)atTag;
@end

@interface FilterView : UIView {
    NSArray *filters;
    id<FilterViewDelegate> delegate;
    HighlightFilter *highlight;
}

@property (nonatomic, retain) NSArray *filters;
@property (nonatomic, assign) id<FilterViewDelegate> delegate;
@property (nonatomic, retain) HighlightFilter *highlight;

-(void)loadFilterButtons;

@end
