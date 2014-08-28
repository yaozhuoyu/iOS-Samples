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
    
    [self testOrderedToManyRelationshipKVO];
    
    /*
    [testItem addObserver:self
               forKeyPath:@"itemName"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior
                  context:NULL];
    
    [testItem addObserver:self
               forKeyPath:@"fullItemName"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:NULL];
    
    [testItem addObserver:self
               forKeyPath:@"manualTriggerKVOItemName"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:NULL];
    */
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        testItem.itemName = @"item1";
        testItem.manualTriggerKVOItemName = @"manual_trigger_item1";
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        testItem.itemName = @"item2";
        testItem.manualTriggerKVOItemName = @"manual_trigger_item1";
    });
    
}

- (void)testOrderedToManyRelationshipKVO{
    testItem.orderArray = [NSArray arrayWithObject:@"orderArray_string0"];
    
    [testItem addObserver:self
               forKeyPath:@"orderArray"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:NULL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /*
         这种触发的结果 change dict 中 NSKeyValueChangeKindKey是setting，kind为1 (NSKeyValueChangeSetting)
         testItem.orderArray = [NSArray arrayWithObject:@"orderArray0"];
         */
        
        ///////////////////////////////////////////////
        
        NSMutableArray *orderArray = [testItem mutableArrayValueForKey:@"orderArray"];
        /*
         触发一次kvo，change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeInsertion
         NSKeyValueChangeOldKey没有值， 
         NSKeyValueChangeNewKey 为一个只有一个元素(orderArray_string1)的数组
         NSKeyValueChangeIndexesKey 为一个 NSIndexSet
         */
        NSLog(@"==============================================>>> addObject");
        [orderArray addObject:@"orderArray_string1"];
        
        /*
         触发两次kvo，
         第一次：
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeInsertion
         NSKeyValueChangeOldKey没有值，
         NSKeyValueChangeNewKey 为一个只有一个元素(orderArray_string2)的数组
         NSKeyValueChangeIndexesKey 为一个 NSIndexSet
         
         第二次：
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeInsertion
         NSKeyValueChangeOldKey没有值，
         NSKeyValueChangeNewKey 为一个只有一个元素(orderArray_string3)的数组
         NSKeyValueChangeIndexesKey 为一个 NSIndexSet
         */
        NSLog(@"==============================================>>> addObjectsFromArray");
        [orderArray addObjectsFromArray:@[@"orderArray_string2", @"orderArray_string3"]];
        
        /*
         触发1次kvo，
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeRemoval
         NSKeyValueChangeOldKey为一个只有一个元素(orderArray_string3)的数组，
         NSKeyValueChangeNewKey没有值
         NSKeyValueChangeIndexesKey 为一个 NSIndexSet
         */
        NSLog(@"==============================================>>> removeLastObject");
        [orderArray removeLastObject];
        
        /*
         触发1次kvo，
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeReplacement
         NSKeyValueChangeOldKey为一个只有一个元素(orderArray_string0)的数组，
         NSKeyValueChangeNewKey为一个只有一个元素(orderArray_string0_replace)的数组
         NSKeyValueChangeIndexesKey 为一个 NSIndexSet
         */
        NSLog(@"==============================================>>> replaceObject");
        //orderArray[0] = @"orderArray_string0_replace"; 等价于replaceObjectAtIndex
        [orderArray replaceObjectAtIndex:0 withObject:@"orderArray_string0_replace"];
        
        /*
         触发四次kvo，
         第1次 删 NSKeyValueChangeRemoval      orderArray_string2
         第2次 删 NSKeyValueChangeRemoval      orderArray_string1
         第3次 删 NSKeyValueChangeRemoval      orderArray_string0_replace
         第4次 添加 NSKeyValueChangeInsertion   orderArray_string4
         */
        NSLog(@"==============================================>>> setArray");
        [orderArray setArray:@[@"orderArray_string4"]];
        
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
