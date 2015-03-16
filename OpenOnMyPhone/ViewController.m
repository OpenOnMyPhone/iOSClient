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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
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

UIView *scanView;
AVCaptureSession *session;
- (IBAction)didClickQRScanButton:(id)sender {
    scanView = [[UIView alloc] init];
    scanView.frame = self.view.bounds;
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = scanView.bounds;
    [scanView.layer insertSublayer:previewLayer atIndex:0];
    
    UIButton *exitButton = [[UIButton alloc] init];
    [exitButton setFrame:CGRectMake(20, 20, 0, 0)];
    [exitButton setTitle:@"Back" forState:UIControlStateNormal];
    [exitButton sizeToFit];
    [exitButton setTintColor:[UIColor darkTextColor]];
    [exitButton addTarget:self action:@selector(didClickQRScanExitButton:) forControlEvents:UIControlEventTouchUpInside];
    [scanView addSubview:exitButton];
    
    session = [[AVCaptureSession alloc] init];
    [session beginConfiguration];
    [session setSessionPreset:AVCaptureSessionPreset640x480];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    [previewLayer setSession:session];
    
    [session commitConfiguration];
    [session startRunning];
    
    [self.view addSubview:scanView];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataMachineReadableCodeObject *qrcode in metadataObjects) {
        NSLog(@"%@", [qrcode stringValue]);
        if ([[qrcode stringValue] hasPrefix:@"p2mp:"]) {
            NSString *code = [[qrcode stringValue] substringFromIndex:5];
            NSLog(@"Found:%@!", code);
            
            [self.code setText:code];
            [scanView removeFromSuperview];
            [session stopRunning];
            scanView = nil;
            session = nil;
        }
    }
}

- (IBAction)didClickQRScanExitButton:(id)sender {
    [scanView removeFromSuperview];
    [session stopRunning];
    scanView = nil;
    session = nil;
}

@end
