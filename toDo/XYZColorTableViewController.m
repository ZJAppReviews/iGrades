//
//  XYZColorTableViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 27/07/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZColorTableViewController.h"
#import "XYZColorTableViewCell.h"

@interface XYZColorTableViewController ()

@property NSMutableArray *colores;
@property NSMutableArray *coloresNombres;

@end

@implementation XYZColorTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.colores = [[NSMutableArray alloc] init];
    self.coloresNombres = [[NSMutableArray alloc] init];
    
    //ROJO
    [self.colores addObject:[UIColor colorWithRed:(199.0f/255.0f) green:(27.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0f]];
    [self.coloresNombres addObject:@"Red"];
    
    //NARANJA
    [self.colores addObject:[UIColor orangeColor]];
    [self.coloresNombres addObject:@"Orange"];
    
    //AMARILLO
    [self.colores addObject:[UIColor colorWithRed:(237.0f/255.0f) green:(193.0f/255.0f) blue:(44.0f/255.0f) alpha:1.0f]];
    [self.coloresNombres addObject:@"Yellow"];
    
    //VERDE
    [self.colores addObject:[UIColor colorWithRed:(27.0f/255.0f) green:(174.0f/255.0f) blue:(12.0f/255.0f) alpha:1.0f]];
    [self.coloresNombres addObject:@"Green"];
    
    //AZUL CIELO
    [self.colores addObject:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [self.coloresNombres addObject:@"Light blue"];
    
    //AZUL MAR
    [self.colores addObject:[UIColor colorWithRed:(11.0f/255.0f) green:(28.0f/255.0f) blue:(118.0f/255.0f) alpha:1.0f]];
    [self.coloresNombres addObject:@"Dark blue"];
    
    //VIOLETA
    [self.colores addObject:[UIColor purpleColor]];
    [self.coloresNombres addObject:@"Purple"];
    
    //MARRON
    [self.colores addObject:[UIColor brownColor]];
    [self.coloresNombres addObject:@"Brown"];
    
    //ROSA
    [self.colores addObject:[UIColor colorWithRed:(234.0f/255.0f) green:(124.0f/255.0f) blue:(169.0f/255.0f) alpha:1.0f]];
    [self.coloresNombres addObject:@"Pink"];
    
    //NEGRO
    [self.colores addObject:[UIColor blackColor]];
    [self.coloresNombres addObject:@"Black"];
    
    self.colorSel = nil;
    
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colorCell" forIndexPath:indexPath];
    
    //cell.colorButon.layer.cornerRadius = 4.0f;
    cell.colorButon.backgroundColor = [self.colores objectAtIndex:indexPath.row];
    cell.colorName.text = [self.coloresNombres objectAtIndex:indexPath.row];
    UIColor *refC = [self.colores objectAtIndex:indexPath.row];
    if ([refC isEqual:self.colorSel]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    return cell;
}

-(void)cellTapped:(UITapGestureRecognizer *)onetap
{
    UITableViewCell *cell = (UITableViewCell *)[onetap view];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.colorSel = [self.colores objectAtIndex:indexPath.row];
    
    [self.papi.navigationController.navigationBar setBarTintColor:self.colorSel];
    [self.papi.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.papi.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.papi.navigationController.navigationBar setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.tableView reloadData];
}

@end
