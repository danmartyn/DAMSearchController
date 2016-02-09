//
//  Person.m
//  SearchController
//
//  Created by Daniel Martyn on 2016-02-09.
//  Copyright © 2016 Daniel Martyn. All rights reserved.
//

#import "Person.h"
#import "NameGenerator.h"



@implementation Person


#pragma mark -
#pragma mark - Class Creator

+ (instancetype)randomPerson
{
    NameGenerator *generator = [NameGenerator sharedGenerator];
    NSString *randomName = [generator randomName];
    NSUInteger randomAge = arc4random() % (120 - 0) + 0;
    
    return [[Person alloc] initWithName:randomName age:randomAge];
}


#pragma mark -
#pragma mark - Initializer

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age
{
    self = [super init];
    if (self) {
        _name = name;
        _age = age;
    }
    return self;
}


#pragma mark -
#pragma mark - Debug Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%ld)", self.name, (long)self.age];
}


@end
