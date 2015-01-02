//
//  XYZIcons8ViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 28/07/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZIcons8ViewController.h"

@interface XYZIcons8ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *icons8web;

@end

@implementation XYZIcons8ViewController

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
    NSString *fullURL = @"http://icons8.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.icons8web loadRequest:requestObj];
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
