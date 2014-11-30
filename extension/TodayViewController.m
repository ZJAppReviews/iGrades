//
//  TodayViewController.m
//  extension
//
//  Created by Mauro Vime Castillo on 16/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "XYZToDoItem.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *siglas;
@property (weak, nonatomic) IBOutlet UILabel *asig;
@property (weak, nonatomic) IBOutlet UILabel *profesor;
@property (weak, nonatomic) IBOutlet UILabel *completado;
@property (weak, nonatomic) IBOutlet UILabel *porc;
@property (weak, nonatomic) IBOutlet UIButton *color;
@property (weak, nonatomic) IBOutlet UIView *asigView;
@property (weak, nonatomic) IBOutlet UILabel *completed;
@property UILabel *noAssig;
@property NSArray *assigs;
@property NSString *tipo;
@property double oldMin;
@property double oldMax;
@property double pass;

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateNumberLabelText];
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateNumberLabelText];
}

- (void)updateNumberLabelText {
    [self.noAssig setAlpha:0];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    [defaults synchronize];
    NSData *savedArray = [defaults objectForKey:@"arraySaveMauroVimeasig"];
    NSArray *subjects;
    if (savedArray != nil)
    {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            subjects = oldArray;
        } else {
            subjects = [[NSArray alloc] init];
        }
    }
    if ([subjects count] == 0) {
        self.preferredContentSize = CGSizeMake(320, 155);
        [self.asigView setAlpha:0];
        self.noAssig = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 110)];
        self.noAssig.text = @"You don't have any subject! Go to the app and create one.";
        [self.noAssig setTextAlignment:NSTextAlignmentCenter];
        [self.noAssig setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
        self.noAssig.numberOfLines = 0;
        self.noAssig.textColor = [UIColor whiteColor];
        [self.view addSubview:self.noAssig];
        [self.view bringSubviewToFront:self.noAssig];
        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(95, 120, 130, 30)];
        [moreButton setTitle:@"Open the app" forState:UIControlStateNormal];
        moreButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreButton.layer.cornerRadius = 5.0f;
        [moreButton setClipsToBounds:YES];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreButton addTarget:self action:@selector(openApp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moreButton];
    }
    else {
        self.assigs = subjects;
        
        float maxHeight = [[ UIScreen mainScreen ] bounds ].size.height - 126;
        int numAssig = maxHeight / 115;
        if (numAssig > [subjects count]) numAssig = (int)[subjects count];
        [self actualizarAssigWithMax:numAssig];
    }
}

-(void)actualizarAssigWithMax:(int)max
{
    [self loadTipo];
    [self.asigView removeFromSuperview];
    for (int i = 0; i < max; ++i) {
        XYZToDoItem *item = [self.assigs objectAtIndex:i];
        self.siglas.text = item.sigles;
        self.asig.text = item.itemName;
        self.profesor.text = item.profesor;
        if([self.tipo isEqualToString:@"0"]) {
            self.porc.text = [[NSString stringWithFormat:@"%.2f", [item getNota]] stringByAppendingString:@"%"];
            if ([item.nota doubleValue] >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
                self.porc.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
            }
            else if ([item.nota doubleValue] >= self.pass) {
                self.porc.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
            }
            else {
                if ([item.nota doubleValue] >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                    self.porc.textColor = [UIColor orangeColor];
                }
                else {
                    self.porc.textColor = [UIColor redColor];
                }
            }
        }
        else {
            self.porc.text = [NSString stringWithFormat:@"%.2f", ([item getNota]/10)];
            double gold = (self.oldMax-((self.oldMax - self.oldMin)/10));
            if ([item.nota doubleValue]/10 >= gold) {
                self.porc.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
            }
            else if ([item.nota doubleValue]/10 >= self.pass) {
                self.porc.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
            }
            else {
                if (([item.nota doubleValue]/10) >= (self.pass-((self.oldMax - self.oldMin)/10))){
                    self.porc.textColor = [UIColor orangeColor];
                }
                else {
                    self.porc.textColor = [UIColor redColor];
                }
            }
        }
        self.color.backgroundColor = item.color;
        self.completado.text = [[NSString stringWithFormat:@"%.2f",[item cantComp]] stringByAppendingString:@"%"];
        UIView *vistaAssig = [self vistaAsig];
        [vistaAssig setFrame:CGRectMake(0, (i * 115), 320, 110)];
        [self.view addSubview:vistaAssig];
    }
    if (max < [self.assigs count]) {
        double w = [[ UIScreen mainScreen ] bounds ].size.width;
        double dif = w - 320;
    
        self.preferredContentSize = CGSizeMake(320, (max * 115) + 50);
        // AÑADIR SHOW ALL BUTTON
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake((((w/2) - 65) - dif), ((max * 115) + 10), 130, 30)];
        [moreButton setTitle:@"Show more subjects" forState:UIControlStateNormal];
        moreButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreButton.layer.cornerRadius = 5.0f;
        [moreButton setClipsToBounds:YES];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreButton addTarget:self action:@selector(openApp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moreButton];
    }
    else {
        self.preferredContentSize = CGSizeMake(320, (max * 115));
    }
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    float wi = [[ UIScreen mainScreen ] bounds ].size.width;
    if (wi <= 320) return UIEdgeInsetsZero;
    return defaultMarginInsets;
}

-(void)openApp:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:@"igrades://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

-(UIView *)vistaAsig
{
    UIView *vistaAssig = [[UIView alloc] initWithFrame:self.asigView.frame];
    UILabel *siglas = [self labelWithLabel:self.siglas];
    [vistaAssig addSubview:siglas];
    UILabel *asig = [self labelWithLabel:self.asig];
    [vistaAssig addSubview:asig];
    UILabel *prof = [self labelWithLabel:self.profesor];
    [vistaAssig addSubview:prof];
    UILabel *porc = [self labelWithLabel:self.porc];
    [vistaAssig addSubview:porc];
    UILabel *completado = [self labelWithLabel:self.completado];
    [vistaAssig addSubview:completado];
    UIButton *col = [self buttonWithButton:self.color];
    [vistaAssig addSubview:col];
    UILabel *comp = [self labelWithLabel:self.completed];
    [vistaAssig addSubview:comp];
    return vistaAssig;
}

-(UIButton *)buttonWithButton:(UIButton *)button
{
    UIButton *result = [[UIButton alloc] initWithFrame:button.frame];
    result.backgroundColor = button.backgroundColor;
    result.titleLabel.text = button.titleLabel.text;
    [result setUserInteractionEnabled:NO];
    return result;
}

-(UILabel *)labelWithLabel:(UILabel *)label
{
    UILabel *result = [[UILabel alloc] initWithFrame:label.frame];
    result.text = label.text;
    result.textAlignment = label.textAlignment;
    result.font = label.font;
    result.textColor = label.textColor;
    result.numberOfLines = label.numberOfLines;
    return result;
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
        self.tipo = (NSString *)[defaults stringForKey:nom];
    }
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
