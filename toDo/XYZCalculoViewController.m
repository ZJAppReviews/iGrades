//
//  XYZCalculoViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 28/07/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZCalculoViewController.h"
#import "XYZToDoItem.h"

@interface XYZCalculoViewController () <UITextFieldDelegate,UIAlertViewDelegate>

@property double oldMin;
@property double oldMax;
@property double pass;
@property CGPoint originalCenter;
@property NSMutableArray *toDoItems;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation XYZCalculoViewController

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

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

-(void) viewWillAppear:(BOOL)animated
{
    self.originalCenter = self.view.center;
    [self.value setAdjustsFontSizeToFitWidth:YES];
    
    self.oldMin = 0;
    self.oldMax = 10;
    self.pass = 5;
    
    [self.min setDelegate:self];
    [self.max setDelegate:self];
    [self.value setDelegate:self];
    
    if([self loadFirst]) {
        UIImage *iconRefreshButton = [UIImage imageNamed:@"next"];
        iconRefreshButton = [iconRefreshButton imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.nextButton.imageView setImage:iconRefreshButton];
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Grade format"
                                          message:@"Please select your prefered format. Percentage or decimal. You can always change this in the settings."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Percentage"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     self.tipo = @"0";
                                     NSString *nom = @"iGradesTipo";
                                     [[NSUserDefaults standardUserDefaults] setObject:self.tipo forKey:nom];
                                     
                                     [self loadTipo];
                                     [self cargar];
                                     [self loadLista];
                                     [self guardar];
                                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iGradesFirstCalc"];
                                 }];
            [alert addAction:ok]; // add action to uialertcontroller
            
            UIAlertAction* ok2 = [UIAlertAction
                                 actionWithTitle:@"Decimal"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     self.tipo = @"1";
                                     NSString *nom = @"iGradesTipo";
                                     [[NSUserDefaults standardUserDefaults] setObject:self.tipo forKey:nom];
                                     
                                     [self loadTipo];
                                     [self cargar];
                                     [self loadLista];
                                     [self guardar];
                                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iGradesFirstCalc"];
                                 }];
            [alert addAction:ok2]; // add action to uialertcontroller
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            //show alertview
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Grade format", @"AlertView")
                                                                message:NSLocalizedString(@"Please select your prefered format. Percentage or decimal. You can always change this in the settings.", @"AlertView")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Percentage", @"AlertView")
                                                      otherButtonTitles:NSLocalizedString(@"Decimal", @"AlertView"), nil];
            [alertView show];
        }
    }
    
    else {
        [self loadTipo];
        [self cargar];
        [self loadLista];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.tipo = @"0";
    }
    else {
        self.tipo = @"1";
    }
    NSString *nom = @"iGradesTipo";
    [[NSUserDefaults standardUserDefaults] setObject:self.tipo forKey:nom];
    
    [self loadTipo];
    [self cargar];
    [self loadLista];
    [self guardar];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iGradesFirstCalc"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minChanged:(id)sender {
    
    if ([self.min.text intValue] != self.oldMin) {
        double minVal = [self.min.text doubleValue];
        self.oldMin = minVal;
        double maxVal = [self.max.text doubleValue];
        self.oldMax = maxVal;
        self.pass = ((maxVal-minVal)/2);
        self.pass += minVal;
        
        [self.slider setMinimumValue:(self.oldMin*100)];
        [self.slider setMaximumValue:(self.oldMax*100)];
        [self.slider setValue:(self.pass*100) animated:YES];
        NSString *val = [NSString stringWithFormat:@"%.2f",self.pass];
        self.value.text = val;
        [self recalcularAssig];
        [self guardar];
    }
}

- (IBAction)maxChanged:(id)sender {
    
    if ([self.max.text intValue] != self.oldMax) {
        [self recalcularAssig];
        
        double minVal = [self.min.text doubleValue];
        self.oldMin = minVal;
        double maxVal = [self.max.text doubleValue];
        self.oldMax = maxVal;
        self.pass = ((maxVal-minVal)/2);
        self.pass += minVal;
        
        [self.slider setMinimumValue:(self.oldMin*100)];
        [self.slider setMaximumValue:(self.oldMax*100)];
        [self.slider setValue:(self.pass*100) animated:YES];
        NSString *val = [NSString stringWithFormat:@"%.2f",self.pass];
        self.value.text = val;
        [self guardar];
    }
}

- (IBAction)passChanged:(id)sender {
    double passOld =  self.pass;
    self.pass = [self.value.text doubleValue];
    if(self.oldMin <= self.pass && self.oldMax >= self.pass){
        [self.slider setValue:(self.pass*100) animated:YES];
        [self guardar];
    }
    else {
        self.pass = passOld;
        NSString *val = [NSString stringWithFormat:@"%.2f",self.pass];
        self.value.text = val;
        // ERROR
    }
}

