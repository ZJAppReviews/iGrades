//
//  XYZCloudConfigTableViewCell.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 12/08/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZCloudConfigTableViewCell.h"
#import "Reachability.h"

@implementation XYZCloudConfigTableViewCell

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

- (BOOL)connectedToInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

-(void)configSwitch
{
    BOOL alarmaPermitida = YES;
    NSString *nom = @"iGradesCloudboolKey";
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
    if(data == nil){
        [[NSUserDefaults standardUserDefaults] setBool:alarmaPermitida forKey:nom];
    }
    else {
        alarmaPermitida = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:nom];
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
    mySwitch2.onTintColor = [UIColor purpleColor];//[UIColor colorWithRed:(66.0f/255.0f) green:(198.0f/255.0f) blue:(64.0f/255.0f) alpha:1.0f];
    mySwitch2.isRounded = NO;
    mySwitch2.borderColor = [UIColor lightGrayColor];
    [self.sswitch addSubview:mySwitch2];
    [mySwitch2 setOn:alarmaPermitida animated:YES];
    if (alarmaPermitida) [mySwitch2 setThumbTintColor:[UIColor whiteColor]];
    else [mySwitch2 setThumbTintColor:[UIColor lightGrayColor]];
}

- (void)switchChanged:(SevenSwitch *)sender {
    BOOL alarmaPermitida = YES;
    NSString *nom = @"iGradesCloudboolKey";
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
    if(data == nil){
        [[NSUserDefaults standardUserDefaults] setBool:alarmaPermitida forKey:nom];
    }
    else {
        alarmaPermitida = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:nom];
    }
    alarmaPermitida = !alarmaPermitida;
    if(alarmaPermitida) {
        BOOL ok = [self connectedToInternet];
        if (!ok) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                            message:@"This function needs internet connection. Please turn on the wi-fi or data."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [sender setOn:NO animated:YES];
            [self.papi.tableView reloadData];
        }
        else {
            [sender setThumbTintColor:[UIColor whiteColor]];
            [self.papi updateCloud];
            [self saveAlarma:alarmaPermitida];
            [self.papi.tableView reloadData];
        }
    }
    else {
        [sender setThumbTintColor:[UIColor lightGrayColor]];
        [self saveAlarma:alarmaPermitida];
        [self.papi.tableView reloadData];
    }
}

-(void)saveAlarma:(BOOL)alarmaPermitida
{
    NSString *nom = @"iGradesCloudboolKey";
    NSUserDefaults *NonVolatile = [NSUserDefaults standardUserDefaults];
    [NonVolatile setBool:alarmaPermitida forKey:nom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
