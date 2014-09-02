//
//  KVCSample.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-29.
//
//

#import "KVCSample.h"
#import "Person.h"
#import "Child.h"

@implementation KVCSample

- (void)test{
    //[self test_setNilToScalarProperty];
    //[self test_attributeAndToOneRelationCompliance];
    //[self test_collectionOperators];
    [self test_orderCollectionsSearch];
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
    
    /*
     successed
     */
    [mPerson setValue:@"dna1" forKey:@"dna"];
    NSLog(@"%@ -> \n%@", NSStringFromSelector(_cmd), mPerson);
}

- (void)test_collectionOperators{
    Person *mPerson = [[Person alloc] init];
    
    Child *child0 = [[Child alloc] init];
    child0.name = @"child0";
    child0.age = 10;
    child0.birth = [NSDate dateWithTimeIntervalSinceNow:-3600];
    
    Child *child1 = [[Child alloc] init];
    child1.name = @"child1";
    child1.age = 11;
    child1.birth = [NSDate dateWithTimeIntervalSinceNow:-7200];
    
    Child *child2 = [[Child alloc] init];
    child2.name = @"child2";
    child2.age = 12;
    child2.birth = [NSDate dateWithTimeIntervalSinceNow:-10800];
    
    mPerson.childern = [NSArray arrayWithObjects:child0, child1, child2,nil];
    NSLog(@"%@", mPerson.childern);
    
    /////////////////////////////
    //1.求平均值
    //  average age 11
    NSNumber *avgAge = [mPerson valueForKeyPath:@"childern.@avg.age"];
    NSLog(@"average age %d", [avgAge unsignedIntegerValue]);
    
    //2.个数
    //  child count 3
    NSNumber *countOfChild = [mPerson valueForKeyPath:@"childern.@count"];
    NSLog(@"child count %d", [countOfChild unsignedIntegerValue]);
    
    
    //3.max
    //  max child age 12
    NSNumber *maxAgeOfChild = [mPerson valueForKeyPath:@"childern.@max.age"];
    NSLog(@"max child age %d", [maxAgeOfChild unsignedIntegerValue]);
    
    //4.min
    //  min child birth
    NSDate *minBirthOfChild = [mPerson valueForKeyPath:@"childern.@min.birth"];
    NSLog(@"min child birth %@", minBirthOfChild);
    
    //5.sum
    //  sum child age 33
    NSNumber *sumAgesOfChild = [mPerson valueForKeyPath:@"childern.@sum.age"];
    NSLog(@"sum child age %@", sumAgesOfChild);
    
}

- (void)test_orderCollectionsSearch{
    Person *mPerson = [[Person alloc] init];
    NSMutableArray *mutableArray = [mPerson mutableArrayValueForKey:@"subPersons"];
    NSLog(@"mutableArray : %@", mutableArray);
    //[mutableArray addObject:@"sub0"];
    NSLog(@"mutableArray : %@", mutableArray);
    
}














@end
