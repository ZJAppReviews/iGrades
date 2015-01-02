//
//  XYZToDoListViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 22/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZToDoListViewController.h"
#import "XYZToDoItem.h"
#import "XYZWatchAssigModel.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZCustomCell.h"
#import "XYZNotaMediaTableViewCell.h"
#import "XYZEditItemViewController.h"
#import "XYZBloquesViewController.h"
#import "XYZContactViewController.h"
#import "Reachability.h"
#import <Parse/Parse.h>
#import "XYZWebViewController.h"

@interface XYZToDoListViewController ()

@property UILongPressGestureRecognizer *lpgr;
@property XYZToDoItem *elementoEdit;
@property XYZToDoItem *elementoBloques;
@property XYZToDoItem *elementoNota;
@property BOOL borra;
@property UIView *parche;
@property UIView *pista;
@property XYZToDoItem *itemWeb;

@end

@implementation XYZToDoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    XYZAddToDoItemViewController *source = [segue sourceViewController];
    XYZToDoItem *item = source.toDoItem;
    if (item != nil) {
        [item actualizarNota];
        [self.toDoItems addObject:item];
        [self guardar];
        [self.tableView reloadData];
    }
}

- (IBAction)unwindToEditList:(UIStoryboardSegue *)segue
{
    [self guardar];
    [self.tableView reloadData];
}

- (IBAction)unwindToNothing:(UIStoryboardSegue *)segue
{
    // NO HACE NADA!
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toDoItems = [[NSMutableArray alloc] init];
    
    self.parche = nil;
    if([self.toDoItems count] > 0) self.borra = NO;
    else self.borra = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1.0f]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(0.0f/255.0f) green:(122.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setTranslucent:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //LOAD TIPO
    self.tipo = @"0";
    [self loadInitialData];
    [self loadTipo];
    [self loadValores];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([self loadFirstTut]) [self performSegueWithIdentifier:@"segueTuto" sender:self];
}

- (void) guardar {
    
    for(int i=0; i < [self.toDoItems count]; ++i) {
        XYZToDoItem *assig = [self.toDoItems objectAtIndex:i];
        for(int j = 0; j < [assig.bloques count]; ++j) {
            XYZBloque *bloque = [assig.bloques objectAtIndex:j];
            [bloque recalculateNota];
        }
        [assig actualizarNota];
    }
    
    [self loadTipoOrder];
    
    NSString *ordName;
    BOOL tipoAD;
    
    if ([self.tipoOrder isEqualToString:@"0"]) {
        ordName = @"itemName";
        tipoAD = YES;
    }
    else if ([self.tipoOrder isEqualToString:@"1"]) {
        ordName = @"sigles";
        tipoAD = YES;
    }
    else if ([self.tipoOrder isEqualToString:@"2"]) {
        ordName = @"creationDate";
        tipoAD = NO;
    }
    else if ([self.tipoOrder isEqualToString:@"3"]) {
        ordName = @"modificationDate";
        tipoAD = NO;
    }
    else if ([self.tipoOrder isEqualToString:@"4"]) {
        ordName = @"nota";
        tipoAD = NO;
    }
    else {
        ordName = @"itemName";
        tipoAD = YES;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:ordName ascending:tipoAD];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    self.toDoItems = [[self.toDoItems sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    [sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.toDoItems] forKey:@"arraySaveMauroVimeasig"];
    
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:[self.toDoItems count]];
    
    for (int i = 0; i < [self.toDoItems count]; ++i) {
        XYZToDoItem *item = [self.toDoItems objectAtIndex:i];
        XYZWatchAssigModel *model = [[XYZWatchAssigModel alloc] init];
        model.sigles = item.sigles;
        model.nota = item.nota;
        model.completed = [NSNumber numberWithDouble:[item cantComp]];
        if ([self.tipo isEqualToString:@"0"]) model.notaType = [NSNumber numberWithInt:0];
        else model.notaType = [NSNumber numberWithInt:1];
        model.color = item.color;
        [models addObject:model];
    }
    
    

    [sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:models] forKey:@"arraySaveWatch"];
    
    BOOL alarmaPermitida = YES;
    
    NSString *nom = @"iGradesCloudboolKey";
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:nom];
    if(data == nil){
        [[NSUserDefaults standardUserDefaults] setBool:alarmaPermitida forKey:nom];
    }
    else {
        alarmaPermitida = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:nom];
    }
    
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
    [sharedDefaults synchronize];
    if (alarmaPermitida) [self iCloudUp];
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

