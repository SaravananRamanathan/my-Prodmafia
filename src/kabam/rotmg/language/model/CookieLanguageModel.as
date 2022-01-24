package kabam.rotmg.language.model {
import flash.net.SharedObject;
import flash.utils.Dictionary;

public class CookieLanguageModel implements LanguageModel {

    public static const DEFAULT_LOCALE:String = "en";

    public function CookieLanguageModel() {
        this.availableLanguages = this.makeAvailableLanguages();
        super();
        try {
            this.cookie = SharedObject.getLocal("RotMG", "/");

        } catch (error:Error) {

        }
    }
    private var cookie:SharedObject;
    private var language:String;
    private var availableLanguages:Dictionary;

    public function getLanguage():String {
        var _local1:* = this.language || this.readLanguageFromCookie();
        this.language = _local1;
        return _local1;
    }

    public function setLanguage(_arg_1:String):void {
        this.language = _arg_1;
        try {
            this.cookie.data.locale = _arg_1;
            this.cookie.flush();

        } catch (error:Error) {

        }
    }

    public function getLanguageFamily():String {
        return this.getLanguage().substr(0, 2).toLowerCase();
    }

    public function getLanguageNames():Vector.<String> {
        var _local2:* = undefined;
        var _local1:Vector.<String> = new Vector.<String>();
        var _local4:int = 0;
        var _local3:* = this.availableLanguages;
        for (_local2 in this.availableLanguages) {
            _local1.push(_local2);
        }
        return _local1;
    }

    public function getLanguageCodeForName(_arg_1:String):String {
        return this.availableLanguages[_arg_1];
    }

    public function getNameForLanguageCode(_arg_1:String):String {
        var _local3:* = undefined;
        var _local2:* = null;
        var _local5:int = 0;
        var _local4:* = this.availableLanguages;
        for (_local3 in this.availableLanguages) {
            if (this.availableLanguages[_local3] == _arg_1) {
                _local2 = _local3;
            }
        }
        return _local2;
    }

    private function readLanguageFromCookie():String {
        return "en";
    }

    private function makeAvailableLanguages():Dictionary {
        var _local1:Dictionary = new Dictionary();
        _local1["Languages.English"] = "en";
        _local1["Languages.French"] = "fr";
        _local1["Languages.Spanish"] = "es";
        _local1["Languages.Italian"] = "it";
        _local1["Languages.German"] = "de";
        _local1["Languages.Turkish"] = "tr";
        _local1["Languages.Russian"] = "ru";
        return _local1;
    }
}
}
