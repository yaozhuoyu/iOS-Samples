//
//  Person.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-29.
//
//

#import "Person.h"

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
    [description appendString:[NSString stringWithFormat:@"person -> \nisMale:%d", [self isMale]]];
    [description appendString:[NSString stringWithFormat:@"\npersonName:%@", self.personName]];
    return description;
    
}

@end





















