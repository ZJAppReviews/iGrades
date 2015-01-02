//
//  XYZiPadListViewController.h
//  iNotas
//
//  Created by Mauro Vime Castillo on 7/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZiPadListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *completedPorc;
@property (weak, nonatomic) IBOutlet UILabel *gradePorc;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *sigles;
@property (weak, nonatomic) IBOutlet UILabel *nom;
@property (weak, nonatomic) IBOutlet UIWebView *website;

@property NSMutableArray *toDoItems;

@end
