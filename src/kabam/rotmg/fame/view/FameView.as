package kabam.rotmg.fame.view {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.screens.ScoreTextLine;
import com.company.assembleegameclient.screens.ScoringBox;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.FameIconBackgroundDesign;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.util.BitmapUtil;
import com.gskinner.motion.GTween;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;

import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.components.ScreenBase;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class FameView extends Sprite {

    private static const FameIconBackgroundDesign_:Class = FameIconBackgroundDesign;


    private const DEFAULT_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0, 0.5, 12, 12);

    public function FameView() {
        super();
        this.init();
    }
    public var closed:Signal;
    private var infoContainer:DisplayObjectContainer;
    private var overlayContainer:Bitmap;
    private var title:TextFieldDisplayConcrete;
    private var date:TextFieldDisplayConcrete;
    private var scoringBox:ScoringBox;
    private var finalLine:ScoreTextLine;
    private var continueBtn:TitleMenuOption;
    private var isAnimation:Boolean;
    private var isFadeComplete:Boolean;
    private var isDataPopulated:Boolean;

    private var _remainingChallengerCharacters:UILabel;

    public function get remainingChallengerCharacters():UILabel {
        return this._remainingChallengerCharacters;
    }

    public function set remainingChallengerCharacters(_arg_1:UILabel):void {
        this._remainingChallengerCharacters = _arg_1;
    }

    public function setIsAnimation(_arg_1:Boolean):void {
        this.isAnimation = _arg_1;
    }

    public function setBackground(_arg_1:BitmapData):void {
        this.overlayContainer.bitmapData = _arg_1;
        var _local2:GTween = new GTween(this.overlayContainer, 2, {"alpha": 0});
        _local2.onComplete = this.onFadeComplete;
        SoundEffectLibrary.play("death_screen");
    }

    public function clearBackground():void {
        this.overlayContainer.bitmapData = null;
    }

    public function setCharacterInfo(_arg_1:String, _arg_2:int, _arg_3:int):void {
        this.title = new TextFieldDisplayConcrete().setSize(38).setColor(0xcccccc);
        this.title.setBold(true).setAutoSize("center");
        this.title.filters = [DEFAULT_FILTER];
        var _local4:String = ObjectLibrary.typeToDisplayId_[_arg_3];
        this.title.setStringBuilder(new LineBuilder().setParams("FameView.CharacterInfo", {
            "name": _arg_1,
            "level": _arg_2,
            "type": _local4
        }));
        this.title.x = stage.stageWidth * 0.5;
        this.title.y = 225;
        this.infoContainer.addChild(this.title);
    }

    public function setDeathInfo(_arg_1:String, _arg_2:String):void {
        this.date = new TextFieldDisplayConcrete().setSize(24).setColor(0xcccccc);
        this.date.setBold(true).setAutoSize("center");
        this.date.filters = [DEFAULT_FILTER];
        var _local3:LineBuilder = new LineBuilder();
        if (_arg_2) {
            _local3.setParams("FameView.deathInfoLong", {
                "date": _arg_1,
                "killer": this.convertKillerString(_arg_2)
            });
        } else {
            _local3.setParams("FameView.deathInfoShort", {"date": _arg_1});
        }
        this.date.setStringBuilder(_local3);
        this.date.x = stage.stageWidth * 0.5;
        this.date.y = 272;
        this.infoContainer.addChild(this.date);
    }

    public function setIcon(_arg_1:BitmapData):void {
        var _local2:Sprite = new Sprite();
        var _local3:Sprite = new FameIconBackgroundDesign_();
        _local3.filters = [DEFAULT_FILTER];
        _local2.addChild(_local3);
        var _local4:Bitmap = new Bitmap(_arg_1);
        _local4.x = _local2.width * 0.5 - _local4.width * 0.5;
        _local4.y = _local2.height * 0.5 - _local4.height * 0.5;
        _local2.addChild(_local4);
        _local2.y = 20;
        _local2.x = stage.stageWidth * 0.5 - _local2.width * 0.5;
        this.infoContainer.addChild(_local2);
    }

    public function setScore(_arg_1:int, _arg_2:XML):void {
        this.scoringBox = new ScoringBox(new Rectangle(0, 0, 784, 150), _arg_2);
        this.scoringBox.x = 8;
        this.scoringBox.y = 316;
        addChild(this.scoringBox);
        this.infoContainer.addChild(this.scoringBox);
        var _local3:BitmapData = FameUtil.getFameIcon();
        _local3 = BitmapUtil.cropToBitmapData(_local3, 6, 6, _local3.width - 12, _local3.height - 12);
        this.finalLine = new ScoreTextLine(24, 0xcccccc, 16762880, "FameView.totalFameEarned", null, 0, _arg_1, "", "", new Bitmap(_local3));
        this.finalLine.x = 10;
        this.finalLine.y = 470;
        this.infoContainer.addChild(this.finalLine);
        this.isDataPopulated = true;
        if (!this.isAnimation || this.isFadeComplete) {
            this.makeContinueButton();
        }
    }

    public function addRemainingChallengerCharacters(_arg_1:int):void {
        this._remainingChallengerCharacters = new UILabel();
        DefaultLabelFormat.createLabelFormat(this._remainingChallengerCharacters, 18, 0xff0000, "left", true);
        this._remainingChallengerCharacters.autoSize = "left";
        this._remainingChallengerCharacters.text = "You can create " + _arg_1 + " more characters";
        this._remainingChallengerCharacters.x = (this.width - this._remainingChallengerCharacters.width) / 2;
        this._remainingChallengerCharacters.y = this.finalLine.y + this.finalLine.height - 10;
        this.infoContainer.addChild(this._remainingChallengerCharacters);
    }

    private function init():void {
        addChild(new ScreenBase());
        var _local1:* = new Sprite();
        this.infoContainer = _local1;
        addChild(_local1);
        _local1 = new Bitmap();
        this.overlayContainer = _local1;
        addChild(_local1);
        this.continueBtn = new TitleMenuOption("Options.continueButton", 36, false);
        this.continueBtn.setAutoSize("center");
        this.continueBtn.setVerticalAlign("middle");
        this.closed = new NativeMappedSignal(this.continueBtn, "click");
    }

    private function onFadeComplete(_arg_1:GTween):void {
        removeChild(this.overlayContainer);
        this.isFadeComplete = true;
        if (this.isDataPopulated) {
            this.makeContinueButton();
        }
    }

    private function convertKillerString(_arg_1:String):String {
        var _local2:Array = _arg_1.split(".");
        var _local4:String = _local2[0];
        var _local3:* = _local2[1];
        if (_local3 == null) {
            _local3 = _local4;
            var _local5:* = _local3;
            switch (_local5) {
                case "lava":
                    _local3 = "Lava";
                    break;
                case "lava blend":
                    _local3 = "Lava Blend";
                    break;
                case "liquid evil":
                    _local3 = "Liquid Evil";
                    break;
                case "evil water":
                    _local3 = "Evil Water";
                    break;
                case "puke water":
                    _local3 = "Puke Water";
                    break;
                case "hot lava":
                    _local3 = "Hot Lava";
                    break;
                case "pure evil":
                    _local3 = "Pure Evil";
                    break;
                case "lod red tile":
                    _local3 = "lod Red Tile";
                    break;
                case "lod purple tile":
                    _local3 = "lod Purple Tile";
                    break;
                case "lod blue tile":
                    _local3 = "lod Blue Tile";
                    break;
                case "lod green tile":
                    _local3 = "lod Green Tile";
                    break;
                case "lod cream tile":
                    _local3 = "lod Cream Tile";
            }
        } else {
            _local3 = _local3.substr(0, _local3.length - 1);
            _local3 = _local3.replace(/_/g, " ");
            _local3 = _local3.replace(/APOS/g, "\'");
            _local3 = _local3.replace(/BANG/g, "!");
        }
        if (ObjectLibrary.getPropsFromId(_local3)) {
            _local3 = ObjectLibrary.getPropsFromId(_local3).displayId_;
        } else if (GroundLibrary.getPropsFromId(_local3) != null) {
            _local3 = GroundLibrary.getPropsFromId(_local3).displayId_;
        }
        return _local3;
    }

    private function makeContinueButton():void {
        this.infoContainer.addChild(new ScreenGraphic());
        this.continueBtn.x = stage.stageWidth * 0.5;
        this.continueBtn.y = 550;
        this.infoContainer.addChild(this.continueBtn);
        if (this.isAnimation) {
            this.scoringBox.animateScore();
        } else {
            this.scoringBox.showScore();
        }
    }
}
}
