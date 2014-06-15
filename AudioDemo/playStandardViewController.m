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

AVAudioPlayer *newPlayer;

@interface playStandardViewController ()

@property (assign) SystemSoundID goal;
@property (assign) SystemSoundID goal3;

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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"GOAL-TASTIC!";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.082 green:0.09 blue:0.125 alpha:1];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName: [UIFont fontWithName:@"Lobster 1.4" size:24],
                                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                      }];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone5_9"]]];

    [self.view addSubview:[self requestNormalImage]];
    
    // goal button
    UIButton *goalBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goalBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [goalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIFont *museoButtonFont500 = [UIFont fontWithName:@"Lobster 1.4" size:18.0];
    [goalBtn setFont:museoButtonFont500];
    goalBtn.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
    [[goalBtn layer] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0].CGColor];
    [goalBtn addTarget:self action:@selector(startMusic) forControlEvents:UIControlEventTouchDown];
    [goalBtn addTarget:self action:@selector(stopMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goalBtn];
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    [bannerView_ setFrame:CGRectMake(0.0, self.view.frame.size.height-GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = @"ca-app-pub-7160152319171038/4419989588";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];


    

//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView_ attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

}

-(IBAction)startMusic{
    
    NSString *goal = [[NSBundle mainBundle] pathForResource:@"goal" ofType:@"wav"];
	NSURL *goalURL = [NSURL fileURLWithPath:goal];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)goalURL, &_goal);
    NSLog(@"music started");
    AudioServicesPlaySystemSound(self.goal);
    
    [self.view addSubview:[self requestScreamImage]];
}

-(IBAction)stopMusic{
    AudioServicesDisposeSystemSoundID(self.goal);
    NSLog(@"music stoped");
    
    [self.view addSubview:[self requestNormalImage]];
}

- (void)configureSystemSound {
    NSString *goal3 = [[NSBundle mainBundle] pathForResource:@"goal3" ofType:@"wav"];
	NSURL *goal3URL = [NSURL fileURLWithPath:goal3];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)goal3URL, &_goal3);
}

-(UIImageView *)requestNormalImage{
    
    UIImageView *ronaldoNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ronaldoNormal.png"]];
    ronaldoNormal.frame = CGRectMake((self.view.frame.size.width / 2) - (ronaldoNormal.bounds.size.width / 2), (self.view.frame.size.height / 2) - (ronaldoNormal.bounds.size.height / 2), ronaldoNormal.bounds.size.width, ronaldoNormal.bounds.size.height);
    
    return ronaldoNormal;
    
}

-(UIImageView *)requestScreamImage{
    
    UIImageView *ronaldoScream = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ronaldoScream"]];
    ronaldoScream.frame = CGRectMake((self.view.frame.size.width / 2) - (ronaldoScream.bounds.size.width / 2), (self.view.frame.size.height / 2) - (ronaldoScream.bounds.size.height / 2), ronaldoScream.bounds.size.width, ronaldoScream.bounds.size.height);
    
    return ronaldoScream;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
