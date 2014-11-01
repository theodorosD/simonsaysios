//
//  Home_viewcontroller.m
//  repeat rythme
//
//  Created by Θεόδωρος Δεληγιαννίδης on 4/18/14.
//  Copyright (c) 2014 NA. All rights reserved.
//

#import "Home_viewcontroller.h"
#import "_ViewController.h"
#import "helpViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <GameKit/GameKit.h>
#import "POP.h"
#import <AVFoundation/AVFoundation.h>

@interface Home_viewcontroller ()
// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;
// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (nonatomic) int64_t scores;
@property (readwrite, assign) BOOL timerRunning;

@property (nonatomic, retain) UIView *playMenuButton;
@property (nonatomic, retain) UIView *howtoMenuButton;
@property (nonatomic, retain) UIView *leaderboardMenuButton;
@property (nonatomic, retain) UIView *highscoreMenuButton;
@property (nonatomic, retain) UIView *twitter;
@property (nonatomic, retain) UIView *facebook;
@property (nonatomic, retain) UIView *background;


@end

@implementation Home_viewcontroller
@synthesize playButtonLabel,howtoButtonLabel,shareButtonLabel,header,headerdummy,gcButtonLabel,highscoreLabel;

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Home Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get system version
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    //User Defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //Game cetner variables
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"";
    //Check version and load authentication based on version
    if(sysVer<7.0){
        [self authenticateLocalPlayeriOS6];
    }else{
        [self authenticateLocalPlayer];
    }
    _timerRunning = NO;
    //iOS 6+7 status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    //Is iPad or iPhone?
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
        button_width=200;
        button_margin=120;
        line_margin=60;
        helveticaneue46=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:86.0f];
        helveticaneue46bold=[UIFont fontWithName:@"HelveticaNeue-Light" size:66.0f];


    } else {
        /* do something specifically for iPhone or iPod touch. */
        button_width=80;
        button_margin=40;
        line_margin=30;
        helveticaneue46=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:46.0f];
        helveticaneue46bold=[UIFont fontWithName:@"HelveticaNeue-Light" size:46.0f];

    }
    /*
    //GAME Colors
    //R:52, G:152, B:219
    UIColor *blueColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    //237, 118, 105
    UIColor *redColor = [UIColor colorWithRed:237.0/255.0 green:118.0/255.0 blue:105.0/255.0 alpha:1.0];
    //R:46, G:204, B:113
    UIColor *greenColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
    //R:243, G:156, B:18
    UIColor *yellowColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
    // R:52, G:73, B:94
    //155, 89, 182
    UIColor *movlColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0];
    */
    UIColor *petrolColor = [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0];

    UIColor *gfxInsidelColor = [UIColor colorWithRed:221.0/255.0 green:219.0/255.0 blue:196.0/255.0 alpha:1.0];
    //UIColor *gfxOutsidelColor = [UIColor colorWithRed:48.0/255.0 green:76.0/255.0 blue:91.0/255.0 alpha:1.0];
    UIFont *helveticaneue24=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:21.0f];

    //Get Device Screen Bounds
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth=screenRect.size.width;
    self.view.backgroundColor=[UIColor whiteColor];
    
    //Google ADS
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    bannerView_ = [[GADBannerView alloc]  initWithAdSize:kGADAdSizeSmartBannerPortrait
                                                  origin:origin];
    bannerView_.adUnitID = @"YOUR ADMOB AD ID";
    bannerView_.rootViewController = self;
    //GADRequest *request=[GADRequest request];
    //request.testDevices=[NSArray arrayWithObjects:@"e29f6d49753c4c8ba2c72418dfd0dc5d",GAD_SIMULATOR_ID,nil];
    [bannerView_ loadRequest:[GADRequest request]];
    //GOOGLE ADS
    
    //background
     _background=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back.png"]];
    CGRect backframe=_background.frame;
    backframe.origin.x=0;
    backframe.origin.y=0;
    backframe.size.height=screenHeight;
    _background.frame=backframe;
    _background.alpha=0.3f;
    
    //Header
    headerdummy=[[UILabel alloc] initWithFrame:CGRectMake(5, 25, screenWidth, screenHeight/6)];
    headerdummy.userInteractionEnabled=YES;
    headerdummy.textAlignment=NSTextAlignmentCenter;
    [headerdummy setAdjustsFontSizeToFitWidth:YES];
    [headerdummy setMinimumScaleFactor:1.0f];
    headerdummy.font=helveticaneue46;
    headerdummy.textColor=petrolColor;
    headerdummy.numberOfLines=0;
    headerdummy.text=@"Simon Says";
    headerdummy.hidden=YES;
    
    header=[[UILabel alloc] initWithFrame:CGRectMake(5, -100, screenWidth, screenHeight/6)];
    header.userInteractionEnabled=YES;
    header.textAlignment=NSTextAlignmentCenter;
    header.backgroundColor=[UIColor clearColor];
    [header setAdjustsFontSizeToFitWidth:YES];
    [header setMinimumScaleFactor:1.0f];
    header.font=helveticaneue46;
    header.textColor=petrolColor;
    header.numberOfLines=0;
    header.text=@"Simon Says";
    
    //Upper Line
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,self.view.frame.size.width-line_margin*2, 0.5)];
    //shape layer for the line
    line = [CAShapeLayer layer];
    line.path = [linePath CGPath];
    line.fillColor = [petrolColor CGColor];
    line.frame = CGRectMake(line_margin, headerdummy.frame.origin.y+headerdummy.frame.size.height,self.view.frame.size.width-line_margin*2,0.5);
    line.opacity=0.0;

    
    //Play Button
    _playMenuButton=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play.png"]];
    CGRect gcframe = _playMenuButton.frame;
    gcframe.origin.x=button_margin;
    gcframe.origin.y=headerdummy.frame.origin.y+header.frame.size.height+_playMenuButton.frame.size.height/2;
    _playMenuButton.frame=gcframe;
    _playMenuButton.userInteractionEnabled=YES;
    UITapGestureRecognizer *playTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPlayView)];
    [_playMenuButton addGestureRecognizer:playTouch];
    _playMenuButton.alpha=0;
    
    //Play Button Label
    playButtonLabel=[[UILabel alloc] initWithFrame:CGRectMake(_playMenuButton.frame.origin.x-10, _playMenuButton.frame.origin.y+_playMenuButton.frame.size.height, _playMenuButton.frame.size.width+20, 25)];
    playButtonLabel.textAlignment=NSTextAlignmentCenter;
    playButtonLabel.backgroundColor=[UIColor clearColor];
    [playButtonLabel setAdjustsFontSizeToFitWidth:YES];
    [playButtonLabel setMinimumScaleFactor:0.3f];
    playButtonLabel.font=helveticaneue24;
    playButtonLabel.numberOfLines=0;
    playButtonLabel.text=@"Play";
    
    //How to play Button
    _howtoMenuButton=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"howto.png"]];
    CGRect gcframe2 = _howtoMenuButton.frame;
    gcframe2.origin.x=screenWidth-_howtoMenuButton.frame.size.width-button_margin;
    gcframe2.origin.y=headerdummy.frame.origin.y+header.frame.size.height+_howtoMenuButton.frame.size.height/2;
    
    _howtoMenuButton.frame=gcframe2;
    _howtoMenuButton.userInteractionEnabled=YES;
    UITapGestureRecognizer *helpTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadHelpView)];
    [_howtoMenuButton addGestureRecognizer:helpTouch];
    _howtoMenuButton.alpha=0;

    //How to play Button Label
    howtoButtonLabel=[[UILabel alloc] initWithFrame:CGRectMake(_howtoMenuButton.frame.origin.x-10, _howtoMenuButton.frame.origin.y+_howtoMenuButton.frame.size.height, _howtoMenuButton.frame.size.width+20, 25)];
    howtoButtonLabel.textAlignment=NSTextAlignmentCenter;
    [howtoButtonLabel setAdjustsFontSizeToFitWidth:YES];
    howtoButtonLabel.backgroundColor=[UIColor clearColor];
    [howtoButtonLabel setMinimumScaleFactor:0.3f];
    howtoButtonLabel.font=helveticaneue24;
    howtoButtonLabel.numberOfLines=1;
    howtoButtonLabel.text=@"How to play";
    
    //GAMECENTER Button
    _leaderboardMenuButton=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leaderboard.png"]];
    CGRect gcframe3 = _leaderboardMenuButton.frame;
    gcframe3.origin.x=button_margin;
    gcframe3.origin.y=_playMenuButton.frame.origin.y+_playMenuButton.frame.size.height+_leaderboardMenuButton.frame.size.height;
    _leaderboardMenuButton.frame=gcframe3;
    _leaderboardMenuButton.userInteractionEnabled=YES;
    UITapGestureRecognizer *gamecenterTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGC)];
    [_leaderboardMenuButton addGestureRecognizer:gamecenterTouch];
    _leaderboardMenuButton.alpha=0;

    //GAMECENTER Label
    gcButtonLabel=[[UILabel alloc] initWithFrame:CGRectMake(_leaderboardMenuButton.frame.origin.x-15, _leaderboardMenuButton.frame.origin.y+_leaderboardMenuButton.frame.size.height, _leaderboardMenuButton.frame.size.width+30, 25)];
    gcButtonLabel.textAlignment=NSTextAlignmentCenter;
    gcButtonLabel.backgroundColor=[UIColor clearColor];
    [gcButtonLabel setAdjustsFontSizeToFitWidth:YES];
    [gcButtonLabel setMinimumScaleFactor:0.3f];
    gcButtonLabel.font=helveticaneue24;
    gcButtonLabel.numberOfLines=1;
    gcButtonLabel.text=@"Leaderboards";
  
    //Share Button
    _highscoreMenuButton=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"score.png"]];
    CGRect gcframe4 = _howtoMenuButton.frame;
    gcframe4.origin.x=screenWidth-_highscoreMenuButton.frame.size.width-button_margin;
    gcframe4.origin.y=_howtoMenuButton.frame.origin.y+_howtoMenuButton.frame.size.height+_highscoreMenuButton.frame.size.height;
    _highscoreMenuButton.frame=gcframe4;
    _highscoreMenuButton.userInteractionEnabled=YES;
    UITapGestureRecognizer *highscoreTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadShareView)];
    [_highscoreMenuButton addGestureRecognizer:highscoreTouch];
    _highscoreMenuButton.alpha=0;

    //Share Button label
    shareButtonLabel=[[UILabel alloc] initWithFrame:CGRectMake(_highscoreMenuButton.frame.origin.x-15, _highscoreMenuButton.frame.origin.y+_highscoreMenuButton.frame.size.height, _highscoreMenuButton.frame.size.width+30, 25)];
    shareButtonLabel.textAlignment=NSTextAlignmentCenter;
    shareButtonLabel.backgroundColor=[UIColor clearColor];
    [shareButtonLabel setAdjustsFontSizeToFitWidth:YES];
    [shareButtonLabel setMinimumScaleFactor:0.3f];
    shareButtonLabel.font=helveticaneue24;
    shareButtonLabel.numberOfLines=1;
    shareButtonLabel.text=@"Share highscore";
    
    NSInteger highscore=[defaults integerForKey:@"highScore"];
    highscoreLabel=[[UILabel alloc] initWithFrame:CGRectMake(_highscoreMenuButton.frame.origin.x, _highscoreMenuButton.frame.origin.y-2, _highscoreMenuButton.frame.size.width,_highscoreMenuButton.frame.size.width)];
    highscoreLabel.textColor=gfxInsidelColor;
    highscoreLabel.backgroundColor=[UIColor clearColor];
    highscoreLabel.textAlignment=NSTextAlignmentCenter;
    [highscoreLabel setAdjustsFontSizeToFitWidth:YES];
    [highscoreLabel setMinimumScaleFactor:0.5f];
    highscoreLabel.font=helveticaneue46bold;
    highscoreLabel.text=[NSString stringWithFormat:@"%ld",(long)highscore];
    highscoreLabel.numberOfLines=0;
    highscoreLabel.alpha=0;
    
    //FACEBOOK
    _facebook=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fb.png"]];
    CGRect gcframe5 = _facebook.frame;
    gcframe5.origin.x=screenWidth/2-_facebook.frame.size.width;
    gcframe5.origin.y=bannerView_.frame.origin.y -_facebook.frame.size.height-15;
    _facebook.frame=gcframe5;
    _facebook.userInteractionEnabled=YES;
    UITapGestureRecognizer *fbTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFBapp)];
    [_facebook addGestureRecognizer:fbTouch];
    _facebook.alpha=0;
    
    //TWITTER
    _twitter=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tw.png"]];
    CGRect gcframe6 = _twitter.frame;
    gcframe6.origin.x=screenWidth/2+_twitter.frame.size.width/2-5;
    gcframe6.origin.y=bannerView_.frame.origin.y -_facebook.frame.size.height-13;
    _twitter.frame=gcframe6;
    _twitter.userInteractionEnabled=YES;
    UITapGestureRecognizer *twTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTwitterapp)];
    [_twitter addGestureRecognizer:twTouch];
    _twitter.alpha=0;
    
    line_bottom = [CAShapeLayer layer];
    line_bottom.path = [linePath CGPath];
    line_bottom.fillColor = [petrolColor CGColor];
    line_bottom.frame = CGRectMake(line_margin, _facebook.frame.origin.y-10,self.view.frame.size.width-line_margin*2,0.5);
    line_bottom.opacity=0.0;
    
    /*
    rateButton=[[UILabel alloc] initWithFrame:CGRectMake(button_width/2,-40 , screenWidth-button_width, 40)];
    rateButton.backgroundColor=redColor;
    rateButton.userInteractionEnabled=YES;
    rateButton.textAlignment=NSTextAlignmentCenter;
    [rateButton setAdjustsFontSizeToFitWidth:YES];
    [rateButton setMinimumScaleFactor:1.0f];
    rateButton.font=[UIFont fontWithName:@"Helsinki" size:24.0];
    rateButton.numberOfLines=0;
    rateButton.text=@"Rate us";
    UITapGestureRecognizer *rateTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadRateView)];
    [rateButton addGestureRecognizer:rateTouch];
    */
    [self.view addSubview:_background];
    [self.view addSubview:headerdummy];
    [self.view addSubview:header];
    [self.view.layer addSublayer:line];
        
    [self.view addSubview:_playMenuButton];
    [self.view addSubview:_howtoMenuButton];
    [self.view addSubview:_leaderboardMenuButton];
    [self.view addSubview:_highscoreMenuButton];
    [self.view addSubview:highscoreLabel];
    
    [self.view addSubview:playButtonLabel];
    [self.view addSubview:howtoButtonLabel];
    [self.view addSubview:gcButtonLabel];
    [self.view addSubview:shareButtonLabel];
    [self.view addSubview:_facebook];
    [self.view addSubview:_twitter];
    [self.view.layer addSublayer:line_bottom];
    
    //Set all button invisible
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
           // subview.hidden = NO;
            subview.alpha=0;
            //subview.backgroundColor=[UIColor whiteColor];
        }
    }
    //Button animation
    [self performSelector:@selector(startSFXnew)  withObject:header afterDelay:0.7];
    //Add Ads
    [self.view addSubview:bannerView_];
    [self.view bringSubviewToFront:bannerView_];
    //Submit Score
    [self reportScore];
}

