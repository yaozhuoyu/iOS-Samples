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
































