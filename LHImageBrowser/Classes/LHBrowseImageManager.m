//
//  KSBrowImageManager.m
//  ImageBrow
//
//  Created by lihui on 2020/7/23.
//  Copyright © 2020 lihui. All rights reserved.
//

#import "LHBrowseImageManager.h"
#import "LHBrowseImageView.h"
#import <UIKit/UIKit.h>
#import "LHImageModel.h"


// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [UIApplication sharedApplication].windows.lastObject.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


#pragma mark - KSBrowImageModel
@interface LHBrowseImageModel : NSObject

/// 初始展示位置
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) LHBrowseImageView *imv;
@property (nonatomic, weak) UIScrollView *scrollView;
/// 来源位置
@property (nonatomic, assign) CGRect fromRect;


@end

@implementation  LHBrowseImageModel

@end

#pragma mark - KSBrowImageManager
@interface LHBrowseImageManager ()<KSBrowImageViewDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, strong) NSMutableArray *imageModelArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat s_width;
@property (nonatomic, assign) CGFloat s_height;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *bgView;

/// 是否正在移动 
@property (nonatomic, assign) BOOL isMoving;


@end

@implementation LHBrowseImageManager
+ (void)showImagesWith:(NSArray *)imgArray andFromVC:(UIViewController *)fromVC selectIndex:(NSInteger)index title:(NSString *)title {
    [[[self alloc] init] _showImagesWith:imgArray andFromVC:fromVC selectIndex:index title:title];
}

- (void)dealloc {
    
}
#pragma mark - private
- (void)_showImagesWith:(NSArray *)imgArray andFromVC:(UIViewController *)fromVC selectIndex:(NSInteger)index title:(NSString *)title {
    BOOL isiPhoneX = NO;
    if (@available(iOS 11.0, *)) {
       isiPhoneX = [UIApplication sharedApplication].windows.lastObject.safeAreaInsets.bottom > 0.0;
    }
    
    self.currentIndex = index;
    self.fromVC = fromVC;
    [self _configArray:imgArray];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _configSubViews];
        [self _configImageViews];
    });
}

- (void)_configArray :(NSArray *)imgArrray {
    self.pageControl.numberOfPages = imgArrray.count;
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i <imgArrray.count; i++) {
        LHImageModel *kModel = imgArrray[i];
        
        UIImage *img = kModel.image;
        CGFloat w = self.s_width;
        CGFloat coefficient = (self.s_width/img.size.width);
        CGFloat h = coefficient * img.size.height;
        
        if (h > self.s_height) {
            h = self.s_height;
            w = (h/img.size.height) * img.size.width;
            
            if (w > self.s_width) {
                w = self.s_width;
                h = (self.s_width/img.size.width) * img.size.height;
            }
        } else {
            if (w > self.s_width) {
                w = self.s_width;
                h = (self.s_width/img.size.width) * img.size.height;
            }
        }
        
        LHBrowseImageModel *model = [[LHBrowseImageModel alloc] init];
        model.image = img;
        CGFloat safeP = 0;
        if (IPHONE_X) {
            safeP = 78;
        }
        model.frame =CGRectMake((self.s_width - w)/2 , (self.s_height - h) / 2 , w, h);
        model.index = i;
        model.fromRect = kModel.fromRect;
        
        
        //过渡
        if (i == self.currentIndex) {

            UIView *view = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            UIImageView *v = [[UIImageView alloc] initWithFrame:model.fromRect];
            v.image = model.image;
            [view addSubview:v];
            CGFloat topPadding = IPHONE_X ? 44 : 0;
            CGRect r = model.frame;
            [UIView animateWithDuration:0.25 animations:^{
                view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
                v.frame = CGRectMake(r.origin.x, r.origin.y + topPadding, r.size.width, r.size.height);
            }];
            [self.fromVC.view.window addSubview:view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [view removeFromSuperview];
            });
        }
        [mArr addObject:model];

    }
    self.imageModelArray = mArr;
}

