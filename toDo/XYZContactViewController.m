//
//  XYZContactViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 31/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZContactViewController.h"
#import "XYZToDoItem.h"
#import "XYZNotaMediaTableViewCell.h"
#import "XYZTipoTableViewCell.h"
#import "XYZContactoTableViewCell.h"
#import <Social/Social.h>
#import "XYZCloudTableViewCell.h"
#import "XYZCloudConfigTableViewCell.h"
#import "Reachability.h"
#import "XYZTouchIDTableViewCell.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface XYZContactViewController () <MFMailComposeViewControllerDelegate,MBProgressHUDDelegate>

@end

@implementation XYZContactViewController

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
    [self loadTipo];
    [self loadTipoOrder];
    if (self.tipo == nil) self.tipo = @"0";
    if (self.tipoOrder == nil) self.tipoOrder = @"0";
    
    //[self iCloudUp];
    //[self iCloudDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        NSMutableArray *tipoBool = [[NSMutableArray alloc] init];
        [tipoBool addObject:self.tipo];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:tipoBool] forKey:@"tipoNotaMViGrades"];
    }
    [super viewWillDisappear:animated];
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

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1 || section == 7) return 1;
    if (section == 2) return 6;
    if (section == 3) return 3;
    if (![self hasTouchID] && section == 5) return 1;
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Format";
    if (section == 1) return @"Evaluation";
    if (section == 2) return @"Sort by";
    if (section == 3) return @"iCloud";
    if (section == 4) return @"Social";
    if (section == 5) return @"Lock";
    return @"";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 2) return @"All numerical sortings will be made in descending order";
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *myLabel = [[UILabel alloc] init];
    if(section == 0) myLabel.frame = CGRectMake(15, 30, 320, 20);
    else if (section == 3) myLabel.frame = CGRectMake(15, 0, 320, 20);
    else myLabel.frame = CGRectMake(15, 15, 320, 20);
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) return 25;
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 5, 300, 15);
    myLabel.numberOfLines = 0;
    [myLabel setFont:[UIFont systemFontOfSize:10.0f]];
    myLabel.text = [self tableView:tableView titleForFooterInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"cellTipoNota";
        XYZTipoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.tipo.text = @"Percentage";
        }
        else {
            cell.tipo.text = @"Decimal";
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if([self.tipo intValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
        
        return cell;
    }
    else if (indexPath.section == 2) {
        NSString *CellIdentifier = @"cellTipoNota";
        XYZTipoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.tipo.text = @"Alphabetically (name)";
        }
        else if (indexPath.row == 1) {
            cell.tipo.text = @"Alphabetically (initials)";
        }
        else if (indexPath.row == 2) {
            cell.tipo.text = @"Last added";
        }
        else if (indexPath.row == 3) {
            cell.tipo.text = @"Last modified";
        }
        else if (indexPath.row == 4) {
            cell.tipo.text = @"Grade";
        }
        else {
            cell.tipo.text = @"Weight";
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if([self.tipoOrder intValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTappedOrder:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
        
        return cell;
    }
    else if (indexPath.section == 3) {
        if(indexPath.row == 2) {
            NSString *CellIdentifier = @"cellCloudSw";
            XYZCloudConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.papi = self;
            cell.logo.layer.cornerRadius = 5;
            [cell.logo setClipsToBounds:YES];
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
                cell.texto.text = @"Disable automatic push";
            }
            else {
                cell.texto.text = @"Enable automatic push";
            }
            return cell;
        }
        NSString *CellIdentifier = @"cellCloud";
        XYZCloudTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 0) {
            cell.logo.image = [UIImage imageNamed:@"upload"];
            cell.logo.layer.cornerRadius = 5;
            [cell.logo setClipsToBounds:YES];
            cell.texto.text = @"Upload";
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadToiCloud:)];
            tapGestureRecognizer.numberOfTapsRequired = 1;
            tapGestureRecognizer.numberOfTouchesRequired = 1;
            cell.tag = indexPath.row;
            [cell addGestureRecognizer:tapGestureRecognizer];
            return cell;
        }
        cell.logo.image = [UIImage imageNamed:@"download"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        cell.texto.text = @"Download";
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadFromiCloud:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
        return cell;
    }
    else if (indexPath.section == 5 && indexPath.row == 1){
        NSString *CellIdentifier = @"cellTouchID";
        XYZTouchIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.papi = self;
        cell.texto.text = @"TouchID";
        cell.logo.image = [UIImage imageNamed:@"TouchID"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        
        BOOL alarmaPermitida = YES;
        NSString *nom = @"iGradesTouchIDboolKey";
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
        if(data == nil){
            [[NSUserDefaults standardUserDefaults] setBool:alarmaPermitida forKey:nom];
        }
        else {
            alarmaPermitida = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:nom];
        }
        if(alarmaPermitida) {
            cell.texto.text = @"Disable TouchID";
        }
        else {
            cell.texto.text = @"Enable TouchID";
        }
        return cell;
    }
    
    NSString *CellIdentifier = @"cellContact";
    XYZContactoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 4 && indexPath.row == 0) {
        cell.texto.text = @"Share on Twitter";
        cell.logo.image = [UIImage imageNamed:@"Twitter"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShareTwitter:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    else if (indexPath.section == 4 && indexPath.row == 1) {
        cell.texto.text = @"Share on Facebook";
        cell.logo.image = [UIImage imageNamed:@"Facebook"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShareFacebook:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    else if (indexPath.section == 1) {
        cell.texto.text = @"Configuration";
        cell.logo.image = [UIImage imageNamed:@"Calculo"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Calculo:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    else if (indexPath.section == 5 && indexPath.row == 0){
        cell.texto.text = @"Configuration";
        cell.logo.image = [UIImage imageNamed:@"lock"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self loadLock]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell setTintColor:[UIColor brownColor]];
            cell.texto.textColor = [UIColor blackColor];
        }
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Lock:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    else if (indexPath.section == 6 && indexPath.row == 0){
        cell.texto.text = @"Tutorial";
        cell.logo.image = [UIImage imageNamed:@"tutorial"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tutorial:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    else if (indexPath.section == 6 && indexPath.row == 1){
        cell.texto.text = @"Guide";
        cell.logo.image = [UIImage imageNamed:@"guide"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Guide:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    else {
        cell.texto.text = @"Copyright";
        cell.logo.image = [UIImage imageNamed:@"Copyright"];
        cell.logo.layer.cornerRadius = 5;
        [cell.logo setClipsToBounds:YES];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Copyright:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:tapGestureRecognizer];
    }
    return cell;
}

-(BOOL)loadLock
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesLockboolKey";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setBool:NO forKey:nom];
        return NO;
    }
    else {
        return (BOOL)[defaults boolForKey:nom];
    }
}

-(BOOL)hasTouchID
{
    if (nil != NSClassFromString(@"LAContext")) {
        LAContext *context = [[LAContext alloc] init];
        
        NSError *error = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            // Authenticate User
            return YES;
        }
    }
    return NO;
}

-(void)Tutorial:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"segueTut" sender:self];
}

-(void)Guide:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"segueGuide" sender:self];
}

