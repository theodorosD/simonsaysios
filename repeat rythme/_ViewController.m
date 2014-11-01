//
//  _ViewController.m
//  repeat rythme
//
//  Created by Θεόδωρος Δεληγιαννίδης on 4/13/14.
//  Copyright (c) 2014 NA. All rights reserved.
//

#import "_ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Home_viewcontroller.h"
#import "_AppDelegate.h"

@interface _ViewController ()
@property (nonatomic, retain) UIView *background;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation _ViewController
@synthesize one,two,three,four,headerImageview,restartImageview,menuImageview,isGamestarted,lblScore,lblLevel,lblRemaining,plus1;//stage

NSDate *start ;
NSDate *methodFinish;
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Play Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //R:52, G:152, B:219
    UIColor *blueColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    //R:231, G:76, B:60
    UIColor *redColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
    //R:46, G:204, B:113
    UIColor *greenColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
    //R:243, G:156, B:18
    UIColor *yellowColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
    // R:52, G:73, B:94
    UIColor *petrolColor = [UIColor colorWithRed:48.0/255.0 green:76.0/255.0 blue:91.0/255.0 alpha:1.0];
    
    self.view.backgroundColor=[UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    //Get Device Screen Bounds
     screenRect = [[UIScreen mainScreen] bounds];
     screenHeight = screenRect.size.height;
     screenWidth=screenRect.size.width;
    
    //Google ADS
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height);
    bannerView_ = [[GADBannerView alloc]  initWithAdSize:kGADAdSizeSmartBannerPortrait
                                                  origin:origin];
    bannerView_.adUnitID = @"YOUR ADMOB AD ID";
    bannerView_.rootViewController = self;
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

    //UI
    one=[[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight/6, screenWidth/2, screenWidth/2)];
    two=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2, screenHeight/6, screenWidth/2, screenWidth/2)];
    three=[[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight/6+one.frame.size.height, screenWidth/2, screenWidth/2)];
    four=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2, screenHeight/6+two.frame.size.height, screenWidth/2, screenWidth/2)];
    headerImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight/6, screenWidth,screenWidth/2*2)];
    
    menuImageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu.png"]];
    restartImageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restart.png"]];
    CGRect menuframe = menuImageview.frame;
    menuframe.origin.x=10;
    menuframe.origin.y=((screenHeight/6)-menuframe.size.height)/2;
    menuImageview.frame=menuframe;
    
    CGRect restartframe = restartImageview.frame;
    restartframe.origin.x=screenWidth/2-restartframe.size.width-10;
    restartframe.origin.y=((screenHeight/6)-restartframe.size.height)/2;
    restartImageview.frame=restartframe;

    //PLUS 1 BONUS GFX
    plus1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plus1.png"]];
    plusframe = plus1.frame;
    plusframe.origin.x=screenWidth/2;
    plusframe.origin.y=screenHeight/2-plus1.frame.size.height;
    plus1.frame=plusframe;
    plus1.hidden=YES;
    
    //PROGRESSBAR
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.center = self.view.center;
    self.progressView.progress=1.0;
    self.progressView.tintColor=greenColor;
   //self.progressView.tintAdjustmentMode=UIViewTintAdjustmentModeDimmed;
    CGRect progressFrame=self.progressView.frame;
    progressFrame.size.width=screenWidth;
    progressFrame.origin.x=0;
    progressFrame.origin.y=one.frame.origin.y-progressFrame.size.height;
    self.progressView.frame=progressFrame;
    
    
    lblLevel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2,0,screenWidth,(screenHeight/6)/3)];
    lblLevel.textAlignment=NSTextAlignmentLeft;
    lblLevel.backgroundColor=[UIColor clearColor];
    [lblLevel setAdjustsFontSizeToFitWidth:YES];
    lblLevel.text=@"Level: 0";
    
    lblScore=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2,(screenHeight/6)/3,screenWidth,(screenHeight/6)/3)];
    lblScore.textAlignment=NSTextAlignmentLeft;
    lblScore.backgroundColor=[UIColor clearColor];
    [lblScore setAdjustsFontSizeToFitWidth:YES];
    lblScore.text=@"Score: 0";
    
    lblRemaining=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2,((screenHeight/6)/3)*2,screenWidth,(screenHeight/6)/3)];
    lblRemaining.textAlignment=NSTextAlignmentLeft;
    lblRemaining.backgroundColor=[UIColor clearColor];
    [lblRemaining setAdjustsFontSizeToFitWidth:YES];
    lblRemaining.text=@"Remaining: 0";
    
    if ( IDIOM == IPAD ) {
        /* do something specifically for iPad. */
        [lblLevel setMinimumScaleFactor:1.0f];
        lblLevel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:41.0];
        lblLevel.textColor=petrolColor;
        lblLevel.numberOfLines=0;
        
        [lblScore setMinimumScaleFactor:1.0f];
        lblScore.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:41.0];
        lblScore.textColor=petrolColor;
        lblScore.numberOfLines=0;
        
        [lblRemaining setMinimumScaleFactor:1.0f];
        lblRemaining.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:41.0];
        lblRemaining.textColor=petrolColor;
        lblRemaining.numberOfLines=1;

    } else {
        /* do something specifically for iPhone or iPod touch. */
        
        [lblLevel setMinimumScaleFactor:1.0f];
        lblLevel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
        lblLevel.textColor=petrolColor;
        lblLevel.numberOfLines=0;
        
        [lblScore setMinimumScaleFactor:1.0f];
        lblScore.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
        lblScore.textColor=petrolColor;
        lblScore.numberOfLines=0;

        [lblRemaining setMinimumScaleFactor:0.4f];
        lblRemaining.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:21.0];
        lblRemaining.textColor=petrolColor;
        lblRemaining.numberOfLines=1;

    }
    
    one.backgroundColor=blueColor;
    two.backgroundColor=redColor;
    three.backgroundColor=greenColor;
    four.backgroundColor=yellowColor;
    
    headerImageview.backgroundColor=[UIColor whiteColor];
    
    one.userInteractionEnabled=YES;
    two.userInteractionEnabled=YES;
    three.userInteractionEnabled=YES;
    four.userInteractionEnabled=YES;
    
    menuImageview.userInteractionEnabled=YES;
    restartImageview.userInteractionEnabled=YES;
    [menuImageview sizeToFit];
    [restartImageview sizeToFit];

    UITapGestureRecognizer *oneTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSound:)];
    [one addGestureRecognizer:oneTouch];
    oneTouch.delaysTouchesBegan=YES;
    oneTouch.cancelsTouchesInView=NO;
    
    UITapGestureRecognizer *twoTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSound:)];
    [two addGestureRecognizer:twoTouch];
    twoTouch.delaysTouchesBegan=YES;
    twoTouch.cancelsTouchesInView=NO;
    
    UITapGestureRecognizer *threeTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSound:)];
    [three addGestureRecognizer:threeTouch];
    threeTouch.delaysTouchesBegan=YES;
    threeTouch.cancelsTouchesInView=NO;
    
    UITapGestureRecognizer *fourTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playSound:)];
    [four addGestureRecognizer:fourTouch];
    fourTouch.delaysTouchesBegan=YES;
    fourTouch.cancelsTouchesInView=NO;
    
    UITapGestureRecognizer *menuTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMenu)];
    [menuImageview addGestureRecognizer:menuTouch];
    UITapGestureRecognizer *restartTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartGame:)];
    [restartImageview addGestureRecognizer:restartTouch];
    
    one.tag=1;
    two.tag=2;
    three.tag=3;
    four.tag=4;
    restartImageview.tag=5;
    
    score=0;
    computerSeq=@"";
    playerSeq=@"";
    soundPack=@"0";
    stage=1;
    isGamestarted=FALSE;
    [self.view addSubview:_background];
    [self.view addSubview:headerImageview];
    //[self.view addSubview:self.progressView];

    [self.view addSubview:one];
    [self.view addSubview:two];
    [self.view addSubview:three];
    [self.view addSubview:four];
    [self.view addSubview:menuImageview];
    [self.view addSubview:restartImageview];
    [self.view addSubview:lblLevel];
    [self.view addSubview:lblScore];
    [self.view addSubview:lblRemaining];
    [self.view addSubview:plus1];
    [self beginGame];
    [self.view addSubview:bannerView_];
    [self.view bringSubviewToFront:bannerView_];
}

