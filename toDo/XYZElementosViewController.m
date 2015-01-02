//
//  XYZElementosViewController.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZElementosViewController.h"
#import "XYZAddElementoViewController.h"
#import "XYZCustomElementoCell.h"
#import "XYZEditElementoViewController.h"

@interface XYZElementosViewController ()

@property XYZElemento *elementoEdit;
@property double oldMin;
@property double oldMax;
@property double pass;

@end

@implementation XYZElementosViewController

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
    [self.navigationItem setTitle:@"Exams/Assignments"];//[@"Exams/Assignments of " stringByAppendingString:self.mainB.assig.sigles]];
    [self sortList];
    if (self.bloque.actes == nil) self.bloque.actes = [[NSMutableArray alloc] init];
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
        tipoAD = YES;
    }
    else {
        ordName = @"pes";
        tipoAD = NO;
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:ordName ascending:tipoAD];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.bloque.actes = [[self.bloque.actes sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (IBAction)unwindToElementos:(UIStoryboardSegue *)segue
{
    XYZAddElementoViewController *source = [segue sourceViewController];
    XYZElemento *elemento = source.elem;
    if (elemento != nil) {
        [self.bloque.actes addObject:elemento];
        [self sortList];
        [self.mainB.main guardar];
        [self.tableView reloadData];
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(guardarTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(IBAction)unwindToEditingElemento:(UIStoryboardSegue *)segue
{
    [self sortList];
    [self.mainB sortList];
    [self.mainB.main guardar];
    [self.tableView reloadData];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(guardarTimer:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)guardarTimer:(NSTimer*)timer
{
    [self.mainB.main guardar];
}

-(IBAction)unwindToNothingElemento:(UIStoryboardSegue *)segue
{
    
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
    return [self.bloque.actes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ElementoCell";
    XYZCustomElementoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZElemento *elemento = [self.bloque.actes objectAtIndex:indexPath.row];
    cell.nomE.text = elemento.nom;
    cell.porcE.text = [[NSString stringWithFormat:@"%.2f",[elemento.pes doubleValue]] stringByAppendingString:@"%"];
    
    if (elemento.nota == nil) {
        cell.notaE.text = @"- -";
        [cell.notaE setTextColor:[UIColor blackColor]];
    }
    else {
        if([self.tipo isEqualToString:@"0"]) {
            cell.notaE.text = [[NSString stringWithFormat:@"%.2f", [elemento.nota doubleValue]] stringByAppendingString:@"%"];
            if ([elemento.nota doubleValue] >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
                cell.notaE.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
            }
            else if ([elemento.nota doubleValue] >= self.pass) {
                cell.notaE.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
            }
            else {
                if ([elemento.nota doubleValue] >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                    cell.notaE.textColor = [UIColor orangeColor];
                }
                else {
                    cell.notaE.textColor = [UIColor redColor];
                }
            }
        }
        else {
            cell.notaE.text = [NSString stringWithFormat:@"%.2f", ([elemento.nota doubleValue]/10)];
            if (([elemento.nota doubleValue]/10) >= (self.oldMax-((self.oldMax - self.oldMin)/10))) {
                cell.notaE.textColor = [UIColor colorWithRed:(240.0f/256.0f) green:(175.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0f];
            }
            else if ([elemento.nota doubleValue]/10 >= self.pass) {
                cell.notaE.textColor = [UIColor colorWithRed:(0.0f/256.0f) green:(204.0f/256.0f) blue:(51.0f/256.0f) alpha:1.0f];
            }
            else {
                if ([elemento.nota doubleValue]/10 >= (self.pass-((self.oldMax - self.oldMin)/10))) {
                    cell.notaE.textColor = [UIColor orangeColor];
                }
                else {
                    cell.notaE.textColor = [UIColor redColor];
                }
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
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.bloque.actes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self sortList];
    [self.mainB.main guardar];
}

-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Edit  ";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.elementoEdit = [self.bloque.actes objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"editarElemento" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editarElemento"]) {
        XYZEditElementoViewController *editVC = segue.destinationViewController;
        editVC.elemento = self.elementoEdit;
        editVC.color = self.mainB.assig.color;
        editVC.tipo = self.tipo;
        editVC.bloque = self.bloque;
        editVC.assig = self.mainB.assig;
    }
    else if ([[segue identifier] isEqualToString:@"nuevoElemento"]) {
        UINavigationController *navi = segue.destinationViewController;
        XYZAddElementoViewController *addVC = (XYZAddElementoViewController *)navi.childViewControllers[0];
        addVC.color = self.mainB.assig.color;
        addVC.bloque = self.bloque;
        addVC.tipo = self.tipo;
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
