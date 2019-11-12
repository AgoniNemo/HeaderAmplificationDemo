//
//  ConstantDefinition.h
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#ifndef ConstantDefinition_h
#define ConstantDefinition_h

#pragma mark - ——————— 字体与颜色相关 ————————

CG_INLINE UIFont *FONTSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:a];
}
CG_INLINE UIFont *FONTBOLDSIZE(CGFloat a) {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:a];
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
