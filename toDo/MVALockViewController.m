//
//  AMNotificacionesViewController.m
//  aMenjar
//
//  Created by Mauro Vime Castillo on 06/05/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVALockViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface MVALockViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *diguno;
@property UIImageView *imagenes;
@property UIImageView *imagenes2;
@property UIImageView *imag3;
@property UIImageView *imag4;
@property UIImageView *logo;
@property UIImageView *separador;
@property UILabel *labelEstado;
@property (weak, nonatomic) IBOutlet UIImageView *estado;
@property BOOL reenter;
@property NSString *primero;
@property int paso;

@end

@implementation MVALockViewController

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
    [self.diguno setDelegate:self];
    [self.diguno addTarget:self action:@selector(textFieldUno:) forControlEvents:UIControlEventEditingChanged];
    [self.diguno becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self ponerEnSitio];
    [self clearPass];
    self.reenter = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.diguno becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)ponerEnSitio
{
    CGFloat wid = self.view.frame.size.width;
    
    CGRect flogo = CGRectMake(((wid/2)-50), 80, 100, 100);
    self.logo = [[UIImageView alloc] initWithFrame:flogo];
    self.logo.image = [UIImage imageNamed:@"logo"];
    self.logo.layer.cornerRadius = 15.0f;
    self.logo.clipsToBounds = YES;
    [self.logo setFrame:flogo];
    [self.view addSubview:self.logo];
    
    CGRect f = CGRectMake((wid/2) - 72, 216, 30, 30);
    self.imag4 = [[UIImageView alloc] initWithFrame:f];
    [self.view addSubview:self.imag4];
    
    CGRect f2 = CGRectMake((wid/2) - 34, 216, 30, 30);
    self.imag3 = [[UIImageView alloc] initWithFrame:f2];
    [self.view addSubview:self.imag3];
    
    CGRect f3 = CGRectMake((wid/2) + 4, 216, 30, 30);
    self.imagenes2 = [[UIImageView alloc] initWithFrame:f3];
    [self.view addSubview:self.imagenes2];
    
    CGRect f4 = CGRectMake((wid/2) + 42, 216, 30, 30);
    self.imagenes = [[UIImageView alloc] initWithFrame:f4];
    [self.view addSubview:self.imagenes];
    
    CGRect flabel = CGRectMake(8, 256, (wid - 16), 45);
    self.labelEstado = [[UILabel alloc] initWithFrame:flabel];
    self.labelEstado.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    self.labelEstado.textAlignment = NSTextAlignmentCenter;
    self.labelEstado.text = @"Please enter the password";
    
    [self.labelEstado setFrame:flabel];
    [self.view addSubview:self.labelEstado];
    
    CGRect flinea = CGRectMake(8, 306, (wid - 16), 6);
    self.separador = [[UIImageView alloc] initWithFrame:flinea];
    [self.separador setImage:[UIImage imageNamed:@"separator"]];
    [self.view addSubview:self.separador];
    
    CGFloat hei = self.view.frame.size.height;
    if (hei <= 480) {
        CGRect flogo = CGRectMake(((wid/2)-35), 75, 70, 70);
        [self.logo setFrame:flogo];
        self.logo.image = nil;
        
        CGRect f = CGRectMake((wid/2) - 72, 156, 30, 30);
        [self.imag4  setFrame:f];
        
        CGRect f2 = CGRectMake((wid/2) - 34, 156, 30, 30);
        [self.imag3 setFrame:f2];
        
        CGRect f3 = CGRectMake((wid/2) + 4, 156, 30, 30);
        [self.imagenes2 setFrame:f3];
        
        CGRect f4 = CGRectMake((wid/2) + 42, 156, 30, 30);
        [self.imagenes setFrame:f4];
        
        CGRect flabel = CGRectMake(8, 186, (wid - 16), 45);
        [self.labelEstado setFrame:flabel];
        
        CGRect flinea = CGRectMake(8, 240, (wid - 16), 6);
        [self.separador setFrame:flinea];
    }
}

#define MAXLENGTH 4

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

