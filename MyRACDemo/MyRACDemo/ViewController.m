//
//  ViewController.m
//  MyRACDemo
//
//  Created by Darsky on 2018/4/20.
//  Copyright © 2018年 Darsky. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "SimulateClient.h"


@interface ViewController ()

#pragma mark - UI
@property (copy, nonatomic) NSString *demoName;

@property (copy, nonatomic) NSString *demoName2;

@property (weak, nonatomic) IBOutlet UITextField *field1;

@property (weak, nonatomic) IBOutlet UITextField *field2;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (weak, nonatomic) IBOutlet UIButton *touchMeButton;

@property (weak, nonatomic) IBOutlet UIButton *loginInButton;

#pragma mark - Commands
@property (strong, nonatomic) RACCommand *loginCommand;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [RACObserve(self, demoName) subscribeNext:^(NSString *newName)
     {
        NSLog(@"%@", newName);
    }];
    
    [[RACObserve(self, demoName2) filter:^BOOL(NSString *newName)
     {
         return [newName hasPrefix:@"World"];
     }]
     subscribeNext:^(id  _Nullable x)
     {
         NSLog(@"%@", x);
     }];
    
    RAC(self, stateButton.selected) = [RACSignal
                                combineLatest:@[RACObserve(self, field1.text), RACObserve(self, field2.text)]
                                reduce:^(NSString *password, NSString *passwordConfirm)
                                       {
                                           return @([passwordConfirm isEqualToString:password] && password.length > 0);
                                }];
    
    self.touchMeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _)
                                      {
        NSLog(@"touch me was pressed!");
        return [RACSignal empty];
    }];
    

    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^(id sender)
                         {
        // The hypothetical -logIn method returns a signal that sends a value when
        // the network request finishes.
                             return [SimulateClient logIn];
    }];
    

    [self.loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        // Log a message whenever we log in successfully.
        [loginSignal subscribeCompleted:^
        {
            NSLog(@"Logged in successfully!");
        }];
    }];
    
    self.loginInButton.rac_command = self.loginCommand;
    
    
}


- (IBAction)didSimpleDemoTouch:(id)sender
{
    self.demoName = @"Hello World";
}

- (IBAction)didChangeButtonTouch:(UIButton*)sender
{
    if (sender.tag == 0)
    {
        self.demoName2 = @"World";
    }
    else if (sender.tag == 1)
    {
        self.demoName2 = @"Earth";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
