//
//  EditPhotoViewController.m
//  lovethat
//
//  Created by Stephen Keep on 07/11/2012.
//
//

#import "EditPhotoViewController.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"

@interface EditPhotoViewController () {
    FilterView *filterView;
    UIView *filters;
    float startingY;
    GPUImageView *displayImageView;
    GPUImagePicture *sourcePicture;
    GPUImageFilter *effectFilter;
    GPUImagePicture *stillImageSource;
}

@property (nonatomic, retain) IBOutlet UIView *filters;
@property (nonatomic, retain) GPUImageView *displayImageView;
@property (nonatomic, assign) float startingY;

@end

@implementation EditPhotoViewController


@synthesize filters,startingY,displayImageView,featureId,profile,place;

- (void)dealloc
{
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
        [filterView removeFromSuperview];
        [filterView release];
        filterView = nil;
    }
    if (stillImageSource) {
        [stillImageSource release];
        stillImageSource = nil;
    }
    [displayImageView release];
    [filters release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor blackColor];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.0f];
    [self toggleFilters];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)getImage {
    
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
    
    filters.frame = CGRectMake(0, filters.frame.origin.y+90, 320, 90);
    startingY = filters.frame.origin.y;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    UIImage *inputImage = [UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"originalPhoto.jpg"]];
    
    stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];

    displayImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.view.frame.size.width, self.view.frame.size.width)];
    displayImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:displayImageView];
    [self.view sendSubviewToBack:displayImageView];

    [self filterImageWithFilterId:featureId];
    
}

-(void)didPressFilter:(NSString *)_atTag {

    [self filterImageWithFilterId:[_atTag intValue]];
}

-(void)filterImageWithFilterId:(int)_atTag {
    
    [stillImageSource removeAllTargets];
 
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
    
    switch (_atTag) {
        case 0:
            effectFilter = [[GPUImageFilter alloc] init];
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
            effectFilter = [[GPUImageFilter alloc] init];
            break;
    }
    

    [stillImageSource addTarget:effectFilter];
    
    if (sourcePicture) {
        
        
        [sourcePicture processImage];
        [sourcePicture addTarget:effectFilter];
        
        
    } 
    
    [effectFilter addTarget:displayImageView];
    [stillImageSource processImage];
    
    
}

-(IBAction)toggleFilters {
    DLog(@"%.2f",filters.frame.origin.y);
    if (filters.frame.origin.y == startingY) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             filters.frame = CGRectMake(0, filters.frame.origin.y+90, 320, 90);}
                         completion:^(BOOL completed){
                             
                         }];
    } else {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             filters.frame = CGRectMake(0, filters.frame.origin.y-90, 320, 90);}
                         completion:^(BOOL completed){
                             
                         }];
    }
    
    
}

- (UIImage *)imageWithGradient:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    CGFloat scale = image.scale;
    CGSize itemSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
    CGContextSetInterpolationQuality(context, 3);
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    // Create gradient
    CGFloat locations[4];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:4];
    UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [colors addObject:(id)[color CGColor]];
    locations[0] = 0.0;
    color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [colors addObject:(id)[color CGColor]];
    locations[1] = 1.0;
    color = [UIColor colorWithRed:0.137 green:0.155 blue:0.208 alpha:0.1];
    [colors addObject:(id)[color CGColor]];
    locations[2] = 0.51;
    color = [UIColor colorWithRed:0.237 green:0.257 blue:0.305 alpha:0.1];
    [colors addObject:(id)[color CGColor]];
    locations[3] = 0.654;
    
    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
    
    // Apply gradient
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,image.size.height * scale), 0);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return newImage;
}


-(IBAction)saveImage {
    
    UIImage *filtered = [effectFilter imageFromCurrentlyProcessedOutput];
    
    NSData *dataForPNGFile = UIImageJPEGRepresentation(filtered,0.5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error2 = nil;
    if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"originalPhoto.jpg"] options:NSAtomicWrite error:&error2])
    {
        return;
    }
    
    CGFloat scale = filtered.scale;
    CGSize size;
    
    if (scale > 1 ) {
        size = CGSizeMake(150, 150);
    } else size = CGSizeMake(300, 300);
    
    

    if (profile) {
        UIImage* image = [filtered resizedImageToFitInSize:size scaleIfSmaller:NO];
        dataForPNGFile = UIImageJPEGRepresentation(image,0.5);
        
        error2 = nil;
        if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"user_.jpg"]] options:NSAtomicWrite error:&error2])
        {
            return;
        }

        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"didTakeProfilePhoto" object: nil userInfo: nil];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        
        UIImage *smaller = [self imageWithGradient:filtered scaledToSize:size];
        UIImage* image = [smaller resizedImageToFitInSize:size scaleIfSmaller:NO];
        dataForPNGFile = UIImageJPEGRepresentation(image,0.5);
        
        error2 = nil;
        if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"gradientPhoto.jpg"] options:NSAtomicWrite error:&error2])
        {
            return;
        }
        
    }
    



}

@end
