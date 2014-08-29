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

//// to many relationship
@property (nonatomic, strong) NSArray *childern;

@end
