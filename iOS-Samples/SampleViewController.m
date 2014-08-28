//
//  SampleViewController.m
//  iOS-Samples
//
//  Created by 姚卓禹 on 14-8-28.
//
//

#import "SampleViewController.h"
#import "KVOSample.h"

@interface SampleViewController (){
    //KVOSample *kvoSample_;
    IOSSample *iosSample_;
}

@end

@implementation SampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        iosSample_ = [[KVOSample alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [iosSample_ test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}














@end
