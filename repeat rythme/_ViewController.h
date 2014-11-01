//
//  _ViewController.h
//  repeat rythme
//
//  Created by Θεόδωρος Δεληγιαννίδης on 4/13/14.
//  Copyright (c) 2014 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import "GAITrackedViewController.h"


@interface _ViewController : GAITrackedViewController{
    GADBannerView *bannerView_;
    NSString *computerSeq;
    NSString *playerSeq;
    NSString *soundPack;
    NSArray *seqArray;
    int currentColor;
    NSInteger score;
    NSInteger testint;
    NSInteger remainingTouches;
    AVAudioPlayer *player;
    AVPlayerItem* avitem;
    NSArray *arrayOfTracks;
    NSUInteger currentTrackNumber;
    CGRect screenRect ;
    CGFloat screenHeight ;
    CGFloat screenWidth;
    CGRect plusframe;
    int stage;
    int count;
}

@property (nonatomic, assign) BOOL isGamestarted;

//@property (nonatomic, assign) NSInteger stage;

@property (nonatomic,retain) IBOutlet UIImageView *one;
@property (nonatomic,retain) IBOutlet UIImageView *two;
@property (nonatomic,retain) IBOutlet UIImageView *three;
@property (nonatomic,retain) IBOutlet UIImageView *four;
@property (nonatomic,retain) IBOutlet UIImageView *headerImageview,*menuImageview,*restartImageview,*plus1;

@property (nonatomic,retain) IBOutlet UILabel *lblScore;
@property (nonatomic,retain) IBOutlet UILabel *lblLevel;
@property (nonatomic,retain) IBOutlet UILabel *lblRemaining;

@property (strong, nonatomic) IBOutlet UIView *playView;

@end
