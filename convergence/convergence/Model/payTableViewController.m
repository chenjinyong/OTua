//
//  payTableViewController.m
//  convergence
//
//  Created by admin on 2017/9/12.
//  Copyright © 2017年 adminadmineducation. All rights reserved.
//

#import "payTableViewController.h"
#import "GBAlipayConfig.h"

@interface payTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalpriceLabel;//总价
@property (weak, nonatomic) IBOutlet UILabel *unitpriceLabel;//单价
- (IBAction)StepperValueChanged:(id)sender;

@property (strong,nonatomic)NSArray *arr;

@end

@implementation payTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self naviConfig];
    [self uiLayout];
    [self dataInitalize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)naviConfig{

    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"支付" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
    
}


-(void)dataInitalize{
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}


-(void)payAction{
    switch (self.tableView.indexPathForSelectedRow.row) {
        case 0:{
            NSString * tradeNo = [GBAlipayManager generateTradeNO];
            [GBAlipayManager alipayWithProductName:_Vouche.name amount:[NSString stringWithFormat:@"%ld元",(long)_Vouche.orginPrice] tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@活动报名费",_Vouche.name] itBPay:@"30"];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
            
        default:
            break;
    }
}

-(void)purchaseResultAction:(NSNotification *)note{
    NSString * result = note.object;
    if ([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜您，订购成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
        
        
    }else{
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"9000"]? @"未能支付成功，请账户余额充足": @"您已取消支付" andTitle:@"支付失败" onView:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

//设置组的名字方式
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"支付方式";
}

-(void)uiLayout{
//    _HotelnameLbl.text = _Hotel.hotel_name;

    _cardNameLabel.text = _Vouche.name;
    _nameLabel.text = _Vouche.name;
//    _unitpriceLabel.text = _Vouch.currentPrice;
    _unitpriceLabel.text = [NSString stringWithFormat:@"¥%ld元",(long)_Vouche.orginPrice];
//    _todLabel.text = [[StorageMgr singletonStorageMgr] objectForKey:@"today"];
//    _tomlabel.text = [[StorageMgr singletonStorageMgr] objectForKey:@"tomorrow"];
    //去掉多余下划线
    self.tableView.tableFooterView = [UIView new];
    //将表格试图设置为“编辑视图中”
    self.tableView.editing = YES;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表歌视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //遍历表格视图中所有选中状态下的细胞
    for (NSIndexPath * eachIP in tableView.indexPathsForSelectedRows) {
        //当选中的细胞不是当前正在按的这个细胞的情况下
        if (eachIP != indexPath) {
            //将细胞从选中状态下改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
            
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _arr[indexPath.row];
    
    return cell;
}

#pragma mark - Table view data source


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)StepperValueChanged:(id)sender {
    UIStepper *st = (UIStepper *)sender;
    NSLog(@"%f",st.value);
    _numberLabel.text = [NSString stringWithFormat:@"%0.f",st.value];
    _totalpriceLabel.text = [NSString stringWithFormat:@"%ld元",[_numberLabel.text integerValue] * [_unitpriceLabel.text integerValue]];
}
@end
