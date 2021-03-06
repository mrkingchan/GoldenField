//
//  SettingVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SettingVC.h"
#import "GestureSettingVC.h"
#import "SkinVC.h"
#import "HealthVC.h"
#import "AutoLayoutVC.h"

@interface SettingVC () <TZImagePickerControllerDelegate>

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.dataArray addObject:@"手势密码"];
    [self.dataArray addObject:@"皮肤设置"];
    [self.dataArray addObject:@"健康数据管理"];
    [self.dataArray addObject:@"YogaKit"];
    [self.dataArray addObject:@"设置启动图"];
}

// MARK:  -- UITableViewDataSource&Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //手势
        [self.navigationController pushViewController:[GestureSettingVC new] animated:YES];
    } else if (indexPath.row == 1 ) {
        //皮肤
        [self.navigationController pushViewController:[SkinVC new] animated:YES];
    } else if (indexPath.row == 2) {
        //健康数据管理
        [self.navigationController pushViewController:[HealthVC new] animated:YES];
    } else if (indexPath.row == 3) {
        [self.navigationController pushViewController:[AutoLayoutVC new] animated:YES];
    } else if (indexPath.row == 4) {
        //设置动态启动图
        TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
        pickerVC.showSelectBtn = YES;
        pickerVC.showSelectedIndex = YES;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
}

// MARK: - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    if (photos.count) {
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"launchImage.png"]];
        BOOL result =[UIImagePNGRepresentation(photos.firstObject)writeToFile:filePath   atomically:YES];
        if (result == YES) {
            NSLog(@"保存成功");
        }
    }
}

// MARK: - memory management
- (void)dealloc {
    if (self.tableView) {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        self.tableView = nil;
    }
}
@end
