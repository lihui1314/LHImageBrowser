//
//  LHTestViewController.m
//  LHImageBrowser_Example
//
//  Created by 李辉 on 2021/3/1.
//  Copyright © 2021 18221534728@163.com. All rights reserved.
//

#import "LHTestViewController.h"
#import "LHBrowseImageManager.h"
#import "LHImageModel.h"
@interface LHTestViewController ()
@property (nonatomic, strong) UIImageView *v1;
@property (nonatomic, strong) UIImageView *v2;

@property (nonatomic, strong) UIButton *button;
@end

@implementation LHTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV1)];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV2)];
    
    [self.v1 addGestureRecognizer:tap1];
    [self.v2 addGestureRecognizer:tap2];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *i = [UIImage imageNamed:@"t.jpg"];
    UIImage *t = [UIImage imageNamed:@"timg.jpeg"];
    
    self.v1.image = i;
    self.v2.image = t;
    
    self.v1.frame = CGRectMake(100, 100, 100, 100/i.size.width * i.size.height);
    [self.view addSubview:self.v1];
    self.v2.frame = CGRectMake(250, 200, 100, (100 / t.size.width) * t.size.height);
    [self.view addSubview:self.v2];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
//    UIImage *i = [UIImage imageNamed:@"t.jpg"];
//    UIImage *t = [UIImage imageNamed:@"timg.jpeg"];

}

- (void)tapV1 {
    NSArray *imageArray = [self getImageArray];
    [LHBrowseImageManager showImagesWith:imageArray andFromVC:self selectIndex:0 title:@""];
    
}

- (void)tapV2 {
    NSArray *imageArray = [self getImageArray];
    [LHBrowseImageManager showImagesWith:imageArray andFromVC:self selectIndex:1 title:@""];
}

#pragma mark -Getter

- (NSArray *)getImageArray {
    LHImageModel *model1 = [[LHImageModel alloc] init];
    model1.image = self.v1.image;
    CGPoint point = [self.v1 convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    model1.fromRect = CGRectMake(point.x, point.y, self.v1.frame.size.width,self.v1.frame.size.height);
     
    LHImageModel *model2 = [[LHImageModel alloc] init];
    model2.image = self.v2.image;
    CGPoint point2 = [self.v2 convertPoint:CGPointMake(0,0) toView:[UIApplication sharedApplication].windows.lastObject];
    model2.fromRect = CGRectMake(point2.x, point2.y, self.v2.frame.size.width,self.v2.frame.size.height);
     
    NSArray * array = @[model1,model2];
    return array;
}

- (UIImageView *)v1 {
    if (_v1 == nil) {
        _v1 = [[UIImageView alloc] init];
        _v1.userInteractionEnabled = YES;
    
    }
    return _v1;
}

- (UIImageView *)v2 {
    if (_v2 == nil) {
        _v2 = [[UIImageView alloc] init];
        _v2.userInteractionEnabled = YES;
    }
    return _v2;;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [[UIButton alloc] init];
    }
    return _button;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
