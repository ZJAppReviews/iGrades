//
//  MVAPassViewController.m
//  Bruce Stats
//
//  Created by Mauro Vime Castillo on 16/05/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPassViewController.h"
#import <Parse/Parse.h>
#import <AudioToolbox/AudioServices.h>

@interface MVAPassViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *diguno;
@property (weak, nonatomic) IBOutlet UIImageView *imagenes;
@property (weak, nonatomic) IBOutlet UIImageView *imagenes2;
@property (weak, nonatomic) IBOutlet UIImageView *imag3;
@property (weak, nonatomic) IBOutlet UIImageView *imag4;
@property (weak, nonatomic) IBOutlet UILabel *labelEstado;
@property (weak, nonatomic) IBOutlet UIImageView *logoBruce;
@property int paso;

@end

@implementation MVAPassViewController

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
    [self.logoBruce.layer setMasksToBounds:YES];
    [self.logoBruce.layer setCornerRadius:15.0f];
    BOOL activado = [self loadLock];
    if (!activado) {
        UIView *black = [[UIView alloc] initWithFrame:self.view.frame];
        black.backgroundColor = [UIColor blackColor];
        [self.view addSubview: black];
    }
    else {
        [self performSegueWithIdentifier:@"seguePass" sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    BOOL activado = [self loadLock];
    if (!activado) {
        [self performSegueWithIdentifier:@"seguePass" sender:self];
    }
    else {
        [self clearPass];
        [self.diguno setDelegate:self];
        [self.diguno addTarget:self action:@selector(textFieldUno:) forControlEvents:UIControlEventEditingChanged];
        [self.diguno becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#define MAXLENGTH 4

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

- (IBAction)textFieldUno:(id)sender
{
    int len = (int)[self.diguno.text length];
    if(len == 0) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO"]];
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO"]];
        [self.imag3 setImage:[UIImage imageNamed:@"redondaNO"]];
        [self.imag4 setImage:[UIImage imageNamed:@"redondaNO"]];
        self.paso = 0;
    }
    else if (len == 1) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO"]];
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO"]];
        [self.imag3 setImage:[UIImage imageNamed:@"redondaNO"]];
        
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR"]];
        if(self.paso == (len-1)) {
            CGRect frameB = self.imag4.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = 98.0f;
            frameB.origin.y = 215.5f;
            [self.imag4 setFrame:frameB];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect frameB = self.imag4.frame;
                                 frameB.size.height = 30.0f;
                                 frameB.size.width = 30.0f;
                                 frameB.origin.x = 88.0f;
                                 frameB.origin.y = 205.5f;
                                 [self.imag4 setFrame:frameB];
                             }
                             completion:^(BOOL finished){
                                 ;
                             }];
        }
        self.paso = 1;
    }
    else if (len == 2) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO"]];
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO"]];
        
        [self.imag3 setImage:[UIImage imageNamed:@"redondaG"]];
        if(self.paso == (len-1)) {
            CGRect frameB = self.imag3.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = 136.0f;
            frameB.origin.y = 215.5f;
            [self.imag3 setFrame:frameB];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect frameB = self.imag3.frame;
                                 frameB.size.height = 30.0f;
                                 frameB.size.width = 30.0f;
                                 frameB.origin.x = 126.0f;
                                 frameB.origin.y = 205.5f;
                                 [self.imag3 setFrame:frameB];
                             }
                             completion:^(BOOL finished){
                                 ;
                             }];
        }
        
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR"]];
        self.paso = 2;
    }
    else if (len == 3) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO"]];
        
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaB"]];
        
        if(self.paso == (len-1)) {
            CGRect frameB = self.imagenes2.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = 174.0f;
            frameB.origin.y = 215.5f;
            [self.imagenes2 setFrame:frameB];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect frameB = self.imagenes2.frame;
                                 frameB.size.height = 30.0f;
                                 frameB.size.width = 30.0f;
                                 frameB.origin.x = 164.0f;
                                 frameB.origin.y = 205.5f;
                                 [self.imagenes2 setFrame:frameB];
                             }
                             completion:^(BOOL finished){
                                 ;
                             }];
        }
        
        [self.imag3 setImage:[UIImage imageNamed:@"redondaG"]];
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR"]];
        [self.labelEstado setText:@"Password required"];
        [self.labelEstado setTextColor:[UIColor whiteColor]];
        
        self.paso = 3;
    }
    else if (len == 4) {
        
        [self.imagenes setImage:[UIImage imageNamed:@"redondaY"]];
        
        if(self.paso == (len-1)) {
            CGRect frameB = self.imagenes.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = 212.0f;
            frameB.origin.y = 215.5f;
            [self.imagenes setFrame:frameB];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect frameB = self.imagenes.frame;
                                 frameB.size.height = 30.0f;
                                 frameB.size.width = 30.0f;
                                 frameB.origin.x = 202.0f;
                                 frameB.origin.y = 205.5f;
                                 [self.imagenes setFrame:frameB];
                             }
                             completion:^(BOOL finished){
                                 ;
                             }];
        }
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaB"]];
        [self.imag3 setImage:[UIImage imageNamed:@"redondaG"]];
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR"]];
        [self check];
        
        self.paso = 4;
    }
}