- (IBAction)textFieldUno:(id)sender {
    int len = (int)[self.diguno.text length];
    CGPoint point = self.imagenes.frame.origin;
    if(len == 0) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO.png"]];
        [self.imag3 setImage:[UIImage imageNamed:@"redondaNO.png"]];
        [self.imag4 setImage:[UIImage imageNamed:@"redondaNO.png"]];
        self.paso = 0;
    }
    else if (len == 1) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO.png"]];
        [self.imag3 setImage:[UIImage imageNamed:@"redondaNO.png"]];
        
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR.png"]];
        if(self.paso == (len-1)) {
            CGRect frameCopy = self.imag4.frame;
            CGRect frameB = self.imag4.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = (frameB.origin.x + 10);
            frameB.origin.y = (point.y + 10.0f);
            [self.imag4 setFrame:frameB];
            [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frameB = self.imag4.frame;
                             frameB.size.height = 30.0f;
                             frameB.size.width = 30.0f;
                             frameB.origin.x = frameCopy.origin.x;
                             frameB.origin.y = point.y;
                             [self.imag4 setFrame:frameB];
                         }
                         completion:^(BOOL finished){
                             ;
                         }];
        }
        if (!self.reenter){
            BOOL lock = [self loadLock];
            if (lock) [self.labelEstado setText:@"Introduce the password to disable it"];
            else [self.labelEstado setText:@"Introduce the password to enable it"];
        }
        else [self.labelEstado setText:@"Introduce the password again"];
        [self.labelEstado setTextColor:[UIColor blackColor]];
        self.paso = 1;
    }
    else if (len == 2) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO.png"]];
        
        [self.imag3 setImage:[UIImage imageNamed:@"redondaG.png"]];
        if(self.paso == (len-1)) {
            CGRect frameCopy = self.imag3.frame;
            CGRect frameB = self.imag3.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = (frameB.origin.x + 10);
            frameB.origin.y = (point.y + 10.0f);
            [self.imag3 setFrame:frameB];
            [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frameB = self.imag3.frame;
                             frameB.size.height = 30.0f;
                             frameB.size.width = 30.0f;
                             frameB.origin.x = frameCopy.origin.x;
                             frameB.origin.y = point.y;
                             [self.imag3 setFrame:frameB];
                         }
                         completion:^(BOOL finished){
                             ;
                         }];
        }
    
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR.png"]];
        self.paso = 2;
    }
    else if (len == 3) {
        [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
        
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaB.png"]];
        
        if(self.paso == (len-1)) {
            CGRect frameCopy = self.imagenes2.frame;
            CGRect frameB = self.imagenes2.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = (frameB.origin.x + 10);
            frameB.origin.y = (point.y + 10.0f);
            [self.imagenes2 setFrame:frameB];
            [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frameB = self.imagenes2.frame;
                             frameB.size.height = 30.0f;
                             frameB.size.width = 30.0f;
                             frameB.origin.x = frameCopy.origin.x;
                             frameB.origin.y = point.y;
                             [self.imagenes2 setFrame:frameB];
                         }
                         completion:^(BOOL finished){
                             ;
                         }];
        }
        
        [self.imag3 setImage:[UIImage imageNamed:@"redondaG.png"]];
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR.png"]];
        if (!self.reenter){
            BOOL lock = [self loadLock];
            if (lock) [self.labelEstado setText:@"Introduce the password to disable it"];
            else [self.labelEstado setText:@"Introduce the password to enable it"];
        }
        else [self.labelEstado setText:@"Introduce the password again"];
        [self.labelEstado setTextColor:[UIColor blackColor]];
        
        self.paso = 3;
    }
    else if (len == 4) {
        
        [self.imagenes setImage:[UIImage imageNamed:@"redondaY.png"]];
        
        if(self.paso == (len-1)) {
            CGRect frameCopy = self.imagenes.frame;
            CGRect frameB = self.imagenes.frame;
            frameB.size.height = 10.0f;
            frameB.size.width = 10.0f;
            frameB.origin.x = (frameB.origin.x + 10);
            frameB.origin.y = (point.y + 10.0f);
            [self.imagenes setFrame:frameB];
            [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect frameB = self.imagenes.frame;
                             frameB.size.height = 30.0f;
                             frameB.size.width = 30.0f;
                             frameB.origin.x = frameCopy.origin.x;
                             frameB.origin.y = point.y;
                             [self.imagenes setFrame:frameB];
                         }
                         completion:^(BOOL finished){
                             ;
                         }];
        }
        [self.imagenes2 setImage:[UIImage imageNamed:@"redondaB.png"]];
        [self.imag3 setImage:[UIImage imageNamed:@"redondaG.png"]];
        [self.imag4 setImage:[UIImage imageNamed:@"redondaR.png"]];
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(check:)
                                       userInfo:nil
                                        repeats:NO];
        
        self.paso = 4;
    }
}