-(void)startSFXnew
{
    
    
    POPSpringAnimation *headerdummyAnimation = [POPSpringAnimation animation];
    headerdummyAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    headerdummyAnimation.toValue=[NSNumber numberWithFloat:headerdummy.frame.origin.y+header.frame.size.height/2];
    headerdummyAnimation.springBounciness = 100.0;
    headerdummyAnimation.springSpeed = 20.0;

    
    POPSpringAnimation *lineAnimation = [POPSpringAnimation animation];
    lineAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerOpacity];
    lineAnimation.toValue=[NSNumber numberWithFloat:0.5f];
    lineAnimation.springBounciness = 100.0;
    lineAnimation.springSpeed = 20.0;
    
    POPSpringAnimation *lineAnimationbottom= [POPSpringAnimation animation];
    lineAnimationbottom.property = [POPAnimatableProperty propertyWithName:kPOPLayerOpacity];
    lineAnimationbottom.toValue=[NSNumber numberWithFloat:0.5f];
    lineAnimationbottom.springBounciness = 100.0;
    lineAnimationbottom.springSpeed = 20.0;
    
    POPSpringAnimation *playButtonAnimation = [POPSpringAnimation animation];
    playButtonAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    playButtonAnimation.toValue=[NSNumber numberWithFloat:1.0];
    playButtonAnimation.springBounciness = 100.0;
    playButtonAnimation.springSpeed = 40.0;
    
    POPSpringAnimation *helpButtonAnimation = [POPSpringAnimation animation];
    helpButtonAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    helpButtonAnimation.toValue=[NSNumber numberWithFloat:1.0];
    helpButtonAnimation.springBounciness = 100.0;
    helpButtonAnimation.springSpeed = 40.0;
    
    POPSpringAnimation *gamecenterButtonAnimation = [POPSpringAnimation animation];
    gamecenterButtonAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    gamecenterButtonAnimation.toValue=[NSNumber numberWithFloat:1.0];
    gamecenterButtonAnimation.springBounciness = 100;
    gamecenterButtonAnimation.springSpeed = 40.0;
    
    POPSpringAnimation *scoreButtonAnimation = [POPSpringAnimation animation];
    scoreButtonAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    scoreButtonAnimation.toValue=[NSNumber numberWithFloat:1.0];
    scoreButtonAnimation.springBounciness = 100.0;
    scoreButtonAnimation.springSpeed = 40.0;
    
    POPSpringAnimation *scorelabelButtonAnimation = [POPSpringAnimation animation];
    scorelabelButtonAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    scorelabelButtonAnimation.toValue=[NSNumber numberWithFloat:1.0];
    scorelabelButtonAnimation.springBounciness = 100.0;
    scorelabelButtonAnimation.springSpeed = 40.0;

    
    [header pop_addAnimation:headerdummyAnimation forKey:@"headerpop"];
    [line pop_addAnimation:lineAnimation forKey:@"linepop"];
    [line_bottom pop_addAnimation:lineAnimationbottom forKey:@"linebpop"];

    [_playMenuButton pop_addAnimation:playButtonAnimation forKey:@"playpop"];
    [_howtoMenuButton pop_addAnimation:helpButtonAnimation forKey:@"helpop"];
    [_leaderboardMenuButton pop_addAnimation:gamecenterButtonAnimation forKey:@"leaderpop"];
    [_highscoreMenuButton pop_addAnimation:scoreButtonAnimation forKey:@"highpop"];
    [highscoreLabel pop_addAnimation:scorelabelButtonAnimation forKey:@"highlabelpop"];
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            // subview.hidden = NO;
            [UIView animateWithDuration:1.2 animations:^{
            } completion:^(BOOL finished) {
                subview.alpha=1;
                _twitter.alpha=1;
                _facebook.alpha=1;
                [UIView animateWithDuration:0.8 animations:^{
                }];
            }];
            //subview.backgroundColor=[UIColor whiteColor];
        }
    }
   
}