- (void)_configSubViews {
    [self.fromVC.view.window addSubview:self.scrollView];
    [self.fromVC.view.window addSubview:self.pageControl];
    self.scrollView.contentSize = CGSizeMake(self.fromVC.view.window.bounds.size.width * self.imageModelArray.count, self.fromVC.view.window.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.s_width * self.currentIndex, 0);
    self.pageControl.currentPage = self.currentIndex;
}

- (void)_configImageViews {
    for (int i = 0; i < self.imageModelArray.count; i++) {
        LHBrowseImageModel *model = self.imageModelArray[i];
        LHBrowseImageView *imv = [[LHBrowseImageView alloc] initWithFrame:model.frame];
        imv.image = model.image;
        imv.userInteractionEnabled = YES;
        imv.delegate = self;
        imv.index = i;
        imv.isNeedMove = YES;
        CGFloat topPadding = IPHONE_X ? 44 : 0;
        UIScrollView *c = [[UIScrollView alloc] initWithFrame:CGRectMake(self.s_width * i,topPadding, self.s_width, self.fromVC.view.window.bounds.size.height)];
        c.contentSize = CGSizeMake(self.s_width, self.s_height);
        c.delegate = self;
        c.minimumZoomScale = 1;
        c.maximumZoomScale = 3;
        if (@available(iOS 11.0, *)) {
            c.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [c addSubview:imv];
   
        model.imv = imv;
        model.scrollView = c;
        [self.scrollView addSubview:c];
    }
    
}


- (void)_hidden {
    
    LHBrowseImageModel *model = self.imageModelArray[self.currentIndex];
    model.scrollView.userInteractionEnabled = NO;
//    model.scrollView.frame;
//    NSLog(@"%f,%f",model.scrollView.contentSize.width,model.scrollView.contentSize.height);
//    NSLog(@"%f,%f,%f,%f",self.scrollView.frame.origin.x,self.scrollView.frame.origin.y,self.scrollView.frame.size.width,self.scrollView.frame.size.height);
//    NSLog(@"%f,%f,%f,%f",model.imv.frame.origin.x,model.imv.frame.origin.y, model.imv.frame.size.width,model.imv.frame.size.height);
//    NSLog(@"%f,%f",model.scrollView.contentOffset.x,model.scrollView.contentOffset.y);
    CGRect frame = model.imv.frame;
    CGFloat topPadding = IPHONE_X ? 44 : 0;
    if (frame.size.width > model.frame.size.width) {
        model.imv.frame = CGRectMake(-model.scrollView.contentOffset.x, -model.scrollView.contentOffset.y - topPadding, frame.size.width, frame.size.height);
        [self.fromVC.view.window addSubview:model.imv];
        topPadding = 0;
    }
    
    
    CGRect r = model.fromRect;
    [UIView animateWithDuration:0.25 animations:^{
        model.imv.frame = CGRectMake(r.origin.x, r.origin.y - topPadding, r.size.width, r.size.height);
        self.scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        [model.imv removeFromSuperview];
    });
    [self.pageControl removeFromSuperview];
}

#pragma mark - KSBrowImageViewDelegate
- (void)moved:(LHBrowseImageView *)imv point:(CGPoint)point {
    self.isMoving = YES;
    
    self.scrollView.scrollEnabled = NO;
    LHBrowseImageModel *model = self.imageModelArray[imv.index];

    CGFloat s =  self.s_height - model.frame.origin.y;
    //位移
    CGFloat wy = imv.frame.origin.y - model.frame.origin.y;
    //比例
    CGFloat bl = (s - fabs(wy))/s;
    
    if (wy < 0) {
        bl = 1;
    }
    
    self.scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:fabs(bl)];
    NSLog(@"%f",point.y);
}