-(void)check:(NSTimer *)timer
{
    if(!self.reenter) {
        BOOL disable = [self loadLock];
        if (disable) {
            NSString *pass =[self loadPass];
            if(pass == nil) [self savePass:@""];
            if([self.diguno.text isEqualToString:pass]) {
                [self saveLock:NO];
                [self savePass:@""];
                [self clearPass];
            }
            else {
                [self.labelEstado setText:@"ERROR\nThe password is incorrect!"];
                [self.labelEstado setTextColor:[UIColor redColor]];
                [self mal];
            }
        }
        else {
            [self reenterPass];
        }
    }
    else {
        if([self.diguno.text isEqualToString:self.primero]) {
            [self saveLock:YES];
            [self savePass:self.diguno.text];
            [self todoOK];
            [self.labelEstado setText:@"Password set correctly!"];
            [self clearPass];
        }
        else {
            [self mal];
        }
    }
}

-(void)todoOK
{
    [self.diguno resignFirstResponder];
    self.logo.layer.cornerRadius = 0;
    self.logo.image = [UIImage imageNamed:@"passOk"];
    self.imagenes.image = [UIImage imageNamed:@"redondaY"];
    self.imagenes2.image = [UIImage imageNamed:@"redondaB"];
    self.imag3.image = [UIImage imageNamed:@"redondaG"];
    self.imag4.image = [UIImage imageNamed:@"redondaR"];
    self.labelEstado.text = @"Password OK";
}

-(void)reenterPass
{
    self.primero = self.diguno.text;
    self.reenter = YES;
    self.paso = 0;
    
    [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imag3 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imag4 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    
    [self.labelEstado setText:@"Introduce the password again"];
    [self.labelEstado setTextColor:[UIColor blackColor]];
    
    [self.diguno setEnabled:YES];
    [self.diguno setText:@""];
    [self.diguno becomeFirstResponder];
    
}

-(void)savePass:(NSString *)pass
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesLockStringKey";
    [defaults setObject:pass forKey:nom];
    [defaults synchronize];
}

-(NSString *)loadPass
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesLockStringKey";
    return [defaults stringForKey:nom];
}

-(void)saveLock:(BOOL)alarmaPermitida
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesLockboolKey";
    [defaults setBool:alarmaPermitida forKey:nom];
    [defaults synchronize];
}

-(BOOL)loadLock
{
    NSString *nom = @"iGradesLockboolKey";
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
    
    [self.diguno setEnabled:YES];
    
    [self.diguno setText:@""];
    
    [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imag3 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imag4 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    
    [self.diguno becomeFirstResponder];
    self.paso = 0;
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
    [self.imagenes setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imagenes2 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imag3 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    [self.imag4 setImage:[UIImage imageNamed:@"redondaNO.png"]];
    
    BOOL lock = [self loadLock];
    if (lock) {
        [self.labelEstado setText:@"Introduce the password to disable it"];
        self.estado.image = [UIImage imageNamed:@"bloqueado"];
    }
    else {
        [self.labelEstado setText:@"Introduce the password to enable it"];
        self.estado.image = [UIImage imageNamed:@"desbloqueado"];
    }
    [self.labelEstado setTextColor:[UIColor blackColor]];
    
    [self.diguno becomeFirstResponder];
    self.reenter = NO;
    self.paso = 0;
    
    [self.logo.layer setMasksToBounds:YES];
    [self.logo.layer setCornerRadius:15.0f];
}

- (IBAction)unwindToNothingNoti:(UIStoryboardSegue *)segue{
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self.diguno resignFirstResponder];
    return YES;
}

@end
