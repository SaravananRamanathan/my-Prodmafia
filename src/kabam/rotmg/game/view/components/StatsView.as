package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.objects.Player;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import kabam.rotmg.game.model.StatModel;

import org.osflash.signals.natives.NativeSignal;

public class StatsView extends Sprite {

    private static const statsModel:Array = [new StatModel("StatModel.attack.short", "StatModel.attack.long", "StatModel.attack.description", true), new StatModel("StatModel.defense.short", "StatModel.defense.long", "StatModel.defense.description", false), new StatModel("StatModel.speed.short", "StatModel.speed.long", "StatModel.speed.description", true), new StatModel("StatModel.dexterity.short", "StatModel.dexterity.long", "StatModel.dexterity.description", true), new StatModel("StatModel.vitality.short", "StatModel.vitality.long", "StatModel.vitality.description", true), new StatModel("StatModel.wisdom.short", "StatModel.wisdom.long", "StatModel.wisdom.description", true)];

    private static const statsModelLength:uint = statsModel.length;

    public static const ATTACK:int = 0;

    public static const DEFENSE:int = 1;

    public static const SPEED:int = 2;

    public static const DEXTERITY:int = 3;

    public static const VITALITY:int = 4;

    public static const WISDOM:int = 5;

    public static const LIFE:int = 6;

    public static const MANA:int = 7;

    public static const STATE_UNDOCKED:String = "state_undocked";

    public static const STATE_DOCKED:String = "state_docked";

    public static const STATE_DEFAULT:String = "state_docked";


    private const DEFAULT_FILTER:GlowFilter = new GlowFilter(0, 1, 10, 10, 1, 3);

    private const WIDTH:int = 188;

    private const HEIGHT:int = 45;

    public function StatsView() {
        this.background = this.createBackground();
        this.stats_ = new Vector.<StatView>();
        this.containerSprite = new Sprite();
        super();
        addChild(this.background);
        addChild(this.containerSprite);
        this.createStats();
        mouseChildren = false;
        this.mouseDown = new NativeSignal(this, "mouseDown", MouseEvent);
    }
    public var myPlayer:Boolean = true;
    public var altPlayer:Player;
    public var stats_:Vector.<StatView>;
    public var containerSprite:Sprite;
    public var mouseDown:NativeSignal;
    public var currentState:String = "state_docked";
    private var background:Sprite;

    public function draw(_arg_1:Player, _arg_2:Boolean = true):void {
        if (_arg_1) {
            this.setBackgroundVisibility();
            this.drawStats(_arg_1);
        }
        if (_arg_2) {
            this.containerSprite.x = (188 - this.containerSprite.width) / 2;
        }
    }

    public function dock():void {
        this.currentState = "state_docked";
    }

    public function undock():void {
        this.currentState = "state_undocked";
    }

    private function createStats():void {
        var _local1:int = 0;
        var _local2:* = null;
        var _local3:int = 0;
        _local1 = 0;
        while (_local1 < statsModelLength) {
            _local2 = this.createStat(_local1, _local3);
            this.stats_.push(_local2);
            this.containerSprite.addChild(_local2);
            _local3 = _local3 + _local1 % 2;
            _local1++;
        }
    }

    private function createStat(_arg_1:int, _arg_2:int):StatView {
        var _local3:* = null;
        var _local4:StatModel = statsModel[_arg_1];
        _local3 = new StatView(_local4.name, _local4.abbreviation, _local4.description, _local4.redOnZero);
        _local3.x = _arg_1 % 2 * 188 * 0.5;
        _local3.y = _arg_2 * 15;
        return _local3;
    }

    private function drawStats(_arg_1:Player):void {
        this.stats_[0].draw(_arg_1.attack_, _arg_1.attackBoost_, _arg_1.attackMax_, _arg_1.level_);
        this.stats_[1].draw(_arg_1.defense_, _arg_1.defenseBoost_, _arg_1.defenseMax_, _arg_1.level_);
        this.stats_[2].draw(_arg_1.speed_, _arg_1.speedBoost_, _arg_1.speedMax_, _arg_1.level_);
        this.stats_[3].draw(_arg_1.dexterity_, _arg_1.dexterityBoost_, _arg_1.dexterityMax_, _arg_1.level_);
        this.stats_[4].draw(_arg_1.vitality_, _arg_1.vitalityBoost_, _arg_1.vitalityMax_, _arg_1.level_);
        this.stats_[5].draw(_arg_1.wisdom, _arg_1.wisdomBoost_, _arg_1.wisdomMax_, _arg_1.level_);
    }

    private function createBackground():Sprite {
        this.background = new Sprite();
        this.background.graphics.clear();
        this.background.graphics.beginFill(0x363636);
        this.background.graphics.lineStyle(2, 0xffffff);
        this.background.graphics.drawRoundRect(-5, -5, 198, 58, 10);
        this.background.filters = [DEFAULT_FILTER];
        return this.background;
    }

    private function setBackgroundVisibility():void {
        if (this.currentState == "state_undocked") {
            this.background.alpha = 1;
        } else if (this.currentState == "state_docked") {
            this.background.alpha = 0;
        }
    }
}
}
