### KVC-Samples
===========

#### 1.关于Scalar类型的属性设置为nil的处理

在KVC中我们知道，对于scalar类型的属性（非对象属性）的设置也是通过设置对象来完成的。当给scalar属性设置一个nil的时候，默认会抛出异常，我们需要重写方法`- (void)setNilValueForKey:(NSString *)key`来处理。

对于例子中Person对象，处理如下
```objective-c
- (void)setNilValueForKey:(NSString *)key{
    if ([key isEqualToString:@"male"]) {
        [self setValue:@(YES) forKey:key];
    }else{
        [super setNilValueForKey:key];
    }
}
```

#### 2.关于属性的验证

一个属性的验证方法如下形式`validate<Key>:error:`。

关于validation方法的调用，我们可以直接调用，或者调用方法`validateValue:forKey:error:`，传入指定的key。
`validateValue:forKey:error:`方法的缺省实现是在类中寻找名为`validate<Key>:error:`的方法，如果名为`validate<Key>:error:`的方法找到了，则直接调用，并返回。如果没有找到，则直接返回YES。

对应`-set<Key>:`方法的实现，一定不要调用验证方法。

通常情况下，kvc是不会自动进行验证方法的调用的，如果需要验证，自己有责任调用。但是对于有些框架，其在一定条件下会自动掉有那个验证方法，例如Core Data中，当managed object context 进行save的时候，会自动的进行验证，调用验证方法。


#### 3.关于KVC的兼容

对于一个类的某个属性kvc兼容，表示其可以正常的使用`valueForKey:`和`setValue:forKey:`方法。

分下面三类考虑：

##### 1.关于attribute和to-one relationship的兼容性

如果属性是一个attribute或者一个to-one relationship，如果想要kvc兼容，则需要类做下面几个方面：

实现名字为`-<key>`和`-is<Key>`的方法，或者有一个名为`<key>`或者`_<key>`的实例变量；
如果属性为可变的，则也需要实现`-set<Key>:`方法；
如果我们自己实现`-set<Key>:`方法，不要在`-set<Key>:`方法中进行验证(调用验证方法);
如果需要对其进行验证，则类应该实现方法`-validate<Key>:error:`。

##### 2.关于indexed to-many relationship的兼容性

如果属性为有序的to-many relationship，则想要kvc兼容，则需要类做下面几个方面：

实现一个名为`-<key>`的方法，并返回一个数组；
或者有一个名为`<key>`或者`_<key>`的实例变量，为数组类型；
或者类实现了方法`-countOf<Key>`，以及`-objectIn<Key>AtIndex:`和` -<key>AtIndexes:`中的一个或者两个；
可选的，如果要提高性能，可以实现`-get<Key>:range:`。

如果是可变的有序to-many relationship，同时类还要实现下面的方法：

实现`-insertObject:in<Key>AtIndex:`和 `-insert<Key>:atIndexes:`中的一个或者两个都实现；
实现`-removeObjectFrom<Key>AtIndex:`和 `-remove<Key>AtIndexes:`中的一个或者两个都实现；
可选择的，可以实现`-replaceObjectIn<Key>AtIndex:withObject:`和`-replace<Key>AtIndexes:with<Key>:`来提高性能。

##### 2.关于unordered to-many relationship的兼容性

如果属性为无序的to-many relationship，则想要kvc兼容，则需要类做下面几个方面：

实现一个名为`-<key>`的方法，并返回一个set；
或者有一个名为`<key>`或者`_<key>`的实例变量，为set类型；
或者实现了这三个方法`-countOf<Key>`, `-enumeratorOf<Key>`, 和 `-memberOf<Key>:`

如果是可变的无序to-many relationship，同时类还要实现下面的方法：

实现`-add<Key>Object:`和`-add<Key>:`中的一个或者两个都实现；
实现`-remove<Key>Object:`和`-remove<Key>:`中的一个或者两个都实现；
可选择的，可以实现`-intersect<Key>:`和`-set<Key>:`来提高性能。


#### 4.关于KVC的详细实现

KVC会首先尝试使用accessor方法去获取和设置对应的值，如果没有，才直接访问对应的实例变量。

##### 1.简单属性的查找模式

对于`setValue:forKey:`
当对一个属性调用`setValue:forKey:`的时候，按照下面顺序查找：
* (1)类先寻找名字和`set<Key>:`相同的accessor方法。
* (2)如果没有找到accessor方法，并且类的方法`accessInstanceVariablesDirectly`返回YES，则比较类中实例变量和下面的名字是否相配，`_<key>`、`_is<Key>`，`<key>`，`is<Key>`(按序比较)。
* (3)如果一个相匹配的accessor方法或者实例变量被找到，则用其去设置值。
* (4)如果都没有找到，则会调用方法`setValue:forUndefinedKey:`。

对于`valueForKey:`
* (1)首先在类中按照`get<Key>`、`<key>`、`is<Key>`的顺序去寻找对应的accessor方法，如果找到，则直接调用。如果方法返回的是对象指针类型，则直接简单的返回，如果返回的类型为scalar，并且支持NSNumber转换，返回返回一个NSNumber；否则转换为一个NSValue并返回。
* (2)如果对应的accessor方法没有找到，则在类中寻找如下格式的方法`countOf<Key>`、`objectIn<Key>AtIndex:`(对应于NSArray中的primitive methods)、`<key>AtIndexes:`(对应于NSArray中的方法 objectsAtIndexes:)。
如果`countOf<Key>`方法和剩下的两个方法中的至少一个找到了，则一个能响应所有NSArray方法的集合代理对象（collection proxy object）会返回。每一个发送给集合代理对象的NSArray方法都是有方法`countOf<Key>`、`objectIn<Key>AtIndex:`、`<key>AtIndexes:`组合起来的。
* (3)如果上述一些列array access方法没有找到，则继续寻找是否有下面三个方法`countOf<Key>`、`enumeratorOf<Key>`、`memberOf<Key>:`(对应NSSet的primitive methods)。
如果这三个方法发现了，则一个能响应所有NSSet方法的集合代理对象（collection proxy object）会返回，每一个发送给集合代理对象的NSSet方法都是有方法`countOf<Key>`、`enumeratorOf<Key>`、`memberOf<Key>:`组合起来的。
* (4)如果上述方法都没有发现，并且类的方法`accessInstanceVariablesDirectly`返回YES，则会按下面顺序去寻找对应的实例变量名字`_<key>`、`_is<Key>`、`<key>`、`is<Key>`，如果找到，则对应的值会返回，如果值为scalar类型，则会包裹成对应的NSNumber或者NSValue再返回。
* (5)如果上面的都没有找到，则会调用方法`valueForUndefinedKey:`。


##### 2.ordered collection的查找模式

对于方法`mutableArrayValueForKey:`的查找如下：
* (1)类首先名字匹配`insertObject:in<Key>AtIndex:`和`removeObjectFrom<Key>AtIndex:`的方法(对应NSMutableArray的方法`insertObject:atIndex:`、`removeObjectAtIndex:`)，或者名字匹配`insert<Key>:atIndexes:`和`remove<Key>AtIndexes:`的方法(对应NSMutableArray的方法`insertObjects:atIndexes:`、`removeObjectsAtIndexes:`)。
如果至少一个insetion方法和至少一个removal方法找到，则返回一个collection proxy object，对其的调用的每一个NSMutableArray方法都是有上面的insetion方法和removal方法组成完成的。
* (2)


