-(NSDictionary *)listToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:[self.toDoItems count]];
    for (int i = 0; i < [self.toDoItems count]; ++i) {
        XYZToDoItem *item = [self.toDoItems objectAtIndex:i];
        [dic setObject:[item asDictionary] forKey:[NSString stringWithFormat:@"item %d",i]];
    }
    return dic;
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
        if([self iCloudIsAvailable]) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self listToDictionary]];
            NSMutableArray *mutableA = [[NSMutableArray alloc] init];
            [mutableA addObject:self.tipo];
            [mutableA addObject:self.tipoOrder];
            [mutableA addObject:[NSNumber numberWithDouble:self.oldMax]];
            [mutableA addObject:[NSNumber numberWithDouble:self.oldMin]];
            [mutableA addObject:[NSNumber numberWithDouble:self.pass]];
            NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:mutableA];
            NSString *filePath = [self grabCloudPath:@"iGradesList"];
            [data writeToFile:filePath atomically:YES];
            //[[NSUbiquitousKeyValueStore defaultStore] setObject:data forKey:@"Data1"];
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

- (void)loadInitialData
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSData *savedArray = [defaults objectForKey:@"arraySaveMauroVimeasig"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self loadFirst]) {
        [self.tableView setScrollEnabled:NO];
        return 1;
    }
    [self.tableView setScrollEnabled:YES];
    if([self.toDoItems count] == 0 && self.borra) return 0;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self loadFirst]) return 0;
    if (section == 1) {
        if (!self.borra || ([self.toDoItems count] > 0)) return 1;
        return 0;
    }
    return [self.toDoItems count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) return 70;
    return 140;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // AÑADIR SUGERENCIA
    if ([self loadFirst]) {
        CGFloat wid = self.view.frame.size.width;
        self.pista = [[UIView alloc] init];
        UIImageView *imagen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pegatina"]];
        CGRect fview = imagen.frame;
        fview.origin.x = wid - 310;
        fview.origin.y = -15.0f;
        imagen.frame = fview;
        [self.pista addSubview:imagen];
        return self.pista;
    }
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 15, 320, 20);
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self loadFirst]) return @"test";
    if (section == 1) return @"Average grade";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        self.borra = YES;
        NSString *CellIdentifier = @"cellNotaMedia";
        XYZNotaMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        double media = 0.0;
        for(int i = 0; i < [self.toDoItems count]; ++i) {
            XYZToDoItem *asig = [self.toDoItems objectAtIndex:i];
            media += [asig getNota];
        }
        if ([self.toDoItems count] > 0) {
            media /= [self.toDoItems count];
        }
        
        if ([self.tipo isEqualToString:@"0"]) {
            
            cell.notaMedia.text = [NSString stringWithFormat:@"%.2f", media];
            cell.notaMedia.text = [cell.notaMedia.text stringByAppendingString:@"%"];
            if (media >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
                cell.notaMedia.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
            }
            else if (media >= self.pass) {
                cell.notaMedia.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
            }
            else if (media >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                cell.notaMedia.textColor = [UIColor orangeColor];
            }
            else {
                cell.notaMedia.textColor = [UIColor redColor];
            }
        }
        else {
            media = media/10;
            cell.notaMedia.text = [NSString stringWithFormat:@"%.2f", media];
            if (media >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
                cell.notaMedia.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
            }
            else if (media >= self.pass) {
                cell.notaMedia.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
            }
            else if (media >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                cell.notaMedia.textColor = [UIColor orangeColor];
            }
            else {
                cell.notaMedia.textColor = [UIColor redColor];
            }
        }
        return cell;
    }
    
    NSString *CellIdentifier = @"CustomAsigCell";
    XYZCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.nomTasca.text = toDoItem.sigles;
    cell.nomAsig.text = toDoItem.itemName;
    cell.nomProfesor.text = toDoItem.profesor;
    cell.asig = toDoItem;
    cell.web.backgroundColor = toDoItem.color;
    [cell.web setClipsToBounds:YES];
    cell.web.layer.cornerRadius = (cell.web.frame.size.height/2.0f);
    cell.papi = self;
    if (toDoItem.url == nil) [cell.web setHidden:YES];
    else [cell.web setHidden:NO];
    if([self.tipo isEqualToString:@"0"]) {
        cell.numNota.text = [[NSString stringWithFormat:@"%.2f", [toDoItem getNota]] stringByAppendingString:@"%"];
        if ([toDoItem.nota doubleValue] >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
            cell.numNota.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
        }
        else if ([toDoItem.nota doubleValue] >= self.pass) {
            cell.numNota.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
        }
        else {
            if ([toDoItem.nota doubleValue] >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                cell.numNota.textColor = [UIColor orangeColor];
            }
            else {
                cell.numNota.textColor = [UIColor redColor];
            }
        }
    }
    else {
        cell.numNota.text = [NSString stringWithFormat:@"%.2f", ([toDoItem getNota]/10)];
        double gold = (self.oldMax-((self.oldMax - self.oldMin)/10));
        if ([toDoItem.nota doubleValue]/10 >= gold) {
            cell.numNota.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
        }
        else if ([toDoItem.nota doubleValue]/10 >= self.pass) {
            cell.numNota.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
        }
        else {
            if (([toDoItem.nota doubleValue]/10) >= (self.pass-((self.oldMax - self.oldMin)/10))){
                cell.numNota.textColor = [UIColor orangeColor];
            }
            else {
                cell.numNota.textColor = [UIColor redColor];
            }
        }
    }
    
    cell.colorB.backgroundColor = toDoItem.color;
    
    cell.completed.text = [[NSString stringWithFormat:@"%.2f",[toDoItem cantComp]] stringByAppendingString:@"%"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    cell.tag = indexPath.row;
    
    UITapGestureRecognizer *twoclick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    twoclick.numberOfTapsRequired = 2;
    cell.tag = indexPath.row;
    
    [tapGestureRecognizer requireGestureRecognizerToFail:twoclick];
    [cell addGestureRecognizer:tapGestureRecognizer];
    [cell addGestureRecognizer:twoclick];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            self.borra = NO;
            [self.toDoItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([self.toDoItems count] == 0) self.borra = YES;
        }
        [self guardar];
        [self.tableView reloadData];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) return YES;
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Edit  ";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.elementoEdit = [self.toDoItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueEdit" sender:self];
}