-(void)loadMenu
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (score>[defaults integerForKey:@"highScore"]) {
        [self saveScore];
    }
    [player stop];
    Home_viewcontroller *homeView=[[Home_viewcontroller alloc]init];
    homeView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homeView animated:YES completion:nil];
}
-(void)restartGame:(UITapGestureRecognizer *)sender
{
    //RESTART GAME AND SET ALL VALUES TO DEF
    if(testint==0){
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if (score>[defaults integerForKey:@"highScore"]) {
//            [defaults setInteger:score forKey:@"highScore"];
//            [defaults synchronize];
            [self saveScore];

        }
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha=0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.3 animations:^{
                self.view.alpha=1;
                testint=0; //Counter for not getting the player touching when sesquence is playing
                score=0;
                computerSeq=@"";
                playerSeq=@"";
                soundPack=@"0";
                stage=1;
                remainingTouches=0;
                isGamestarted=FALSE;
                [self refreshUI];
                [self beginGame];
                self.progressView.progress =1.0f;
            }];
        }];

    }
}
-(void)refreshUI
{
    lblRemaining.text=[NSString stringWithFormat:@"Remaining: 0"];
    lblLevel.text=[NSString stringWithFormat:@"Level: 0"];
    lblScore.text=[NSString stringWithFormat:@"Score: 0"];
}
-(void)beginGame
{
    start=nil;
    methodFinish=nil;
    isGamestarted=YES;
    playerSeq=@"";
    testint=stage;
    [self generateSesq:stage];
    [self performSelector:@selector(playSequence:) withObject:computerSeq afterDelay:0.5];
    lblRemaining.text=[NSString stringWithFormat:@"Remaining: %ld",(long)remainingTouches];
    lblLevel.text=[NSString stringWithFormat:@"Level: %lu",(long)stage];
    self.progressView.progress=1.0f;

}

