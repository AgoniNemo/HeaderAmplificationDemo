//
//  ConstantDefinition.h
//  CQ_App
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#ifndef ConstantDefinition_h
#define ConstantDefinition_h


#pragma mark - ——————— 数据库相关 ————————

CG_INLINE NSString *OWNER(NSString *a,NSString *b) {
    return [NSString stringWithFormat:@"owner = '%@' AND %@ ",b,a];
}

#pragma mark - ——————— 支付、FireBase相关 ————————


#if DevelopMent ==0
/*********正式环境*********/
#define FIREBASEFILENAME @"GoogleService-Info"

#elif DevelopMent ==1
/*********开发环境*********/
#define FIREBASEFILENAME @"GoogleService-Info_dev"

#else
/*********测试环境*********/
#define FIREBASEFILENAME @"GoogleService-Info_dev"

#endif


#pragma mark - ——————— 字体与颜色相关 ————————

CG_INLINE UIFont *FONTSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:a];
}
CG_INLINE UIFont *FONTBOLDSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:a];
}


//品牌色
CG_INLINE UIColor * BRANDCOLOR() {
    return RGBACOLOR(0, 212, 231, 1.0);
}
//辅助色
CG_INLINE UIColor * AUXILIARYCOLOR() {
    return RGBACOLOR(199, 164, 104, 1.0);
}
//辅助色2
CG_INLINE UIColor * AUXILIARYCOLOR2() {
    return RGBACOLOR(250, 244, 235, 1.0);
}
//成功色
CG_INLINE UIColor * SUCCESSCOLOR() {
    return HEXCOLOR(0x4CD964);
}
//警告色
CG_INLINE UIColor * WARNINGCOLOR() {
    return RGBACOLOR(230, 47, 92, 1.0);
}

CG_INLINE UIColor * SHADOWCOLOR() {
    return RGBACOLOR(0, 26, 37, 0.2);
}
// 黑色 COLOR222222
CG_INLINE UIColor * MAINCOLOR() {
    return RGBACOLOR(34, 34, 34, 1.0);
}
// 白色
CG_INLINE UIColor * COLORFFFFFF() {
    return [UIColor whiteColor];
}
// 灰色1
CG_INLINE UIColor * COLOR555555() {
    return RGBACOLOR(85, 85, 85, 1.0);
}
// 灰色2 COLOR888888
CG_INLINE UIColor * GRAYCOLOR() {
    return RGBACOLOR(136, 136, 136, 1.0);
}
//灰色2
CG_INLINE UIColor * COLOR888888() {
    return RGBACOLOR(136, 136, 136, 1.0);
}
// 灰色3
CG_INLINE UIColor * COLORCCCCCC() {
    return RGBACOLOR(204, 204, 204, 1.0);
}
//灰色4 分割线颜色
CG_INLINE UIColor * COLOREDEDED() {
    return RGBACOLOR(237, 237, 237, 1.0);
}
//键盘灰色
CG_INLINE UIColor * COLORF5F5F5() {
    return HEXCOLOR(0xF5F5F5);
}
//灰色5
CG_INLINE UIColor * COLORF9F9F9() {
    return RGBACOLOR(249, 249, 249, 1.0);
}
/// 肤色 #FAF4EB
CG_INLINE UIColor * COLORFAF4EB() {
    return HEXCOLOR(0xFAF4EB);
}
/// 地址选中红色
CG_INLINE UIColor *REDCOLOR(){
    return RGBCOLOR(230, 47, 92);
}
/// #F9F4EC
CG_INLINE UIColor * COLORF9F4EC() {
    return HEXCOLOR(0xF9F4EC);
}
/// 性别蓝色
CG_INLINE UIColor * COLOR0091FF() {
    return RGBACOLOR(0, 145, 255, 1.0);
}




#endif /* ConstantDefinition_h */