-(void)cellTapped:(UITapGestureRecognizer *)onetap
{
    UITableViewCell *cell = (UITableViewCell *)[onetap view];
    [cell setSelected:NO];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.elementoBloques = [self.toDoItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueBloques" sender:self];
}

-(void)doubleTapped:(UITapGestureRecognizer *)twotap
{
    UITableViewCell *cell = (UITableViewCell *)[twotap view];
    [cell setSelected:NO];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.elementoNota = [self.toDoItems objectAtIndex:indexPath.row];
    [cell setSelected:NO];
    double notafinal = [self.elementoNota notaFinal];
    NSString *notaText;
    
    if ([self.tipo isEqualToString:@"0"]) {
        notaText = [NSString stringWithFormat:@"%.2f",notafinal];
    }
    else {
        notaText = [NSString stringWithFormat:@"%.2f",(notafinal/10)];
    }
    
    if (notafinal > 100) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"FAILED"
                                          message:@"We're sorry to tell you that you've already failed this subject"
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FAILED"
                                                            message:@"We're sorry to tell you that you've already failed this subject"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    else if (notafinal <= 0){
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"PASSED"
                                          message:@"Congratulations! You've passed this subject"
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PASSED"
                                                            message:@"Congratulations! You've passed this subject"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Average grade needed"
                                          message:notaText
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Average grade needed"
                                                            message:notaText
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueEdit"]){
        XYZEditItemViewController *editVC = segue.destinationViewController;
        editVC.item = self.elementoEdit;
    }
    else if ([[segue identifier] isEqualToString:@"segueBloques"]) {
        XYZBloquesViewController *bloquesVC = segue.destinationViewController;
        if (self.elementoBloques.bloques == nil) {
            self.elementoBloques.bloques = [[NSMutableArray alloc] init];
        }
        bloquesVC.assig = self.elementoBloques;
        bloquesVC.main = self;
        bloquesVC.tipo = self.tipo;
    }
    else if ([[segue identifier] isEqualToString:@"segueInfo"]) {
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *savedArrayTipo = [currentDefaults objectForKey:@"tipoNotaMViGrades"];
        if (savedArrayTipo != nil)
        {
            NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArrayTipo];
            if (oldArray != nil) {
                self.tipo = [[[NSMutableArray alloc] initWithArray:oldArray] objectAtIndex:0];
            } else {
                self.tipo = @"0";
            }
        }
        XYZContactViewController *infoVC = segue.destinationViewController;
        infoVC.tipo = self.tipo;
        infoVC.main = self;
    }
    else if ([[segue identifier] isEqualToString:@"add"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iGradesFirst"];
        [self.pista removeFromSuperview];
    }
    else if ([[segue identifier] isEqualToString:@"segueWeb"]) {
        XYZWebViewController *webVC = (XYZWebViewController *) segue.destinationViewController;
        webVC.asig = self.itemWeb;
    }
}

-(BOOL)loadFirst
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"iGradesFirst"];
    if(data == nil){
        return YES;//YES;
    }
    else {
        return NO;//NO;
    }
}

-(BOOL)loadFirstTut
{
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesFirstTut";
    NSData *data = [defaults objectForKey:nom];
    if (data == nil) {
        return YES;
    }
    return NO;
}

-(void)loadTipo
{
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.igrades.subjects"];
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

-(void)loadValores
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    if ([self.tipo isEqualToString:@"0"]) {
        self.pass = [[defaults objectForKey:@"PassedValue"] doubleValue];
        self.pass *= 10;
        self.oldMin = [[defaults objectForKey:@"MinValue"] doubleValue];
        self.oldMin *= 10;
        self.oldMax = [[defaults objectForKey:@"MaxValue"] doubleValue];
        self.oldMax *= 10;
    }
    else {
        self.pass = [[defaults objectForKey:@"PassedValue"] doubleValue];
        self.oldMin = [[defaults objectForKey:@"MinValue"] doubleValue];
        self.oldMax = [[defaults objectForKey:@"MaxValue"] doubleValue];
    }
}

-(void)openWeb:(XYZToDoItem *)item
{
    self.itemWeb = item;
    [self performSegueWithIdentifier:@"segueWeb" sender:self];
}

@end


