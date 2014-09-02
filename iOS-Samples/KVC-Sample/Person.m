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
    NSMutableArray *internalChildern;
}

@end

@implementation Person

- (id)init{
    self = [super init];
    if (self) {
        //必须为NSMutableArray类型
        internalChildern = [NSMutableArray array];
    }
    return self;
}

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
    [description appendString:[NSString stringWithFormat:@"\tinternalChildern:%@", internalChildern]];
    return description;
    
}

- (void)setChildern:(NSArray *)childern{
    NSLog(@"call set childern %@",childern);
    _childern = childern;
}

@end





















