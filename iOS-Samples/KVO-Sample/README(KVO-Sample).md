### KVO-Samples
===========

#### 1.关于添加observer时，options的选择

在添加kvo通知的时候需要方法
```objective-c
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
```
其中options有几个可用的选项：
* NSKeyValueObservingOptionNew
* NSKeyValueObservingOptionOld
* NSKeyValueObservingOptionInitial
* NSKeyValueObservingOptionPrior

`NSKeyValueObservingOptionNew` 和 `NSKeyValueObservingOptionOld` 我们大家都常用，在此不用解释了，主要是后面两个。

`NSKeyValueObservingOptionInitial`选项如果添加上，则在调用方法`- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context`的时候，并在此方法还没返回的时候，就会触发第一次KVO通知，如果options中包含`NSKeyValueObservingOptionNew`，则change字典中会包含`NSKeyValueChangeNewKey`，但是即使options中包含`NSKeyValueObservingOptionOld`，change字典中也不会包含`NSKeyValueChangeOldKey`。

`NSKeyValueObservingOptionInitial`选项还是很有用的，比如说，我们有一个属性为hidden，我们通过kvo监听他，当hidden为YES的时候，把一个UIButton设置为隐藏的，当hidden为NO的时候，把UIButton设置为显示的。但是如果不添加`NSKeyValueObservingOptionInitial`属性的时候，只有在属性hidden改变的时候，我们才会收到相应的通知，去改变对应的状态，没有办法一开始在addObserver就方便的设置好。

`NSKeyValueObservingOptionPrior`选项加上之后，当监听的属性发生改变的时候，方法`- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)contex`会调用两次，在改变之前调用一次，改变之后调用一次。改变之前调用的一次在change字典中会多一个一项（`notificationIsPrior = 1`）,通过这个我们可以判断是此通知是在修改前还是修改后发出的。


#### 2.关于方法`+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key`

当添加观察一个对象的属性字符串时(调用方法`- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context`)，此方法会去调用被观察对象的类方法`keyPathsForValuesAffectingValueForKey`，询问是否有其他的属性的改变会影响到此属性。此方法一般用在对合成的属性进行观察的时候。

如例子中，当监听属性`fullItemName`的时候，调用了此方法，我们在此方法中返回了包含属性`itemName`的NSSet，则当属性itemName发生改变的时候，监听属性`fullItemName`的对象会收到对应的通知。

此方法的缺省实现是在类中寻找一个名字为+keyPathsForValuesAffecting<Key>的方法，如果找到此方法则返回此方法的返回结果。


#### 3.关于手动触发KVO通知

如果想要对一个属性字符串进行手动触发，则一定要实现方法`+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key`，对于对应的key放回NO，或者实现类方法`automaticallyNotifiesObserversOf<key>`返回NO。然后在对应的值修改的时候调用`willChangeValueForKey`和`didChangeValueForKey`方法。


#### 4.关于有序的relationship的KVO通知

对于有序的to-many relationship，当修改了`mutableArrayValueForKey:`返回的数组的值(或者`mutableOrderedSetValueForKey:`返回的NSMutableOrderedSet)，则有发出KVO通知，，kind可能有(`NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, and NSKeyValueChangeReplacement`)，具体的下面的例子。（除了方法mutableArrayValueForKey，其他的key-value coding-compliant array or ordered set mutation methods for the key 也适用）


```objective-c
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
```

如果需要手动触发，则应该使用下面两个方法：

```objective-c
- (void)willChange:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key;
- (void)didChange:(NSKeyValueChange)changeKind valuesAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key;
```

#### 5.关于无序的relationship的KVO通知

同有序的差不多，在此处使用NSSet，看下面的例子：

```objective-c
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
```

如果需要手动触发，则应该使用下面两个方法：

```objective-c
- (void)willChangeValueForKey:(NSString *)key withSetMutation:(NSKeyValueSetMutationKind)mutationKind usingObjects:(NSSet *)objects;
- (void)didChangeValueForKey:(NSString *)key withSetMutation:(NSKeyValueSetMutationKind)mutationKind usingObjects:(NSSet *)objects;
```






















