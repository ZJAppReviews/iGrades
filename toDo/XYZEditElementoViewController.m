//
//  XYZEditElementoViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 31/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZEditElementoViewController.h"

@interface XYZEditElementoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nom;
@property (weak, nonatomic) IBOutlet UITextField *pes;
@property (weak, nonatomic) IBOutlet UITextField *nota;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property double oldMin;
@property double oldMax;
@property double pass;

@property double pesoOrig;

@end

@implementation XYZEditElementoViewController

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadValores];
    
    self.pesoOrig = [self.elemento.pes doubleValue];
    
    self.nom.text = self.elemento.nom;
    
    self.pes.text = [NSString stringWithFormat:@"%f", [self.elemento.pes doubleValue]];
    
    if (self.elemento.nota != nil) {
        if([self.tipo isEqualToString:@"0"]) {
            self.nota.text = [NSString stringWithFormat:@"%.2f", [self.elemento.nota doubleValue]];
        }
        else {
            self.nota.text = [NSString stringWithFormat:@"%.2f", ([self.elemento.nota doubleValue]/10)];
        }
    }
    
    [self.nota setPlaceholder:[NSString stringWithFormat:@"%.2f - %.2f", self.oldMin, self.oldMax]];
    
    if (self.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.navigationItem setTitle:[@"Edit " stringByAppendingString:self.elemento.nom]];
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
    if (self.nom.text == 0) {
        error = [error stringByAppendingString:@"This Exam/Assignment needs to have a name\n"];
        errorB = NO;
    }
    if (self.pes.text == 0) {
        error = [error stringByAppendingString:@"This Exam/Assignment needs to have a weight\n"];
        errorB = NO;
    }
    else {
        if (([self.pes.text doubleValue] + ([self.bloque sumaPorcs] - self.pesoOrig)) > 100) {
            error = [error stringByAppendingString:@"The weight of all the Exams/Assignments together exceeds a 100%\n"];
            errorB = NO;
        }
    }
    
    if (self.nota.text.length == 0) {
        // NADA
    }
    else {
        if([self.tipo isEqualToString:@"0"]) { //%
            if (([self.nota.text doubleValue] < self.oldMin) || ([self.nota.text doubleValue] > self.oldMax)) {
                error = [error stringByAppendingString:[NSString stringWithFormat:@"The grade must be between %.2f and %.2f\n",self.oldMin,self.oldMax]];
                errorB = NO;
            }
        }
        else { //Dec
            if (([self.nota.text doubleValue] < self.oldMin) || ([self.nota.text doubleValue] > self.oldMax)) {
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
    [self.nom resignFirstResponder];
    [self.pes resignFirstResponder];
    [self.nota resignFirstResponder];
    if (sender != self.saveButton) return;
    if (sender == self.saveButton) {
        self.elemento.nom = self.nom.text;
        self.elemento.pes = [[NSNumber alloc] initWithDouble:[self.pes.text doubleValue]];
        if (self.nota.text.length > 0) {
            if([self.tipo isEqualToString:@"0"]) {
                self.elemento.nota = [[NSNumber alloc] initWithDouble:[self.nota.text doubleValue]];
            }
            else {
                self.elemento.nota = [[NSNumber alloc] initWithDouble:([self.nota.text doubleValue]*10)];
            }
        }
        else {
            self.elemento.nota = nil;
        }
        self.elemento.modificationDate = [NSDate date];
        self.bloque.modificationDate = [NSDate date];
        self.assig.modificationDate = [NSDate date];
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
    if ([textField isEqual:self.nom]) [self.pes becomeFirstResponder];
    return NO;
}

- (IBAction)porcMod:(id)sender {
    NSString *notaT = self.pes.text;
    [self.pes setText:[notaT stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}

- (IBAction)gradeMod:(UITextField *)sender {
    NSString *notaT = self.nota.text;
    [self.nota setText:[notaT stringByReplacingOccurrencesOfString:@"," withString:@"."]];
}

@end
