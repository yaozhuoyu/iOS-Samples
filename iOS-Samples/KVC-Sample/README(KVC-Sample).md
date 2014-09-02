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


