-(void)cellTapped:(UITapGestureRecognizer *)onetap
{
    UITableViewCell *cell = (UITableViewCell *)[onetap view];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.tipo = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    [self guardar];
    [self.tableView reloadData];
}

-(void)cellTappedOrder:(UITapGestureRecognizer *)onetap
{
    UITableViewCell *cell = (UITableViewCell *)[onetap view];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.tipoOrder = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    [self guardar];
    [self.main guardar];
    [self.tableView reloadData];
}

-(void)ShareFacebook:(UITapGestureRecognizer *)onetap
{
    SLComposeViewController *fbController=[SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeFacebook];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }
        };
        
        NSString *text = @"I'm loving the new iGrades App! It's really useful #iGradesApp";
        
        [fbController addURL:[NSURL URLWithString:@"https://itunes.apple.com/es/app/a-menjar!/id816473131?mt=8"]];
        
        [fbController setInitialText:text];
        
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
    else{
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Please sign in"
                                          message:@"You should first sign in before using this function."
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
            UIAlertView *alert = [[UIAlertView alloc]   initWithTitle:@"Please sign in."
                                                              message:@"You should first sign in before using this function."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)ShareTwitter:(UITapGestureRecognizer *)onetap
{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    NSString *text = @"I'm loving the new iGrades App! It's really useful #iGradesApp";
    
    [tweetSheet setInitialText:text];
    
    
    if (![tweetSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/es/app/a-menjar!/id816473131?mt=8"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}

-(void)Calculo:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"segueCalculadora" sender:self];
}

-(void)Copyright:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"segueCopyright" sender:self];
}

