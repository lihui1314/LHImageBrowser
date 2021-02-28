//
//  LHBrowseImageView.h
//  ImageBrow
//
//  Created by lihui on 2020/7/23.
//  Copyright © 2020 lihui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef CGFloat (^CallBack)(void);
@class LHBrowseImageView;
@protocol KSBrowImageViewDelegate <NSObject>

- (void)moved:(LHBrowseImageView *)imv point:(CGPoint)point;

- (void)endMove:(LHBrowseImageView *)imv point:(CGPoint) point hidden:(BOOL)hidden;
@end

@interface LHBrowseImageView : UIImageView

/// 能否移动
@property (nonatomic, assign) BOOL canMove;

@property (nonatomic, assign) NSInteger index;
///strong 为了持有manager 对象
@property (nonatomic, strong) id<KSBrowImageViewDelegate>delegate;


/// 是否需要独立移动
@property (nonatomic, assign) BOOL isNeedMove;

@property (nonatomic, copy) CallBack callBack;

@end

NS_ASSUME_NONNULL_END
