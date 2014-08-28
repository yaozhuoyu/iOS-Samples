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
    
    //[self testOrderedToManyRelationshipKVO];
    [self testUnOrderedToManyRelationshipKVO];
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

/******************************************************
 测试有序的kvo
 ******************************************************/
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

/******************************************************
 测试无序的kvo
******************************************************/
- (void)testUnOrderedToManyRelationshipKVO{
    testItem.unorderSet = [NSSet setWithObject:@"unorderSet_string0"];
    
    [testItem addObserver:self
               forKeyPath:@"unorderSet"
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:NULL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /*
         这种触发的结果 change dict 中 NSKeyValueChangeKindKey是setting，kind为1 (NSKeyValueChangeSetting)
         NSKeyValueChangeNewKey 和 NSKeyValueChangeOldKey 都是NSSet
         testItem.unorderSet = [NSSet setWithObject:@"_unorderSet_string0"];
        */
        
        ///////////////////////////////////////////////
        
        NSMutableSet *mutableSet = [testItem mutableSetValueForKey:@"unorderSet"];
        
        /*
         触发一次kvo，change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeInsertion
         NSKeyValueChangeOldKey没有值，
         NSKeyValueChangeNewKey 为一个只有一个元素(unorderSet_string1)的NSSet
         */
        NSLog(@"==============================================>>> addObject");
        [mutableSet addObject:@"unorderSet_string1"];
        
        /*
         触发1次kvo，
         
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeInsertion
         NSKeyValueChangeOldKey没有值，
         NSKeyValueChangeNewKey 为一个有两个元素(unorderSet_string2,unorderSet_string3)的NSSet
         */
        NSLog(@"==============================================>>> addObjectsFromArray");
        [mutableSet addObjectsFromArray:@[@"unorderSet_string2", @"unorderSet_string3"]];
        
        
        /*
         触发1次kvo，
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeInsertion
         NSKeyValueChangeOldKey没有值，
         NSKeyValueChangeNewKey为一个有1元素(unorderSet_string4)的NSSet
         当unionSet的值为unorderSet_string3时，NSKeyValueChangeKindKey还是NSKeyValueChangeInsertion，
         NSKeyValueChangeNewKey则变成一个空的NSSet
         */
        NSLog(@"==============================================>>> unionSet");
        [mutableSet unionSet:[NSSet setWithObject:@"unorderSet_string4"]];
        
        /*
         触发1次kvo，
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeRemoval
         NSKeyValueChangeOldKey为一个只有一个元素(unorderSet_string4)的NSSet，
         NSKeyValueChangeNewKey没有值
         */
        NSLog(@"==============================================>>> minusSet");
        [mutableSet minusSet:[NSSet setWithObject:@"unorderSet_string4"]];
        
        /*
         触发一次KVO
         change dict 中 NSKeyValueChangeKindKey 为 NSKeyValueChangeRemoval
         NSKeyValueChangeOldKey为一个有2个元素(unorderSet_string0， unorderSet_string1)的NSSet，
         NSKeyValueChangeNewKey没有值
         */
        NSLog(@"==============================================>>> intersectSet");
        //当前mutableSet结果为unorderSet_string0 ，unorderSet_string1， unorderSet_string2， unorderSet_string3
        [mutableSet intersectSet:[NSSet setWithArray:@[@"unorderSet_string2", @"unorderSet_string3", @"unorderSet_string6"]]];
        //当前mutableSet结果为unorderSet_string2， unorderSet_string3
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
