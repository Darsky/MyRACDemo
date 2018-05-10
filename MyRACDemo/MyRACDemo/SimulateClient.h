//
//  SimulateClient.h
//  MyRACDemo
//
//  Created by Darsky on 2018/5/10.
//  Copyright © 2018年 Darsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface SimulateClient : NSObject

+ (RACSignal*)logIn;

@end
