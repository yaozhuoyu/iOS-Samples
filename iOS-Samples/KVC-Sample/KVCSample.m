//
//  KVCSample.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-29.
//
//

#import "KVCSample.h"
#import "Person.h"

@implementation KVCSample

- (void)test{
    //[self test_setNilToScalarProperty];
    [self test_toManyRelationShipProperty];
}

- (void)test_setNilToScalarProperty{
    Person *mPerson = [[Person alloc] init];
    [mPerson setValue:nil forKey:@"personName"];
    [mPerson setValue:nil forKey:@"male"];
    NSLog(@"%@ -> %@", NSStringFromSelector(_cmd), mPerson);
}

- (void)test_toManyRelationShipProperty{
    Person *mPerson = [[Person alloc] init];
    
    mPerson.childern = [NSArray arrayWithObjects:@"child0",@"child1",@"child2", nil];
    
    //
    //NSUInteger childernCount = [mPerson count];
    
    NSLog(@"%@ -> %@", NSStringFromSelector(_cmd), mPerson);
}


















@end
