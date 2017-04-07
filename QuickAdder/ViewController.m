//
//  ViewController.m
//  QuickAdder
//
//  Created by PhantomX on 2017/3/26.
//  Copyright © 2017年 PhantomX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{

}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)quickAdderReturnDictionary:(NSDictionary *)dic {
    NSLog(@"%@",dic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(UIButton *)sender {
    QuickAdder *quickAdder;
    QuickAdderForImage *quickAdderForImage;
    NSDictionary *keyDictionary = @{
                                    @"first" : @"\\d",
                                    @"second" : @"\\d"
                                    };
    quickAdderForImage = [[QuickAdderForImage alloc] initQuickAdderForImageWithViewController:self pictureCanBeNil:NO ImageName:@"Image" title:@"标题" message:@"信息" keyDictionary:keyDictionary];
    [quickAdderForImage setDelegate:self];
    [quickAdderForImage openQuickAdderForImage];
}

@end
