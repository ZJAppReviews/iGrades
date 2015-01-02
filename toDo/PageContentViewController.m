//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

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
    CGFloat wid = self.view.frame.size.width;
    CGFloat alt = self.view.frame.size.height;
    CGRect f;
    if (alt <= 480) f = CGRectMake((wid/2) - (260/2), alt - 390, 260, 488);
    else f = CGRectMake((wid/2) - (260/2), alt - 488, 260, 488);
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:f];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    [self.view addSubview:self.backgroundImageView];
    self.titleLabel.text = self.titleText;
    self.titleLabel.userInteractionEnabled = NO;
    self.subtitleLabel.text = self.subtitleText;
    self.subtitleLabel.userInteractionEnabled = NO;
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
