//
//  CRCCAlbumDetailViewController.m
//  ClassicCover
//
//  Created by c0ldra1n on 9/2/17.
//  Copyright © 2017 c0ldra1n. All rights reserved.
//

#import "CRCCAlbumDetailViewController.h"
#import "CRCCAlbumTracksTableViewCell.h"
#import "UIImage+Graphics.h"


NSString * timeToLabelTime(NSTimeInterval time){
    int minutes = floor(time/60);
    int seconds = floor(time) - minutes*60;
    return [NSString stringWithFormat:(seconds<10?@"%d:0%d":@"%d:%d"), minutes, seconds];
}

@interface CRCCAlbumDetailViewController (){
    UIImage *_artwork;
}

@end

@implementation CRCCAlbumDetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.view.artistLabel.text = [self.album representativeItem].albumArtist;
    self.view.albumLabel.text = [self.album representativeItem].albumTitle;
    
    _artwork = [self.album.representativeItem.artwork imageWithSize:CGSizeMake(100, 100)];
    
    if(!_artwork){
        
        if(kCFCoreFoundationVersionNumber >= 1348.0){
            //  iOS 10
            _artwork = [UIImage imageNamed:@"placeholder-artwork" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaPlayerUI.framework"] compatibleWithTraitCollection:nil];
        }else{
            //  iOS 9 and Below
            _artwork = [UIImage imageNamed:@"MissingAlbumArtworkGenericProxy" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FuseUI.framework"] compatibleWithTraitCollection:nil];
            
        }
        
    }
    
    self.view.artworkView.image = _artwork;
    
    self.view.backgroundArtworkView.image = [_artwork blurredImageWithRadius:30.f];
    
    self.view.backgroundArtworkView.backgroundColor = [_artwork averageColor];
    
    //    [self.view.trackTableView registerClass:[CRCCAlbumTracksTableViewCell class] forCellReuseIdentifier:@"CRCCAlbumTrackCell"];
    
    [self.view.trackTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.album.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CRCCAlbumTracksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CRCCAlbumTrackCell" forIndexPath:indexPath];
    
    
    MPMediaItem *item = [self.album.items objectAtIndex:indexPath.row];
    
    cell.trackTitleLabel.text = item.title;
    if(item.albumTrackNumber != 0){
        cell.trackNumberLabel.text = [@(item.albumTrackNumber) stringValue];
    }else{
        cell.trackNumberLabel.text = @"";
    }
    cell.trackLengthLabel.text = timeToLabelTime(item.playbackDuration);
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[MPMusicPlayerController systemMusicPlayer] setQueueWithItemCollection:_album];
    [[MPMusicPlayerController systemMusicPlayer] setNowPlayingItem:_album.items[indexPath.row]];
    [[MPMusicPlayerController systemMusicPlayer] play];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    });
    
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
