//
//  XYZAddBloqueViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZAddBloqueViewController.h"

@interface XYZAddBloqueViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *porcText;

@end

@implementation XYZAddBloqueViewController

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
    
    [self.textField setDelegate:self];
    [self.porcText setDelegate:self];
    
    if (self.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.navigationItem setTitle:@"Add block"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender != self.doneButton) return YES;
    NSString *error = @"";
    BOOL errorB = YES;
    if (self.textField.text.length == 0) {
        error = [error stringByAppendingString:@"This block must have a name\n"];
        errorB = NO;
    }
    if (self.porcText.text.length == 0) {
        error = [error stringByAppendingString:@"This block must have a weight\n"];
        errorB = NO;
    }
    else {
        if (([self.porcText.text doubleValue] + [self.assig sumaPorcs]) > 100) {
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
    [self.textField resignFirstResponder];
    [self.porcText resignFirstResponder];
    if (sender != self.doneButton) return;
    if (sender == self.doneButton) {
        self.bloque = [[XYZBloque alloc] init];
        self.bloque.nom = self.textField.text;
        self.bloque.porc = [[NSNumber alloc] initWithDouble:[self.porcText.text doubleValue]];
        self.bloque.nota = [NSNumber numberWithDouble:0.0];
        self.bloque.creationDate = [NSDate date];
        self.bloque.modificationDate = [NSDate date];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField isEqual:self.textField]) [self.porcText becomeFirstResponder];
    return NO;
}

- (IBAction)porcMod:(id)sender {
    NSString *notaT = self.porcText.text;
    [self.porcText setText:[notaT stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}

@end
