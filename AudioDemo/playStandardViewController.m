//
//  playStandardViewController.m
//  AudioDemo
//
//  Created by John D. Storey on 6/15/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "playStandardViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "GADBannerView.h"
#import "GADInterstitial.h"

GADInterstitial *interstitial_;

@interface playStandardViewController ()

@property (assign) SystemSoundID goal;
@property (assign) SystemSoundID goal3;

@property (strong,nonatomic) UIImageView *ronaldoScream;
@property (strong,nonatomic) UIImageView *ronaldoNormal;
@property (strong,nonatomic) NSNumber *clicks;

-(UIImageView *)requestNormalImage;
-(UIImageView *)requestScreamImage;

@end

@implementation playStandardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self configureSystemSound];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // load clicks from storage
    self.clicks = [[NSUserDefaults standardUserDefaults] objectForKey:@"clicks"];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"GOAL-TASTIC!";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.082 green:0.09 blue:0.125 alpha:1];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName: [UIFont fontWithName:@"Lobster 1.4" size:24],
                                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                      }];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone5_9"]]];
    
    UIImageView *ronaldoScream = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ronaldoScream"]];
    ronaldoScream.frame = CGRectMake((self.view.frame.size.width / 2) - (ronaldoScream.bounds.size.width / 2), (self.view.frame.size.height / 2) - (ronaldoScream.bounds.size.height / 2), ronaldoScream.bounds.size.width, ronaldoScream.bounds.size.height);
    self.ronaldoScream = ronaldoScream;
    
    UIImageView *ronaldoNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ronaldoNormal.png"]];
    ronaldoNormal.frame = CGRectMake((self.view.frame.size.width / 2) - (ronaldoNormal.bounds.size.width / 2), (self.view.frame.size.height / 2) - (ronaldoNormal.bounds.size.height / 2), ronaldoNormal.bounds.size.width, ronaldoNormal.bounds.size.height);
    self.ronaldoNormal = ronaldoNormal;

    [self.view addSubview:[self requestNormalImage]];
    
    // sets whole view as button
    UIButton *goalBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goalBtn.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
    [[goalBtn layer] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0].CGColor];
    [goalBtn addTarget:self action:@selector(startMusic) forControlEvents:UIControlEventTouchDown];
    [goalBtn addTarget:self action:@selector(stopMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goalBtn];
    
#pragma mark - Admob Ads
    // interstitial Ad
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = @"ca-app-pub-7160152319171038/8850189185";
    [interstitial_ loadRequest:[GADRequest request]];
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    [bannerView_ setFrame:CGRectMake(0.0, self.view.frame.size.height-GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    bannerView_.adUnitID = @"ca-app-pub-7160152319171038/4419989588";
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];

}

-(void)startMusic{
    // Needs to be here because gets dismissed every time it stops (see stopMusic
    NSString *goal = [[NSBundle mainBundle] pathForResource:@"goal" ofType:@"wav"];
	NSURL *goalURL = [NSURL fileURLWithPath:goal];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)goalURL, &_goal);
    AudioServicesPlaySystemSound(self.goal);
    [self.view addSubview:[self requestScreamImage]];
}

-(void)stopMusic{
    AudioServicesDisposeSystemSoundID(self.goal);
    [self.view addSubview:[self requestNormalImage]];
    NSNumber *clicks = [[NSUserDefaults standardUserDefaults] objectForKey:@"clicks"];
    int value = [clicks intValue];
    clicks = [NSNumber numberWithInt:value + 1];
    self.clicks = clicks;
    NSLog(@"#ofclicks: %@", self.clicks);
    // ad - presents modal if they've clicked 9 times
    if ([self.clicks isEqual:@(9)]) {
        [interstitial_ presentFromRootViewController:self];
        self.clicks = 0;
    }
}

- (void)configureSystemSound {
    NSString *goal3 = [[NSBundle mainBundle] pathForResource:@"goal3" ofType:@"wav"];
	NSURL *goal3URL = [NSURL fileURLWithPath:goal3];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)goal3URL, &_goal3);
}

-(UIImageView *)requestNormalImage{
    return self.ronaldoNormal;
}

-(UIImageView *)requestScreamImage{
    return self.ronaldoScream;
}


- (void) setClicks:(NSNumber *)clicks{
    _clicks = clicks;
    [[NSUserDefaults standardUserDefaults] setObject:self.clicks forKey:@"clicks"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
