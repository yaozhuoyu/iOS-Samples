//
//  KVOItem.h
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-28.
//
//

#import <Foundation/Foundation.h>

@interface KVOItem : NSObject

@property (nonatomic, strong) NSString *itemName;

//手动触发kvo
@property (nonatomic, strong) NSString *manualTriggerKVOItemName;

- (NSString *)fullItemName;

@end
