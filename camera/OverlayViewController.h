

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "FilterView.h"

@interface OverlayViewController : UIViewController <FilterViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    BOOL profile;
    NSDictionary *place;
}

@property (nonatomic,assign) BOOL profile;
@property (nonatomic,retain) NSDictionary *place;
 
@end
