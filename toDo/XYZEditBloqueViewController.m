//
//  XYZEditBloqueViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 31/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZEditBloqueViewController.h"

@interface XYZEditBloqueViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nom;
@property (weak, nonatomic) IBOutlet UITextField *porc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property double pesoOrig;

@end

@implementation XYZEditBloqueViewController

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
    
    [self.nom setDelegate:self];
    [self.porc setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.pesoOrig = [self.bloque.porc doubleValue];
    self.nom.text = self.bloque.nom;
    self.porc.text = [NSString stringWithFormat:@"%.2f", [self.bloque.porc doubleValue]];
    
    if (self.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.navigationItem setTitle:[@"Edit " stringByAppendingString:self.bloque.nom]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender != self.saveButton) return YES;
    NSString *error = @"";
    BOOL errorB = YES;
    if (self.nom.text.length == 0) {
        error = [error stringByAppendingString:@"This block must have a name\n"];
        errorB = NO;
    }
    if (self.porc.text.length == 0) {
        error = [error stringByAppendingString:@"This block must have a weight\n"];
        errorB = NO;
    }
    else {
        if (([self.porc.text doubleValue] + ([self.assig sumaPorcs] - self.pesoOrig)) > 100) {
            error = [error stringByAppendingString:@"The weight of all the blocks together exceeds a 100%\n"];
            errorB = NO;
        }
    }
    
    if (!errorB) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"ERROR"
                                          message:error
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
                                                            message:error
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    return errorB;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.nom resignFirstResponder];
    [self.porc resignFirstResponder];
    if (sender != self.saveButton) return;
    if (sender == self.saveButton) {
        self.bloque.nom = self.nom.text;
        if (self.porc.text.length > 0) {
            self.bloque.porc = [[NSNumber alloc] initWithDouble:[self.porc.text doubleValue]];
        }
        self.bloque.modificationDate = [NSDate date];
        self.assig.modificationDate = [NSDate date];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField isEqual:self.nom]) [self.porc becomeFirstResponder];
    return NO;
}

- (IBAction)porcMod:(id)sender {
    NSString *notaT = self.porc.text;
    [self.porc setText:[notaT stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}

@end
