package kabam.rotmg.mysterybox.model {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;

import kabam.display.Loader.LoaderProxy;
import kabam.display.Loader.LoaderProxyConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class MysteryBoxInfo extends GenericBoxInfo {


    public function MysteryBoxInfo() {
        _rollsWithContents = new Vector.<Vector.<int>>();
        _rollsWithContentsUnique = new Vector.<int>();
        _loader = new LoaderProxyConcrete();
        _infoImageLoader = new LoaderProxyConcrete();
        _rollsContents = new Vector.<Vector.<int>>();
        super();
    }
    public var _rollsWithContents:Vector.<Vector.<int>>;
    public var _rollsWithContentsUnique:Vector.<int>;

    public var _iconImageUrl:String;

    public function get iconImageUrl():* {
        return this._iconImageUrl;
    }

    public function set iconImageUrl(_arg_1:String):void {
        this._iconImageUrl = _arg_1;
        this.loadIconImageFromUrl(this._iconImageUrl);
    }

    private var _iconImage:DisplayObject;

    public function get iconImage():DisplayObject {
        return this._iconImage;
    }

    public var _infoImageUrl:String;

    public function get infoImageUrl():* {
        return this._infoImageUrl;
    }

    public function set infoImageUrl(_arg_1:String):void {
        this._infoImageUrl = _arg_1;
        this.loadInfomageFromUrl(this._infoImageUrl);
    }

    private var _infoImage:DisplayObject;

    public function get infoImage():DisplayObject {
        return this._infoImage;
    }

    public function set infoImage(_arg_1:DisplayObject):void {
        this._infoImage = _arg_1;
    }

    private var _loader:LoaderProxy;

    public function get loader():LoaderProxy {
        return this._loader;
    }

    public function set loader(_arg_1:LoaderProxy):void {
        this._loader = _arg_1;
    }

    private var _infoImageLoader:LoaderProxy;

    public function get infoImageLoader():LoaderProxy {
        return this._infoImageLoader;
    }

    public function set infoImageLoader(_arg_1:LoaderProxy):void {
        this._infoImageLoader = _arg_1;
    }

    private var _rollsContents:Vector.<Vector.<int>>;

    public function get rollsContents():Vector.<Vector.<int>> {
        return this._rollsContents;
    }

    private var _rolls:int;

    public function get rolls():int {
        return this._rolls;
    }

    public function set rolls(_arg_1:int):void {
        this._rolls = _arg_1;
    }

    private var _jackpots:String = "";

    public function get jackpots():String {
        return this._jackpots;
    }

    public function set jackpots(_arg_1:String):void {
        this._jackpots = _arg_1;
    }

    private var _displayedItems:String = "";

    public function get displayedItems():String {
        return this._displayedItems;
    }

    public function set displayedItems(_arg_1:String):void {
        this._displayedItems = _arg_1;
    }

    public function get currencyName():String {
        var _local1:* = _priceCurrency;
        switch (_local1) {
            case "0":
                return LineBuilder.getLocalizedStringFromKey("Currency.gold").toLowerCase();
            case "1":
                return LineBuilder.getLocalizedStringFromKey("Currency.fame").toLowerCase();
            default:
                return "";
        }
    }

    public function parseContents():void {
        var _local7:* = undefined;
        var _local1:int = 0;
        var _local3:* = null;
        var _local5:* = null;
        var _local4:* = null;
        var _local6:Array = _contents.split(";");
        var _local2:Dictionary = new Dictionary();
        var _local11:int = 0;
        var _local10:* = _local6;
        for each(_local3 in _local6) {
            _local7 = new Vector.<int>();
            _local5 = _local3.split(",");
            var _local9:int = 0;
            var _local8:* = _local5;
            for each(_local4 in _local5) {
                if (_local2[int(_local4)] == null) {
                    _local2[_local4] = true;
                    this._rollsWithContentsUnique.push(_local4);
                }
                _local7.push(_local4);
            }
            this._rollsWithContents.push(_local7);
            this._rollsContents[_local1] = _local7;
            _local1++;
        }
    }

    private function loadIconImageFromUrl(_arg_1:String):void {
        this._loader && this._loader.unload();
        this._loader.contentLoaderInfo.addEventListener("complete", this.onComplete);
        this._loader.contentLoaderInfo.addEventListener("ioError", this.onError);
        this._loader.contentLoaderInfo.addEventListener("diskError", this.onError);
        this._loader.contentLoaderInfo.addEventListener("networkError", this.onError);
        this._loader.load(new URLRequest(_arg_1));
    }

    private function loadInfomageFromUrl(_arg_1:String):void {
        this.loadImageFromUrl(_arg_1, this._infoImageLoader);
    }

    private function loadImageFromUrl(_arg_1:String, _arg_2:LoaderProxy):void {
        _arg_2 && _arg_2.unload();
        _arg_2.contentLoaderInfo.addEventListener("complete", this.onInfoComplete);
        _arg_2.contentLoaderInfo.addEventListener("ioError", this.onInfoError);
        _arg_2.contentLoaderInfo.addEventListener("diskError", this.onInfoError);
        _arg_2.contentLoaderInfo.addEventListener("networkError", this.onInfoError);
        _arg_2.load(new URLRequest(_arg_1));
    }

    private function onError(_arg_1:IOErrorEvent):void {
    }

    private function onComplete(_arg_1:Event):void {
        this._loader.contentLoaderInfo.removeEventListener("complete", this.onComplete);
        this._loader.contentLoaderInfo.removeEventListener("ioError", this.onError);
        this._loader.contentLoaderInfo.removeEventListener("diskError", this.onError);
        this._loader.contentLoaderInfo.removeEventListener("networkError", this.onError);
        this._iconImage = DisplayObject(this._loader);
    }

    private function onInfoError(_arg_1:IOErrorEvent):void {
    }

    private function onInfoComplete(_arg_1:Event):void {
        this._infoImageLoader.contentLoaderInfo.removeEventListener("complete", this.onInfoComplete);
        this._infoImageLoader.contentLoaderInfo.removeEventListener("ioError", this.onInfoError);
        this._infoImageLoader.contentLoaderInfo.removeEventListener("diskError", this.onInfoError);
        this._infoImageLoader.contentLoaderInfo.removeEventListener("networkError", this.onInfoError);
        this._infoImage = DisplayObject(this._infoImageLoader);
    }
}
}
