//
//  ViewControllerPDF.m
//  waduoduo
//
//  Created by Apple  on 2019/4/22.
//  Copyright © 2019 侯彦名. All rights reserved.
//

#import "ViewControllerPDF.h"
#import "CollectionViewCell.h"//导入自定义的CollectionViewCell
#import "RiderPDFView.h"//导入展示PDF文件内容的View

@interface ViewControllerPDF()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,collectionCellDelegate>//遵守协议

{
    
    UICollectionView *testCollectionView; //展示用的CollectionView
    
    CGPDFDocumentRef _docRef; //需要获取的PDF资源文件
    
}

@property(nonatomic,strong)NSMutableArray *dataArray;//存数据的数组

@property(nonatomic,assign)int totalPage;//一共有多少页

@end

@implementation ViewControllerPDF

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _docRef= test(@"http://teaching.csse.uwa.edu.au/units/CITS4401/practicals/James1_files/SPMP1.pdf");//通过test函数获取PDF文件资源，test函数的实现为我们最上面的方法，当然下面又写了一遍
    
    [self getDataArrayValue];//获取需要展示的数据
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];//UICollectionView需要在创建的时候传入一个布局参数，故在创建它之前，先创建一个布局，这里使用系统的布局就好
    
    layout.itemSize=self.view.frame.size;//设置CollectionView中每个item及集合视图中每单个元素的大小，我们每个视图使用一页来显示，所以设置为当前视图的大小
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置滑动方向为水平方向，也可以设置为竖直方向
    
    layout.minimumLineSpacing=0;//设置item之间最下行距
    
    layout.minimumInteritemSpacing=0;//设置item之间最小间距
    
    testCollectionView= [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];//创建一个集合视图，设置其大小为当前view的大小，布局为上面我们创建的布局
    
    testCollectionView.pagingEnabled=YES;//设置集合视图一页一页的翻动
    
    [testCollectionView registerClass:[CollectionViewCell class]forCellWithReuseIdentifier:@"test"];//为集合视图注册单元格
    
    testCollectionView.delegate=self;//设置代理
    
    testCollectionView.dataSource=self;//设置数据源
    
    [self.view addSubview:testCollectionView];//将集合视图添加到当前视图上
    
}


//通过地址字符串获取PDF资源

CGPDFDocumentRef   test(NSString*urlString) {
    
    NSURL*url = [NSURL URLWithString:urlString];//将传入的字符串转化为一个NSURL地址
    
    CFURLRef refURL = (__bridge_retained CFURLRef)url;//将的到的NSURL转化为CFURLRefrefURL备用
    
    CGPDFDocumentRef document =CGPDFDocumentCreateWithURL(refURL);//通过CFURLRefrefURL获取文件内容
    
    CFRelease(refURL);//过河拆桥，释放使用完毕的CFURLRefrefURL，这个东西并不接受自动内存管理，所以要手动释放
    
    if(document) {
        
        return  document;//返回获取到的数据
        
    }else{
        
        return   NULL; //如果没获取到数据，则返回NULL，当然，你可以在这里添加一些打印日志，方便你发现问题
        
    }
}
//获取所有需要显示的PDF页面

- (void)getDataArrayValue {
    
    size_t totalPages =CGPDFDocumentGetNumberOfPages(_docRef);//获取总页数
    
    self.totalPage= (int)totalPages;//给全局变量赋值
    
    NSMutableArray*arr = [NSMutableArray new];
    
    //通过循环创建需要显示的PDF页面，并把这些页面添加到数组中
    
    for(int i =1; i <= totalPages; i++) {
        
        RiderPDFView *view = [[RiderPDFView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height) documentRef: _docRef andPageNum:i];
        
        [arr addObject:view];
        
    }
    
    self.dataArray= arr;//给数据数组赋值
    
}

//返回集合视图共有几个分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    
    return 1;
    
}

//返回集合视图中一共有多少个元素——自然是总页数

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalPage;
    
}

//复用、返回cell

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    CollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"test"forIndexPath:indexPath];
    
    cell.cellTapDelegate=self;//设置tap事件代理
    
    cell.showView=self.dataArray[indexPath.row];//赋值，设置每个item中显示的内容
    
    return cell;
    
}

//当集合视图的item被点击后触发的事件，根据个人需求写

- (void)collectioncellTaped:(CollectionViewCell*)cell {
    
    NSLog(@"我点了咋的？");
    
}

//集合视图继承自scrollView，所以可以用scrollView 的代理事件，这里的功能是当某个item不在当前视图中显示的时候，将它的缩放比例还原

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    
    for(UIView *view in testCollectionView.subviews) {
        
        if([view isKindOfClass:[CollectionViewCell class]]) {
            
            CollectionViewCell*cell = (CollectionViewCell*)view;
            
            [cell.contentScrollView setZoomScale:1.0];
            
        }
        
    }
    
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
