//
//  CRCCViewController.m
//  ClassicCover
//
//  Created by c0ldra1n on 3/5/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//
//

#import "CRCCViewController.h"
#import "CRCCAlbumArtView.h"
#import "UIImage+Graphics.h"
#ifdef THEOSBUILD
#import <substrate.h>
#endif

#define HomescreenFilePath @"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"

#define kCRCCBackgroundImageFilePath @"/Library/Application\ Support/ClassicCover/background"

static dispatch_queue_t control_queue;


@interface CRCCViewController (){
    CALayer *darkenLayer;
    UIImage *playImage;
    UIImage *pauseImage;
}

@property UIImage *fallbackArtwork;
@property CGFloat cardUnit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playPauseHeight;

@end

@implementation UIColor (random)

+(UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end

@implementation CRCCViewController

-(UIImage *)wallpaper{
    
    UIImage *wallpaper;
    
#ifdef THEOSBUILD
    
    CFArrayRef (*CPBitmapCreateImagesFromData)(CFDataRef, void*, int, void*) = (CFArrayRef (*)(CFDataRef, void*, int, void*)) (dlsym(RTLD_DEFAULT, "CPBitmapCreateImagesFromData"));
    
    CFArrayRef someArrayRef = CPBitmapCreateImagesFromData((__bridge CFDataRef)([NSData dataWithContentsOfFile:HomescreenFilePath]), NULL, 1, NULL);
    
    NSArray *array = (__bridge NSArray*)someArrayRef;
    
    wallpaper = [UIImage imageWithCGImage:(__bridge CGImageRef)(array[0])];
    
#else
    
    wallpaper = [UIImage imageNamed:@"test"];
    
#endif
    
    return wallpaper;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MPMusicPlayerController systemMusicPlayer] prepareToPlay];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad){
        CRCCArtworkSize s = [CRCCPrefsValueForKey(kCRCCPrefsArtworkSizeKey) integerValue];
        //  For now...
        self.cardUnit = ((width > height ? height : width)/10)*(7-s);
        
        if((width > height ? height : width) <= 320){
            self.playPauseHeight.constant = 18;
        }else{
            self.playPauseHeight.constant = 27;
        }
        
    }else{
        self.cardUnit = ((width > height ? height : width)/10)*5;
    }
    
    
