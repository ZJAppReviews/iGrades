//
//  XYZTouchIDTableViewCell.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 8/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZTouchIDTableViewCell.h"
#import "Reachability.h"

@implementation XYZTouchIDTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSwitch];
    }
    return self;
}

- (void)awakeFromNib
{
    [self configSwitch];
}

-(void)configSwitch
{
    BOOL alarmaPermitida = YES;
    NSString *nom = @"iGradesTouchIDboolKey";
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setBool:alarmaPermitida forKey:nom];
    }
    else {
        alarmaPermitida = (BOOL)[defaults boolForKey:nom];
    }
    if(alarmaPermitida) {
        self.texto.text = @"Disable automatic push";
    }
    else {
        self.texto.text = @"Enable automatic push";
    }
    SevenSwitch *mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake(0.0f,0.0f, 56, 25)];
    [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    mySwitch2.offImage = [UIImage imageNamed:@"cross"];
    mySwitch2.onImage = [UIImage imageNamed:@"check"];
    mySwitch2.onTintColor = [UIColor colorWithRed:(249.0f/255.0f) green:(38.0f/255.0f) blue:(119.0f/255.0f) alpha:1.0f];
    mySwitch2.isRounded = NO;
    mySwitch2.borderColor = [UIColor lightGrayColor];
    [self.sswitch addSubview:mySwitch2];
    [mySwitch2 setOn:alarmaPermitida animated:YES];
    if (alarmaPermitida) [mySwitch2 setThumbTintColor:[UIColor whiteColor]];
    else [mySwitch2 setThumbTintColor:[UIColor lightGrayColor]];
}

- (void)switchChanged:(SevenSwitch *)sender {
    BOOL alarmaPermitida = YES;
    NSString *nom = @"iGradesTouchIDboolKey";
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
    if(data == nil){
        [[NSUserDefaults standardUserDefaults] setBool:alarmaPermitida forKey:nom];
    }
    else {
        alarmaPermitida = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:nom];
    }
    alarmaPermitida = !alarmaPermitida;
    if(alarmaPermitida) {
        [sender setThumbTintColor:[UIColor whiteColor]];
        [self saveAlarma:alarmaPermitida];
        [self.papi.tableView reloadData];
    }
    else {
        [sender setThumbTintColor:[UIColor lightGrayColor]];
        [self saveAlarma:alarmaPermitida];
        [self.papi.tableView reloadData];
    }
}

-(void)saveAlarma:(BOOL)alarmaPermitida
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesTouchIDboolKey";
    [defaults setBool:alarmaPermitida forKey:nom];
    [defaults synchronize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
