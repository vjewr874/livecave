//
//  CoinVeiw.h
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinVeiw : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property NSString *coin;
@property (nonatomic,strong) NSString *titleStr;;

@end
