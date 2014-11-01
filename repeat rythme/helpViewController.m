//
//  helpViewController.m
//  repeat rythme
//
//  Created by Θεόδωρος Δεληγιαννίδης on 4/25/14.
//  Copyright (c) 2014 NA. All rights reserved.
//

#import "helpViewController.h"
#import "Home_viewcontroller.h"

@interface helpViewController ()

@end

@implementation helpViewController
@synthesize alertDetailScroll,help;
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
    //iOS 6+7
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    self.view.backgroundColor=[UIColor whiteColor];    
    self.view.alpha=0;
    [UIView animateWithDuration:1.5 animations:^{
        self.view.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.3 animations:^{
            self.view.alpha=1;
        }];
    }];
    
    alertDetailScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    alertDetailScroll.backgroundColor=[UIColor whiteColor];
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake( 10,0,alertDetailScroll.frame.size.width-20, alertDetailScroll.frame.size.height)];
    alertDetailScroll.contentSize=CGSizeMake(self.view.frame.size.width , lblTitle.frame.size.height+50);
    
    help=[[UIImageView alloc] initWithFrame:CGRectMake(0, alertDetailScroll.frame.origin.y, alertDetailScroll.frame.size.width, alertDetailScroll.frame.size.height)];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            //move to your iphone5 storyboard
            help.image=[UIImage imageNamed:@"help-568h.png"];
        }
        else{
            //move to your iphone4s storyboard
            help.image=[UIImage imageNamed:@"help.png"];
            
        }
    }else{
        help.image=[UIImage imageNamed:@"help.png"];
        
    }
    [help setContentMode:UIViewContentModeTop];
    help.userInteractionEnabled=YES;
    UITapGestureRecognizer *exitTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitView)];
    [help addGestureRecognizer:exitTouch];
    alertDetailScroll.scrollEnabled=NO;
    [self.view addSubview:alertDetailScroll];
    [alertDetailScroll addSubview:help];
}

-(void)exitView
{
    Home_viewcontroller *homeView=[[Home_viewcontroller alloc]init];
    homeView.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:homeView animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