#ifdef THEOSBUILD
    
    NSBundle *MPUIBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaPlayerUI.framework"];
    
    self.fallbackArtwork = [UIImage imageNamed:@"placeholder-artwork" inBundle:MPUIBundle compatibleWithTraitCollection:nil];
    
    if(kCFCoreFoundationVersionNumber >= 1348.00){
        //  iOS 10
        
        playImage =  [[UIImage imageNamed:@"play-mini" inBundle:MPUIBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        pauseImage =  [[UIImage imageNamed:@"pause-mini" inBundle:MPUIBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        
    }else{
        
        //  iOS 9 and Below
        
        playImage =  [[UIImage imageNamed:@"SystemMediaControl-Play" inBundle:MPUIBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        pauseImage =  [[UIImage imageNamed:@"SystemMediaControl-Pause" inBundle:MPUIBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    }
    
#endif
    
    _albums = [[[MPMediaQuery albumsQuery] collections] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        if ([CRCCPrefsValueForKey(kCRCCPrefsSortKey) integerValue] == CRCCSortMethodArtist) {
            return [[obj1 representativeItem].artist compare:[obj2 representativeItem].artist];
        }else if ([CRCCPrefsValueForKey(kCRCCPrefsSortKey) integerValue] == CRCCSortMethodAlbum) {
            return [[obj1 representativeItem].albumTitle compare:[obj2 representativeItem].albumTitle];
        }else{
            //  default fallback to artist
            return [[obj1 representativeItem].artist compare:[obj2 representativeItem].artist];
        }
    }];
    
    switch ([CRCCPrefsValueForKey(kCRCCPrefsBackgroundStyleKey) integerValue]) {
        case CRCCBackgroundStyleColor:
        {
            self.backgroundWallpaperView.backgroundColor = [UIColor colorWithCSS:CRCCPrefsValueForKey(kCRCCPrefsBackgroundKey)];
        }
            break;
        case CRCCBackgroundStyleImage:
        {
            self.backgroundWallpaperView.image = [[UIImage imageWithContentsOfFile:kCRCCBackgroundImageFilePath] colorizeWithColor:[UIColor colorWithWhite:0 alpha:0.3]];
            
            if(!self.backgroundWallpaperView.image){
                self.backgroundWallpaperView.backgroundColor = [UIColor colorWithHex:0x333333];
            }else{
                self.backgroundWallpaperView.backgroundColor = [self.backgroundWallpaperView.image averageColor];
            }
        }
            break;
        case CRCCBackgroundStyleImageBlur:
        {
            UIImage *image = [UIImage imageWithContentsOfFile:kCRCCBackgroundImageFilePath];
            
            self.backgroundWallpaperView.image = [[image blurredImageWithRadius:25.f] colorizeWithColor:[UIColor colorWithWhite:0 alpha:0.3]];
            
            if(!self.backgroundWallpaperView.image){
                self.backgroundWallpaperView.backgroundColor = [UIColor colorWithHex:0x333333];
            }else{
                self.backgroundWallpaperView.backgroundColor = [image averageColor];
            }
        }
            break;
        case CRCCBackgroundStyleBlur:
        {
            UIImage *image = [self wallpaper];
            self.backgroundWallpaperView.image = [[image blurredImageWithRadius:25.f] colorizeWithColor:[UIColor colorWithWhite:0 alpha:0.3]];
            
            if(!self.backgroundWallpaperView.image){
                self.backgroundWallpaperView.backgroundColor = [UIColor colorWithHex:0x333333];
            }else{
                self.backgroundWallpaperView.backgroundColor = [image averageColor];
            }
        }
            break;
            
        default:
        {
            self.backgroundWallpaperView.backgroundColor = [UIColor colorWithHex:0x333333];
        }
            break;
    }
    
    self.backgroundWallpaperView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.view.backgroundColor = self.backgroundWallpaperView.backgroundColor;
    
    
    [self.view sendSubviewToBack:self.backgroundWallpaperView];
    
    [self.carouselView setType:[CRCCPrefsValueForKey(kCRCCPrefsCoverStyleKey) integerValue]];
    
    [self.carouselView reloadData];
    
    darkenLayer = [CALayer layer];
    
    darkenLayer.frame = self.carouselView.frame;
    
    darkenLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    darkenLayer.opacity = 0.0;
    
    [self.carouselView.layer addSublayer:darkenLayer];
    
    darkenLayer.zPosition = 999;
    
    self.albumNameLabel.text = _albums[0].representativeItem.albumTitle;
    self.albumArtistLabel.text = _albums[0].representativeItem.albumArtist;
    
    if(control_queue == NULL){
        control_queue = dispatch_queue_create("io.c0ldra1n.music.classiccover.control", nil);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayPause) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    
    [[MPMusicPlayerController systemMusicPlayer] beginGeneratingPlaybackNotifications];
    
    [self updatePlayPause];
}

-(void)updatePlayPause{
    
    dispatch_async(control_queue, ^{
        
        UIImage *image;
        
        if([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying){
            image = pauseImage;
        }else{
            image = playImage;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playpauseButton setImage:image forState:UIControlStateNormal];
            [self.playpauseButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
            self.playpauseButton.titleLabel.text = nil;
        });
        
    });
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _albums.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    
    CRCCAlbumArtView *albumArtView;
    
    if(!view){
        
        albumArtView = [[CRCCAlbumArtView alloc] initWithFrame:CGRectMake(0, 0, self.cardUnit, self.cardUnit)];
        
    }else{
        albumArtView = (CRCCAlbumArtView *)view;
        [albumArtView prepareForReuse];
    }
    
    MPMediaItemCollection *collection = _albums[index];
    
    albumArtView.artworkView.image = [[collection.representativeItem artwork] imageWithSize:CGSizeMake(200, 200)];
    
    albumArtView.album = collection;
    
    if(!albumArtView.artworkView.image){
        albumArtView.artworkView.image = self.fallbackArtwork;
    }
    
    return albumArtView;
    
}

-(CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    
    if(carousel.type == iCarouselTypeCoverFlow || carousel.type == iCarouselTypeCoverFlow2){
        
        if (option == iCarouselOptionSpacing) {
            return 0.3;
        }
        
        if (option == iCarouselOptionShowBackfaces) {
            return 0.0;
        }
        
    }
    
    return value;
}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(carousel.currentItemIndex >= 0){
            
            MPMediaItemCollection *collection = _albums[carousel.currentItemIndex];
            
            [UIView transitionWithView:self.view
                              duration:0.1
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                
                                self.albumNameLabel.text = collection.representativeItem.albumTitle;
                                self.albumArtistLabel.text = collection.representativeItem.albumArtist;
                                
                            } completion:nil];
            
        }
        
    });
    
    
}


-(BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index withTap:(nullable UITapGestureRecognizer *)tapGesture{
    
    if(index == carousel.currentItemIndex){
        
        CRCCAlbumArtView *view = (CRCCAlbumArtView *)[carousel itemViewAtIndex:index];
        view.delegate = self;
        [view flip:true];
        
        //         I SERIOUSLY DON'T KNOW HOW THIS WORKS! REALLY WHY DOES THIS WORK!
        
        return false;
    }
    
    
    return true;
}

-(void)albumArtView:(CRCCAlbumArtView *)view didFlip:(BOOL)flip{
    
    if(!flip){
        
        self.carouselView.scrollEnabled = true;
        self.carouselView.tapShortCutEnabled = true;
        
        for (CRCCAlbumArtView *card in self.carouselView.visibleItemViews) {
            if (card != view) {
                [card setActive:YES animated:YES];
            }
        }
        
    }
    
}

-(void)albumArtView:(CRCCAlbumArtView *)view willFlip:(BOOL)flip{
    
    if(flip){
        self.carouselView.scrollEnabled = false;
        self.carouselView.tapShortCutEnabled = false;
        
        for (CRCCAlbumArtView *card in self.carouselView.visibleItemViews) {
            if (card != view) {
                [card setActive:NO animated:YES];
            }
        }
        
    }
    
}

-(IBAction)playpause:(id)sender{
    
    dispatch_async(control_queue, ^{
        
        if([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying){
            [[MPMusicPlayerController systemMusicPlayer] pause];
        }else{
            [[MPMusicPlayerController systemMusicPlayer] play];
        }
        
    });
    
    
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden{
    return false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
