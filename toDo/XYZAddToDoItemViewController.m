//
//  XYZAddToDoItemViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 22/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZAddToDoItemViewController.h"
#import "XYZColorTableViewController.h"

@interface XYZAddToDoItemViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *textSigles;
@property (weak, nonatomic) IBOutlet UITextField *textProf;
@property (weak, nonatomic) IBOutlet UITextField *textUrl;

@end

@implementation XYZAddToDoItemViewController

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
	
    [self.navigationItem setTitle:@"Add subject"];
    
    [self.textField setDelegate:self];
    [self.textSigles setDelegate:self];
    [self.textProf setDelegate:self];
    [self.textUrl setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    //PASAR PAPI A LA TABLA
    XYZColorTableViewController *tbc = (XYZColorTableViewController *)self.childViewControllers[0];
    tbc.colorSel = nil;
    tbc.papi = self;
    [tbc.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender != self.doneButton) return YES;
    BOOL error = NO;
    NSString *errorText = @"";
    if (self.textField.text.length == 0) {
        errorText = [errorText stringByAppendingString:@"The subject must have a name\n"];
        error = YES;
    }
    if (self.textSigles.text.length == 0) {
        errorText = [errorText stringByAppendingString:@"The subject must have initials"];
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
    [self.textField resignFirstResponder];
    [self.textSigles resignFirstResponder];
    [self.textProf resignFirstResponder];
    [self.textUrl resignFirstResponder];
    if (sender != self.doneButton) return;
    if (sender == self.doneButton) {
        self.toDoItem = [[XYZToDoItem alloc] init];
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.creationDate = [NSDate date];
        self.toDoItem.modificationDate = [NSDate date];
        self.toDoItem.sigles = self.textSigles.text;
        if (self.textProf.text.length > 0) {
            self.toDoItem.profesor = self.textProf.text;
        }
        if(self.textUrl.text.length > 0) {
            self.toDoItem.url = self.textUrl.text;
        }
        
        XYZColorTableViewController *tbc = (XYZColorTableViewController *)self.childViewControllers[0];
        UIColor *colorSel = tbc.colorSel;
        if (colorSel != nil) self.toDoItem.color = colorSel;
        else self.toDoItem.color = [UIColor lightGrayColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField isEqual:self.textField]) [self.textSigles becomeFirstResponder];
    else if ([textField isEqual:self.textSigles])[self.textProf becomeFirstResponder];
    else if ([textField isEqual:self.textProf])[self.textUrl becomeFirstResponder];
    return NO;
}

@end
