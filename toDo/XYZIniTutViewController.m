//
//  MVAIniTutViewController.m
//  Bruce Stats
//
//  Created by Mauro Vime Castillo on 23/08/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZIniTutViewController.h"

@interface XYZIniTutViewController () <UIPageViewControllerDelegate>

@end

@implementation XYZIniTutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Create the data model
    self.pageTitles = @[@"Configure the evaluation method", @"Configure more things", @"Adding a new subject", @"Adding a new subject (2)", @"Adding a new block", @"Adding a new element",@"Edit a subject/block/element", @"Minimum grade to pass", @"Read the guide"];
    self.pageSubtitles = @[@"Minimum and maximum grade and the C level value", @"Such as the sorting or grade type", @"Press the + button to add a new subject", @"Provide the required information",@"Press the + button to add a new block",@"Press the + button to add a new element",@"Swipe left on any object (subject/block/element) and select 'Edit' to edit it",@"If you double tap on a subject the app will tell you the minimum grade needed to pass",@"Please first read our guide to understand the app and take better profit from it"];
    self.pageImages = @[@"tutorial1", @"tutorial2", @"tutorial3", @"tutorial4",@"tutorial5",@"tutorial6",@"tutorial7",@"tutorial8",@"tutorial9"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.endButton setHidden:YES];
    
    CGFloat wid = self.view.frame.size.width;
    CGRect f = self.startButton.frame;
    f.origin.x = (wid/2) - (40);
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (IBAction)endWalkthrough:(id)sender {
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"iGradesFirstTut";
    [defaults setBool:NO forKey:nom];
    [defaults synchronize];
    [self performSegueWithIdentifier:@"segueCalc" sender:self];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.subtitleText = self.pageSubtitles[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    PageContentViewController *prevVC = [previousViewControllers objectAtIndex:0];
    if ([prevVC.titleText isEqualToString:(NSString*)[self.pageTitles objectAtIndex:([self.pageTitles count] - 2)]] && completed) {
        if ([self.endButton isHidden]) {
            [UIView animateWithDuration:1
                             animations:^{
                                 CGRect frame = self.startButton.frame;
                                 frame.origin.x = 40;
                                 [self.startButton setFrame:frame];
                             }
                             completion:^(BOOL finished){
                                 if (finished) {
                                     [self.endButton setHidden:NO];
                                 }
                             }
             ];
        }
    }
}

@end