//Load play view
-(void)loadPlayView
{
    _ViewController *playView=[[_ViewController alloc]init];
    playView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:playView animated:YES completion:nil];
}
-(void)loadHelpView
{
        helpViewController *helpView=[[helpViewController alloc]init];
        helpView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:helpView animated:YES completion:nil];
}
-(void)loadRateView
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8&id=869789983"]];
}
-(void)openTwitterapp
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=kouna_to"]];
}
-(void)openFBapp
{
    NSURL *url = [NSURL URLWithString:@"fb://profile/YOUR_FB_ID"];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)loadShareView
{
    //Load variables
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger highscore=[defaults integerForKey:@"highScore"];

    NSArray *activityItems = @[[NSString stringWithFormat:@"Just played Simon Says and my highscore is %ld. Can you beat it? #simonsaysgame\n",(long)highscore],[NSURL URLWithString:@"http://"]];
    
    //IOS 6 doesnt support UIActivityTypeAddToReadingList
    if(&UIActivityTypeAddToReadingList) {
        // UIActivityTypeAddToReadingList is available
    excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint,UIActivityTypeAddToReadingList];
    } else {
        // Its not available. Don't use it.
    excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint];
    }
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    activityController.excludedActivityTypes=excludeActivities;
    activityController.title=@"Share highscore";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.view.window != nil){
       self.poc=[[UIPopoverController alloc] initWithContentViewController:activityController];
        [self.poc presentPopoverFromRect:CGRectMake(_highscoreMenuButton.frame.origin.x-75, _highscoreMenuButton.frame.origin.y, 100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }
    }
}
-(void) playSound:(NSNumber *)_loopInt
{
    int loop = [_loopInt intValue];
    NSString *filename= [NSString stringWithFormat:@"/%ld.wav",(long)loop];
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath],filename];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}
//IOS 6 authenticate
-(void)authenticateLocalPlayeriOS6{
    GKLocalPlayer* localPlayer =[GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler =^(UIViewController *viewController,NSError *error) {
        if ([GKLocalPlayer localPlayer].authenticated) {
            _gameCenterEnabled = YES;
        } else if(viewController!=nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else {
            _gameCenterEnabled = NO;
        }
    };
}
//IOS 7 authenticate
-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}
//Report score to GC
-(void)reportScore{
    GKScore *score;
        if ([GKLocalPlayer localPlayer].isAuthenticated) {
            // Create a GKScore object to assign the score and report it as a NSArray object.
            if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
                score = [[GKScore alloc] initWithCategory:@"my_leaderboard"];
            } else {
                score = [[GKScore alloc] initWithLeaderboardIdentifier:@"my_leaderboard"];
            }
//            GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"my_leaderboard"];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            _scores= [defaults integerForKey:@"highScore"];
            score.value =_scores;
            [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
}
-(void)showGC
{
        [self showLeaderboardAndAchievements:YES];
        //[self showLeaderboardAndAchievements:YES];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        if(sysVer<7.0){
            gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gcViewController.leaderboardTimeScope = GKLeaderboardTimeScopeAllTime;
            
            gcViewController.leaderboardCategory = _leaderboardIdentifier;
        }else{
            gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
            gcViewController.viewState = GKGameCenterViewControllerStateDefault;
        }
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    [self presentViewController:gcViewController animated:YES completion:nil];
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"asd");
}

//MISC FUNCTIONS,Non essential
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    return urlWasHandled;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
