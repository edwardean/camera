//
//  EditPhotoViewController.h
//  lovethat
//
//  Created by Stephen Keep on 07/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "FilterView.h"

@interface EditPhotoViewController : UIViewController <FilterViewDelegate> {
    int featureId;
    BOOL profile;
    NSDictionary *place;
}

@property (nonatomic,assign) BOOL profile;
@property (nonatomic,retain) NSDictionary *place;
@property (nonatomic,assign) int featureId;

@end
