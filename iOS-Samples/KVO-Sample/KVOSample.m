//
//  KVOSample.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-28.
//
//

#import "KVOSample.h"
#import "KVOItem.h"

@interface KVOSample(){
    KVOItem *testItem;
}

@end

@implementation KVOSample

- (void)test{
    
    testItem = [[KVOItem alloc] init];
    testItem.itemName = @"item0";
    testItem.manualTriggerKVOItemName = @"manual_trigger_item0";
    
//    [testItem addObserver:self
//               forKeyPath:@"itemName"
//                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior
//                  context:NULL];
//    [testItem addObserver:self
//               forKeyPath:@"fullItemName"
//                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
//                  context:NULL];
    
    [testItem addObserver:self
               forKeyPath:@"manualTriggerKVOItemName"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:NULL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        testItem.itemName = @"item1";
        testItem.manualTriggerKVOItemName = @"manual_trigger_item1";
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        testItem.itemName = @"item2";
        testItem.manualTriggerKVOItemName = @"manual_trigger_item1";
    });
    
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    NSLog(@"----> key path (%@)",keyPath);
    NSLog(@"----> change (%@)",change);
    
}


- (void)dealloc{
    [testItem removeObserver:self forKeyPath:@"itemName"];
}

@end
