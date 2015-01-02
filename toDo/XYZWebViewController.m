//
//  XYZWebViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 17/9/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZWebViewController.h"
#import "MBProgressHUD.h"

@interface XYZWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property MBProgressHUD *HUD;

@end

@implementation XYZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.webView setDelegate:self];
    NSURL *url;
    if (![self.asig.url hasPrefix:@"http://"] && ![self.asig.url hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.asig.url]];
    }
    else url  = [NSURL URLWithString:self.asig.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    if (self.asig.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.asig.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [self.navigationItem setTitle:self.asig.sigles];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:self.HUD];
        self.HUD.labelText = @"Opening URL";
        [self.HUD show:YES];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
    });
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
    });
    if (nil != NSClassFromString(@"UIAlertController")) {
        //show alertcontroller
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"ERROR"
                                      message:error.localizedDescription
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok]; // add action to uialertcontroller
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        //show alertview
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
