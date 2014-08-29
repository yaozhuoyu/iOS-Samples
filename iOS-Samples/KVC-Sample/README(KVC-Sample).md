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

























