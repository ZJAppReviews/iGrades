//
//  XYZiPadListViewController.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 7/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZiPadListViewController.h"
#import "XYZCustomCell.h"
#import "XYZNotaMediaTableViewCell.h"
#import "EFCircularSlider.h"

@interface XYZiPadListViewController () <UITableViewDataSource,UITableViewDelegate>

@property XYZToDoItem *viewItem;
@property EFCircularSlider* circularSliderComp;
@property EFCircularSlider* circularSliderGrade;

@end

@implementation XYZiPadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toDoItems = [[NSMutableArray alloc] init];
    XYZToDoItem *item = [[XYZToDoItem alloc] init];
    item.sigles = @"CAIM";
    item.itemName = @"Carca i Anàlisi d'Informació Massiva";
    item.profesor = @"Mr. Appleseed";
    item.nota = [NSNumber numberWithDouble:67];
    item.color = [UIColor purpleColor];
    item.url = @"www.google.es";
    [self.toDoItems addObject:item];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.viewItem = item;
    [self updateViewItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)info:(id)sender {
}

- (IBAction)addNew:(id)sender {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    /*if ([self loadFirst]) {
        [self.tableView setScrollEnabled:NO];
        return 1;
    }*/
    [self.tableView setScrollEnabled:YES];
    //if([self.toDoItems count] == 0 && self.borra) return 0;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    /*if ([self loadFirst]) return 0;
    if (section == 1) {
        if (!self.borra || ([self.toDoItems count] > 0)) return 1;
        return 0;
    }*/
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
    /*if ([self loadFirst]) {
        CGFloat wid = self.view.frame.size.width;
        self.pista = [[UIView alloc] init];
        UIImageView *imagen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pegatina"]];
        CGRect fview = imagen.frame;
        fview.origin.x = wid - 310;
        fview.origin.y = -15.0f;
        imagen.frame = fview;
        [self.pista addSubview:imagen];
        return self.pista;
    }*/
    
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
    //if ([self loadFirst]) return @"test";
    if (section == 1) return @"Average grade";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        //self.borra = YES;
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
        cell.notaMedia.text = [NSString stringWithFormat:@"%.2f", media];
        cell.notaMedia.text = [cell.notaMedia.text stringByAppendingString:@"%"];
        /*if ([self.tipo isEqualToString:@"0"]) {
            
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
        }*/
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
    [cell.web setHidden:YES];
    cell.numNota.text = [[NSString stringWithFormat:@"%.2f", 67.0/*[toDoItem getNota]*/] stringByAppendingString:@"%"];
    /*if([self.tipo isEqualToString:@"0"]) {
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
    }*/
    
    cell.colorB.backgroundColor = toDoItem.color;
    
    cell.completed.text = [[NSString stringWithFormat:@"%.2f",67.0/*[toDoItem cantComp]*/] stringByAppendingString:@"%"];
    
    /*UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
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
    [cell addGestureRecognizer:lpgr];*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (indexPath.section == 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            self.borra = NO;
            [self.toDoItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([self.toDoItems count] == 0) self.borra = YES;
        }
        [self guardar];
        [self.tableView reloadData];
    }*/
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
    //self.elementoEdit = [self.toDoItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueEdit" sender:self];
}

-(void)updateViewItem
{
    [self.detailView setBackgroundColor:self.viewItem.color];
    self.completedPorc.text = [[NSString stringWithFormat:@"%.2f",67.0/*[self.viewItem cantComp]*/] stringByAppendingString:@"%"];
    self.completedPorc.backgroundColor = self.viewItem.color;
    self.completedPorc.layer.cornerRadius = 33;
    [self.completedPorc setClipsToBounds:YES];
    self.gradePorc.text = [[NSString stringWithFormat:@"%.2f", 67.0/*[self.viewItem getNota]*/] stringByAppendingString:@"%"];
    self.gradePorc.backgroundColor = self.viewItem.color;
    self.gradePorc.layer.cornerRadius = 33;
    [self.gradePorc setClipsToBounds:YES];
    self.teacher.text = self.viewItem.profesor;
    self.sigles.text = self.viewItem.sigles;
    self.nom.text = self.viewItem.itemName;
    NSURL *url;
    if (![self.viewItem.url hasPrefix:@"http://"] && ![self.viewItem.url hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:self.viewItem.url]];
    }
    else url  = [NSURL URLWithString:self.viewItem.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.website loadRequest:requestObj];
    
    [self drawColorsInRect:CGRectMake(69,117, 125, 125)];
    
    self.circularSliderComp = [[EFCircularSlider alloc] initWithFrame:CGRectMake(69,117, 125, 125)];
    [self.circularSliderComp setClipsToBounds:YES];
    [self.circularSliderComp setMinimumValue:0];
    [self.circularSliderComp setMaximumValue:100];
    [self.circularSliderComp setCurrentValue:67.0];
    [self.circularSliderComp setUnfilledColor:[UIColor clearColor]];
    [self.circularSliderComp setLineWidth:30];
    [self.circularSliderComp setHandleColor:[UIColor colorWithWhite:1 alpha:0]];
    [self.circularSliderComp setFilledColor:self.viewItem.color];
    [self.circularSliderComp setHandleType:CircularSliderHandleTypeSemiTransparentBlackCircle];
    [self.circularSliderComp setUserInteractionEnabled:NO];
    [self.detailView addSubview:self.circularSliderComp];
    
    [self drawColorsInRect:CGRectMake(290,117, 125, 125)];
    
    self.circularSliderGrade = [[EFCircularSlider alloc] initWithFrame:CGRectMake(290,117, 125, 125)];
    [self.circularSliderGrade setClipsToBounds:YES];
    [self.circularSliderGrade setMinimumValue:0];
    [self.circularSliderGrade setMaximumValue:100];
    [self.circularSliderGrade setCurrentValue:50];
    [self.circularSliderGrade setUnfilledColor:[UIColor clearColor]];
    [self.circularSliderGrade setLineWidth:30];
    [self.circularSliderGrade setHandleColor:[UIColor colorWithWhite:1 alpha:0]];
    [self.circularSliderGrade setFilledColor:self.viewItem.color];
    [self.circularSliderGrade setHandleType:CircularSliderHandleTypeSemiTransparentBlackCircle];
    [self.circularSliderGrade setUserInteractionEnabled:NO];
    [self.detailView addSubview:self.circularSliderGrade];
    
    [self.detailView bringSubviewToFront:self.completedPorc];
    [self.detailView bringSubviewToFront:self.gradePorc];
}

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

- (UIBezierPath *)createArcPathWithRect:(CGRect)rect
{
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(62.5, 62.5)
                                                         radius:62
                                                     startAngle:0
                                                       endAngle:DEGREES_TO_RADIANS(360)
                                                      clockwise:YES];
    return aPath;
}

- (void)drawColorsInRect:(CGRect)rect
{
    UIBezierPath *myClippingPath = [self createArcPathWithRect:rect];
    myClippingPath.lineWidth = 39.0f;
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = myClippingPath.CGPath;
    UIImageView *gradient = [[UIImageView alloc] initWithFrame:rect];
    gradient.image = [UIImage imageNamed:@"RadialProgressFill"];
    gradient.layer.mask = mask;
    [self.detailView addSubview:gradient];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
