

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface skyCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSInteger porsection;
    UILabel *lbl;
    UIImageView *imgView;
    NSDictionary *jsonObjCell;
    NSMutableArray* dataPic;
    NSMutableArray* dataLabel;
   AppDelegate *app;
    NSDictionary *jsonObj;
}
@property (nonatomic, retain) NSMutableArray* dataArray1;
@property (nonatomic, retain) NSMutableArray* dataPic;
@property (nonatomic, retain) NSMutableArray* dataLabel;

@property(nonatomic,copy)NSString *lblHead;
@property(nonatomic,retain) NSDictionary *jsonObjCell;
@end
