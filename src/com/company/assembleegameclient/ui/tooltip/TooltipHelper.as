package com.company.assembleegameclient.ui.tooltip {
public class TooltipHelper {
    public static const BETTER_COLOR:uint = 65280;
    public static const WORSE_COLOR:uint = 16711680;
    public static const NO_DIFF_COLOR:uint = 16777103;
    public static const NO_DIFF_COLOR_INACTIVE:uint = 6842444;
    public static const WIS_BONUS_COLOR:uint = 4219875;
    public static const UNTIERED_COLOR:uint = 9055202;
    public static const SET_COLOR:uint = 16750848;
    public static const SET_COLOR_INACTIVE:uint = 6835752;

    public function TooltipHelper() {
        super();
    }

    public static function wrapInFontTag(text:String, colorCode:String) : String {
        return "<font color=\"" + colorCode + "\">" + text + "</font>";
    }

    public static function getOpenTag(colorCode:uint) : String {
        return "<font color=\"#" + colorCode.toString(16) + "\">";
    }

    public static function getCloseTag() : String {
        return "</font>";
    }

    public static function compareAndGetPlural(num1:Number, num2:Number, denominator:String,
                                               isFirst:Boolean = true, isSameEff:Boolean = true) : String {
        return wrapInFontTag(getPlural(num1, denominator),
                "#" + getTextColor(
                (isFirst ? num1 - num2 : num2 - num1) * int(isSameEff)).toString(16));
    }

    public static function compare(num1:Number, num2:Number, isFirst:Boolean = true,
                                   suffix:String = "", useAbs:Boolean = false, isSameEff:Boolean = true) : String {
        return wrapInFontTag((useAbs ? Math.abs(num1) : num1) + suffix,
                "#" + getTextColor(
                (isFirst ? num1 - num2 : num2 - num1) * int(isSameEff)).toString(16));
    }

    public static function getPlural(num:Number, denominator:String) : String {
        var modStr:String = num + " " + denominator;
        if (num != 1)
            return modStr + "s";
        return modStr;
    }

    public static function getTextColor(delta:Number) : uint {
        return delta < 0 ? 0xff0000 : delta > 0 ? 0xff00 : 0xffff8f;
    }
}
}