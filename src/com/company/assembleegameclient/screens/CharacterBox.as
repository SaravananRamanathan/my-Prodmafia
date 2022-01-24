package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.ui.tooltip.ClassToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.FullCharBoxGraphic;
import com.company.rotmg.graphics.LockedCharBoxGraphic;
import com.company.rotmg.graphics.StarGraphic;
import com.company.util.AssetLibrary;
import com.gskinner.motion.GTween;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.natives.NativeSignal;

public class CharacterBox extends Sprite {

    private static const fullCT:ColorTransform = new ColorTransform(0.8, 0.8, 0.8);

    private static const emptyCT:ColorTransform = new ColorTransform(0.2, 0.2, 0.2);

    public function CharacterBox(_arg_1:XML, _arg_2:CharacterStats, _arg_3:PlayerModel, _arg_4:Boolean = false) {
        var _local5:* = null;
        super();
        this.model = _arg_3;
        this.playerXML_ = _arg_1;
        this.charStats_ = _arg_2;
        this.available_ = _arg_4 || _arg_3.isLevelRequirementsMet(this.objectType());
        if (!this.available_) {
            this.graphic_ = new LockedCharBoxGraphic();
        } else {
            this.graphic_ = new FullCharBoxGraphic();
        }
        this.graphicContainer_ = new Sprite();
        addChild(this.graphicContainer_);
        this.graphicContainer_.addChild(this.graphic_);
        this.characterSelectClicked_ = new NativeSignal(this.graphicContainer_, "click", MouseEvent);
        this.bitmap_ = new Bitmap(null);
        this.setImage(2, 0, 0);
        this.graphic_.addChild(this.bitmap_);
        this.classNameText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setAutoSize("center").setTextWidth(this.graphic_.width).setBold(true);
        this.classNameText_.setStringBuilder(new LineBuilder().setParams(ClassToolTip.getDisplayId(this.playerXML_)));
        this.classNameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        this.graphic_.addChild(this.classNameText_);
        this.setStatusButton();
        if (this.available_) {
            _local5 = this.getStars(FameUtil.numStars(_arg_3.getBestFame(this.objectType())), FameUtil.STARS.length);
            _local5.y = 60;
            _local5.x = this.graphic_.width / 2 - _local5.width / 2;
            _local5.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
            this.graphicContainer_.addChild(_local5);
            this.classNameText_.y = 74;
        } else {
            this.lock_ = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface2", 5));
            this.lock_.scaleX = 2;
            this.lock_.scaleY = 2;
            this.lock_.x = 4;
            this.lock_.y = 8;
            addChild(this.lock_);
            addChild(this.statusText_);
            this.classNameText_.y = 78;
        }
    }
    public var playerXML_:XML = null;
    public var charStats_:CharacterStats;
    public var model:PlayerModel;
    public var available_:Boolean;
    public var characterSelectClicked_:NativeSignal;
    private var graphicContainer_:Sprite;
    private var graphic_:Sprite;
    private var bitmap_:Bitmap;
    private var statusText_:TextFieldDisplayConcrete;
    private var classNameText_:TextFieldDisplayConcrete;
    private var lock_:Bitmap;
    private var unlockedText_:TextFieldDisplayConcrete;

    public function objectType():int {
        return int(this.playerXML_.@type);
    }

    public function unlock():void {
        var _local1:* = null;
        var _local2:* = null;
        if (this.available_ == false) {
            this.available_ = true;
            this.graphicContainer_.removeChild(this.graphic_);
            this.graphic_ = new FullCharBoxGraphic();
            this.graphicContainer_.addChild(this.graphic_);
            this.setImage(2, 0, 0);
            this.graphic_.addChild(this.bitmap_);
            this.graphic_.addChild(this.classNameText_);
            if (contains(this.statusText_)) {
                removeChild(this.statusText_);
            }
            if (this.lock_ && contains(this.lock_)) {
                removeChild(this.lock_);
            }
            _local1 = this.getStars(FameUtil.numStars(this.model.getBestFame(this.objectType())), FameUtil.STARS.length);
            _local1.y = 60;
            _local1.x = this.graphic_.width / 2 - _local1.width / 2;
            _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
            addChild(_local1);
            this.classNameText_.y = 74;
            if (!this.unlockedText_) {
                this.getCharacterUnlockText();
            }
            addChild(this.unlockedText_);
            _local2 = new GTween(this.unlockedText_, 2.5, {
                "alpha": 0,
                "y": -30
            });
            _local2.onComplete = this.removeUnlockText;
        }
    }

    public function getTooltip():ToolTip {
        return new ClassToolTip(this.playerXML_, this.model, this.charStats_);
    }

    public function setOver(_arg_1:Boolean):void {
        if (!this.available_) {
            return;
        }
        if (_arg_1) {
            transform.colorTransform = new ColorTransform(1.2, 1.2, 1.2);
        } else {
            transform.colorTransform = new ColorTransform(1, 1, 1);
        }
    }

    private function removeUnlockText(_arg_1:GTween):void {
        removeChild(this.unlockedText_);
    }

    private function setImage(_arg_1:int, _arg_2:int, _arg_3:Number):void {
        this.bitmap_.bitmapData = SavedCharacter.getImage(null, this.playerXML_, _arg_1, _arg_2, _arg_3, this.available_, false);
        this.bitmap_.x = this.graphic_.width / 2 - this.bitmap_.bitmapData.width / 2;
    }

    private function getStars(_arg_1:int, _arg_2:int):Sprite {
        var _local3:* = null;
        var _local4:int = 0;
        var _local5:int = 0;
        var _local6:Sprite = new Sprite();
        while (_local4 < _arg_1) {
            _local3 = new StarGraphic();
            _local3.x = _local5;
            _local3.transform.colorTransform = fullCT;
            _local6.addChild(_local3);
            _local5 = _local5 + _local3.width;
            _local4++;
        }
        while (_local4 < _arg_2) {
            _local3 = new StarGraphic();
            _local3.x = _local5;
            _local3.transform.colorTransform = emptyCT;
            _local6.addChild(_local3);
            _local5 = _local5 + _local3.width;
            _local4++;
        }
        return _local6;
    }

    private function setStatusButton():void {
        this.statusText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xff0000).setAutoSize("center").setBold(true).setTextWidth(this.graphic_.width);
        this.statusText_.setStringBuilder(new LineBuilder().setParams("CharacterBox.locked"));
        this.statusText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        this.statusText_.y = 58;
    }

    private function getCharacterUnlockText():void {
        this.unlockedText_ = new TextFieldDisplayConcrete().setSize(14).setColor(0xff00).setBold(true).setAutoSize("center");
        this.unlockedText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        this.unlockedText_.setStringBuilder(new LineBuilder().setParams("CharacterBox.classUnlocked"));
        this.unlockedText_.y = -20;
    }
}
}
