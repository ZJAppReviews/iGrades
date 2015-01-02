//
//  XYZAddElementoViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZAddElementoViewController.h"

@interface XYZAddElementoViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nomE;
@property (weak, nonatomic) IBOutlet UITextField *pesoE;
@property (weak, nonatomic) IBOutlet UITextField *notaE;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property double oldMin;
@property double oldMax;
@property double pass;

@end

@implementation XYZAddElementoViewController

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
    
    [self.nomE setDelegate:self];
    [self.pesoE setDelegate:self];
    [self.notaE setDelegate:self];
    
    if (self.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.navigationItem setTitle:@"New Exam/Assignment"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadValores];
    [self.notaE setPlaceholder:[NSString stringWithFormat:@"%.2f - %.2f", self.oldMin, self.oldMax]];
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
    if (self.nomE.text.length == 0) {
        error = [error stringByAppendingString:@"This Exam/Assignment must have a name\n"];
        errorB = NO;
    }
    if (self.pesoE.text.length == 0) {
        error = [error stringByAppendingString:@"This Exam/Assignment must have a weight\n"];
        errorB = NO;
    }
    else {
        if (([self.pesoE.text doubleValue] + [self.bloque sumaPorcs]) > 100) {
            error = [error stringByAppendingString:@"The weight of all the Exams/Assignments together exceeds a 100%\n"];
            errorB = NO;
        }
    }
    
    if (self.notaE.text.length == 0) {
        // NADA
    }
    else {
        if([self.tipo isEqualToString:@"0"]) { //%
            if (([self.notaE.text doubleValue] < self.oldMin) || ([self.notaE.text doubleValue] > self.oldMax)) {
                error = [error stringByAppendingString:[NSString stringWithFormat:@"The grade must be between %.2f and %.2f\n",self.oldMin,self.oldMax]];
                errorB = NO;
            }
        }
        else { //Dec
            if (([self.notaE.text doubleValue] < self.oldMin) || ([self.notaE.text doubleValue] > self.oldMax)) {
                error = [error stringByAppendingString:[NSString stringWithFormat:@"The grade must be between %.2f and %.2f\n",self.oldMin,self.oldMax]];
                errorB = NO;
            }
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
    [self.nomE resignFirstResponder];
    [self.pesoE resignFirstResponder];
    [self.notaE resignFirstResponder];
    if (sender != self.doneButton) return;
    if (sender == self.doneButton) {
        self.elem = [[XYZElemento alloc] init];
        self.elem.nom = self.nomE.text;
        self.elem.pes = [[NSNumber alloc] initWithDouble:[self.pesoE.text doubleValue]];
        if (self.notaE.text.length > 0) {
            if([self.tipo isEqualToString:@"0"]) {
                self.elem.nota = [[NSNumber alloc] initWithDouble:[self.notaE.text doubleValue]];
            }
            else {
                self.elem.nota = [[NSNumber alloc] initWithDouble:([self.notaE.text doubleValue]*10)];
            }
        }
        else {
            self.elem.nota = nil;
        }
        self.elem.creationDate = [NSDate date];
        self.elem.modificationDate = [NSDate date];
    }
}

-(void)loadValores
{
    if ([self.tipo isEqualToString:@"0"]) {
        self.pass = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PassedValue"] doubleValue];
        self.pass *= 10;
        self.oldMin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MinValue"] doubleValue];
        self.oldMin *= 10;
        self.oldMax = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxValue"] doubleValue];
        self.oldMax *= 10;
    }
    else {
        self.pass = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PassedValue"] doubleValue];
        self.oldMin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MinValue"] doubleValue];
        self.oldMax = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxValue"] doubleValue];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if([textField isEqual:self.nomE]) [self.pesoE becomeFirstResponder];
    return NO;
}

- (IBAction)porcMod:(id)sender {
    NSString *notaT = self.pesoE.text;
    [self.pesoE setText:[notaT stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}

- (IBAction)gradeMod:(UITextField *)sender {
    
    NSString *notaT = self.notaE.text;
    [self.notaE setText:[notaT stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}

@end
