

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
 
@protocol skyDelegate
@optional
-(void)translate:(NSString *)ID_Num;

@end
@interface skyCell : UITableViewCell<  UITableViewDataSource,UITableViewDelegate ,UIScrollViewDelegate>
{
    UITableView *table;
    NSInteger porsection;
    UILabel *lbl;
    UIImageView *imgView;
    NSDictionary *jsonObjCell;
    NSMutableArray* dataPic;
    NSMutableArray* dataLabel;
    AppDelegate *app;
   NSArray *jsonObj;
    id<skyDelegate>delegate;
    int i;
}
@property (nonatomic, retain) NSMutableArray* dataArray1;
@property (nonatomic, retain) NSMutableArray* dataPic;
@property (nonatomic, retain) NSMutableArray* dataLabel;

@property(nonatomic,copy)NSString *lblHead;
@property(nonatomic,retain) NSDictionary *jsonObjCell;
@property(assign,nonatomic)id<skyDelegate> delegate;
-(void)action;
@end
