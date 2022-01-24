package kabam.rotmg.game.view {
import com.company.assembleegameclient.map.AbstractMap;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.greensock.TweenMax;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;
import io.decagames.rotmg.ui.texture.TextureParser;

public class RealmQuestsDisplay extends Sprite {

    public static const NUMBER_OF_QUESTS:int = 3;


    private const CONTENT_ALPHA:Number = 0.7;

    private const QUEST_DESCRIPTION:String = "Free %s from Oryx\'s Minions!";

    private const REQUIREMENT_TEXT_01:String = "Reach <font color=\'#00FF00\'><b>Level 20</b></font> and become stronger.";

    private const REQUIREMENT_TEXT_02:String = "Defeat <font color=\'#00FF00\'><b>%d remaining</b></font> Heroes of Oryx.";

    private const REQUIREMENT_TEXT_03:String = "Defeat <font color=\'#00FF00\'><b>Oryx the Mad God</b></font> in his Castle.";

    private const REQUIREMENTS_TEXTS:Vector.<String> = new <String>["Reach <font color=\'#00FF00\'><b>Level 20</b></font> and become stronger.", "Defeat <font color=\'#00FF00\'><b>%d remaining</b></font> Heroes of Oryx.", "Defeat <font color=\'#00FF00\'><b>Oryx the Mad God</b></font> in his Castle."];

    public function RealmQuestsDisplay(_arg_1:AbstractMap) {
        super();
        this.tabChildren = false;
        this._map = _arg_1;
    }
    private var _realmLabel:UILabel;
    private var _isOpen:Boolean;
    private var _content:Sprite;
    private var _buttonContainer:Sprite;
    private var _buttonContainerGraphics:Graphics;
    private var _buttonDiamondContainer:Sprite;
    private var _buttonNameContainer:Sprite;
    private var _buttonContent:Sprite;
    private var _arrow:Bitmap;
    private var _realmQuestDiamonds:Vector.<Bitmap>;
    private var _realmQuestItems:Vector.<RealmQuestItem>;
    private var _map:AbstractMap;
    private var _currentQuestHero:String;

    public var _realmName:String;

    public function set realmName(_arg_1:String):void {
        this._realmName = _arg_1;
        this._realmLabel.text = this._realmName;
        this.setHitArea(this._buttonNameContainer);
        this.createQuestDescription();
    }

    private var _requirementsStates:Vector.<Boolean>;

    public function get requirementsStates():Vector.<Boolean> {
        return this._requirementsStates;
    }

    public function set requirementsStates(_arg_1:Vector.<Boolean>):void {
        this._requirementsStates = _arg_1;
    }

    public function set level(_arg_1:int):void {
        var _local2:RealmQuestItem = this._realmQuestItems[0];
        var _local3:* = _arg_1 == 20;
        this._requirementsStates[0] = _local3;
        if (_local3) {
            this.completeRealmQuestItem(_local2);
        } else {
            _local2.updateItemState(false);
        }
        this.updateDiamonds();
    }

    public function set remainingHeroes(_arg_1:int):void {
        var _local2:RealmQuestItem = this._realmQuestItems[1];
        _local2.updateItemText("Defeat <font color=\'#00FF00\'><b>%d remaining</b></font> Heroes of Oryx.".replace("%d", _arg_1));
        var _local3:* = _arg_1 == 0;
        this._requirementsStates[1] = _local3;
        if (_local3) {
            this.completeRealmQuestItem(_local2);
        } else {
            _local2.updateItemState(false);
        }
        this.updateDiamonds();
    }

    public function toggleOpenState():void {
        this._isOpen = !this._isOpen;
        this.alphaTweenContent(0.7);
        this._arrow.scaleY = !this._isOpen ? -1 : 1;
        this._arrow.y = !this._isOpen ? this._arrow.height + 2 : 3;
        this._buttonDiamondContainer.visible = !this._isOpen;
        this._buttonNameContainer.visible = this._isOpen;
        this._buttonContent.visible = this._isOpen;
        Parameters.data.expandRealmQuestsDisplay = this._isOpen;
    }

    public function init():void {
        var _local1:GameObject = this._map.quest_.getObject(getTimer());
        if (_local1) {
            this._currentQuestHero = this._map.quest_.getObject(getTimer()).name_;
        }
        this.createContainers();
        this.createArrow();
        this.createRealmLabel();
        this.createDiamonds();
        this.createRealmQuestItems();
        this.toggleOpenState();
        if (Parameters.data.expandRealmQuestsDisplay) {
            this.toggleOpenState();
        }
    }

    public function setOryxCompleted():void {
        this._requirementsStates[2] = true;
        var _local1:RealmQuestItem = this._realmQuestItems[2];
        this.completeRealmQuestItem(_local1);
        this.updateDiamonds();
    }

    private function createContainers():void {
        this._content = new Sprite();
        this._content.alpha = 0.7;
        this._content.addEventListener("rollOver", this.onRollOver);
        this._content.addEventListener("rollOut", this.onRollOut);
        addEventListener("mouseUp", this.onMouseUp);
        addEventListener("mouseDown", this.onMouseDown);
        addChild(this._content);
        this._buttonContainer = new Sprite();
        this._buttonContainerGraphics = this._buttonContainer.graphics;
        this._buttonContainer.buttonMode = true;
        this._buttonContainer.addEventListener("click", this.onMouseClick);
        this._content.addChild(this._buttonContainer);
        this._buttonDiamondContainer = new Sprite();
        this._buttonDiamondContainer.mouseEnabled = false;
        this._buttonContainer.addChild(this._buttonDiamondContainer);
        this._buttonNameContainer = new Sprite();
        this._buttonNameContainer.mouseEnabled = false;
        this._buttonNameContainer.visible = this._isOpen;
        this._buttonContainer.addChild(this._buttonNameContainer);
        this._buttonContent = new Sprite();
        this._buttonContent.mouseEnabled = false;
        this._buttonContent.mouseChildren = false;
        this._buttonContent.visible = this._isOpen;
        this._content.addChild(this._buttonContent);
        this._realmQuestDiamonds = new Vector.<Bitmap>(0);
    }

    private function createArrow():void {
        this._arrow = TextureParser.instance.getTexture("UI", "spinner_up_arrow");
        this._buttonContainer.addChild(this._arrow);
    }

    private function createRealmLabel():void {
        this._realmLabel = new UILabel();
        DefaultLabelFormat.createLabelFormat(this._realmLabel, 16, 0xffffff, "left", true);
        this._realmLabel.x = 20;
        this._realmLabel.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this._buttonNameContainer.addChild(this._realmLabel);
    }

    private function createDiamonds():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:int = 0;
        while (_local3 < 3) {
            _local2 = !this._requirementsStates[_local3] ? "checkbox_empty" : "checkbox_filled";
            _local1 = TextureParser.instance.getTexture("UI", _local2);
            _local1.x = _local3 * (_local1.width + 5) + this._arrow.width + 5;
            this._buttonDiamondContainer.addChild(_local1);
            this.setHitArea(this._buttonContainer);
            this._realmQuestDiamonds.push(_local1);
            _local3++;
        }
    }

    private function disposeDiamonds():void {
        var _local2:* = null;
        var _local1:int = 2;
        while (_local1 >= 0) {
            _local2 = this._realmQuestDiamonds.pop();
            _local2.bitmapData.dispose();
            this._buttonDiamondContainer.removeChild(_local2);
            _local2 = null;
            _local1--;
        }
    }

    private function createRealmQuestItems():void {
        var _local1:* = null;
        var _local2:int = 0;
        var _local3:int = 28;
        this._realmQuestItems = new Vector.<RealmQuestItem>(0);
        while (_local2 < 3) {
            _local1 = new RealmQuestItem(this.REQUIREMENTS_TEXTS[_local2], this._requirementsStates[_local2]);
            _local1.updateItemState(false);
            _local1.x = 20;
            _local1.y = _local3 + 5;
            _local3 = _local1.y + _local1.height;
            this._buttonContent.addChild(_local1);
            this._realmQuestItems.push(_local1);
            _local2++;
        }
    }

    private function createQuestDescription():void {
        var _local1:UILabel = new UILabel();
        _local1.x = 20;
        _local1.y = 15;
        _local1.text = "Free %s from Oryx\'s Minions!".replace("%s", this._realmName);
        DefaultLabelFormat.createLabelFormat(_local1, 12, 0xffcc00);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this._buttonContent.addChild(_local1);
    }

    private function alphaTweenContent(_arg_1:Number):void {
        if (TweenMax.isTweening(this._content)) {
            TweenMax.killTweensOf(this._content);
        }
        TweenMax.to(this._content, 0.3, {"alpha": _arg_1});
    }

    private function setHitArea(_arg_1:Sprite):void {
        var _local2:Sprite = new Sprite();
        _local2.graphics.clear();
        _local2.graphics.beginFill(0xffcc00, 0);
        _local2.graphics.drawRect(0, 0, _arg_1.width, _arg_1.height);
        _arg_1.addChild(_local2);
    }

    private function updateDiamonds():void {
        this.disposeDiamonds();
        this.createDiamonds();
    }

    private function completeRealmQuestItem(_arg_1:RealmQuestItem):void {
        _arg_1.updateItemState(true);
        _arg_1.updateItemText("<font color=\'#a8a8a8\'>" + _arg_1.label.text + "</font>");
    }

    private function onMouseClick(_arg_1:MouseEvent):void {
        this.toggleOpenState();
    }

    private function onRollOver(_arg_1:MouseEvent):void {
        if (TweenMax.isTweening(this._content)) {
            TweenMax.killTweensOf(this._content);
        }
        TweenMax.to(this._content, 0.3, {"alpha": 1});
    }

    private function onRollOut(_arg_1:MouseEvent):void {
        this.alphaTweenContent(0.7);
    }

    private function onMouseUp(_arg_1:MouseEvent):void {
        this._map.mapHitArea.dispatchEvent(_arg_1);
    }

    private function onMouseDown(_arg_1:MouseEvent):void {
        this._map.mapHitArea.dispatchEvent(_arg_1);
    }
}
}
