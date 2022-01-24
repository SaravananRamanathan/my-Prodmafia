package kabam.rotmg.ui.view {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.map.GradientOverlay;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.TradePanel;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.util.GraphicsUtil;
import com.company.util.SpriteUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import io.decagames.rotmg.classes.NewClassUnlockNotification;
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.minimap.view.MiniMapImp;

public class HUDView extends Sprite implements UnFocusAble {


    private const BG_POSITION:Point = new Point(0, 0);

    private const MAP_POSITION:Point = new Point(4, 4);

    private const CHARACTER_DETAIL_PANEL_POSITION:Point = new Point(0, 198);

    private const STAT_METERS_POSITION:Point = new Point(12, 230);

    private const EQUIPMENT_INVENTORY_POSITION:Point = new Point(14, 304);

    private const TAB_STRIP_POSITION:Point = new Point(7, 346);

    private const INTERACT_PANEL_POSITION:Point = new Point(0, 500);

    public function HUDView() {
        super();
        this.createAssets();
        this.addAssets();
        this.positionAssets();
    }
    public var miniMap:MiniMapImp;
    public var equippedGrid:EquippedGrid;
    public var statMeters:StatMetersView;
    public var characterDetails:CharacterDetailsView;
    public var tabStrip:TabStripView;
    public var interactPanel:InteractPanel;
    public var tradePanel:TradePanel;
    public var sidebarGradientOverlay_:GradientOverlay = null;
    private var background:CharacterWindowBackground;
    private var newClassUnlockNotification:NewClassUnlockNotification;
    private var equippedGridBG:Sprite;
    private var player:Player;

    public function dispose():void {
        this.background = null;
        this.player = null;
        this.statMeters && this.statMeters.dispose();
        this.miniMap && this.miniMap.dispose();
        this.tabStrip && this.tabStrip.dispose();
    }

    public function setPlayerDependentAssets(_arg_1:GameSprite):void {
        this.player = _arg_1.map.player_;
        this.createEquippedGridBackground();
        this.createEquippedGrid();
        this.createInteractPanel(_arg_1);
    }

    public function draw():void {
        if (this.equippedGrid) {
            this.equippedGrid.draw();
        }
        if (this.interactPanel) {
            this.interactPanel.draw();
        }
    }

    public function startTrade(_arg_1:AGameSprite, _arg_2:TradeStart):void {
        if (!this.tradePanel) {
            this.tradePanel = new TradePanel(_arg_1, _arg_2);
            this.tradePanel.y = 200;
            this.tradePanel.addEventListener("cancel", this.onTradeCancel);
            addChild(this.tradePanel);
            this.setNonTradePanelAssetsVisible(false);
        }
    }

    public function tradeDone():void {
        this.removeTradePanel();
    }

    public function tradeChanged(_arg_1:TradeChanged):void {
        if (this.tradePanel) {
            this.tradePanel.setYourOffer(_arg_1.offer_);
        }
    }

    public function tradeAccepted(_arg_1:TradeAccepted):void {
        if (this.tradePanel) {
            this.tradePanel.youAccepted(_arg_1.myOffer_, _arg_1.yourOffer_);
        }
    }

    private function createAssets():void {
        this.background = new CharacterWindowBackground();
        this.miniMap = new MiniMapImp(192, 192);
        if (!StaticInjectorContext.injector.getInstance(SeasonalEventModel).isChallenger) {
            this.newClassUnlockNotification = new NewClassUnlockNotification();
        }
        this.tabStrip = new TabStripView();
        this.characterDetails = new CharacterDetailsView();
        this.statMeters = new StatMetersView();
        this.sidebarGradientOverlay_ = new GradientOverlay();
    }

    private function addAssets():void {
        addChild(this.background);
        addChild(this.miniMap);
        if (this.newClassUnlockNotification) {
            addChild(this.newClassUnlockNotification);
        }
        addChild(this.tabStrip);
        addChild(this.characterDetails);
        addChild(this.statMeters);
        addChild(this.sidebarGradientOverlay_);
    }

    private function positionAssets():void {
        this.sidebarGradientOverlay_.x = -10;
        this.sidebarGradientOverlay_.y = this.BG_POSITION.y;
        this.background.x = this.BG_POSITION.x;
        this.background.y = this.BG_POSITION.y;
        this.miniMap.x = this.MAP_POSITION.x;
        this.miniMap.y = this.MAP_POSITION.y;
        if (this.newClassUnlockNotification) {
            this.newClassUnlockNotification.x = this.MAP_POSITION.x;
            this.newClassUnlockNotification.y = this.MAP_POSITION.y;
        }
        this.tabStrip.x = this.TAB_STRIP_POSITION.x;
        this.tabStrip.y = this.TAB_STRIP_POSITION.y;
        this.characterDetails.x = this.CHARACTER_DETAIL_PANEL_POSITION.x;
        this.characterDetails.y = this.CHARACTER_DETAIL_PANEL_POSITION.y;
        this.statMeters.x = this.STAT_METERS_POSITION.x;
        this.statMeters.y = this.STAT_METERS_POSITION.y;
    }

    private function createInteractPanel(_arg_1:GameSprite):void {
        this.interactPanel = new InteractPanel(_arg_1, this.player, 200, 100);
        this.interactPanel.x = this.INTERACT_PANEL_POSITION.x;
        this.interactPanel.y = this.INTERACT_PANEL_POSITION.y;
        addChild(this.interactPanel);
    }

    private function createEquippedGrid():void {
        this.equippedGrid = new EquippedGrid(this.player, this.player.slotTypes_, this.player);
        this.equippedGrid.x = this.EQUIPMENT_INVENTORY_POSITION.x;
        this.equippedGrid.y = this.EQUIPMENT_INVENTORY_POSITION.y;
        addChild(this.equippedGrid);
    }

    private function createEquippedGridBackground():void {
        var _local1:* = undefined;
        var _local3:GraphicsSolidFill = new GraphicsSolidFill(0x676767, 1);
        var _local2:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        _local1 = new <IGraphicsData>[_local3, _local2, GraphicsUtil.END_FILL];
        GraphicsUtil.drawCutEdgeRect(0, 0, 178, 46, 6, [1, 1, 1, 1], _local2);
        this.equippedGridBG = new Sprite();
        this.equippedGridBG.x = this.EQUIPMENT_INVENTORY_POSITION.x - 3;
        this.equippedGridBG.y = this.EQUIPMENT_INVENTORY_POSITION.y - 3;
        this.equippedGridBG.graphics.drawGraphicsData(_local1);
        addChild(this.equippedGridBG);
    }

    private function setNonTradePanelAssetsVisible(_arg_1:Boolean):void {
        this.characterDetails.visible = _arg_1;
        this.statMeters.visible = _arg_1;
        this.tabStrip.visible = _arg_1;
        this.equippedGrid.visible = _arg_1;
        this.equippedGridBG.visible = _arg_1;
        this.interactPanel.visible = _arg_1;
    }

    private function removeTradePanel():void {
        if (this.tradePanel) {
            SpriteUtil.safeRemoveChild(this, this.tradePanel);
            this.tradePanel.removeEventListener("cancel", this.onTradeCancel);
            this.tradePanel = null;
            this.setNonTradePanelAssetsVisible(true);
        }
    }

    private function onTradeCancel(_arg_1:Event):void {
        this.removeTradePanel();
    }
}
}
