package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.util.FameUtil;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.getTimer;

public class ScoringBox extends Sprite {


    public function ScoringBox(_arg_1:Rectangle, _arg_2:XML) {
        mask_ = new Shape();
        linesSprite_ = new Sprite();
        scoreTextLines_ = new Vector.<ScoreTextLine>();
        var _local3:* = null;
        super();
        this.rect_ = _arg_1;
        graphics.lineStyle(1, 0x494949, 2);
        graphics.drawRect(this.rect_.x + 1, this.rect_.y + 1, this.rect_.width - 2, this.rect_.height - 2);
        graphics.lineStyle();
        this.scrollbar_ = new Scrollbar(16, this.rect_.height);
        this.scrollbar_.addEventListener("change", this.onScroll);
        this.mask_.graphics.beginFill(0xffffff, 1);
        this.mask_.graphics.drawRect(this.rect_.x, this.rect_.y, this.rect_.width, this.rect_.height);
        this.mask_.graphics.endFill();
        addChild(this.mask_);
        mask = this.mask_;
        addChild(this.linesSprite_);
        this.addLine("FameView.Shots", null, 0, _arg_2.Shots, false, 5746018);
        if (_arg_2.Shots != 0) {
            this.addLine("FameView.Accuracy", null, 0, 100 * _arg_2.ShotsThatDamage / _arg_2.Shots, true, 5746018, "", "%");
        }
        this.addLine("FameView.TilesSeen", null, 0, _arg_2.TilesUncovered, false, 5746018);
        this.addLine("FameView.MonsterKills", null, 0, _arg_2.MonsterKills, false, 5746018);
        this.addLine("FameView.GodKills", null, 0, _arg_2.GodKills, false, 5746018);
        this.addLine("FameView.OryxKills", null, 0, _arg_2.OryxKills, false, 5746018);
        this.addLine("FameView.QuestsCompleted", null, 0, _arg_2.QuestsCompleted, false, 5746018);
        this.addLine("FameView.DungeonsCompleted", null, 0, _arg_2.PirateCavesCompleted + _arg_2.UndeadLairsCompleted + _arg_2.AbyssOfDemonsCompleted + _arg_2.SnakePitsCompleted + _arg_2.SpiderDensCompleted + _arg_2.SpriteWorldsCompleted + _arg_2.TombsCompleted + _arg_2.TrenchesCompleted + _arg_2.JunglesCompleted + _arg_2.ManorsCompleted + _arg_2.ForestMazeCompleted + _arg_2.LairOfDraconisCompleted + _arg_2.CandyLandCompleted + _arg_2.HauntedCemeteryCompleted + _arg_2.CaveOfAThousandTreasuresCompleted + _arg_2.MadLabCompleted + _arg_2.DavyJonesCompleted + _arg_2.TombHeroicCompleted + _arg_2.DreamscapeCompleted + _arg_2.IceCaveCompleted + _arg_2.DeadWaterDocksCompleted + _arg_2.CrawlingDepthCompleted + _arg_2.WoodLandCompleted + _arg_2.BattleNexusCompleted + _arg_2.TheShattersCompleted + _arg_2.BelladonnaCompleted + _arg_2.PuppetMasterCompleted + _arg_2.ToxicSewersCompleted + _arg_2.TheHiveCompleted + _arg_2.MountainTempleCompleted + _arg_2.TheNestCompleted + _arg_2.LairOfDraconisHmCompleted + _arg_2.LostHallsCompleted + _arg_2.CultistHideoutCompleted + _arg_2.TheVoidCompleted + _arg_2.PuppetEncoreCompleted + _arg_2.LairOfShaitanCompleted + _arg_2.ParasiteChambersCompleted, false, 5746018);
        this.addLine("FameView.PartyMemberLevelUps", null, 0, _arg_2.LevelUpAssists, false, 5746018);
        var _local4:BitmapData = FameUtil.getFameIcon();
        _local4 = BitmapUtil.cropToBitmapData(_local4, 6, 6, _local4.width - 12, _local4.height - 12);
        this.addLine("FameView.BaseFameEarned", null, 0, _arg_2.BaseFame, true, 16762880, "", "", new Bitmap(_local4));
        var _local6:int = 0;
        var _local5:* = _arg_2.Bonus;
        for each(_local3 in _arg_2.Bonus) {
            this.addLine(_local3.@id, _local3.@desc, _local3.@level, _local3, true, 16762880, "+", "", new Bitmap(_local4));
        }
    }
    private var rect_:Rectangle;
    private var mask_:Shape;
    private var linesSprite_:Sprite;
    private var scoreTextLines_:Vector.<ScoreTextLine>;
    private var scrollbar_:Scrollbar;
    private var startTime_:int;

    public function showScore():void {
        var _local1:* = null;
        this.animateScore();
        this.startTime_ = -2147483647;
        var _local3:int = 0;
        var _local2:* = this.scoreTextLines_;
        for each(_local1 in this.scoreTextLines_) {
            _local1.skip();
        }
    }

    public function animateScore():void {
        this.startTime_ = getTimer();
        addEventListener("enterFrame", this.onEnterFrame);
    }

    private function addLine(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:uint, _arg_7:String = "", _arg_8:String = "", _arg_9:DisplayObject = null):void {
        if (_arg_4 == 0 && !_arg_5) {
            return;
        }
        this.scoreTextLines_.push(new ScoreTextLine(20, 0xb3b3b3, _arg_6, _arg_1, _arg_2, _arg_3, _arg_4, _arg_7, _arg_8, _arg_9));
    }

    private function addScrollbar():void {
        graphics.clear();
        graphics.lineStyle(1, 0x494949, 2);
        graphics.drawRect(this.rect_.x + 1, this.rect_.y + 1, this.rect_.width - 26, this.rect_.height - 2);
        graphics.lineStyle();
        this.scrollbar_.x = this.rect_.width - 16;
        this.scrollbar_.setIndicatorSize(this.mask_.height, this.linesSprite_.height);
        this.scrollbar_.setPos(1);
        addChild(this.scrollbar_);
    }

    private function onScroll(_arg_1:Event):void {
        var _local2:Number = this.scrollbar_.pos();
        this.linesSprite_.y = _local2 * (this.rect_.height - this.linesSprite_.height - 15) + 5;
    }

    private function onEnterFrame(_arg_1:Event):void {
        var _local6:Number = NaN;
        var _local5:* = null;
        var _local3:int = 0;
        var _local2:Number = this.startTime_ + 2000 * (this.scoreTextLines_.length - 1) / 2;
        _local6 = getTimer();
        var _local4:int = Math.min(this.scoreTextLines_.length, 2 * (getTimer() - this.startTime_) / 2000 + 1);
        while (_local3 < _local4) {
            _local5 = this.scoreTextLines_[_local3];
            _local5.y = 28 * _local3;
            this.linesSprite_.addChild(_local5);
            _local3++;
        }
        this.linesSprite_.y = this.rect_.height - this.linesSprite_.height - 10;
        if (_local6 > _local2 + 1000) {
            this.addScrollbar();
            dispatchEvent(new Event("complete"));
            removeEventListener("enterFrame", this.onEnterFrame);
        }
    }
}
}
