//
//  Person.h
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Person : NSObject


@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSUInteger age;


+ (instancetype)randomPerson;
- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age;


@end
