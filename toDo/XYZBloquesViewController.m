//
//  XYZBloquesViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZBloquesViewController.h"
#import "XYZAddBloqueViewController.h"
#import "XYZCustomBloqueCell.h"
#import "XYZElementosViewController.h"
#import "XYZEditBloqueViewController.h"

@interface XYZBloquesViewController ()

@property XYZBloque *bloqueEdit;
@property XYZBloque *bloqueElementos;
@property double oldMin;
@property double oldMax;
@property double pass;

@end

@implementation XYZBloquesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToBloque:(UIStoryboardSegue *)segue
{
    XYZAddBloqueViewController *source = [segue sourceViewController];
    XYZBloque *bloque = source.bloque;
    if (bloque != nil) {
        [self.assig.bloques addObject:bloque];
        [self sortList];
        [self.tableView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(guardarTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(IBAction)unwindToEditingBloque:(UIStoryboardSegue *)segue
{
    XYZEditBloqueViewController *source = [segue sourceViewController];
    XYZBloque *bloque = source.bloque;
    if (bloque != nil) {
        bloque.actes = self.bloqueEdit.actes;
        bloque.nota = self.bloqueEdit.nota;
        bloque.creationDate = self.bloqueEdit.creationDate;
        [self.assig.bloques removeObject:self.bloqueEdit];
        [self.assig.bloques addObject:bloque];
        [self sortList];
        [self.tableView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(guardarTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)guardarTimer:(NSTimer*)timer
{
    [self.main guardar];
}

-(IBAction)unwindToNothingBloque:(UIStoryboardSegue *)segue
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:[@"Blocks of " stringByAppendingString:self.assig.sigles]];
    if (self.assig.color != nil) {
        [self.navigationController.navigationBar setBarTintColor:self.assig.color];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTranslucent:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    for(int i = 0; i < [self.assig.bloques count]; ++i) {
        [[self.assig.bloques objectAtIndex:i] recalculateNota];
    }
    [self sortList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadValores];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) sortList {
    
    [self loadTipoOrder];
    
    for(int i = 0; i < [self.assig.bloques count]; ++i) {
        XYZBloque *bloque = [self.assig.bloques objectAtIndex:i];
        [bloque recalculateNota];
    }
    
    NSString *ordName;
    BOOL tipoAD;
    
    if ([self.tipoOrder isEqualToString:@"0"]) {
        ordName = @"nom";
        tipoAD = YES;
    }
    else if ([self.tipoOrder isEqualToString:@"1"]) {
        ordName = @"nom";
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
        ordName = @"porc";
        tipoAD = NO;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:ordName ascending:tipoAD];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.assig.bloques = [[self.assig.bloques sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assig.bloques count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CustomBloqueCell";
    XYZCustomBloqueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZBloque *bloque = [self.assig.bloques objectAtIndex:indexPath.row];
    cell.nomB.text = bloque.nom;
    cell.porcB.text = [[NSString stringWithFormat:@"%.2f",[bloque.porc doubleValue]] stringByAppendingString:@"%"];
    cell.completedB.text = [[bloque completed] stringByAppendingString:@"%"];
    
    
    if ([self.tipo isEqualToString:@"0"]) {
        cell.notaB.text = [[NSString stringWithFormat:@"%.2f", [bloque.nota doubleValue]] stringByAppendingString:@"%"];
        if ([bloque.nota doubleValue] >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
            cell.notaB.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
        }
        else if ([bloque.nota doubleValue] >= self.pass) {
            cell.notaB.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
        }
        else {
            if ([bloque.nota doubleValue] >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                cell.notaB.textColor = [UIColor orangeColor];
            }
            else {
                cell.notaB.textColor = [UIColor redColor];
            }
        }
    }
    else {
        cell.notaB.text = [NSString stringWithFormat:@"%.2f", ([bloque.nota doubleValue]/10)];
        double gold = (self.oldMax-((self.oldMax - self.oldMin)/10));
        if (([bloque.nota doubleValue]/10) >= gold) {
            cell.notaB.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
        }
        else if ([bloque.nota doubleValue]/10 >= self.pass) {
            cell.notaB.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
        }
        else {
            if ([bloque.nota doubleValue]/10 >= (self.pass-((self.oldMax - self.oldMin)/10))){
                cell.notaB.textColor = [UIColor orangeColor];
            }
            else {
                cell.notaB.textColor = [UIColor redColor];
            }
        }
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    [cell addGestureRecognizer:lpgr];
    return cell;
}

-(void)cellTapped:(UILongPressGestureRecognizer *)longPress
{
    UITableViewCell *cell = (UITableViewCell *)[longPress view];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.bloqueElementos = [self.assig.bloques objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueElements" sender:self];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.assig.bloques removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self sortList];
    [self.main guardar];
}

-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Edit  ";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.bloqueEdit = [self.assig.bloques objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"editBloque" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueElements"]){
        XYZElementosViewController *elementosVC = segue.destinationViewController;
        if (elementosVC.bloque == nil) {
            elementosVC.bloque = [[XYZBloque alloc] init];
        }
        elementosVC.bloque = self.bloqueElementos;
        elementosVC.mainB = self;
        elementosVC.tipo = self.tipo;
    }
    else if ([[segue identifier] isEqualToString:@"editBloque"]) {
        XYZEditBloqueViewController *editVC = segue.destinationViewController;
        editVC.bloque = [[XYZBloque alloc] init];
        editVC.bloque = self.bloqueEdit;
        editVC.color = self.assig.color;
        editVC.assig = self.assig;
    }
    else {
        UINavigationController *navi = segue.destinationViewController;
        XYZAddBloqueViewController *addVC = (XYZAddBloqueViewController *)navi.childViewControllers[0];
        addVC.color = self.assig.color;
        addVC.assig = self.assig;
    }
}

-(void)loadValores
{
    if ([self.tipo isEqualToString:@"0"]) {
        self.pass = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PassedValue"] doubleValue];
        self.pass *= 10;
        self.oldMin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MinValue"] doubleValue];
        self.oldMin *= 10;
        self.oldMax = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxValue"] doubleValue];
        self.oldMax *= 10;
    }
    else {
        self.pass = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PassedValue"] doubleValue];
        self.oldMin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MinValue"] doubleValue];
        self.oldMax = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxValue"] doubleValue];
    }
}

@end
