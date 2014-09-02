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
    [self test_attributeAndToOneRelationCompliance];
}

- (void)test_setNilToScalarProperty{
    Person *mPerson = [[Person alloc] init];
    [mPerson setValue:nil forKey:@"personName"];
    [mPerson setValue:nil forKey:@"male"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
}

- (void)test_attributeAndToOneRelationCompliance{
    Person *mPerson = [[Person alloc] init];
    
    /*
     successed
     */
    [mPerson setValue:@"internal1" forKey:@"_internalName"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
    
    /*
     successed
     */
    [mPerson setValue:@"internal2" forKey:@"internalName"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
    
    
    /*
     successed
     */
    [mPerson setValue:@"internalHouse1" forKey:@"internalHouse"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
    
    /*
     error
    [mPerson setValue:@"internalHouse2" forKey:@"_internalHouse"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
     */
    
    [mPerson setValue:@"dna1" forKey:@"dna"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
}


















@end
