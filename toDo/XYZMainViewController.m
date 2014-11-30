//
//  XYZMainViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 08/02/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZMainViewController.h"

@interface XYZMainViewController () <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet ADBannerView *iAD;

@end

@implementation XYZMainViewController

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
    self.iAD = [[ADBannerView alloc] init];
    //CGRect bannerFrame = self.iAD.frame;
    //bannerFrame.origin.y = self.view.frame.size.height;
    //self.iAD.frame = bannerFrame;
    
    self.iAD.delegate = self;
    self.iAD.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void) adjustBannerView
{
    CGRect contentViewFrame = self.view.bounds;
    CGRect adBannerFrame = self.iAD.frame;
    
    if([self.iAD isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.iAD.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    else
    {
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.iAD.frame = adBannerFrame;
        //self.contentView.frame = contentViewFrame;
    }];
}

@end
