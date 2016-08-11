//
//  JJScrollMenu.m
//  market
//
//  Created by 邹俊 on 2016/8/3.
//  Copyright © 2016年 尚娱网络. All rights reserved.
//

#import "JJScrollMenu.h"
#import "JJMenuItemCell.h"

int const kMenuHeight = 40;
int const kLineHeight = 3;
NSString *const kMenuItemCellIdentifier = @"JJMenuItemCell";


@interface JJScrollMenu () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/**
 *  头部
 */
@property (nonatomic, strong) UICollectionView *menuCollectionView;
/**
 *  线
 */
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat minMenuItemSpace;

/**
 *  内容
 */
@property (nonatomic, strong) UICollectionView *contentCollectionView;





@end

@implementation JJScrollMenu

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}


/**
 * 初始化
 */
- (void)commonInit {
    /*
     * 初始化默认值
     */
    _menuTitles = [NSArray array];
    _currentIndex = 0;
    _menuBackgroundColor = [UIColor whiteColor];
    _lineColor = [UIColor blueColor];
    _normalFontColor = [UIColor blackColor];
    _selectedFontColor = [UIColor blueColor];
    _normalFontSize = 14;
    _selectedFontSize = 16;
    _minMenuItemSpace = 20;

    /*
     * 标题栏
     */
    UICollectionViewFlowLayout *menuLayout = [[UICollectionViewFlowLayout alloc] init];
    menuLayout.minimumInteritemSpacing = 0;
    menuLayout.minimumLineSpacing = 0;
    menuLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:menuLayout];
    _menuCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _menuCollectionView.backgroundColor = _menuBackgroundColor;
    _menuCollectionView.showsHorizontalScrollIndicator = NO;
    _menuCollectionView.showsVerticalScrollIndicator = NO;
    _menuCollectionView.delegate = self;
    _menuCollectionView.dataSource = self;
    [_menuCollectionView registerClass:[JJMenuItemCell class] forCellWithReuseIdentifier:kMenuItemCellIdentifier];
    [self addSubview:_menuCollectionView];

    [self addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_menuCollectionView]|"
                                                    options:0
                                                    metrics:nil
                                                      views:NSDictionaryOfVariableBindings(_menuCollectionView)]];
    [self addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:
                            [NSString stringWithFormat:@"V:|[_menuCollectionView(%d)]", kMenuHeight]
                                                    options:0
                                                    metrics:nil
                                                      views:NSDictionaryOfVariableBindings(_menuCollectionView)]];

    /*
     * 线
     */
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = _lineColor;
    [_menuCollectionView addSubview:_lineView];

    /*
     * 内容
     */
    UICollectionViewFlowLayout *contentLayout = [[UICollectionViewFlowLayout alloc] init];
    menuLayout.minimumInteritemSpacing = 0;
    menuLayout.minimumLineSpacing = 0;
    menuLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:contentLayout];
    _contentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentCollectionView.backgroundColor = [UIColor redColor];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.showsVerticalScrollIndicator = NO;
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerClass:[JJMenuItemCell class] forCellWithReuseIdentifier:kMenuItemCellIdentifier];
    [self addSubview:_contentCollectionView];

    [self addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentCollectionView]|"
                                                    options:0
                                                    metrics:nil
                                                      views:NSDictionaryOfVariableBindings(_contentCollectionView)]];
    [self addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_menuCollectionView][_contentCollectionView]|"
                                                    options:0
                                                    metrics:nil
                                                      views:NSDictionaryOfVariableBindings(_menuCollectionView, _contentCollectionView)]];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_menuCollectionView]) {
        NSString *title = _menuTitles[(NSUInteger) indexPath.item];
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_selectedFontSize]}];
        size = CGSizeMake(size.width + _minMenuItemSpace, kMenuHeight);
        return size;
    }
    return CGSizeMake(0, 0);
}





#pragma mark - DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_menuCollectionView]) {
        JJMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuItemCellIdentifier forIndexPath:indexPath];
        cell.normalFontColor = _normalFontColor;
        cell.normalFontSize = _normalFontSize;
        cell.selectedFontColor = _selectedFontColor;
        cell.selectedFontSize = _selectedFontSize;
        cell.title = _menuTitles[(NSUInteger) indexPath.item];

        cell.selected = _currentIndex == indexPath.item;

        /*
         * 默认点击
         */
        if ([collectionView indexPathsForSelectedItems].count <= 0) {
            _currentIndex = -1;
            [self selectItemAtIndex:0];
        }

        return cell;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuTitles.count;
}



#pragma mark - Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectItemAtIndex:indexPath.item];
}




#pragma mark - Action
/**
 * 选中某个菜单标签做出的反应
 * @param index
 */
- (void)selectItemAtIndex:(int)index {
    if (_currentIndex == index) {
        return;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];

    /*
     * 默认选中时
     */
    BOOL animated = _currentIndex != -1;

    _currentIndex = index;

    [_menuCollectionView selectItemAtIndexPath:indexPath
                                      animated:animated
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self resizeLineViewWithIndexPath:indexPath animated:animated];
}


/**
 * 处理标示线
 * @param indexPath
 */
- (void)resizeLineViewWithIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    CGRect frame;
    JJMenuItemCell *cell = (JJMenuItemCell *) [_menuCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        UICollectionViewLayoutAttributes *attributes = [_menuCollectionView layoutAttributesForItemAtIndexPath:indexPath];
        frame = attributes.frame;
    } else {
        frame = cell.frame;
    }
    CGRect rect = CGRectMake(CGRectGetMinX(frame)+ _minMenuItemSpace / 2, kMenuHeight - kLineHeight - 2, CGRectGetWidth(frame) - _minMenuItemSpace, kLineHeight);

    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _lineView.frame = rect;
                         }];
    } else {
        _lineView.frame = rect;
    }
}




- (void)setMenuTitles:(NSArray *)menuTitles {
    _menuTitles = menuTitles;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat totalWidth = 0;
    for (NSString *menuTitle in menuTitles) {
        totalWidth = totalWidth + [menuTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_selectedFontSize]}].width;
    }
    if ((totalWidth + _minMenuItemSpace * _menuTitles.count) < screenWidth) {
        _minMenuItemSpace = (screenWidth - totalWidth) / _menuTitles.count;
    }
}


@end
