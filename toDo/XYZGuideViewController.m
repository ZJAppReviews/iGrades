//
//  XYZGuideViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 01/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZGuideViewController.h"

@interface XYZGuideViewController ()

@end

@implementation XYZGuideViewController

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
    // Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"guide" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    
    if (nil != NSClassFromString(@"UIAlertController")) {
        // iOS 8
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:targetURL];
        [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    }
    else {
        // iOS 7.0 and lower
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
