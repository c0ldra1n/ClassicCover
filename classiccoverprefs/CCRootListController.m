
#include "CCRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <substrate.h>
#import "CCHeaderView.h"

#import "../ClassicCover/iCarousel/iCarousel.h"

#define kCRHeaderHeight 250

#define kCCBundlePath @"/Library/PreferenceBundles/ClassicCoverPrefs.bundle"

#define kCCLicensePath @"/Library/Application\ Support/ClassicCover/io.c0ldra1n.classiccover.license"
#define kCCLicenseCountPath @"/Library/Application\ Support/ClassicCover/io.c0ldra1n.classiccover.license.count"
#define kCCKeyPath @"/Library/Application\ Support/ClassicCover/io.c0ldra1n.classiccover.key"

@implementation CCRootListController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCephei];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupCephei];
    }
    
    return self;
    
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self setupCephei];
    }
    
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self clearCache];
    [self reload];
    [super viewWillAppear:animated];
}

-(void)setupCephei{
    
    HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
    //    appearanceSettings.tintColor = [UIColor colorWithRed:252/255.f green:69/255.f blue:255/255.f alpha:1.0];
    appearanceSettings.tintColor = [UIColor colorWithWhite:0.3 alpha:1];
    appearanceSettings.translucentNavigationBar = true;
    self.hb_appearanceSettings = appearanceSettings;
    
    self.table.delegate = self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[kCCBundlePath stringByAppendingPathComponent:@"header-background.png"]];
    UIImage *overlayImage = [UIImage imageWithContentsOfFile:[kCCBundlePath stringByAppendingPathComponent:@"header-overlay.png"]];
    
    self.table.tableHeaderView = [[CCHeaderView alloc] initWithBackground:backgroundImage overlay:overlayImage];
    
    self.table.tableHeaderView.frame = CGRectMake(0, 0, self.table.bounds.size.width, kCRHeaderHeight);
    
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    
    return _specifiers;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    if(indexPath.section == 3 && indexPath.row == 0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

-(NSArray *)getCoverStyleValues{
    return @[@(iCarouselTypeLinear),
             @(iCarouselTypeRotary),
             @(iCarouselTypeInvertedRotary),
             @(iCarouselTypeCylinder),
             @(iCarouselTypeInvertedCylinder),
             @(iCarouselTypeWheel),
             @(iCarouselTypeInvertedWheel),
             @(iCarouselTypeCoverFlow),
             @(iCarouselTypeCoverFlow2),
             @(iCarouselTypeTimeMachine),
             @(iCarouselTypeInvertedTimeMachine)];
}

-(NSArray *)getCoverStyleTitles{
    return @[@"Linear",
             @"Rotary",
             @"Inverted Rotary",
             @"Cylinder",
             @"Inverted Cylinder",
             @"Wheel",
             @"Inverted Wheel",
             @"CoverFlow (default)",
             @"CoverFlow (alternative)",
             @"Time Machine",
             @"Inverted Time Machine"];
}

#define kCRCCBackgroundImageFilePath @"/Library/Application\ Support/ClassicCover/background"

-(void)setCustomImage{
    //  Just place it here(kCRCCBackgroundImageFilePath)
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        
        UIAlertController *uac = [UIAlertController alertControllerWithTitle:@"Error Loading Photos" message:@"Cannot access photo library." preferredStyle:UIAlertControllerStyleAlert];
        
        [uac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:uac animated:YES completion:nil];

    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [UIImagePNGRepresentation(image) writeToFile:kCRCCBackgroundImageFilePath atomically:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)killMusic{
    int (*ios_system)(const char *) = (int (*)(const char *))dlsym(RTLD_DEFAULT, "system");
    ios_system("killall -9 Music");
}


-(void)showOpenSource{
    
    UITextView *textView = [[UITextView alloc] init];
    textView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    textView.font = [UIFont monospacedDigitSystemFontOfSize:11 weight:UIFontWeightRegular];
    textView.text = [NSString stringWithContentsOfFile:[kCCBundlePath stringByAppendingPathComponent:@"opensource.txt"] encoding:NSUTF8StringEncoding error:nil];
    textView.editable = false;
    
    UIViewController *c = [[UIViewController alloc] init];
    c.automaticallyAdjustsScrollViewInsets = YES;
    c.view = textView;
    
    [self.navigationController pushViewController:c animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [super scrollViewDidScroll:scrollView];
    [(CCHeaderView *)self.table.tableHeaderView updateScrollPosition:scrollView.contentOffset.y+self.table.scrollIndicatorInsets.top];
}

@end
