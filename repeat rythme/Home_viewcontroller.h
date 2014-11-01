//
//  Home_viewcontroller.h
//  repeat rythme
//
//  Created by Θεόδωρος Δεληγιαννίδης on 4/18/14.
//  Copyright (c) 2014 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GAITrackedViewController.h"
#import <GameKit/GameKit.h>

@interface Home_viewcontroller :  GAITrackedViewController <GKGameCenterControllerDelegate> {
    GADBannerView *bannerView_;
    CGFloat button_width;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    int button_margin,line_margin;
    UIFont *helveticaneue46;
    UIFont *helveticaneue46bold;
    CAShapeLayer *line;
    CAShapeLayer *line_bottom;
    AVAudioPlayer *player;
    NSArray *excludeActivities;
}
@property (nonatomic,retain) IBOutlet UILabel *playButtonLabel;
@property (nonatomic,retain) IBOutlet UILabel *howtoButtonLabel;
@property (nonatomic,retain) IBOutlet UILabel *shareButtonLabel;
@property (nonatomic,retain) IBOutlet UILabel *gcButtonLabel;
@property (nonatomic,retain) IBOutlet UILabel *highscoreLabel;

@property (nonatomic,retain) IBOutlet UILabel *header;
@property (nonatomic,retain) IBOutlet UILabel *headerdummy;
@property (nonatomic, retain) IBOutlet UIPopoverController *poc;

//@property (nonatomic,retain) IBOutlet UIImageView *gc;

@end