-(void)generateSesq:(NSInteger)stageLevel
{
    int lowerBound = 1;
    int upperBound = 5;
    NSMutableArray *stringSeq2=[[NSMutableArray alloc]init];
    
    if(stageLevel>1){
        stageLevel=stageLevel-(stage-1);
    }
    for(int ii=0;ii<stageLevel;ii++){
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        [stringSeq2 addObject:[NSString stringWithFormat:@"%d",rndValue]];
    }
    for (id obj in stringSeq2)
    {
        /////   this is where i need to bring the obj into a class to work with
        computerSeq=[NSString stringWithFormat:@"%@%@",computerSeq,obj];
    }
    NSLog(@"SEQUENCE: %@ STAGE: %lu ",computerSeq,(long)stage);
    remainingTouches=computerSeq.length;
    
}

//PLAY PLAYER SEQUENCE
-(void) playAuto:(NSNumber *)_loopInt
{
    int loop = [_loopInt intValue];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/3/%ld.wav", [[NSBundle mainBundle] resourcePath],(long)loop]];
	NSError *error;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	player.numberOfLoops = 0;
	if (player == nil)
    {
        NSLog(@"%@",error);
    }
	else{
		[player play];
    }
    [self playa:[NSString stringWithFormat:@"%@",_loopInt]];
    testint--;
    NSLog(@"%lu",(long)testint);
    //PLAYERTIME START
    if(testint==0){
        start = [NSDate date];
    }
}

//PLAY TOUCH SEQUENCE
-(void)playSound:(UITapGestureRecognizer *)sender
{
    if(testint==0)
    {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    UIView *view = sender.view;
    NSInteger tag = view.tag;
    //Flash Rectangle
    [self playa:[NSString stringWithFormat:@"%ld",(long)tag]];
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/3/%ld.wav", [[NSBundle mainBundle] resourcePath],(long)tag]];
        NSError *error;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        player.numberOfLoops = 0;
        if (player == nil)
        {
            NSLog(@"%@",error);
        }
        else{
            [player play];
        }
    
    playerSeq=[NSString stringWithFormat:@"%@%ld",playerSeq,(long)tag];
    remainingTouches--;
    lblRemaining.text=[NSString stringWithFormat:@"Remaining: %lu",(long)remainingTouches];

        NSLog(@"PLAYER: %@ PLAYER.LENGTH: %lu STAGE: %lu", playerSeq,(unsigned long)playerSeq.length,(long)stage);
        if(isGamestarted==YES )
        {
            if(playerSeq.length==computerSeq.length && [playerSeq isEqual:computerSeq]){
                [self.myTimer invalidate];
                methodFinish = [NSDate date];
                NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
                NSLog(@"Execution Time: %f", stage/2-executionTime);
                if(executionTime<stage/2&&stage>=10){[self bonusGFX];score=score+1;NSLog(@"BONUS");}
                [self performSelector:@selector(playEffects:)  withObject:@"excel3" afterDelay:0.5];
                NSLog(@"WIN WIN ");
                score++;
                lblLevel.text=[NSString stringWithFormat:@"Level: %lu",(long)stage];
                lblScore.text=[NSString stringWithFormat:@"Score: %lu",(long)score];
                playerSeq=@"";
                [self beginGame];
            }else if(playerSeq.length==computerSeq.length && ![playerSeq isEqual:computerSeq]) {
                if (score>[defaults integerForKey:@"highScore"]) {
//                    [defaults setInteger:score forKey:@"highScore"];
//                    [defaults synchronize];
                    [self saveScore];
                }
                testint=0;
                [self.myTimer invalidate];
                [self restartGame:0];
                NSLog(@"ERROR LETS DO IT AGAIN ");
                
            }
            
        }
    }
    
}