-(void)Lock:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"segueLock" sender:self];
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
}

-(void)loadTipoOrder
{
    NSString *nom = @"iGradesTipoOrder";
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
    if(data == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:nom];
        self.tipoOrder = @"0";
    }
    else {
        self.tipoOrder = (NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:nom];
    }
}

-(void)guardar
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesTipo";
    [defaults setObject:self.tipo forKey:nom];
    
    NSString *nomO = @"iGradesTipoOrder";
    [[NSUserDefaults standardUserDefaults] setObject:self.tipoOrder forKey:nomO];
}

-(NSDictionary *)listToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:[self.main.toDoItems count]];
    for (int i = 0; i < [self.main.toDoItems count]; ++i) {
        XYZToDoItem *item = [self.main.toDoItems objectAtIndex:i];
        [dic setObject:[item asDictionary] forKey:[NSString stringWithFormat:@"item %d",i]];
    }
    return dic;
}

-(void)fromDictionary:(NSDictionary *)dic
{
    self.main.toDoItems = [[NSMutableArray alloc] initWithCapacity:[dic count]];
    for (int i = 0; i < [dic count]; ++i) {
        XYZToDoItem *item = [[XYZToDoItem alloc] init];
        [item fromDictionary:[dic objectForKey:[NSString stringWithFormat:@"item %d",i]]];
        [self.main.toDoItems addObject:item];
    }
}


- (NSString *)grabCloudPath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *cloudRootURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    
    NSString *pathToCloudFile = [[cloudRootURL path]stringByAppendingPathComponent:@"Documents"];
    pathToCloudFile = [pathToCloudFile stringByAppendingPathComponent:fileName];
    
    return pathToCloudFile;
}

- (BOOL) iCloudIsAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    id test = fileManager.ubiquityIdentityToken;
    return (test != nil) ? YES : NO;
}

-(void)uploadToiCloud:(UITapGestureRecognizer *)onetap
{
    BOOL ok = [self connectedToInternet];
    if (!ok) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"No internet connection"
                                          message:@"This function needs internet connection. Please turn on the wi-fi or data."
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                            message:@"This function needs internet connection. Please turn on the wi-fi or data."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:self.HUD];
        
        self.HUD.delegate = self;
        self.HUD.labelText = @"Uploading";
        
        [self.HUD showWhileExecuting:@selector(iCloudUp) onTarget:self withObject:nil animated:YES];
    }
}

-(void)iCloudUp
{
    BOOL ok = [self connectedToInternet];
    if (!ok) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"No internet connection"
                                          message:@"This function needs internet connection. Please turn on the wi-fi or data."
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                            message:@"This function needs internet connection. Please turn on the wi-fi or data."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        [self.main loadValores];
        [self.main loadTipo];
        [self.main loadTipoOrder];
        [self.main loadInitialData];
        [self.main guardar];
        [self guardar];
        if([self iCloudIsAvailable]) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self listToDictionary]];
            NSMutableArray *mutableA = [[NSMutableArray alloc] init];
            [mutableA addObject:self.tipo];
            [mutableA addObject:self.tipoOrder];
            [mutableA addObject:[NSNumber numberWithDouble:self.main.oldMax]];
            [mutableA addObject:[NSNumber numberWithDouble:self.main.oldMin]];
            [mutableA addObject:[NSNumber numberWithDouble:self.main.pass]];
            NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:mutableA];
            NSString *filePath = [self grabCloudPath:@"iGradesList"];
            [data writeToFile:filePath atomically:YES];
            [[NSUbiquitousKeyValueStore defaultStore] setObject:data2 forKey:@"Data"];
            
        }
        else {
            if (nil != NSClassFromString(@"UIAlertController")) {
                //show alertcontroller
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"iCloud not enabled"
                                              message:@"Please enable the iCloud functions."
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCloud not enabled"
                                                                message:@"Please enable the iCloud functions."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

-(void)downloadFromiCloud:(UITapGestureRecognizer *)onetap
{
    BOOL ok = [self connectedToInternet];
    if (!ok) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"No internet connection"
                                          message:@"This function needs internet connection. Please turn on the wi-fi or data."
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                            message:@"This function needs internet connection. Please turn on the wi-fi or data."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:self.HUD];
        
        self.HUD.delegate = self;
        self.HUD.labelText = @"Downloading";
        
        [self.HUD showWhileExecuting:@selector(iCloudDown) onTarget:self withObject:nil animated:YES];
    }
}