- (void)endMove:(LHBrowseImageView *)imv point:(CGPoint)point hidden:(BOOL)hidden {
    self.isMoving = NO;
    self.scrollView.scrollEnabled = YES;
    LHBrowseImageModel *model = self.imageModelArray[imv.index];
    
    if (hidden) {
        [self _hidden];
        
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            imv.frame = model.frame;
            self.scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    LHBrowseImageModel *model = self.imageModelArray[self.currentIndex];
    model.imv.isNeedMove = NO;
    return  model.imv;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    LHBrowseImageModel *model = self.imageModelArray[self.currentIndex];
    CGFloat y;
    if (scrollView.contentSize.height > self.s_height) {
        y = scrollView.contentSize.height/2;
    } else {
        y = self.s_height/2;
    }
    CGFloat x;
    if (scrollView.contentSize.width > self.s_width) {
        x = scrollView.contentSize.width/2;
    } else {
        x = self.s_width/2;
    }
    CGPoint p = CGPointMake(x , y );
    model.imv.center = p;

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale == 1) {
        if ([view isMemberOfClass:[LHBrowseImageView class]]) {
//            [view setValue:@(YES) forKey:@"isNeedZoomDouble"];
        }
    }
    if ((scale <1.1) && (scale > 0.9)) {
        if ([view isMemberOfClass:[LHBrowseImageView class]]) {
            [view setValue:@(YES) forKey:@"isNeedMove"];
        }
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x / self.s_width;
        self.currentIndex = index;
        self.pageControl.currentPage = index;
    }
}


#pragma mark -Action
- (void)tapAC{
    
    if (self.isMoving) {
        return;
    }
    [self _hidden];
}

- (void)tapDoubleAC:(UITapGestureRecognizer *)tap {
    
    LHBrowseImageModel *model = self.imageModelArray[self.currentIndex];
    CGPoint p = [tap locationInView:model.scrollView];
    if (model.scrollView.zoomScale > 1) {
        [UIView animateWithDuration:0.25 animations:^{
            model.scrollView.zoomScale = 1;
        }];
        [model.imv setValue:@(YES) forKey:@"isNeedMove"];
    
    } else {
        CGPoint op = CGPointZero;
        if (model.frame.size.width >= [UIScreen mainScreen].bounds.size.width/2) {
            CGFloat kx  = ([UIScreen mainScreen].bounds.size.width/2 - [UIScreen mainScreen].bounds.size.width + p.x)/[UIScreen mainScreen].bounds.size.width * model.imv.frame.size.width *2;
            op.x = kx;
        }
        if (model.frame.size.height >= [UIScreen mainScreen].bounds.size.height/2) {
            CGFloat ky  = ([UIScreen mainScreen].bounds.size.height/2 - [UIScreen mainScreen].bounds.size.height + p.y)/[UIScreen mainScreen].bounds.size.height * model.imv.frame.size.height * 2;
            op.y = ky;
        }
        [UIView animateWithDuration:0.25 animations:^{
            model.scrollView.contentOffset = op;
            model.scrollView.zoomScale = 2;
        }];
    }
}

#pragma mark -Getter
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.fromVC.view.window.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAC)];
        tap.numberOfTapsRequired = 1;
        UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDoubleAC:)];
        tapDouble.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:tap];
        [_scrollView addGestureRecognizer:tapDouble];
        [tap requireGestureRecognizerToFail:tapDouble];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;

    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.tintColor = [UIColor grayColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPage = 0;
        CGFloat bp = IPHONE_X ? 34 : 0;
        _pageControl.frame = CGRectMake(0, self.fromVC.view.window.bounds.size.height - 30 - bp, self.s_width, 30);
    }
    return _pageControl;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    return _bgView;
}

- (CGFloat)s_width {

    return self.fromVC.view.window.bounds.size.width;
    
}

- (CGFloat)s_height {
    if (IPHONE_X) {
        return self.fromVC.view.window.bounds.size.height - 78;
    }
    return self.fromVC.view.window.bounds.size.height;
}



@end