-(void)playSequence:(NSString *)playThiseq
{
    stage++;
    unichar character;
    NSString *properString;
	for (int i = 0; i < playThiseq.length; i++) {
		character = [playThiseq  characterAtIndex:i];
        properString=[NSString stringWithFormat: @"%C", character];
        [self performSelector:@selector(playAuto:)  withObject:properString afterDelay:i+1];
        //NSLog(@"%d: %@", i, properString);
	}
}
-(void)bonusGFX
{
    [UIView animateWithDuration:0.6 animations:^{
        plus1.hidden=NO;
        CGRect plusframe2 = plus1.frame;
        plusframe2.size.width=0;
        plusframe2.size.height=0;
        plusframe2.origin.x=lblScore.frame.origin.x+70;
        plusframe2.origin.y=lblScore.frame.origin.y+10;
        plus1.frame=plusframe2;
    } completion:^(BOOL finished) {
        plus1.hidden=YES;
        plus1.frame=plusframe;

    }];

}

-(void) playEffects:(NSString *)filenameArg
{
     NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav", [[NSBundle mainBundle] resourcePath],filenameArg]];
	NSError *error;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	player.numberOfLoops = 0;
	if (player == nil)
    {
        NSLog(@"%@",error);
    }
	else{
		[player play];
    }
}

//Flash rectangle with argument
-(void)playa:(NSString *)col
{
    NSString *asd=col;
    if([asd isEqual:@"1"])
    {
        [UIView animateWithDuration:0.1 animations:^{
            one.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                one.alpha = 1;
            }];
        }];
    }
    
    if([asd isEqual:@"2"])
    {
        [UIView animateWithDuration:0.1 animations:^{
            two.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                two.alpha = 1;
            }];
        }];
    }
    if([asd isEqual:@"3"])
    {
        [UIView animateWithDuration:0.1 animations:^{
            three.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                three.alpha = 1;
            }];
        }];
    }
    if([asd isEqual:@"4"])
    {
        [UIView animateWithDuration:0.1 animations:^{
            four.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                four.alpha = 1;
            }];
        }];
    }
    
}

-(void)simple:(NSString *)playThiseq
{
    NSMutableArray *matchedAddr=[[NSMutableArray alloc]init];
    NSMutableArray *filelist=[NSMutableArray array];

    unichar character;
    NSString *properString;
    
    for (int i = 0; i < playThiseq.length; i++) {
		character = [playThiseq  characterAtIndex:i];
        properString=[NSString stringWithFormat: @"%C", character];
        [matchedAddr addObject:properString];
        //NSLog(@"%d: %@", i, properString);
	}
    for (NSUInteger i = 0; i < [matchedAddr count]; i++)
    {
        NSString *firstVideoPath = [[NSBundle mainBundle] pathForResource:[matchedAddr objectAtIndex:i] ofType:@"wav"];
        //NSLog(@"file %@",firstVideoPath);
        avitem=[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:firstVideoPath]];
        
        NSString * const kStatusKey         = @"status";
        
        [avitem addObserver:self
                              forKeyPath:kStatusKey
                                 options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                 context:@"AVPlayerStatus"];
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(currentItemIs:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:avitem];
*/
        [filelist addObject:avitem];
    }
     player = [AVQueuePlayer queuePlayerWithItems:filelist];

    [player play];
}
-(void)saveScore
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:score forKey:@"highScore"];
    [defaults synchronize];
}
- (void)observeValueForKeyPath:(NSString *)path
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == @"AVPlayerStatus") {
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusUnknown: {
                
            }
                break;
                
            case AVPlayerStatusReadyToPlay: {
                // audio will begin to play now.
                NSLog(@"PLAU");
                //[self playa];
            }
                break;
        }
    }
}

- (void)currentItemIs:(NSNotification *)notification
{
    NSString *asd=[seqArray objectAtIndex:currentColor];
    currentColor=currentColor+1;
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    //NSLog(@"%@",p);
    NSLog(@"%d %@",currentColor,asd);
    
    if([asd isEqual:@"1"])
    {
        [UIView animateWithDuration:0.01 animations:^{
           one.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 animations:^{
               one.alpha = 1;
            }];
        }];
    }
    
    if([asd isEqual:@"2"])
    {
        [UIView animateWithDuration:0.01 animations:^{
            two.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 animations:^{
                two.alpha = 1;
            }];
        }];
    }
    if([asd isEqual:@"3"])
    {
        [UIView animateWithDuration:0.01 animations:^{
            three.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 animations:^{
                three.alpha = 1;
            }];
        }];
    }
    if([asd isEqual:@"4"])
    {
        [UIView animateWithDuration:0.01 animations:^{
            four.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 animations:^{
                four.alpha = 1;
            }];
        }];
    }

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
