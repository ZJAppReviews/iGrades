//
//  XYZEditItemViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZEditItemViewController.h"
#import "XYZColorTableViewController.h"

@interface XYZEditItemViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nomAsig;
@property (weak, nonatomic) IBOutlet UITextField *siglas;
@property (weak, nonatomic) IBOutlet UITextField *profesor;
@property (weak, nonatomic) IBOutlet UITextField *textUrl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property NSMutableArray *result;

@end

@implementation XYZEditItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nomAsig setDelegate:self];
    [self.siglas setDelegate:self];
    [self.profesor setDelegate:self];
    [self.textUrl setDelegate:self];
    self.nomAsig.text = self.item.itemName;
    self.siglas.text = self.item.sigles;
    self.profesor.text = self.item.profesor;
    self.result = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.item.bloques count]; ++i) {
        XYZBloque *bloque = [self.item.bloques objectAtIndex:i];
        [self.result addObjectsFromArray:bloque.actes];
    }
    
    if (self.item.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.item.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if(self.item.url != nil) {
        self.textUrl.text = self.item.url;
    }
    
    [self.navigationItem setTitle:[@"Edit " stringByAppendingString:self.item.sigles]];
}

-(void)viewWillAppear:(BOOL)animated
{
    //PASAR COLOR A LA TABLA
    XYZColorTableViewController *tbc = (XYZColorTableViewController *)self.childViewControllers[0];
    tbc.colorSel = self.item.color;
    tbc.papi = self;
    [tbc.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender != self.saveButton) return YES;
    BOOL error = NO;
    NSString *errorText = @"";
    if (self.nomAsig.text.length == 0) {
        errorText = [errorText stringByAppendingString:@"La assignatura debe tener nombre.\n"];
        error = YES;
    }
    if (self.siglas.text.length == 0) {
        errorText = [errorText stringByAppendingString:@"La assignatura debe tener siglas."];
        error = YES;
    }
    if (error) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"ERROR"
                                          message:errorText
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
                                                            message:errorText
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        return NO;
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.nomAsig resignFirstResponder];
    [self.siglas resignFirstResponder];
    [self.profesor resignFirstResponder];
    if (sender != self.saveButton) return;
    if (sender == self.saveButton) {
        self.item.itemName = self.nomAsig.text;
        self.item.modificationDate = [NSDate date];
        self.item.sigles = self.siglas.text;
        if (self.profesor.text.length > 0) {
            self.item.profesor = self.profesor.text;
        }
        else {
            self.item.profesor = nil;
        }
        if(self.textUrl.text.length > 0) {
            self.item.url = self.textUrl.text;
        }
        else {
            self.item.url = nil;
        }
        XYZColorTableViewController *tbc = (XYZColorTableViewController *)self.childViewControllers[0];
        UIColor *colorSel = tbc.colorSel;
        self.item.color = colorSel;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField isEqual:self.nomAsig]) [self.siglas becomeFirstResponder];
    else if ([textField isEqual:self.siglas])[self.profesor becomeFirstResponder];
    else if ([textField isEqual:self.profesor])[self.textUrl becomeFirstResponder];
    return NO;
}

@end
