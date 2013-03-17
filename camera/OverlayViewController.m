





#import "OverlayViewController.h"
#import "EditPhotoViewController.h"
#import "UIImage+Resize.h"
#import "CameraButton.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface OverlayViewController () {
    
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *sourcePicture;
    GPUImageFilter *effectFilter;
    GPUImageView *imageView;
    
    UIButton *picker;
    UIImageView *thumbView;
    
    FilterView *filterView;
    UIView *filters;
    float startingY;
    int featureId;
    
    UIButton *take;
    
    CameraButton *toggle;
}

@property (nonatomic, retain) GPUImageStillCamera *stillCamera;
@property (nonatomic, retain) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, retain) GPUImagePicture *sourcePicture;
@property (nonatomic, retain) GPUImageFilter *effectFilter;
@property (nonatomic, retain) GPUImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *picker;
@property (nonatomic, retain) UIImageView *thumbView;
@property (nonatomic, retain) IBOutlet UIView *filters;
@property (nonatomic, assign) float startingY;
@property (nonatomic, assign) int featureId;
@property (nonatomic, retain) CameraButton *toggle;

@property (nonatomic, retain) IBOutlet UIButton *take;

@end

@implementation OverlayViewController

@synthesize filters,startingY,featureId,stillCamera,filter,sourcePicture,effectFilter,imageView,take,profile,toggle,thumbView,picker,place;

#pragma mark -
#pragma mark OverlayViewController

- (void)dealloc
{
    [toggle release];
    
    if (thumbView) {
        [thumbView release];
        
    }
    
    if (place) {
        [place release];
    }
    
    if (sourcePicture) {
        [sourcePicture removeAllTargets];
        [sourcePicture release];
        sourcePicture = nil;
    }
    
    if (effectFilter) {
        [effectFilter removeAllTargets];
        [effectFilter release];
        effectFilter = nil;
    }
    if (filterView) {
        [filterView release];
        filterView = nil;
    }
    if (filter) {
        [filter release];
        filter = nil;
    }
    if (stillCamera) {
        [stillCamera release];
        stillCamera = nil;
    }
    if (imageView) {
        [imageView release];
        imageView = nil;
    }
    [filters release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {

    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    take.enabled = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (filterView) {
        [filterView removeFromSuperview];
        [filterView release];
        filterView = nil;
    }
    filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    filterView.delegate = self;
    [filters addSubview:filterView];
    filterView.filters = [NSArray arrayWithObjects:@"original",@"noire",@"whisky",@"victor",@"xpro",@"bravo",@"alpha",@"hotel",@"romeo",@"charlie", nil];
    [filterView loadFilterButtons];
    
    
    startingY = 0.0f;

    [self performSelector:@selector(startCamera) withObject:nil afterDelay:0.0f];
    
    [self performSelector:@selector(enableButton) withObject:nil afterDelay:1.3f];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(viewWillAppear:)
                                                 name: @"didBecomeActive"
                                               object: nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(viewWillDisappear:)
                                                 name: @"willResignActive"
                                               object: nil];
    
}

-(IBAction)cancel:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [stillCamera pauseCameraCapture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (stillCamera) {
        [stillCamera resumeCameraCapture];
        [stillCamera startCameraCapture];
    }
    
    if (startingY == 0.0f) {
        
        DLog(@"%f",self.view.bounds.size.height);
        
        startingY = filters.frame.origin.y;
        filters.frame = CGRectMake(0, filters.frame.origin.y+90, 320, 90);
    }
    
    [self didPressFilter:[NSString stringWithFormat:@"%i",featureId]];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(getLastPhoto) withObject:nil afterDelay:0.1f];
}

-(void)startCamera {
    
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.f, 0.125f, 1.f, .75f)];
    [stillCamera addTarget:filter];
    
    imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.view.frame.size.width, self.view.frame.size.width)];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    [filter addTarget:imageView];

    
    [stillCamera startCameraCapture];
    
    [self showOverlay];
    
}

-(void)showOverlay {
    
    if ([stillCamera isFrontFacingCameraPresent]) {
        if (toggle) {
            [toggle removeFromSuperview];
            [toggle release];
            toggle = nil;
        }
        
        toggle =  [[CameraButton alloc] initWithFrame:CGRectMake(250, 10, 60, 32) andImage:[UIImage imageNamed:@"switch.png"]];
        
        
        [toggle addTarget:self action:@selector(cameraToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:toggle];
    }
    
    
}

#pragma mark Camera Toggle
- (IBAction)cameraToggle:(id)sender
{
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.35f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:imageView cache:NO];
        
    [stillCamera rotateCamera];
    
    [UIView commitAnimations];
    
}

-(void)enableButton {
    
    take.enabled = YES;
     
}