-(void)check
{
    NSString *pass = [self loadPass];
    if([self.diguno.text isEqualToString:pass]) {
        [self clearPass];
        [self performSegueWithIdentifier:@"seguePass" sender:self];
    }
    else {
        [self mal];
    }
}

-(NSString *)loadPass
{
    NSString *nom = @"BruceLockStringKey";
    nom = [nom stringByAppendingString:[[PFUser currentUser] username]];
    return [[NSUserDefaults standardUserDefaults] stringForKey:nom];
}

-(BOOL)loadLock
{
    NSString *nom = @"BruceLockboolKey";
    nom = [nom stringByAppendingString:[[PFUser currentUser] username]];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
    if(data == nil){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:nom];
        return NO;
    }
    else {
        return (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:nom];
    }
}

-(void) mal
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [UIView animateWithDuration:0.05
                     animations:^{
                         CGRect frameB = self.imagenes.frame;
                         frameB.origin.x = frameB.origin.x - 10.0f;
                         [self.imagenes setFrame:frameB];
                         
                         frameB = self.imagenes2.frame;
                         frameB.origin.x = frameB.origin.x - 10.0f;
                         [self.imagenes2 setFrame:frameB];
                         
                         frameB = self.imag3.frame;
                         frameB.origin.x = frameB.origin.x - 10.0f;
                         [self.imag3 setFrame:frameB];
                         
                         frameB = self.imag4.frame;
                         frameB.origin.x = frameB.origin.x - 10.0f;
                         [self.imag4 setFrame:frameB];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.05
                                              animations:^{
                                                  CGRect frameB = self.imagenes.frame;
                                                  frameB.origin.x = frameB.origin.x + 10.0f;
                                                  [self.imagenes setFrame:frameB];
                                                  
                                                  frameB = self.imagenes2.frame;
                                                  frameB.origin.x = frameB.origin.x + 10.0f;
                                                  [self.imagenes2 setFrame:frameB];
                                                  
                                                  frameB = self.imag3.frame;
                                                  frameB.origin.x = frameB.origin.x + 10.0f;
                                                  [self.imag3 setFrame:frameB];
                                                  
                                                  frameB = self.imag4.frame;
                                                  frameB.origin.x = frameB.origin.x + 10.0f;
                                                  [self.imag4 setFrame:frameB];
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      [UIView animateWithDuration:0.05
                                                                       animations:^{
                                                                           CGRect frameB = self.imagenes.frame;
                                                                           frameB.origin.x = frameB.origin.x + 10.0f;
                                                                           [self.imagenes setFrame:frameB];
                                                                           
                                                                           frameB = self.imagenes2.frame;
                                                                           frameB.origin.x = frameB.origin.x + 10.0f;
                                                                           [self.imagenes2 setFrame:frameB];
                                                                           
                                                                           frameB = self.imag3.frame;
                                                                           frameB.origin.x = frameB.origin.x + 10.0f;
                                                                           [self.imag3 setFrame:frameB];
                                                                           
                                                                           frameB = self.imag4.frame;
                                                                           frameB.origin.x = frameB.origin.x + 10.0f;
                                                                           [self.imag4 setFrame:frameB];
                                                                       }
                                                                       completion:^(BOOL finished){
                                                                           if (finished) {
                                                                               [UIView animateWithDuration:0.05
                                                                                                animations:^{
                                                                                                    CGRect frameB = self.imagenes.frame;
                                                                                                    frameB.origin.x = frameB.origin.x - 10.0f;
                                                                                                    [self.imagenes setFrame:frameB];
                                                                                                    
                                                                                                    frameB = self.imagenes2.frame;
                                                                                                    frameB.origin.x = frameB.origin.x - 10.0f;
                                                                                                    [self.imagenes2 setFrame:frameB];
                                                                                                    
                                                                                                    frameB = self.imag3.frame;
                                                                                                    frameB.origin.x = frameB.origin.x - 10.0f;
                                                                                                    [self.imag3 setFrame:frameB];
                                                                                                    
                                                                                                    frameB = self.imag4.frame;
                                                                                                    frameB.origin.x = frameB.origin.x - 10.0f;
                                                                                                    [self.imag4 setFrame:frameB];
                                                                                                }
                                                                                                completion:^(BOOL finished){
                                                                                                }];
                                                                           }
                                                                       }];
                                                  }
                                              }];
                         }
                     }];
    [self clearPass];
    [self.labelEstado setText:@"ERROR\nThe password isn't correct!"];
    [self.labelEstado setTextColor:[UIColor redColor]];
}

- (IBAction)focalizar:(id)sender
{
    [self.diguno setEnabled:YES];
    [self.diguno becomeFirstResponder];
}

-(void)clearPass
{
    [self.diguno setEnabled:YES];
    
    [self.diguno setText:@""];
    
    [self.imagenes setImage:[UIImage imageNamed:@"redondaNO"]];
    [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO"]];
    [self.imag3 setImage:[UIImage imageNamed:@"redondaNO"]];
    [self.imag4 setImage:[UIImage imageNamed:@"redondaNO"]];
    
    [self.labelEstado setText:@"Password required"];
    [self.labelEstado setTextColor:[UIColor whiteColor]];
    
    [self.diguno becomeFirstResponder];

    self.paso = 0;
}

@end