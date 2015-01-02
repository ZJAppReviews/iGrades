//
//  XYZCalculoViewController.h
//  iNotas
//
//  Created by Mauro Vime Castillo on 28/07/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZCalculoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *max;

@property (weak, nonatomic) IBOutlet UITextField *min;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UITextField *value;

@property NSString *tipo;

@end
