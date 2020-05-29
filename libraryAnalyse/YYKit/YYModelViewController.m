//
//  YYModelViewController.m
//  libraryAnalyse
//
//  Created by deltalpha on 2020/5/29.
//  Copyright © 2020 52body. All rights reserved.
//

#import "YYModelViewController.h"
#import <YYKit/NSObject+YYModel.h>
// =================== Model与JSON相互转换  ===================
@interface YYUser : NSObject
@property (nonatomic, assign) UInt64 uid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSDate * created;
@end
@implementation YYUser
@end
// ===================  Model属性名和JSON中的Key不相同  ===================
@interface YYBook : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * bookID;
@end
@implementation YYBook
+(NSDictionary *)modelCustomPropertyMapper{
    NSLog(@"test ==== ");
    return @{@"name": @"n",@"page": @"p", @"desc": @"ext.desc", @"bookID" : @[@"id", @"ID", @"book_id"]};
}
@end
// ===================  Model中包含其他model  ===================
@interface modelInModel : NSObject
@property(nonatomic, copy) NSString* name;
@property(nonatomic, assign) NSUInteger pages;
@property(nonatomic, strong) YYUser * author;
@end
@implementation modelInModel
@end
// ===================  容器类属性  ===================
@interface YYPhoto : NSObject
@property(nonatomic, copy)NSString* url;
@property(nonatomic, copy)NSString* desc;
@end
@implementation YYPhoto
@end
@interface YYAlbum : NSObject
@property(nonatomic, copy)NSString* name;
@property(nonatomic, strong)NSArray* photos;// Array<YYPhoto>
@property(nonatomic, strong)NSDictionary * likedUsers; // Key:name(NSString) Value:user(YYUser)
@property(nonatomic, strong)NSSet* likedUserIds; // Set<NSNumber>
@end
@implementation YYAlbum
+(NSDictionary*)modelContainerPropertyGenericClass{
    return @{@"photos": YYPhoto.class, @"likedUsers": YYUser.class, @"likedUserIds": NSNumber.class};
}
@end
// ===================  黑白名单  ===================
@interface whiteBlack : NSObject
@property(nonatomic, copy)NSString * name;
@property(nonatomic, assign)NSUInteger age;
@property(nonatomic, assign)BOOL sex;
@end
@implementation whiteBlack
// 如果实现了该方法，则只会处理下面列表中的属性， 白名单拥有更高的执行权限
+(NSArray *)modelPropertyWhitelist
{
    return @[@"name"];
}
// 如果实现了该方法，则处理过程中忽略该列表内的所有属性
+(NSArray*)modelPropertyBlacklist{
    return @[@"age"];
}
@end
// ===================  自定义校验和自定义转换  ===================
@interface YYMessage : NSObject
@property(nonatomic, assign) uint64_t messageId;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong)NSDate * time;
@end
@implementation YYMessage
// 属性与key不一致
+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"messageId": @"i", @"content": @"c", @"time": @"t"};
}
// 当Model转化为JSON完成后，调用该方法
// 可以在此对数据进行校验，如果校验不通过返回NO， 则该model会被忽略
// 当然可以在此完成一些自动转换完成不理的工作
-(BOOL)modelCustomTransformFromDictionary:(NSMutableDictionary *)dic{
    uint64_t timestamp = [dic unsignedLongLongValueForKey:@"t" default:0];
    self.time = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    return YES;
}
@end
@interface YYModelViewController ()

@end

@implementation YYModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * dataArray = [self readLocalFile];
//    [self model_yykit_json:dataArray[0]];
//    
//    [self model_key_difference:dataArray[1]];
    
//    [self model_in_model:dataArray[2]];
    
//    [self model_in_container:dataArray[3]];
//    [self model_black_white:dataArray[4]];
    [self model_custom_mapper:dataArray[5]];
    // Do any additional setup after loading the view.
}
#pragma Model与JSON相互转换
-(void)model_yykit_json:(NSDictionary *)json{
    // 将json转换为model
    YYUser * user = [YYUser modelWithJSON:json];
    NSLog(@"name === %@,uid === %llu,created === %@", user.name, user.uid, user.created);
    // 将model转换为json或者json字符串
    NSLog(@"\n转换为json ==== %@\n转换为json字符串 === %@", [user modelToJSONObject], [user modelToJSONString]);
}
#pragma Model属性名和JSON中的Key不相同  此处需要研究一下
-(void)model_key_difference:(NSDictionary *)json{
    YYBook * book = [YYBook modelWithJSON:json];
    NSLog(@"%@===%@", [book modelToJSONObject], book.desc);
}
#pragma Model包含其他的Model
-(void)model_in_model:(NSDictionary *)json{
    modelInModel * model = [modelInModel modelWithJSON:json];
    NSLog(@"%@ === %@", [model modelToJSONObject], model.author.name);
}
#pragma 容器类属性
-(void)model_in_container:(NSDictionary *)json{
    YYAlbum * album = [YYAlbum modelWithJSON:json];
    NSLog(@"%@", [album modelToJSONObject]);
}
#pragma 黑名单与白名单
-(void)model_black_white:(NSDictionary *)json{
    whiteBlack * model = [whiteBlack modelWithJSON:json];
    NSLog(@"%@", [model modelToJSONObject]);
}
#pragma 自定义转换
-(void)model_custom_mapper:(NSDictionary *)json{
    YYMessage * message = [YYMessage modelWithJSON:json];
    NSLog(@"%@", [message modelToJSONObject]);
}
- (NSArray *)readLocalFile
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"yykit" ofType:@"json"];
    NSData * data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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
