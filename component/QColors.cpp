#include "QColors.h"
#include "QTools.h"

QColors::QColors(QObject *parent):QObject{parent}{
    Transparent(QColor(0, 0, 0, 0));
    Black(QColor(0, 0, 0));
    White(QColor(255, 255, 255));
    Grey10(QColor(250, 249, 248));
    Grey20(QColor(243, 242, 241));
    Grey30(QColor(237, 235, 233));
    Grey40(QColor(225, 223, 221));
    Grey50(QColor(210, 208, 206));
    Grey60(QColor(200, 198, 196));
    Grey70(QColor(190, 185, 184));
    Grey80(QColor(179, 176, 173));
    Grey90(QColor(161, 159, 157));
    Grey100(QColor(151, 149, 146));
    Grey110(QColor(138, 136, 134));
    Grey120(QColor(121, 119, 117));
    Grey130(QColor(96, 94, 92));
    Grey140(QColor(72, 70, 68));
    Grey150(QColor(59, 58, 57));
    Grey160(QColor(50, 49, 48));
    Grey170(QColor(41, 40, 39));
    Grey180(QColor(37, 36, 35));
    Grey190(QColor(32, 31, 30));
    Grey200(QColor(27, 26, 25));
    Grey210(QColor(22, 21, 20));
    Grey220(QColor(17, 16, 15));


    QAccentColor *yellow = new QAccentColor(this);
    yellow->darkest(QColor(249, 168, 37));
    yellow->darker(QColor(251, 192, 45));
    yellow->dark(QColor(253, 212, 53));
    yellow->normal(QColor(255, 235, 59));
    yellow->light(QColor(255, 238, 88));
    yellow->lighter(QColor(255, 241, 118));
    yellow->lightest(QColor(255, 245, 155));
    Yellow(yellow);

    QAccentColor *orange = new QAccentColor(this);
    orange->darkest(QColor(153, 61, 7));
    orange->darker(QColor(172, 68, 8));
    orange->dark(QColor(209, 88, 10));
    orange->normal(QColor(247, 99, 12));
    orange->light(QColor(248, 122, 48));
    orange->lighter(QColor(249, 145, 84));
    orange->lightest(QColor(250, 192, 106));
    Orange(orange);

    QAccentColor *red = new QAccentColor(this);
    red->darkest(QColor(143, 10, 21));
    red->darker(QColor(162, 11, 24));
    red->dark(QColor(185, 13, 28));
    red->normal(QColor(232, 17, 35));
    red->light(QColor(236, 64, 79));
    red->lighter(QColor(238, 88, 101));
    red->lightest(QColor(240, 107, 118));
    Red(red);

    QAccentColor *magenta = new QAccentColor(this);
    magenta->darkest(QColor(111, 0, 79));
    magenta->darker(QColor(160, 7, 108));
    magenta->dark(QColor(181, 13, 125));
    magenta->normal(QColor(227, 0, 140));
    magenta->light(QColor(234, 77, 168));
    magenta->lighter(QColor(238, 110, 193));
    magenta->lightest(QColor(241, 140, 213));
    Magenta(magenta);

    QAccentColor *purple = new QAccentColor(this);
    purple->darkest(QColor(44, 15, 118));
    purple->darker(QColor(61, 15, 153));
    purple->dark(QColor(78, 17, 174));
    purple->normal(QColor(104, 33, 122));
    purple->light(QColor(123, 76, 157));
    purple->lighter(QColor(141, 110, 189));
    purple->lightest(QColor(158, 142, 217));
    Purple(purple);

    QAccentColor *blue = new QAccentColor(this);
    blue->darkest(QColor(0, 74, 131));
    blue->darker(QColor(0, 84, 148));
    blue->dark(QColor(0, 102, 180));
    blue->normal(QColor(0, 120, 212));
    blue->light(QColor(38, 140, 220));
    blue->lighter(QColor(76, 160, 224));
    blue->lightest(QColor(96, 171, 228));
    Blue(blue);

    QAccentColor *teal = new QAccentColor(this);
    teal->darkest(QColor(0, 110, 91));
    teal->darker(QColor(0, 124, 103));
    teal->dark(QColor(0, 151, 125));
    teal->normal(QColor(0, 178, 148));
    teal->light(QColor(38, 189, 164));
    teal->lighter(QColor(77, 201, 180));
    teal->lightest(QColor(96, 207, 188));
    Teal(teal);

    QAccentColor *green = new QAccentColor(this);
    green->darkest(QColor(9, 76, 9));
    green->darker(QColor(12, 93, 12));
    green->dark(QColor(14, 111, 14));
    green->normal(QColor(16, 124, 16));
    green->light(QColor(39, 137, 57));
    green->lighter(QColor(76, 156, 76));
    green->lightest(QColor(106, 173, 106));
    Green(green);
}

QAccentColor* QColors::createAccentColor(QColor primaryColor){
    QAccentColor *accentColor = new QAccentColor(this);
    accentColor->darkest(QTools::getInstance()->withOpacity(primaryColor,0.7));
    accentColor->darker(QTools::getInstance()->withOpacity(primaryColor,0.8));
    accentColor->dark(QTools::getInstance()->withOpacity(primaryColor,0.9));
    accentColor->normal(primaryColor);
    accentColor->light(QTools::getInstance()->withOpacity(primaryColor,0.9));
    accentColor->lighter(QTools::getInstance()->withOpacity(primaryColor,0.8));
    accentColor->lightest(QTools::getInstance()->withOpacity(primaryColor,0.7));
    return accentColor;
}