- (IBAction)sliderChanged:(id)sender {
    double valor = (double)(self.slider.value/100);
    self.pass = valor;
    NSString *val = [NSString stringWithFormat:@"%.2f",valor];
    self.value.text = val;
    
    [self guardar];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1) {
        double val = 130;
        if (IS_IPHONE5) val = 50;
        [UIView animateWithDuration:0.05
                         animations:^{
                             self.view.center = CGPointMake(self.originalCenter.x,self.originalCenter.y - val);
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.view.center = self.originalCenter;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)guardar
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    if ([self.tipo isEqualToString:@"0"]) {
        [defaults setObject:[NSNumber numberWithDouble:(self.pass/10)] forKey:@"PassedValue"];
        [defaults setObject:[NSNumber numberWithDouble:(self.oldMin/10)] forKey:@"MinValue"];
        [defaults setObject:[NSNumber numberWithDouble:(self.oldMax/10)] forKey:@"MaxValue"];
    }
    else {
        [defaults setObject:[NSNumber numberWithDouble:self.pass] forKey:@"PassedValue"];
        [defaults setObject:[NSNumber numberWithDouble:self.oldMin] forKey:@"MinValue"];
        [defaults setObject:[NSNumber numberWithDouble:self.oldMax] forKey:@"MaxValue"];
    }
    [defaults synchronize];
    [self guardarLista];
}

- (void) guardarLista {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.toDoItems = [[self.toDoItems sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.toDoItems] forKey:@"arraySaveMauroVimeasig"];
    [defaults synchronize];
    for(int i=0; i < [self.toDoItems count]; ++i) {
        XYZToDoItem *assig = [self.toDoItems objectAtIndex:i];
        for(int j = 0; j < [assig.bloques count]; ++j) {
            XYZBloque *bloque = [assig.bloques objectAtIndex:j];
            [bloque recalculateNota];
        }
    }
}

- (void)cargar
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    if ([self.tipo isEqualToString:@"0"]) {
        self.pass = [[defaults objectForKey:@"PassedValue"] doubleValue];
        self.pass *= 10;
        self.oldMin = [[defaults objectForKey:@"MinValue"] doubleValue];
        self.oldMin *= 10;
        self.oldMax = [[defaults objectForKey:@"MaxValue"] doubleValue];
        self.oldMax *= 10;
        if(self.oldMax == 0) {
            self.oldMin = 0;
            self.oldMax = 100.0;
            self.pass = 50;
        }
    }
    else {
        self.pass = [[defaults objectForKey:@"PassedValue"] doubleValue];
        self.oldMin = [[defaults objectForKey:@"MinValue"] doubleValue];
        self.oldMax = [[defaults objectForKey:@"MaxValue"] doubleValue];
        if(self.oldMax == 0){
            self.oldMin = 0;
            self.oldMax = 10.0;
            self.pass = 5.0;
        }
    }
    
    [self.min setText:[NSString stringWithFormat:@"%.2f",self.oldMin]];
    [self.max setText:[NSString stringWithFormat:@"%.2f",self.oldMax]];
    
    [self.slider setMinimumValue:(self.oldMin*100)];
    [self.slider setMaximumValue:(self.oldMax*100)];
    [self.slider setValue:(self.pass*100)];
    
    self.value.text = [NSString stringWithFormat:@"%.2f",self.pass];
}

-(void)loadTipo
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesTipo";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setObject:@"0" forKey:nom];
        self.tipo = @"0";
    }
    else {
        self.tipo = (NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:nom];
    }
}

- (void)loadLista {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"arraySaveMauroVimeasig"];
    if (savedArray != nil)
    {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            self.toDoItems = [[NSMutableArray alloc] initWithArray:oldArray];
        } else {
            self.toDoItems = [[NSMutableArray alloc] init];
        }
    }
}

-(void)recalcularAssig
{
    float minVal = 0.0;
    float maxVal = 0.0;
    float ref;
    if ([self.tipo isEqualToString:@"0"]) {
        minVal = [self.min.text doubleValue];
        maxVal = [self.max.text doubleValue];
        ref = self.oldMax - self.oldMin;
    }
    else {
        minVal = ([self.min.text doubleValue]*10);
        maxVal = ([self.max.text doubleValue]*10);
        ref = (self.oldMax*10) - (self.oldMin*10);
    }
    float refNew = maxVal - minVal;
    for(int i = 0; i < [self.toDoItems count]; ++i) {
        XYZToDoItem *assig = [self.toDoItems objectAtIndex:i];
        for(int j = 0; j < [assig.bloques count]; ++j) {
            XYZBloque *bloque = [assig.bloques objectAtIndex:j];
            for (int k = 0; k < [bloque.actes count]; ++k) {
                XYZElemento *elemento = [bloque.actes objectAtIndex:k];
                float nota;
                if ([self.tipo isEqualToString:@"0"]) {
                    nota = [elemento.nota doubleValue] - self.oldMin;
                }
                else {
                    nota = [elemento.nota doubleValue] - (self.oldMin*10);
                }
                if (elemento.nota != nil) {
                    float repr = nota/ref;
                    float newNota = repr*refNew;
                    if ([self.tipo isEqualToString:@"0"]) {
                        newNota += minVal;
                    }
                    else {
                        newNota += (minVal*10);
                    }
                    NSNumber *nuevo = [NSNumber numberWithFloat:newNota];
                    elemento.nota = nuevo;
                }
            }
            [bloque recalculateNota];
        }
        [assig actualizarNota];
    }
}

-(BOOL)loadFirst
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"iGradesFirstCalc"];
    if(data == nil){
        return YES;//YES;
    }
    else {
        return NO;//NO;
    }
}

@end
