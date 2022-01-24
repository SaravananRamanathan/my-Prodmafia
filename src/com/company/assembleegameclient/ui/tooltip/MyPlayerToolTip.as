package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.GameObjectListItem;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
import com.company.assembleegameclient.util.FameUtil;

import flash.filters.DropShadowFilter;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.view.components.StatsView;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class MyPlayerToolTip extends ToolTip {


    public function MyPlayerToolTip(_arg_1:String, _arg_2:XML, _arg_3:CharacterStats) {
        super(0x363636, 1, 0xffffff, 1);
        this.accountName = _arg_1;
        this.charXML = _arg_2;
        this.charStats = _arg_3;
    }
    public var player_:Player;
    private var factory:CharacterFactory;
    private var classes:ClassesModel;
    private var playerPanel_:GameObjectListItem;
    private var hpBar_:StatusBar;
    private var mpBar_:StatusBar;
    private var lineBreak_:LineBreakDesign;
    private var bestLevel_:TextFieldDisplayConcrete;
    private var nextClassQuest_:TextFieldDisplayConcrete;
    private var eGrid:EquippedGrid;
    private var iGrid:InventoryGrid;
    private var bGrid:InventoryGrid;
    private var accountName:String;
    private var charXML:XML;
    private var charStats:CharacterStats;
    private var stats_:StatsView;

    override protected function alignUI():void {
        if (this.nextClassQuest_) {
            this.nextClassQuest_.x = 8;
            this.nextClassQuest_.y = this.bestLevel_.getBounds(this).bottom - 2;
        }
    }

    override public function draw():void {
        this.hpBar_.draw(this.player_.hp_, this.player_.maxHP_, this.player_.maxHPBoost_, this.player_.maxHPMax_, this.player_.level_);
        this.mpBar_.draw(this.player_.mp_, this.player_.maxMP_, this.player_.maxMPBoost_, this.player_.maxMPMax_, this.player_.level_);
        this.lineBreak_.setWidthColor(width - 10, 0x1c1c1c);
        super.draw();
    }

    public function createUI():void {
        var _local6:* = NaN;
        this.factory = StaticInjectorContext.getInjector().getInstance(CharacterFactory);
        this.classes = StaticInjectorContext.getInjector().getInstance(ClassesModel);
        var _local5:int = this.charXML.ObjectType;
        var _local2:XML = ObjectLibrary.xmlLibrary_[_local5];
        this.player_ = Player.fromPlayerXML(this.accountName, this.charXML);
        var _local1:CharacterClass = this.classes.getCharacterClass(this.player_.objectType_);
        var _local3:CharacterSkin = _local1.skins.getSkin(this.charXML.Texture);
        this.player_.animatedChar_ = this.factory.makeCharacter(_local3.template);
        this.playerPanel_ = new GameObjectListItem(0xb3b3b3, true, this.player_);
        addChild(this.playerPanel_);
        _local6 = 36;
        this.hpBar_ = new StatusBar(176, 16, 14693428, 0x545454, "StatusBar.HealthPoints", true);
        this.hpBar_.x = 6;
        this.hpBar_.y = _local6;
        addChild(this.hpBar_);
        _local6 = Number(_local6 + 22);
        this.mpBar_ = new StatusBar(176, 16, 6325472, 0x545454, "StatusBar.ManaPoints", true);
        this.mpBar_.x = 6;
        this.mpBar_.y = _local6;
        addChild(this.mpBar_);
        _local6 = Number(_local6 + 22);
        this.stats_ = new StatsView();
        this.stats_.draw(this.player_, false);
        this.stats_.x = 6;
        this.stats_.y = _local6 - 3;
        addChild(this.stats_);
        _local6 = Number(_local6 + 44);
        this.eGrid = new EquippedGrid(null, this.player_.slotTypes_, this.player_);
        this.eGrid.x = 8;
        this.eGrid.y = _local6;
        addChild(this.eGrid);
        this.eGrid.setItems(this.player_.equipment_);
        _local6 = Number(_local6 + 44);
        this.iGrid = new InventoryGrid(null, this.player_, 4);
        this.iGrid.x = 8;
        this.iGrid.y = _local6;
        addChild(this.iGrid);
        this.iGrid.setItems(this.player_.equipment_);
        _local6 = Number(_local6 + 88);
        if (this.player_.hasBackpack_) {
            this.bGrid = new InventoryGrid(null, this.player_, 12);
            this.bGrid.x = 8;
            this.bGrid.y = _local6;
            addChild(this.bGrid);
            this.bGrid.setItems(this.player_.equipment_);
            _local6 = Number(_local6 + 88);
        }
        _local6 = Number(_local6 + 8);
        this.lineBreak_ = new LineBreakDesign(100, 0x1c1c1c);
        this.lineBreak_.x = 6;
        this.lineBreak_.y = _local6;
        addChild(this.lineBreak_);
        this.makeBestLevelText();
        this.bestLevel_.x = 8;
        this.bestLevel_.y = height - 2;
        var _local4:int = FameUtil.nextStarFame(this.charStats == null ? 0 : this.charStats.bestFame(), 0);
        if (_local4 > 0) {
            this.makeNextClassQuestText(_local4, _local2);
        }
    }

    public function makeNextClassQuestText(_arg_1:int, _arg_2:XML):void {
        this.nextClassQuest_ = new TextFieldDisplayConcrete().setSize(13).setColor(16549442).setTextWidth(174);
        this.nextClassQuest_.setStringBuilder(new LineBuilder().setParams("MyPlayerToolTip.NextClassQuest", {
            "nextStarFame": _arg_1,
            "character": ClassToolTip.getDisplayId(_arg_2)
        }));
        this.nextClassQuest_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nextClassQuest_);
        waiter.push(this.nextClassQuest_.textChanged);
    }

    public function makeBestLevelText():void {
        this.bestLevel_ = new TextFieldDisplayConcrete().setSize(14).setColor(6206769);
        var _local3:int = this.charStats == null ? 0 : this.charStats.numStars();
        var _local2:String = (this.charStats != null ? this.charStats.bestLevel() : 0).toString();
        var _local1:String = (this.charStats != null ? this.charStats.bestFame() : 0).toString();
        this.bestLevel_.setStringBuilder(new LineBuilder().setParams("bestLevel_.stats", {
            "numStars": _local3,
            "bestLevel": _local2,
            "fame": _local1
        }));
        this.bestLevel_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.bestLevel_);
        waiter.push(this.bestLevel_.textChanged);
    }
}
}