-(void)iCloudDown
{
    BOOL ok = [self connectedToInternet];
    if (!ok) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"No internet connection"
                                          message:@"This function needs internet connection. Please turn on the wi-fi or data."
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection"
                                                            message:@"This function needs internet connection. Please turn on the wi-fi or data."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        if([self iCloudIsAvailable]) {
            NSString *filePath = [self grabCloudPath:@"iGradesList"];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!fileExists) {
                if (nil != NSClassFromString(@"UIAlertController")) {
                    //show alertcontroller
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"No data in iCloud"
                                                  message:@"You first need to upload some data to iCloud."
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data in iCloud"
                                                                    message:@"You first need to upload some data to iCloud."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
            else {
                [[NSFileManager defaultManager]startDownloadingUbiquitousItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
                NSData *dicData = [NSData dataWithContentsOfFile:filePath];
                NSData *vectorData2 = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"Data"];
                if(dicData == nil) {
                    if (nil != NSClassFromString(@"UIAlertController")) {
                        //show alertcontroller
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"Download error"
                                                      message:@"An error ocurrer during the connection with iCloud, please retry the download again."
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
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download error"
                                                                        message:@"An error ocurrer during the connection with iCloud, please retry the download again."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else {
                    NSDictionary* myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dicData];
                    NSMutableArray* myMutableArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:vectorData2];
                    if (myDictionary != nil) {
                        [self fromDictionary:myDictionary];
                        [self.main guardar];
                    }
                    else {
                        if (nil != NSClassFromString(@"UIAlertController")) {
                            //show alertcontroller
                            UIAlertController * alert=   [UIAlertController
                                                          alertControllerWithTitle:@"The data is corrupted"
                                                          message:@"Please download again the data."
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
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The data is corrupted"
                                                                            message:@"Please download again the data."
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    if (myMutableArray2 != nil) {
                        self.main.tipo = (NSString *)[myMutableArray2 objectAtIndex:0];
                        self.main.tipoOrder = (NSString *)[myMutableArray2 objectAtIndex:1];
                        self.tipo = (NSString *)[myMutableArray2 objectAtIndex:0];
                        self.tipoOrder = (NSString *)[myMutableArray2 objectAtIndex:1];
                        self.main.oldMax = [(NSNumber *)[myMutableArray2 objectAtIndex:2] doubleValue];
                        self.main.oldMin = [(NSNumber *)[myMutableArray2 objectAtIndex:3] doubleValue];
                        self.main.pass = [(NSNumber *)[myMutableArray2 objectAtIndex:4] doubleValue];
                    }
                    else {
                        if (nil != NSClassFromString(@"UIAlertController")) {
                            //show alertcontroller
                            UIAlertController * alert=   [UIAlertController
                                                          alertControllerWithTitle:@"The data is corrupted"
                                                          message:@"Please download again the data."
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
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The data is corrupted"
                                                                            message:@"Please download again the data."
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                }
            }
        }
        else {
            if (nil != NSClassFromString(@"UIAlertController")) {
                //show alertcontroller
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"iCloud not enabled"
                                              message:@"Please enable the iCloud functions."
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCloud not enabled"
                                                                message:@"Please enable the iCloud functions."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    // GUARDAR
    [self.main guardar];
    [self.tableView reloadData];
}

-(void)updateCloud
{
    [self iCloudUp];
}

-(IBAction)unwindToContact:(UIStoryboardSegue *)segue
{
    [self.tableView reloadData];
}

@end
