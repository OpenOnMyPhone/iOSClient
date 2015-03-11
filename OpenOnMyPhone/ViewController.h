//
//  ViewController.h
//  OpenOnMyPhone
//
//  Created by Illvili on 15/3/9.
//  Copyright (c) 2015年 Illvili.me. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APService.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *code;
- (IBAction)didClickSetButton:(id)sender;

@end

