//
//  Child.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-9-2.
//
//

#import "Child.h"

@implementation Child

- (NSString *)description{
    return [NSString stringWithFormat:@"age %d, name %@, birth %@", _age, _name, _birth];
}

@end
