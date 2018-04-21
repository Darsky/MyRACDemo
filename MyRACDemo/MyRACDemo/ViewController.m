//
//  ViewController.m
//  MyRACDemo
//
//  Created by Darsky on 2018/4/20.
//  Copyright © 2018年 Darsky. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
@interface ViewController ()

@property (copy, nonatomic) NSString *demoName;

@property (copy, nonatomic) NSString *demoName2;

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
