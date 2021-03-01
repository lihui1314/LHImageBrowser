//
//  LHViewController.m
//  LHImageBrowser
//
//  Created by 18221534728@163.com on 02/28/2021.
//  Copyright (c) 2021 18221534728@163.com. All rights reserved.
//

#import "LHViewController.h"
#import "LHTestViewController.h"

@interface LHViewController ()
@property (nonatomic, strong) UIButton *starButon;
@end

@implementation LHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.starButon];
    self.starButon.frame = CGRectMake(self.view.frame.size.width/2 - 40, 200, 80, 40);

    // Do any additional setup after loading the view.
}


- (void)starButonAction {
    LHTestViewController *vc = [[LHTestViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.edgesForExtendedLayout = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIButton *)starButon {
    if (_starButon == nil) {
        _starButon = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_starButon setTitle:@"测试" forState:(UIControlStateNormal)];
        [_starButon addTarget:self action:@selector(starButonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_starButon.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightMedium)]];
    }
    return _starButon;
}


@end
