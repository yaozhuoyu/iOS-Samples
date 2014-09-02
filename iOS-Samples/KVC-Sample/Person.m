//
//  Person.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-29.
//
//

#import "Person.h"

@interface Person(){
    NSString *_internalName;
    NSString *internalHouse;
}

@end

@implementation Person

- (void)setNilValueForKey:(NSString *)key{
    if ([key isEqualToString:@"male"]) {
        [self setValue:@(YES) forKey:key];
    }else{
        [super setNilValueForKey:key];
    }
}

- (NSString *)description{
    
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:[NSString stringWithFormat:@"person  \tisMale:%d", [self isMale]]];
    [description appendString:[NSString stringWithFormat:@"\tpersonName:%@", self.personName]];
    [description appendString:[NSString stringWithFormat:@"\t_internalName:%@", _internalName]];
    [description appendString:[NSString stringWithFormat:@"\tinternalHouse:%@", internalHouse]];
    [description appendString:[NSString stringWithFormat:@"\tdna:%@", _dna]];
    return description;
    
}

- (void)setSubPersons:(NSArray *)subs{
    ///test
    NSLog(@"called set subpersons : %@", subs);
}

@end





















