package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.assembleegameclient.util.EquipmentUtil;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.FilterUtil;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.rotmg.graphics.StarGraphic;
import com.company.util.AssetLibrary;
import com.company.util.CachingColorTransformer;
import com.company.util.ConversionUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class ClassToolTip extends ToolTip {

    public static const CLASS_TOOL_TIP_WIDTH:int = 210;

    public static const FULL_STAR:ColorTransform = new ColorTransform(0.8, 0.8, 0.8);

    public static const EMPTY_STAR:ColorTransform = new ColorTransform(0.1, 0.1, 0.1);

    public static function getDisplayId(_arg_1:XML):String {
        return _arg_1.DisplayId == undefined ? _arg_1.@id : _arg_1.DisplayId;
    }

    public function ClassToolTip(_arg_1:XML, _arg_2:PlayerModel, _arg_3:CharacterStats) {
        var _local4:* = undefined;
        this._playerXML = _arg_1;
        this._playerModel = _arg_2;
        this._charStats = _arg_3;
        this.showUnlockRequirements = this.shouldShowUnlockRequirements(this._playerModel, this._playerXML);
        if (this.showUnlockRequirements) {
            this._backgroundColor = 0x1c1c1c;
            _local4 = 0x363636;
            this._borderColor = _local4;
            this._lineColor = _local4;
        } else {
            this._backgroundColor = 0x363636;
            this._borderColor = 0xffffff;
            this._lineColor = 0x1c1c1c;
        }
        super(this._backgroundColor, 1, this._borderColor, 1);
        this.init();
    }
    private var portrait_:Bitmap;
    private var nameText_:TextFieldDisplayConcrete;
    private var classQuestText_:TextFieldDisplayConcrete;
    private var classUnlockText_:TextFieldDisplayConcrete;
    private var descriptionText_:TextFieldDisplayConcrete;
    private var lineBreakOne:LineBreakDesign;
    private var lineBreakTwo:LineBreakDesign;
    private var toUnlockText_:TextFieldDisplayConcrete;
    private var unlockText_:TextFieldDisplayConcrete;
    private var nextClassQuest_:TextFieldDisplayConcrete;
    private var showUnlockRequirements:Boolean;
    private var _playerXML:XML;
    private var _playerModel:PlayerModel;
    private var _charStats:CharacterStats;
    private var _equipmentContainer:Sprite;
    private var _progressContainer:Sprite;
    private var _bestContainer:Sprite;
    private var _classUnlockContainer:Sprite;
    private var _numberOfStars:int;
    private var _backgroundColor:Number;
    private var _borderColor:Number;
    private var _lineColor:Number;
    private var _nextStarFame:int;

    override protected function alignUI():void {
        this.nameText_.x = 32;
        this.nameText_.y = 6;
        this.descriptionText_.x = 8;
        this.descriptionText_.y = 40;
        height;
        this.lineBreakOne.x = 6;
        this.lineBreakOne.y = height;
        if (this.showUnlockRequirements) {
            this.toUnlockText_.x = 8;
            this.toUnlockText_.y = height - 2;
            this.unlockText_.x = 12;
            this.unlockText_.y = height - 4;
        } else {
            this.classQuestText_.x = 6;
            this.classQuestText_.y = height - 2;
            if (this._nextStarFame > 0) {
                this.nextClassQuest_.x = 8;
                this.nextClassQuest_.y = height - 4;
            }
            this._progressContainer.x = 10;
            this._progressContainer.y = height - 2;
            this._bestContainer.x = 6;
            this._bestContainer.y = height;
            if (this.lineBreakTwo) {
                this.lineBreakTwo.x = 6;
                this.lineBreakTwo.y = height - 10;
                this.classUnlockText_.visible = true;
                this.classUnlockText_.x = 6;
                this.classUnlockText_.y = height;
                this._classUnlockContainer.x = 6;
                this._classUnlockContainer.y = height - 6;
            }
        }
        this.draw();
        position();
    }

    override public function draw():void {
        this.lineBreakOne.setWidthColor(210, this._lineColor);
        this.lineBreakTwo && this.lineBreakTwo.setWidthColor(210, this._lineColor);
        this._equipmentContainer.x = 210 - this._equipmentContainer.width + 10;
        this._equipmentContainer.y = 6;
        super.draw();
    }

    private function init():void {
        var _local1:Boolean = StaticInjectorContext.injector.getInstance(SeasonalEventModel).isChallenger;
        this._numberOfStars = this._charStats == null ? 0 : this._charStats.numStars();
        this.createCharacter();
        this.createEquipmentTypes();
        this.createCharacterName();
        this.lineBreakOne = new LineBreakDesign(204, this._lineColor);
        addChild(this.lineBreakOne);
        if (this.showUnlockRequirements && !_local1) {
            this.createUnlockRequirements();
        } else {
            this.createClassQuest();
            this.createQuestText();
            this.createStarProgress();
            this.createBestLevelAndFame();
            if (!_local1) {
                this.createClassUnlockTitle();
                this.createClassUnlocks();
                if (this._classUnlockContainer.numChildren > 0) {
                    this.lineBreakTwo = new LineBreakDesign(204, this._lineColor);
                    addChild(this.lineBreakTwo);
                }
            }
        }
    }

    private function createCharacter():void {
        var _local4:AnimatedChar = AnimatedChars.getAnimatedChar(this._playerXML.AnimatedTexture.File, this._playerXML.AnimatedTexture.Index);
        var _local2:MaskedImage = _local4.imageFromDir(0, 0, 0);
        var _local1:int = 4 / _local2.width() * 100;
        var _local3:BitmapData = TextureRedrawer.redraw(_local2.image_, _local1, true, 0);
        if (this.showUnlockRequirements) {
            _local3 = CachingColorTransformer.transformBitmapData(_local3, new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0));
        }
        this.portrait_ = new Bitmap();
        this.portrait_.bitmapData = _local3;
        this.portrait_.x = -4;
        this.portrait_.y = -4;
        addChild(this.portrait_);
    }

    private function createEquipmentTypes():void {
        var _local3:int = 0;
        var _local7:* = null;
        var _local5:* = null;
        var _local4:* = null;
        var _local1:int = 0;
        this._equipmentContainer = new Sprite();
        addChild(this._equipmentContainer);
        var _local6:Vector.<int> = ConversionUtil.toIntVector(this._playerXML.SlotTypes);
        var _local2:Vector.<int> = ConversionUtil.toIntVector(this._playerXML.Equipment);
        while (_local1 < 4) {
            _local3 = _local2[_local1];
            if (_local3 > -1) {
                _local7 = ObjectLibrary.getRedrawnTextureFromType(_local3, 40, true);
                _local5 = new Bitmap(_local7);
                _local5.x = _local1 * 22;
                _local5.y = -12;
                this._equipmentContainer.addChild(_local5);
            } else {
                _local4 = EquipmentUtil.getEquipmentBackground(_local6[_local1], 2);
                if (_local4) {
                    _local4.x = 12 + _local1 * 22;
                    _local4.filters = FilterUtil.getDarkGreyColorFilter();
                    this._equipmentContainer.addChild(_local4);
                }
            }
            _local1++;
        }
    }

    private function createCharacterName():void {
        this.nameText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xffffff);
        this.nameText_.setBold(true);
        this.nameText_.setStringBuilder(new LineBuilder().setParams(getDisplayId(this._playerXML)));
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        waiter.push(this.nameText_.textChanged);
        addChild(this.nameText_);
        this.descriptionText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3).setWordWrap(true).setMultiLine(true).setTextWidth(174);
        this.descriptionText_.setStringBuilder(new LineBuilder().setParams(this._playerXML.Description));
        this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0)];
        waiter.push(this.descriptionText_.textChanged);
        addChild(this.descriptionText_);
    }

    private function createClassQuest():void {
        this.classQuestText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xffffff);
        this.classQuestText_.setBold(true);
        this.classQuestText_.setStringBuilder(new LineBuilder().setParams("Class Quest"));
        this.classQuestText_.filters = [new DropShadowFilter(0, 0, 0)];
        waiter.push(this.classQuestText_.textChanged);
        addChild(this.classQuestText_);
    }

    private function createQuestText():void {
        this._nextStarFame = FameUtil.nextStarFame(this._charStats == null ? 0 : this._charStats.bestFame(), 0);
        if (this._nextStarFame > 0) {
            this.nextClassQuest_ = new TextFieldDisplayConcrete().setSize(13).setColor(16549442).setTextWidth(160).setMultiLine(true).setWordWrap(true);
            if (this._numberOfStars > 0) {
                this.nextClassQuest_.setStringBuilder(new LineBuilder().setParams("Earn {nextStarFame} Fame with {typeToDisplay} to unlock the next Star", {
                    "nextStarFame": this._nextStarFame,
                    "typeToDisplay": getDisplayId(this._playerXML)
                }));
            } else {
                this.nextClassQuest_.setStringBuilder(new LineBuilder().setParams("Earn 20 Fame with {typeToDisplay} to unlock the first star", {"typeToDisplay": getDisplayId(this._playerXML)}));
            }
            this.nextClassQuest_.filters = [new DropShadowFilter(0, 0, 0)];
            waiter.push(this.nextClassQuest_.textChanged);
            addChild(this.nextClassQuest_);
        }
    }

    private function createStarProgress():void {
        var _local10:* = null;
        var _local9:int = 0;
        var _local7:int = 0;
        var _local1:Number = NaN;
        var _local5:* = false;
        var _local3:int = 0;
        var _local13:* = null;
        var _local8:* = null;
        var _local11:int = 0;
        var _local6:int = 0;
        var _local2:int = 0;
        this._progressContainer = new Sprite();
        _local10 = this._progressContainer.graphics;
        addChild(this._progressContainer);
        var _local4:Vector.<int> = FameUtil.STARS;
        var _local12:int = _local4.length;
        while (_local2 < _local12) {
            _local9 = _local4[_local2];
            _local7 = this._charStats != null ? this._charStats.bestFame() : 0;
            _local1 = _local7 >= _local9 ? 0xff00 : 16549442;
            _local5 = _local2 < this._numberOfStars;
            _local3 = 20 + _local2 * 10;
            _local13 = new StarGraphic();
            _local13.x = _local6 + (_local3 - _local13.width) / 2;
            _local13.transform.colorTransform = !_local5 ? EMPTY_STAR : FULL_STAR;
            this._progressContainer.addChild(_local13);
            _local8 = new UILabel();
            _local8.text = _local9.toString();
            DefaultLabelFormat.characterToolTipLabel(_local8, _local1);
            _local8.x = _local6 + (_local3 - _local8.width) / 2;
            _local8.y = 14;
            this._progressContainer.addChild(_local8);
            _local10.beginFill(0x1c1c1c);
            _local10.drawRect(_local6, 31, _local3, 4);
            if (_local7 > 0) {
                _local10.beginFill(_local1);
                if (_local7 >= _local9) {
                    _local10.drawRect(_local6, 31, _local3, 4);
                } else if (_local2 == 0) {
                    _local11 = _local7 / _local9 * _local3;
                    _local10.drawRect(_local6, 31, _local11, 4);
                } else if (_local7 > _local4[_local2 - 1]) {
                    _local11 = (_local7 - _local4[_local2 - 1]) / (_local9 - _local4[_local2 - 1]) * _local3;
                    _local10.drawRect(_local6, 31, _local11, 4);
                }
            }
            _local6 = _local6 + (1 + _local3);
            _local2++;
        }
    }

    private function createBestLevelAndFame():void {
        this._bestContainer = new Sprite();
        addChild(this._bestContainer);
        var _local6:UILabel = new UILabel();
        _local6.text = "Best Level";
        DefaultLabelFormat.characterToolTipLabel(_local6, 0xffffff);
        this._bestContainer.addChild(_local6);
        var _local2:UILabel = new UILabel();
        _local2.text = (this._charStats != null ? this._charStats.bestLevel() : 0).toString();
        DefaultLabelFormat.characterToolTipLabel(_local2, 0xffffff);
        _local2.x = 186;
        this._bestContainer.addChild(_local2);
        var _local1:UILabel = new UILabel();
        _local1.text = "Best Fame";
        DefaultLabelFormat.characterToolTipLabel(_local1, 0xffffff);
        _local1.y = 18;
        this._bestContainer.addChild(_local1);
        var _local4:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 224);
        _local4 = TextureRedrawer.redraw(_local4, 40, true, 0);
        var _local3:Bitmap = new Bitmap(_local4);
        _local3.x = 174;
        _local3.y = _local1.y - 10;
        this._bestContainer.addChild(_local3);
        var _local5:UILabel = new UILabel();
        _local5.text = (this._charStats != null ? this._charStats.bestFame() : 0).toString();
        DefaultLabelFormat.characterToolTipLabel(_local5, 0xffffff);
        _local5.x = _local3.x - _local5.width;
        _local5.y = _local1.y;
        this._bestContainer.addChild(_local5);
    }

    private function createClassUnlockTitle():void {
        this.classUnlockText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xffffff);
        this.classUnlockText_.setBold(true);
        this.classUnlockText_.setStringBuilder(new LineBuilder().setParams("Class Unlocks"));
        this.classUnlockText_.filters = [new DropShadowFilter(0, 0, 0)];
        waiter.push(this.classUnlockText_.textChanged);
        this.classUnlockText_.visible = false;
        addChild(this.classUnlockText_);
    }

    private function createClassUnlocks():void {
        var _local6:* = null;
        var _local2:* = null;
        var _local4:* = null;
        var _local1:int = 0;
        var _local12:Number = NaN;
        var _local8:* = null;
        var _local10:int = 0;
        var _local7:int = 0;
        this._classUnlockContainer = new Sprite();
        var _local9:int = ObjectLibrary.playerChars_.length;
        var _local5:Vector.<XML> = ObjectLibrary.playerChars_;
        var _local3:String = this._playerXML.@id;
        var _local11:int = this._charStats != null ? this._charStats.bestLevel() : 0;
        while (_local7 < _local9) {
            _local6 = _local5[_local7];
            _local2 = _local6.@id;
            if (_local3 != _local2 && _local6.UnlockLevel) {
                var _local14:int = 0;
                var _local13:* = _local6.UnlockLevel;
                for each(_local4 in _local6.UnlockLevel) {
                    if (_local3 == _local4.toString()) {
                        _local1 = _local4.@level;
                        _local12 = _local11 >= _local1 ? 0xff00 : 16711680;
                        _local8 = new UILabel();
                        _local8.text = "Reach level " + _local1.toString() + " to unlock " + _local2;
                        DefaultLabelFormat.characterToolTipLabel(_local8, _local12);
                        _local8.y = _local10;
                        this._classUnlockContainer.addChild(_local8);
                        _local10 = _local10 + 14;
                    }
                }
            }
            _local7++;
        }
        addChild(this._classUnlockContainer);
    }

    private function createUnlockRequirements():void {
        var _local2:* = null;
        var _local1:int = 0;
        var _local3:int = 0;
        this.toUnlockText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3).setTextWidth(174).setBold(true);
        this.toUnlockText_.setStringBuilder(new LineBuilder().setParams("unlockText_.toUnlock"));
        this.toUnlockText_.filters = [new DropShadowFilter(0, 0, 0)];
        waiter.push(this.toUnlockText_.textChanged);
        addChild(this.toUnlockText_);
        this.unlockText_ = new TextFieldDisplayConcrete().setSize(13).setColor(16549442).setTextWidth(174).setWordWrap(false).setMultiLine(true);
        var _local4:AppendingLineBuilder = new AppendingLineBuilder();
        var _local6:int = 0;
        var _local5:* = this._playerXML.UnlockLevel;
        for each(_local2 in this._playerXML.UnlockLevel) {
            _local1 = ObjectLibrary.idToType_[_local2.toString()];
            _local3 = _local2.@level;
            if (this._playerModel.getBestLevel(_local1) < int(_local2.@level)) {
                _local4.pushParams("unlockText_.reachLevel", {
                    "unlockLevel": _local3,
                    "typeToDisplay": ObjectLibrary.typeToDisplayId_[_local1]
                });
            }
        }
        this.unlockText_.setStringBuilder(_local4);
        this.unlockText_.filters = [new DropShadowFilter(0, 0, 0)];
        waiter.push(this.unlockText_.textChanged);
        addChild(this.unlockText_);
    }

    private function shouldShowUnlockRequirements(_arg_1:PlayerModel, _arg_2:XML):Boolean {
        var _local4:Boolean = _arg_1.isClassAvailability(String(_arg_2.@id), "unrestricted");
        var _local3:Boolean = _arg_1.isLevelRequirementsMet(int(_arg_2.@type));
        return !_local4 && !_local3;
    }
}
}
