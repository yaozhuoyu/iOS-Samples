//
//  KVOItem.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-28.
//
//

#import "KVOItem.h"

@implementation KVOItem

- (NSString *)fullItemName{
    return [NSString stringWithFormat:@"full + %@", self.itemName];
}

- (void)setManualTriggerKVOItemName:(NSString *)manualTriggerKVOItemName{
    if (![manualTriggerKVOItemName isEqualToString:_manualTriggerKVOItemName]) {
        [self willChangeValueForKey:@"manualTriggerKVOItemName"];
        _manualTriggerKVOItemName = manualTriggerKVOItemName;
        [self didChangeValueForKey:@"manualTriggerKVOItemName"];
    }
}


#pragma mark - overide

//+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
//    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
//    
//    if ([key isEqualToString:@"fullItemName"]) {
//        NSArray *affectingKeys = @[@"itemName"];
//        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
//    }
//    
//    return keyPaths;
//}

+ (NSSet *)keyPathsForValuesAffectingFullItemName{
    return [NSSet setWithObject:@"itemName"];
}


//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
//    if ([key isEqualToString:@"manualTriggerKVOItemName"]) {
//        return NO;
//    }
//    return [super automaticallyNotifiesObserversForKey:key];
//}

+ (BOOL)automaticallyNotifiesObserversOfManualTriggerKVOItemName{
    return NO;
}



@end
