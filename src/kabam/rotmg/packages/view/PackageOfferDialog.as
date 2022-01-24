package kabam.rotmg.packages.view {
import com.company.assembleegameclient.ui.DeprecatedTextButton;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLRequest;

import kabam.display.Loader.LoaderProxy;
import kabam.display.Loader.LoaderProxyConcrete;
import kabam.lib.resizing.view.Resizable;
import kabam.rotmg.packages.model.PackageInfo;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;

public class PackageOfferDialog extends Sprite implements Resizable {


    internal const paddingTop:Number = 6;

    internal const paddingRight:Number = 6;

    internal const paddingBottom:Number = 16;

    internal const fontSize:int = 27;

    private const busyIndicator:DisplayObject = makeBusyIndicator();

    private const buyNow:Sprite = makeBuyNow();

    private const title:TextFieldDisplayConcrete = makeTitle();

    private const closeButton:DialogCloseButton = makeCloseButton();

    public function PackageOfferDialog() {
        ready = new Signal();
        buy = new Signal();
        close = new Signal();
        loader = new LoaderProxyConcrete();
        goldDisplay = new GoldDisplay();
        spaceAvailable = new Rectangle();
        super();
    }
    public var ready:Signal;
    public var buy:Signal;
    public var close:Signal;
    internal var loader:LoaderProxy;
    internal var goldDisplay:GoldDisplay;
    internal var image:DisplayObject;
    private var packageInfo:PackageInfo;
    private var spaceAvailable:Rectangle;

    public function setPackage(_arg_1:PackageInfo):PackageOfferDialog {
        removeChild(this.busyIndicator);
        this.packageInfo = _arg_1;
        return this;
    }

    public function getPackage():PackageInfo {
        return this.packageInfo;
    }

    public function destroy():void {
        this.loader.unload();
    }

    public function resize(_arg_1:Rectangle):void {
        this.spaceAvailable = _arg_1;
        this.center();
    }

    private function makeBusyIndicator():DisplayObject {
        var _local1:DisplayObject = new BusyIndicator();
        addChild(_local1);
        return _local1;
    }

    private function makeCloseButton():DialogCloseButton {
        return new DialogCloseButton();
    }

    private function makeBuyNow():DeprecatedTextButton {
        return new DeprecatedTextButton(16, "PackageOfferDialog.buyNow");
    }

    private function makeTitle():TextFieldDisplayConcrete {
        var _local1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(27).setColor(0xb3b3b3);
        _local1.y = 11;
        _local1.setAutoSize("center");
        return _local1;
    }

    private function setImageURL(_arg_1:String):void {
        this.loader && this.loader.unload();
        this.loader.contentLoaderInfo.addEventListener("ioError", this.onIOError);
        this.loader.contentLoaderInfo.addEventListener("complete", this.onComplete);
        this.loader.load(new URLRequest(_arg_1));
    }

    private function populateDialog(_arg_1:DisplayObject):void {
        this.setImage(_arg_1);
        addChild(this.title);
        this.handleCloseButton();
        this.handleBuyNow();
        this.handleGold();
    }

    private function removeListeners():void {
        this.loader.contentLoaderInfo.removeEventListener("ioError", this.onIOError);
        this.loader.contentLoaderInfo.removeEventListener("complete", this.onComplete);
    }

    private function handleGold():void {
        this.goldDisplay.init();
        addChild(this.goldDisplay);
        this.goldDisplay.x = this.buyNow.x - 16;
        this.goldDisplay.y = this.buyNow.y + this.buyNow.height / 2;
    }

    private function handleBuyNow():void {
        addChild(this.buyNow);
        this.buyNow.x = this.image.width / 2 - this.buyNow.width / 2;
        this.buyNow.y = this.image.height - this.buyNow.height - 16 - 4;
        this.buyNow.addEventListener("mouseUp", this.onBuyNow);
    }

    private function handleCloseButton():void {
        addChild(this.closeButton);
        this.closeButton.x = this.image.width - this.closeButton.width * 2 - 6;
        this.closeButton.y = 11;
        this.closeButton.addEventListener("mouseUp", this.onMouseUp);
    }

    private function setImage(_arg_1:DisplayObject):void {
        this.image && removeChild(this.image);
        this.image = _arg_1;
        this.image && addChild(this.image);
        this.center();
    }

    private function center():void {
        x = (this.spaceAvailable.width - width) / 2;
        y = (this.spaceAvailable.height - height) / 2;
    }

    private function setTitle(_arg_1:String):void {
        this.title.setStringBuilder(new StaticStringBuilder(_arg_1));
        this.title.x = this.image.width / 2;
    }

    private function setGold(_arg_1:int):void {
        this.goldDisplay.setGold(_arg_1);
    }

    private function onMouseUp(_arg_1:MouseEvent):void {
        this.closeButton.disabled = true;
        this.closeButton.removeEventListener("mouseUp", this.onMouseUp);
        this.close.dispatch();
    }

    private function onIOError(_arg_1:IOErrorEvent):void {
        this.removeListeners();
        this.populateDialog(new PackageBackground());
        this.ready.dispatch();
    }

    private function onComplete(_arg_1:Event):void {
        this.removeListeners();
        this.populateDialog(this.loader);
        this.ready.dispatch();
    }

    private function onBuyNow(_arg_1:Event):void {
        this.buyNow.removeEventListener("mouseUp", this.onBuyNow);
        this.buy.dispatch();
    }
}
}
