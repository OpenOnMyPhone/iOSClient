//
//  ViewController.m
//  OpenOnMyPhone
//
//  Created by Illvili on 15/3/9.
//  Copyright (c) 2015年 Illvili.me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *bind_code = [[NSUserDefaults standardUserDefaults] objectForKey:@"CODE"];
    if (bind_code) {
        [self.code setText:bind_code];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
    if (0 == iResCode) {
        [[[UIAlertView alloc] initWithTitle:@"Code Set" message:@"Code setted!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Code Set Error" message:[NSString stringWithFormat:@"Code not set!\n%d", iResCode] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)didClickSetButton:(id)sender {
    NSString *bind_code = self.code.text;
    NSLog(@"%@", bind_code);
    
    [[NSUserDefaults standardUserDefaults] setObject:bind_code forKey:@"CODE"];
    
    if (bind_code.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Code" message:@"Please enter the code" delegate:self cancelButtonTitle:@"Retype" otherButtonTitles: nil];
        [alert show];
    } else {
        NSString *code_tag = [@"id_" stringByAppendingString:bind_code];
        [APService setTags:[NSSet setWithObject:code_tag] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end
