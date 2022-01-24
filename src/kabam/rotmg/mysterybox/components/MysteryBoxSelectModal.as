package kabam.rotmg.mysterybox.components {
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.mysterybox.services.MysteryBoxModel;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.pets.view.components.PopupWindowBackground;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.swiftsuspenders.Injector;

public class MysteryBoxSelectModal extends Sprite {

    public static const TEXT_MARGIN:int = 20;

    public static var modalWidth:int;

    public static var modalHeight:int;

    public static var aMysteryBoxHeight:int;

    public static var open:Boolean;

    public static var backgroundImageEmbed:Class = MysteryBoxSelectModal_backgroundImageEmbed;

    public static function getRightBorderX():int {
        return 5 * 60 + modalWidth / 2;
    }

    private static function makeModalBackground(_arg_1:int, _arg_2:int):PopupWindowBackground {
        var _local3:PopupWindowBackground = new PopupWindowBackground();
        _local3.draw(_arg_1, _arg_2, 1);
        return _local3;
    }

    public function MysteryBoxSelectModal() {
        box_ = new Sprite();
        super();
        modalWidth = 385;
        modalHeight = 60;
        aMysteryBoxHeight = 77;
        this.selectEntries = new Vector.<MysteryBoxSelectEntry>();
        var _local1:Injector = StaticInjectorContext.getInjector();
        var _local2:MysteryBoxModel = _local1.getInstance(MysteryBoxModel);
        this.mysteryData = _local2.getBoxesOrderByWeight();
        addEventListener("removedFromStage", this.onRemovedFromStage);
        addChild(this.box_);
        this.addBoxChildren();
        this.positionAndStuff();
        open = true;
    }
    private var closeButton:DialogCloseButton;
    private var box_:Sprite;
    private var mysteryData:Object;
    private var titleString:String = "MysteryBoxSelectModal.titleString";
    private var selectEntries:Vector.<MysteryBoxSelectEntry>;

    public function getText(_arg_1:String, _arg_2:int, _arg_3:int):TextFieldDisplayConcrete {
        var _local4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(modalWidth - 40);
        _local4.setBold(true);
        _local4.setStringBuilder(new LineBuilder().setParams(_arg_1));
        _local4.setWordWrap(true);
        _local4.setMultiLine(true);
        _local4.setAutoSize("center");
        _local4.setHorizontalAlign("center");
        _local4.filters = [new DropShadowFilter(0, 0, 0)];
        _local4.x = _arg_2;
        _local4.y = _arg_3;
        return _local4;
    }

    public function updateContent():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.selectEntries;
        for each(_local1 in this.selectEntries) {
            _local1.updateContent();
        }
    }

    private function positionAndStuff():void {
        this.box_.x = 300 - modalWidth / 2;
        this.box_.y = WebMain.STAGE.stageHeight / 2 - modalHeight / 2;
    }

    private function addBoxChildren():void {
        var _local4:* = NaN;
        var _local3:int = 0;
        var _local6:* = null;
        var _local2:* = null;
        var _local5:* = null;
        var _local8:int = 0;
        var _local7:* = this.mysteryData;
        for each(_local6 in this.mysteryData) {
            modalHeight = modalHeight + aMysteryBoxHeight;
        }
        _local2 = new backgroundImageEmbed();
        _local2.width = modalWidth + 1;
        _local2.height = modalHeight - 25;
        _local2.y = 27;
        _local2.alpha = 0.95;
        this.box_.addChild(_local2);
        this.box_.addChild(makeModalBackground(modalWidth, modalHeight));
        this.closeButton = PetsViewAssetFactory.returnCloseButton(modalWidth);
        this.box_.addChild(this.closeButton);
        this.box_.addChild(this.getText(this.titleString, 20, 6).setSize(18));
        _local4 = 50;
        _local3 = 0;
        var _local10:int = 0;
        var _local9:* = this.mysteryData;
        for each(_local6 in this.mysteryData) {
            if (_local3 != 6) {
                _local5 = new MysteryBoxSelectEntry(_local6);
                _local5.x = x + 20;
                _local5.y = y + _local4;
                _local4 = Number(_local4 + aMysteryBoxHeight);
                this.box_.addChild(_local5);
                this.selectEntries.push(_local5);
                _local3++;
                continue;
            }
            break;
        }
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        open = false;
    }
}
}
