//
//  MVAIniTutViewController.h
//  Bruce Stats
//
//  Created by Mauro Vime Castillo on 23/08/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface XYZIniTutViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
- (IBAction)endWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageSubtitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end