- (IBAction)takePhoto:(id)sender
{
    
    
    if (YES) {//if (stillCamera.enabled) {
        take.enabled = NO;
        
        [filter removeAllTargets];
        [filter addTarget:imageView];
        
        [stillCamera pauseCameraCapture];
        [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            
            [stillCamera stopCameraCapture];
            
            CGFloat scale = processedImage.scale;
            CGSize size;
            
            if (scale > 1 ) {
                size = CGSizeMake(320, 320);
            } else size = CGSizeMake(640, 640);
            
            UIImage* image = [processedImage resizedImageToFitInSize:size scaleIfSmaller:NO];
            NSData *dataForPNGFile = UIImageJPEGRepresentation(image,0.5);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSError *error2 = nil;
            if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"originalPhoto.jpg"] options:NSAtomicWrite error:&error2])
            {
                return;
            }
            
            EditPhotoViewController *vc = [[EditPhotoViewController alloc] initWithNibName:@"EditPhotoViewController" bundle:nil];
            vc.featureId = featureId;
            vc.profile = self.profile;
            
            if (place) {
                vc.place = place;
            }
            
            [self.navigationController pushViewController:vc animated:NO];
            [vc release];
            
            take.enabled = YES;
            
        }];
        
        
        
        UIView *flashView = [[UIView alloc] initWithFrame:self.view.frame];
        [flashView setBackgroundColor:[UIColor whiteColor]];
        [flashView setAlpha:0.f];
        [[self view] addSubview:flashView];
        
        [UIView animateWithDuration:.3f
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [flashView setAlpha:1.f];
                             [flashView setAlpha:0.f];
                         }
                         completion:^(BOOL finished){
                             
                             [flashView removeFromSuperview];
                             [flashView release];
                         }
         ];

    }
    
    
    
    
    
}

-(IBAction)toggleFilters {
    DLog(@"%.2f",filters.frame.origin.y);
    DLog(@"startingY: %.2f",startingY);
    if (filters.frame.origin.y == startingY) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             filters.frame = CGRectMake(0, startingY+90, 320, 90);}
                         completion:^(BOOL completed){
                             
                         }];
    } else {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             filters.frame = CGRectMake(0, startingY, 320, 90);}
                         completion:^(BOOL completed){
                             
                         }];
    }
    
    
}

-(void)didPressFilter:(NSString *)_atTag {
    
    featureId = [_atTag intValue];

    [filter removeAllTargets];

    if (sourcePicture) {
        [sourcePicture removeAllTargets];
        [sourcePicture release];
        sourcePicture = nil;
    }
    
    if (effectFilter) {
        [effectFilter removeAllTargets];
        [effectFilter release];
        effectFilter = nil;
    }

    switch ([_atTag intValue]) {
        case 0:
            [filter addTarget:imageView];
            break;
        case 1:
            effectFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 2:
            
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"Whisky"];
            UIImage *inputImage = [UIImage imageNamed:@"whisky.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        case 3:
            effectFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"victor"];
            break;
        case 4:
            
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"xpro"];
            inputImage = [UIImage imageNamed:@"xpro.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        case 5:
            
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"bravo"];
            inputImage = [UIImage imageNamed:@"bravo.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        case 6:
            
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"alpha"];
            inputImage = [UIImage imageNamed:@"alpha.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        case 7:
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"hotel"];
            inputImage = [UIImage imageNamed:@"hotel.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        case 8:
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"romeo"];
            inputImage = [UIImage imageNamed:@"romeo.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        case 9:
            effectFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromFile:@"charlie"];
            inputImage = [UIImage imageNamed:@"charlie.jpg"];
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            
            break;
        default:
            [filter addTarget:imageView];
            break;
    }
    
    if (sourcePicture) {
        [filter addTarget:effectFilter];
        [sourcePicture addTarget:effectFilter];
        [effectFilter addTarget:imageView];
        [sourcePicture processImage];
    } else if (effectFilter != nil) {
        [filter addTarget:effectFilter];
        [effectFilter addTarget:imageView];
    }
    
    


}

-(IBAction)pickPhoto:(id)sender {
    [stillCamera stopCameraCapture];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *p = [[UIImagePickerController alloc] init];
        p.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        p.allowsEditing = YES;
        p.delegate = self;
        [self presentModalViewController:p animated:YES];
        [p release];
        
    }
    
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [stillCamera stopCameraCapture];
    
    UIImage *processedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    CGFloat scale = processedImage.scale;
    CGSize size;
    
    if (scale > 1 ) {
        size = CGSizeMake(320, 320);
    } else size = CGSizeMake(640, 640);
    
    UIImage* image = [processedImage resizedImageToFitInSize:size scaleIfSmaller:NO];
    NSData *dataForPNGFile = UIImageJPEGRepresentation(image,0.5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error2 = nil;
    if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"originalPhoto.jpg"] options:NSAtomicWrite error:&error2])
    {
        return;
    }

    EditPhotoViewController *vc = [[EditPhotoViewController alloc] initWithNibName:@"EditPhotoViewController" bundle:nil];
    vc.featureId = 0;
    vc.profile = self.profile;
    
    if (place) {
        vc.place = place;
    }
    
    [self.navigationController pushViewController:vc animated:NO];
    [vc release];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getLastPhoto {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        if ([group numberOfAssets] > 0) {
            // Chooses the photo at the last index
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets]-1)]
                                    options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                         ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                         
                                         UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                         
                                         if (thumbView) {
                                             [thumbView removeFromSuperview];
                                             [thumbView release];
                                             thumbView = nil;
                                         }
                                         thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(picker.frame.origin.x+1, picker.frame.origin.y+1, 39, 38)];
                                         [thumbView setImage:latestPhoto];
                                         [thumbView setContentMode:UIViewContentModeScaleAspectFill];
                                         thumbView.layer.cornerRadius = 3.0f;
                                         thumbView.clipsToBounds = YES;
                                         [self.view addSubview:thumbView];
                                         
                                         
                                         [self.view bringSubviewToFront:picker];
                                     }
                                 }];
        }
        
    }
                         failureBlock: ^(NSError *error) {
                             // Typically you should handle an error more gracefully than this.
                             NSLog(@"No groups");
                         }];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Camera Actions


@end



