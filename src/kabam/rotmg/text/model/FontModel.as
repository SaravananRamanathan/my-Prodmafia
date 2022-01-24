package kabam.rotmg.text.model {
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;

public class FontModel {

    public static const MyriadPro:Class = FontModel_MyriadPro;

    public static const MyriadPro_Bold:Class = FontModel_MyriadPro_Bold;

    public static var DEFAULT_FONT_NAME:String = "";

    public function FontModel() {
        super();
        Font.registerFont(MyriadPro);
        Font.registerFont(MyriadPro_Bold);
        var _local1:Font = new MyriadPro();
        DEFAULT_FONT_NAME = _local1.fontName;
        this.fontInfo = new FontInfo();
        this.fontInfo.setName(_local1.fontName);
    }
    private var fontInfo:FontInfo;

    public function getFont():FontInfo {
        return this.fontInfo;
    }

    public function apply(_arg_1:TextField, _arg_2:int, _arg_3:uint, _arg_4:Boolean, _arg_5:Boolean = false):TextFormat {
        var _local6:TextFormat = _arg_1.defaultTextFormat;
        _local6.size = _arg_2;
        _local6.color = _arg_3;
        _local6.font = this.getFont().getName();
        _local6.bold = _arg_4;
        if (_arg_5) {
            _local6.align = "center";
        }
        _arg_1.defaultTextFormat = _local6;
        _arg_1.setTextFormat(_local6);
        return _local6;
    }

    public function getFormat(_arg_1:TextField, _arg_2:int, _arg_3:uint, _arg_4:Boolean):TextFormat {
        var _local5:TextFormat = _arg_1.defaultTextFormat;
        _local5.size = _arg_2;
        _local5.color = _arg_3;
        _local5.font = this.getFont().getName();
        _local5.bold = _arg_4;
        return _local5;
    }
}
}
