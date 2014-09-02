//
//  Person.h
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-29.
//
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *personName;

@property (nonatomic, assign, getter = isMale) BOOL male;

//readonly
@property (nonatomic, readonly, strong) NSString *dna;

@end
