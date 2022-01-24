package com.company.assembleegameclient.game {
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.Character;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.IInteractiveObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Pet;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Projectile;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.GuildText;
import com.company.assembleegameclient.ui.RankText;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.assembleegameclient.ui.menu.PlayerMenu;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.TileRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.CachingColorTransformer;
import com.company.util.Hit;
import com.company.util.MoreColorUtil;
import com.company.util.MoreObjectUtil;
import com.company.util.PointUtil;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import io.decagames.rotmg.seasonalEvent.SeasonalLeaderBoard.SeasonalLeaderBoardButton;
import io.decagames.rotmg.seasonalEvent.buttons.SeasonalInfoButton;
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.arena.view.ArenaTimer;
import kabam.rotmg.arena.view.ArenaWaveCounter;
import kabam.rotmg.chat.view.Chat;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.MapModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.view.Layers;
import kabam.rotmg.dailyLogin.signal.ShowDailyCalendarPopupSignal;
import kabam.rotmg.dailyLogin.view.DailyLoginModal;
import kabam.rotmg.dialogs.control.AddPopupToStartupQueueSignal;
import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.dialogs.model.DialogsModel;
import kabam.rotmg.game.model.QuestModel;
import kabam.rotmg.game.view.CreditDisplay;
import kabam.rotmg.game.view.GiftStatusDisplay;
import kabam.rotmg.game.view.NewsModalButton;
import kabam.rotmg.game.view.RealmQuestsDisplay;
import kabam.rotmg.game.view.ShopDisplay;
import kabam.rotmg.messaging.impl.GameServerConnectionConcrete;
import kabam.rotmg.messaging.impl.incoming.MapInfo;
import kabam.rotmg.news.model.NewsModel;
import kabam.rotmg.news.view.NewsTicker;
import kabam.rotmg.packages.services.PackageModel;
import kabam.rotmg.promotions.model.BeginnersPackageModel;
import kabam.rotmg.promotions.signals.ShowBeginnersPackageSignal;
import kabam.rotmg.promotions.view.BeginnersPackageButton;
import kabam.rotmg.promotions.view.SpecialOfferButton;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.stage3D.Renderer;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
import kabam.rotmg.ui.view.HUDView;

import org.osflash.signals.Signal;

public class GameSprite extends AGameSprite {

    public static const NON_COMBAT_MAPS:Vector.<String> = new <String>["Nexus", "Vault", "Guild Hall", "Cloth Bazaar", "Nexus Explanation", "Daily Quest Room"];

    public static const DISPLAY_AREA_Y_SPACE:int = 32;

    protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);


    protected const EMPTY_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0);

    public const monitor:Signal = new Signal(String, int);

    public const modelInitialized:Signal = new Signal();

    public const drawCharacterWindow:Signal = new Signal(Player);

    public const nexusFountains:Point = new Point(129.5, 116.5);

    public const nexusRealms:Point = new Point(nexusFountains.x, nexusFountains.y - 18);

    public const nexusHallway:Point = new Point(nexusFountains.x, nexusFountains.y - 10);

    public const vaultFountain:Point = new Point(56, 67.1);

    public static function toTimeCode_HOWDIDIBREAKTHIS(_arg_1:Number):String {
        var _local4:int = _arg_1 * 0.001;
        var _local2:int = Math.floor(_local4 % 60);
        var _local3:String = !!(Math.round(Math.floor(_local4 * 0.0166666666666667)) + ":" + (_local2 < 10)) ? "0" + _local2 : String(_local2);
        return _local3;
    }

    public static function toTimeCode(_arg_1:Number):String {
        var _local2:int = Math.floor(_arg_1 * 0.001 % 60);
        var _local6:String = _local2 < 10 ? "0" + _local2 : String(_local2);
        var _local5:int = Math.round(Math.floor(_arg_1 * 0.001 * 0.0166666666666667));
        var _local4:String = String(_local5);
        var _local3:String = _local4 + ":" + _local6;
        return _local3;
    }

    public function GameSprite(_arg_1:Server, _arg_2:int, _arg_3:Boolean, _arg_4:int, _arg_5:int, _arg_6:ByteArray, _arg_7:PlayerModel, _arg_8:String, _arg_9:Boolean) {
        showPackage = new Signal();
        currentPackage = new Sprite();
        super();
        this.model = _arg_7;
        map = new Map(this);
        addChild(map);
        gsc_ = new GameServerConnectionConcrete(this, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_8, _arg_9);
        mui_ = new MapUserInput(this);
        this.chatBox_ = new Chat();
        this.chatBox_.list.addEventListener("mouseDown", this.onChatDown, false, 0, true);
        this.chatBox_.list.addEventListener("mouseUp", this.onChatUp, false, 0, true);
        addChild(this.chatBox_);
        this.hitQueue.length = 0;
    }
    public var chatBox_:Chat;
    public var isNexus_:Boolean = false;
    public var idleWatcher_:IdleWatcher;
    public var rankText_:RankText;
    public var guildText_:GuildText;
    public var shopDisplay:ShopDisplay;
    public var challengerLeaderBoard:SeasonalLeaderBoardButton;
    public var challengerInfoButton:SeasonalInfoButton;
    public var creditDisplay_:CreditDisplay;
    public var realmQuestsDisplay:RealmQuestsDisplay;
    public var giftStatusDisplay:GiftStatusDisplay;
    public var newsModalButton:NewsModalButton;
    public var newsTicker:NewsTicker;
    public var arenaTimer:ArenaTimer;
    public var arenaWaveCounter:ArenaWaveCounter;
    public var mapModel:MapModel;
    public var beginnersPackageModel:BeginnersPackageModel;
    public var dialogsModel:DialogsModel;
    public var showBeginnersPackage:ShowBeginnersPackageSignal;
    public var openDailyCalendarPopupSignal:ShowDailyCalendarPopupSignal;
    public var openDialog:OpenDialogSignal;
    public var showPackage:Signal;
    public var packageModel:PackageModel;
    public var addToQueueSignal:AddPopupToStartupQueueSignal;
    public var flushQueueSignal:FlushPopupStartupQueueSignal;
    public var showHideKeyUISignal:ShowHideKeyUISignal;
    public var chatPlayerMenu:PlayerMenu;
    public var packageOffer:BeginnersPackageButton;
    public var questBar:StatusBar;
    public var stats:TextFieldDisplayConcrete;
    public var statsStringBuilder:StaticStringBuilder;
    private var focus:GameObject;
    private var frameTimeSum_:int = 0;
    private var frameTimeCount_:int = 0;
    private var isGameStarted:Boolean;
    private var displaysPosY:uint = 4;
    private var currentPackage:DisplayObject;
    private var packageY:Number;
    private var specialOfferButton:SpecialOfferButton;
    private var timerCounter:TextFieldDisplayConcrete;
    private var timerCounterStringBuilder:StaticStringBuilder;
    private var enemyCounter:TextFieldDisplayConcrete;
    private var enemyCounterStringBuilder:StaticStringBuilder;
    private var lastUpdateInteractiveTime:int = 0;
    private var lastCalcTime:int = -2147483648;
    private var questModel:QuestModel;
    private var seasonalEventModel:SeasonalEventModel;
    private var mapName:String;

    override public function setFocus(_arg_1:GameObject):void {
        _arg_1 = _arg_1 || map.player_;
        this.focus = _arg_1;
    }

    override public function applyMapInfo(_arg_1:MapInfo):void {
        map.setProps(_arg_1.width_, _arg_1.height_, _arg_1.name_, _arg_1.background_, _arg_1.allowPlayerTeleport_, _arg_1.showDisplays_);
        Parameters.savingMap_ = false;
    }

    override public function initialize():void {
        this.questModel = StaticInjectorContext.getInjector().getInstance(QuestModel);
        this.seasonalEventModel = StaticInjectorContext.getInjector().getInstance(SeasonalEventModel);
        this.map.initialize();
        this.modelInitialized.dispatch();
        var _local4:String = this.map.name_;
        this.mapName = _local4;
        this.showHideKeyUISignal.dispatch(_local4 == "Davy Jones\' Locker");
        this.isNexus_ = _local4 == "Nexus";
        this.map.isTrench = this.map.name_ == "Ocean Trench";
        this.map.isRealm = _local4 == "Realm of the Mad God";
        this.map.isVault = _local4 == "Vault";
        var _local5:Vector.<String> = new <String>["Nexus", "Vault", "Guild Hall", "Guild Hall 2", "Guild Hall 3", "Guild Hall 4", "Guild Hall 5", "Cloth Bazaar", "Nexus Explanation", "Daily Quest Room", "Daily Login Room", "Pet Yard", "Pet Yard 2", "Pet Yard 3", "Pet Yard 4", "Pet Yard 5"];
        this.isSafeMap = _local5.indexOf(_local4) != -1;
        if (this.isSafeMap) {
            this.showSafeAreaDisplays();
            if (Parameters.dailyCalendar1RunOnce) {
                this.gsc_.gotoQuestRoom();
                Parameters.dailyCalendar1RunOnce = false;
            }
        } else {
            this.addQuestBar();
        }
        if (_local4 == "Arena") {
            this.showTimer();
            this.showWaveCounter();
        }
        var _local3:Account = StaticInjectorContext.getInjector().getInstance(Account);
        this.creditDisplay_ = new CreditDisplay(this, true);
        this.creditDisplay_.x = 594;
        this.creditDisplay_.y = 0;
        if (!this.isSafeMap) {
            this.creditDisplay_.mouseEnabled = false;
            this.creditDisplay_.mouseChildren = false;
        }
        addChild(this.creditDisplay_);
        if (!isSafeMap && this.canShowRealmQuestDisplay(this.mapName)) {
            this.realmQuestsDisplay = new RealmQuestsDisplay(map);
            this.realmQuestsDisplay.x = 10;
            this.realmQuestsDisplay.y = 10;
            addChild(this.realmQuestsDisplay);
            gsc_.playerText("/server");
        } else {
            this.questModel.previousRealm = "";
        }
        var _local2:AppEngineClient = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        var _local1:Object = {
            "game_net_user_id": _local3.gameNetworkUserId(),
            "game_net": _local3.gameNetwork(),
            "play_platform": _local3.playPlatform()
        };
        MoreObjectUtil.addToObject(_local1, _local3.getCredentials());
        if (_local4 == "Daily Quest Room") {
            this.gsc_.questFetch();
        } else if (_local4 == "Cloth Bazaar") {
            Parameters.timerActive = true;
            Parameters.phaseName = "Portal Entry";
            Parameters.phaseChangeAt = getTimer() + 500 * 60;
        }
        map.setHitAreaProps(map.width, map.height);
        Parameters.save();
        this.parent.parent.setChildIndex((this.parent.parent as Layers).top, 2);
        stage.dispatchEvent(new Event("resize"));
        if (Parameters.data.perfStats) {
            if (Parameters.data.liteMonitor) {
                addStats();
                statsStart = getTimer();
                stage.dispatchEvent(new Event("resize"));
            } else {
                this.addChild(MapUserInput.stats_);
                this.gsc_.enableJitterWatcher();
                this.gsc_.jitterWatcher_.y = MapUserInput.stats_.height;
                this.addChild(this.gsc_.jitterWatcher_);
            }
        }
    }

    override public function fixFullScreen():void {
        stage.scaleMode = "noScale";
    }

    override public function evalIsNotInCombatMapArea():Boolean {
        return NON_COMBAT_MAPS.indexOf(map.name_) != -1;
    }

    override public function showDailyLoginCalendar():void {
        this.openDialog.dispatch(new DailyLoginModal());
    }

    public function addChatPlayerMenu(_arg_1:Player, _arg_2:Number, _arg_3:Number, _arg_4:String = null, _arg_5:Boolean = false, _arg_6:Boolean = false):void {
        this.removeChatPlayerMenu();
        this.chatPlayerMenu = new PlayerMenu();
        if (_arg_4 == null) {
            this.chatPlayerMenu.init(this, _arg_1);
        } else if (_arg_6) {
            this.chatPlayerMenu.initDifferentServer(this, _arg_4, _arg_5, _arg_6);
        } else {
            if (_arg_4.length > 0 && (_arg_4.charAt(0) == "#" || _arg_4.charAt(0) == "*" || _arg_4.charAt(0) == "@")) {
                return;
            }
            this.chatPlayerMenu.initDifferentServer(this, _arg_4, _arg_5);
        }
        addChild(this.chatPlayerMenu);
        chatMenuPositionFixed();
    }

    public function removeChatPlayerMenu():void {
        if (this.chatPlayerMenu && this.chatPlayerMenu.parent) {
            removeChild(this.chatPlayerMenu);
            this.chatPlayerMenu = null;
        }
    }

    public function hudModelInitialized():void {
        if (hudView) {
            hudView.dispose();
        }
        hudView = new HUDView();
        hudView.x = 10 * 60;
        addChild(hudView);
        if (!Parameters.data.mapHack) {
            return;
        }
        if (Parameters.needsMapCheck == 2) {
            this.hudView.miniMap.setFullMap(this.map.name_);
        }
    }

    public function addStats():void {
        if (this.stats == null) {
            this.stats = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff);
            this.stats.mouseChildren = false;
            this.stats.mouseEnabled = false;
            this.statsStringBuilder = new StaticStringBuilder("FPS -1\nLAT -1\nMEM -1");
            this.stats.setStringBuilder(this.statsStringBuilder);
            this.stats.filters = [EMPTY_FILTER];
            this.stats.setBold(true);
            this.stats.x = 5;
            this.stats.y = 5;
            addChild(this.stats);
            stage.dispatchEvent(new Event("resize"));
        }
    }

    public function updateStats(_arg_1:int):void {
        statsFrameNumber = Number(statsFrameNumber) + 1;
        var _local2:int = _arg_1 - statsStart;
        if (_local2 >= 1000) {
            statsFPS = Math.floor(statsFrameNumber / (0.001 * _local2) * 10) * 0.1;
            statsStart = _arg_1;
            statsFrameNumber = 0;
            this.stats.setText("FPS " + statsFPS + "\nLAT " + this.gsc_.pingReceivedAt + "\nMEM " + Math.round(1.0e-6 * System.totalMemoryNumber));
        }
    }

    public function updateEnemyCounter(_arg_1:String):void {
        if (!this.enemyCounter) {
            this.addEnemyCounter();
        }
        this.enemyCounter.visible = true;
        this.enemyCounter.setText(_arg_1);
    }

    public function chatMenuPositionFixed():void {
        var _local2:Number = (stage.mouseX + (stage.stageWidth >> 1) - 400) / stage.stageWidth * 800;
        var _local1:Number = (stage.mouseY + (stage.stageHeight >> 1) - 300) / stage.stageHeight * 600;
        this.chatPlayerMenu.x = _local2;
        this.chatPlayerMenu.y = _local1 - this.chatPlayerMenu.height;
    }

    public function positionDynamicDisplays():void {
        var _local1:NewsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
        var _local2:int = 72;
        if (this.giftStatusDisplay && this.giftStatusDisplay.isOpen) {
            this.giftStatusDisplay.y = _local2;
            _local2 = _local2 + 32;
        }
        if (this.newsModalButton && (NewsModalButton.showsHasUpdate || _local1.hasValidModalNews())) {
            this.newsModalButton.y = _local2;
            _local2 = _local2 + 32;
        }
        if (this.specialOfferButton && this.specialOfferButton.isSpecialOfferAvailable) {
            this.specialOfferButton.y = _local2;
        }
        if (this.newsTicker && this.newsTicker.visible) {
            this.newsTicker.y = _local2;
            _local2 = _local2 + 32;
        }
        this.onScreenResize(null);
    }

    public function refreshNewsUpdateButton():void {
        this.showNewsUpdate(false);
    }

    public function showSpecialOfferIfSafe(_arg_1:Boolean):void {
        if (this.evalIsNotInCombatMapArea()) {
            this.specialOfferButton = new SpecialOfferButton(_arg_1);
            this.specialOfferButton.x = 6;
            addChild(this.specialOfferButton);
            this.positionDynamicDisplays();
        }
    }

    public function showPackageButtonIfSafe():void {
        if (this.isSafeMap) {
        }
    }

    public function connect():void {
        if (!this.isGameStarted) {
            this.isGameStarted = true;
            Parameters.data.noClip = false;
            Renderer.inGame = true;
            this.newsModalButton = null;
            this.questBar = null;
            gsc_.connect();
            lastUpdate_ = getTimer();
            statsStart = -1;
            statsFrameNumber = -1;
            stage.addEventListener("MONEY_CHANGED", this.onMoneyChanged, false, 0, true);
            stage.addEventListener("enterFrame", this.onEnterFrame, false, 0, true);
            stage.addEventListener("activate", this.onFocusIn, false, 0, true);
            stage.addEventListener("deactivate", this.onFocusOut, false, 0, true);
            this.parent.parent.setChildIndex((this.parent.parent as Layers).top, 0);
            stage.scaleMode = "noScale";
            stage.addEventListener("resize", this.onScreenResize, false, 0, true);
            stage.dispatchEvent(new Event("resize"));
        }
    }

    public function disconnect():void {
        if (this.isGameStarted) {
            this.isGameStarted = false;
            Renderer.inGame = false;
            stage.removeEventListener("MONEY_CHANGED", this.onMoneyChanged);
            stage.removeEventListener("enterFrame", this.onEnterFrame);
            stage.removeEventListener("activate", this.onFocusIn);
            stage.removeEventListener("deactivate", this.onFocusOut);
            stage.removeEventListener("resize", this.onScreenResize);
            stage.scaleMode = "exactFit";
            stage.dispatchEvent(new Event("resize"));
            contains(map) && removeChild(map);
            if (hudView) {
                hudView.dispose();
            }
            map.dispose();
            CachingColorTransformer.clear();
            TextureRedrawer.clearCache();
            TileRedrawer.clearCache();
            GlowRedrawer.clearCache();
            Projectile.dispose();
            this.newsModalButton = null;
            this.questBar = null;
            if (this.timerCounter && !(Parameters.phaseName == "Realm Closed" || Parameters.phaseName == "Oryx Shake")) {
                Parameters.timerActive = false;
                this.timerCounter.visible = false;
                this.timerCounter = null;
            }
            if (this.enemyCounter) {
                this.enemyCounter.visible = false;
                this.enemyCounterStringBuilder = null;
                this.enemyCounter = null;
            }
            Parameters.followPlayer = null;
            Parameters.player = null;
            gsc_.disconnect();
            System.pauseForGCIfCollectionImminent(0);
        }
    }

    public function showPetToolTip(_arg_1:Boolean):void {
    }

    private function addQuestBar():void {
        this.questBar = new StatusBar(10 * 60, 15, 0xFFFFFFFF, 0xFF5C1D1D, "Quest!", true);
        this.questBar.x = 0;
        this.questBar.y = 0;
        this.questBar.visible = false;
        addChild(this.questBar);
    }

    private function updateQuestBar():void {
        var _local1:GameObject = this.map.quest_.getObject(0);
        if (_local1 == null) {
            this.questBar.visible = false;
            return;
        }
        this.questBar.visible = true;
        if (this.questBar.quest == null || _local1.objectId_ != this.questBar.quest.objectId_) {
            this.questBar.quest = _local1;
        }
        this.questBar.setLabelText("(" + int(Parameters.dmgCounter[_local1.objectId_] / _local1.maxHP_ * 100) + "%) " + ObjectLibrary.typeToDisplayId_[_local1.objectType_]);
        this.questBar.color_ = Character.green2red(this.questBar.quest.hp_ * 100 / this.questBar.quest.maxHP_);
        this.questBar.draw(_local1.hp_, _local1.maxHP_, 0);
    }

    private function addTimer():void {
        if (this.timerCounter == null) {
            this.timerCounter = new TextFieldDisplayConcrete().setSize(Parameters.data.uiTextSize).setColor(0xffffff);
            this.timerCounter.mouseChildren = false;
            this.timerCounter.mouseEnabled = false;
            this.timerCounter.setBold(true);
            this.timerCounterStringBuilder = new StaticStringBuilder("0:00");
            this.timerCounter.setStringBuilder(this.timerCounterStringBuilder);
            this.timerCounter.filters = [EMPTY_FILTER];
            this.timerCounter.x = 3;
            this.timerCounter.y = 3 * 60;
            addChild(this.timerCounter);
            stage.dispatchEvent(new Event("resize"));
        }
    }

    private function addEnemyCounter():void {
        if (this.enemyCounter == null) {
            this.enemyCounter = new TextFieldDisplayConcrete().setSize(Parameters.data.uiTextSize).setColor(0xffffff);
            this.enemyCounter.mouseChildren = false;
            this.enemyCounter.mouseEnabled = false;
            this.enemyCounter.setBold(true);
            this.enemyCounterStringBuilder = new StaticStringBuilder("0");
            this.enemyCounter.setStringBuilder(this.enemyCounterStringBuilder);
            this.enemyCounter.filters = [EMPTY_FILTER];
            this.enemyCounter.x = 3;
            this.enemyCounter.y = 160;
            addChild(this.enemyCounter);
            stage.dispatchEvent(new Event("resize"));
        }
    }

    private function updateTimer(_arg_1:int):void {
        this.timerCounter.setText(Parameters.phaseName + "\n" + toTimeCode(Parameters.phaseChangeAt - _arg_1));
        if (!this.timerCounter.visible) {
            this.timerCounter.visible = true;
            stage.dispatchEvent(new Event("resize"));
        }
    }

    private function fadeRed(_arg_1:Number):uint {
        if (_arg_1 > 100) {
            _arg_1 = 100;
        }
        var _local3:int = 255 * _arg_1;
        var _local4:* = _local3 << 8;
        var _local5:* = _local3;
        return 16711680 | _local4 | _local5;
    }

    private function canShowRealmQuestDisplay(_arg_1:String):Boolean {
        var _local2:Boolean = false;
        if (_arg_1 == "Realm of the Mad God") {
            this.questModel.previousRealm = _arg_1;
            this.questModel.requirementsStates[1] = false;
            this.questModel.remainingHeroes = -1;
            if (this.questModel.hasOryxBeenKilled) {
                this.questModel.hasOryxBeenKilled = false;
                this.questModel.resetRequirementsStates();
            }
            _local2 = true;
        } else if (this.questModel.previousRealm == "Realm of the Mad God" && _arg_1.indexOf("Oryx") != -1) {
            this.questModel.requirementsStates[1] = true;
            this.questModel.remainingHeroes = 0;
            _local2 = true;
        }
        return _local2;
    }

    private function showSafeAreaDisplays():void {
        this.showRankText();
        this.showGuildText();
        if (this.seasonalEventModel.isChallenger == 1) {
            this.showChallengerInfoButton();
        } else {
            this.showShopDisplay();
        }
        this.showChallengerLeaderBoardButton();
        this.setYAndPositionPackage();
        this.showGiftStatusDisplay();
        this.showNewsUpdate();
        this.showNewsTicker();
    }

    private function showChallengerLeaderBoardButton():void {
        this.challengerLeaderBoard = new SeasonalLeaderBoardButton();
        this.challengerLeaderBoard.x = 594 - this.challengerLeaderBoard.width;
        this.challengerLeaderBoard.y = 40;
        addChild(this.challengerLeaderBoard);
    }

    private function showChallengerInfoButton():void {
        this.challengerInfoButton = new SeasonalInfoButton();
        this.challengerInfoButton.x = 594 - this.challengerInfoButton.width;
        this.challengerInfoButton.y = 80;
        addChild(this.challengerInfoButton);
    }

    private function setDisplayPosY(_arg_1:Number):void {
        var _local2:Number = 28 * _arg_1;
        if (_arg_1 != 0) {
            this.displaysPosY = 4 + _local2;
        } else {
            this.displaysPosY = 2;
        }
    }

    private function showTimer():void {
        this.arenaTimer = new ArenaTimer();
        this.arenaTimer.y = 5;
        addChild(this.arenaTimer);
    }

    private function showWaveCounter():void {
        this.arenaWaveCounter = new ArenaWaveCounter();
        this.arenaWaveCounter.y = 5;
        this.arenaWaveCounter.x = 5;
        addChild(this.arenaWaveCounter);
    }

    private function showNewsTicker():void {
        this.newsTicker = new NewsTicker();
        this.newsTicker.x = 300 - this.newsTicker.width / 2;
        addChild(this.newsTicker);
        this.positionDynamicDisplays();
    }

    private function showGiftStatusDisplay():void {
        this.giftStatusDisplay = new GiftStatusDisplay();
        this.giftStatusDisplay.x = 6;
        addChild(this.giftStatusDisplay);
        this.positionDynamicDisplays();
    }

    private function showShopDisplay():void {
        this.shopDisplay = new ShopDisplay(map.name_ == "Nexus");
        this.shopDisplay.x = 6;
        this.shopDisplay.y = 40;
        addChild(this.shopDisplay);
    }

    private function showNewsUpdate(_arg_1:Boolean = true):void {
        var _local2:* = null;
        var _local3:NewsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
        if (_local3.hasValidModalNews()) {
            _local2 = new NewsModalButton();
            if (this.newsModalButton) {
                return;
            }
            this.newsModalButton = _local2;
            addChild(this.newsModalButton);
            stage.dispatchEvent(new Event("resize"));
        }
    }

    private function setYAndPositionPackage():void {
        this.packageY = this.displaysPosY + 2;
        this.displaysPosY = this.displaysPosY + 28;
        this.positionPackage();
    }

    private function addAndPositionPackage(_arg_1:DisplayObject):void {
        this.currentPackage = _arg_1;
        addChild(this.currentPackage);
        this.positionPackage();
    }

    private function positionPackage():void {
        this.currentPackage.x = 80;
        this.setDisplayPosY(1);
        this.currentPackage.y = this.displaysPosY;
    }

    private function showGuildText():void {
        this.guildText_ = new GuildText("", -1);
        this.guildText_.x = 76;
        this.setDisplayPosY(0);
        this.guildText_.y = this.displaysPosY;
        addChild(this.guildText_);
    }

    private function showRankText():void {
        this.rankText_ = new RankText(-1, true, false);
        this.rankText_.x = 8;
        this.setDisplayPosY(0);
        addChild(this.rankText_);
    }

    private function updateNearestInteractive():void {
        var _local8:Number = NaN;
        var _local3:Number = NaN;
        var _local4:Number = NaN;
        var _local10:* = null;
        var _local11:* = null;
        var _local6:* = null;
        if (!map || !map.player_) {
            return;
        }
        var _local1:Player = map.player_;
        var _local7:* = 1;
        var _local9:Number = _local1.x_;
        var _local2:Number = _local1.y_;
        var _local13:int = 0;
        var _local12:* = map.goDict_;
        for each(_local11 in map.goDict_) {
            _local6 = _local11;
            if (_local6 is IInteractiveObject && (!(_local6 is Pet) || this.map.isPetYard)) {
                _local8 = _local11.x_;
                _local3 = _local11.y_;
                if (Math.abs(_local9 - _local8) < 1 || Math.abs(_local2 - _local3) < 1) {
                    _local4 = PointUtil.distanceSquaredXY(_local8, _local3, _local9, _local2);
                    if (_local4 < 1 && _local4 < _local7) {
                        _local7 = _local4;
                        _local10 = _local6;
                    }
                }
            }
        }
        this.mapModel.currentInteractiveTarget = _local10 as IInteractiveObject;
        if (_local10 == null) {
            this.mapModel.currentInteractiveTargetObjectId = -1;
        } else {
            this.mapModel.currentInteractiveTargetObjectId = _local10.objectId_;
        }
    }

    public function onChatDown(event:MouseEvent):void {
        if (this.chatPlayerMenu != null) {
            this.removeChatPlayerMenu();
        }
        mui_.onMouseDown(event);
    }

    public function onChatUp(event: MouseEvent):void {
        mui_.onMouseUp(event);
    }

    public function onScreenResize(event: Event):void {
        var _local4:Number = NaN;
        var scaleUI:Boolean = Parameters.data.uiscale;
        var widthScale:Number = 800 / stage.stageWidth;
        var heightScale:Number = 600 / stage.stageHeight;
        var aspectRatio:Number = widthScale / heightScale;
        if (this.map) {
            this.map.scaleX = widthScale * Parameters.data.mscale;
            this.map.scaleY = heightScale * Parameters.data.mscale;
            this.map.mapHitArea.scaleX = 1 / this.map.scaleX;
            this.map.mapHitArea.scaleY = 1 / this.map.scaleY;
        }
        if (this.timerCounter) {
            if (scaleUI) {
                this.timerCounter.scaleX = aspectRatio;
                this.timerCounter.scaleY = 1;
                this.timerCounter.y = 3 * 60;
            } else {
                this.timerCounter.scaleX = widthScale;
                this.timerCounter.scaleY = heightScale;
            }
        }
        if (this.enemyCounter) {
            if (scaleUI) {
                this.enemyCounter.scaleX = aspectRatio;
                this.enemyCounter.scaleY = 1;
                this.enemyCounter.y = 160;
            } else {
                this.enemyCounter.scaleX = widthScale;
                this.enemyCounter.scaleY = heightScale;
            }
        }
        if (this.stats) {
            if (scaleUI) {
                this.stats.scaleX = aspectRatio;
                this.stats.scaleY = 1;
                this.stats.y = 5;
            } else {
                this.stats.scaleX = widthScale;
                this.stats.scaleY = heightScale;
            }
            this.stats.x = 5 * this.stats.scaleX;
            this.stats.y = 5 * this.stats.scaleY;
        }
        if (this.questBar) {
            if (scaleUI) {
                this.questBar.scaleX = aspectRatio;
                this.questBar.scaleY = 1;
            } else {
                this.questBar.scaleX = widthScale;
                this.questBar.scaleY = heightScale;
            }
        }
        if (this.hudView) {
            if (scaleUI) {
                this.hudView.scaleX = aspectRatio;
                this.hudView.scaleY = 1;
                this.hudView.y = 0;
            } else {
                this.hudView.scaleX = widthScale;
                this.hudView.scaleY = heightScale;
                this.hudView.y = 300 * (1 - heightScale);
            }
            this.hudView.x = 800 - 200 * this.hudView.scaleX;
            if (this.creditDisplay_) {
                this.creditDisplay_.x = this.hudView.x - 6 * this.creditDisplay_.scaleX;
            }
        }
        if (this.chatBox_) {
            if (scaleUI) {
                this.chatBox_.scaleX = aspectRatio;
                this.chatBox_.scaleY = 1;
            } else {
                this.chatBox_.scaleX = widthScale;
                this.chatBox_.scaleY = heightScale;
            }
            this.chatBox_.y = 5 * 60 + 300 * (1 - this.chatBox_.scaleY);
        }
        if (this.rankText_) {
            if (scaleUI) {
                this.rankText_.scaleX = aspectRatio;
                this.rankText_.scaleY = 1;
            } else {
                this.rankText_.scaleX = widthScale;
                this.rankText_.scaleY = heightScale;
            }
            this.rankText_.x = 8 * this.rankText_.scaleX;
            this.rankText_.y = 2 * this.rankText_.scaleY;
        }
        if (this.guildText_) {
            if (scaleUI) {
                this.guildText_.scaleX = aspectRatio;
                this.guildText_.scaleY = 1;
            } else {
                this.guildText_.scaleX = widthScale;
                this.guildText_.scaleY = heightScale;
            }
            this.guildText_.x = 86 * this.guildText_.scaleX;
            this.guildText_.y = 2 * this.guildText_.scaleY;
        }
        if (this.creditDisplay_) {
            if (scaleUI) {
                this.creditDisplay_.scaleX = aspectRatio;
                this.creditDisplay_.scaleY = 1;
            } else {
                this.creditDisplay_.scaleX = widthScale;
                this.creditDisplay_.scaleY = heightScale;
            }
        }
        if (this.shopDisplay) {
            if (scaleUI) {
                this.shopDisplay.scaleX = aspectRatio;
                this.shopDisplay.scaleY = 1;
            } else {
                this.shopDisplay.scaleX = widthScale;
                this.shopDisplay.scaleY = heightScale;
            }
            this.shopDisplay.x = 6 * this.shopDisplay.scaleX;
            this.shopDisplay.y = 40 * this.shopDisplay.scaleY;
        }
        if (this.packageOffer) {
            if (scaleUI) {
                this.packageOffer.scaleX = aspectRatio;
                this.packageOffer.scaleY = 1;
            } else {
                this.packageOffer.scaleX = widthScale;
                this.packageOffer.scaleY = heightScale;
            }
            this.packageOffer.x = 6 * this.packageOffer.scaleX;
            this.packageOffer.y = 31 * this.packageOffer.scaleY;
        }
        var _local5:int = 72;
        if (this.giftStatusDisplay) {
            if (scaleUI) {
                this.giftStatusDisplay.scaleX = aspectRatio;
                this.giftStatusDisplay.scaleY = 1;
            } else {
                this.giftStatusDisplay.scaleX = widthScale;
                this.giftStatusDisplay.scaleY = heightScale;
            }
            this.giftStatusDisplay.x = 6 * this.giftStatusDisplay.scaleX;
            this.giftStatusDisplay.y = _local5 * this.giftStatusDisplay.scaleY;
            _local5 = _local5 + 32;
        }
        if (this.newsModalButton) {
            if (scaleUI) {
                this.newsModalButton.scaleX = aspectRatio;
                this.newsModalButton.scaleY = 1;
            } else {
                this.newsModalButton.scaleX = widthScale;
                this.newsModalButton.scaleY = heightScale;
            }
            this.newsModalButton.x = 6 * this.newsModalButton.scaleX;
            this.newsModalButton.y = _local5 * this.newsModalButton.scaleY;
            _local5 = _local5 + 32;
        }
        if (this.specialOfferButton) {
            if (scaleUI) {
                this.specialOfferButton.scaleX = aspectRatio;
                this.specialOfferButton.scaleY = 1;
            } else {
                this.specialOfferButton.scaleX = widthScale;
                this.specialOfferButton.scaleY = heightScale;
            }
            this.specialOfferButton.x = 6 * this.specialOfferButton.scaleX;
            this.specialOfferButton.y = _local5 * this.specialOfferButton.scaleY;
            _local5 = _local5 + 32;
        }
        if (this.challengerLeaderBoard) {
            if (scaleUI) {
                this.challengerLeaderBoard.scaleX = aspectRatio;
                this.challengerLeaderBoard.scaleY = 1;
            } else {
                this.challengerLeaderBoard.scaleX = widthScale;
                this.challengerLeaderBoard.scaleY = heightScale;
            }
            if (this.challengerLeaderBoard) {
                this.challengerLeaderBoard.x = this.hudView.x - this.challengerLeaderBoard.width - 6;
                this.challengerLeaderBoard.y = 40;
            }
        }
        if (this.challengerInfoButton) {
            if (scaleUI) {
                this.challengerInfoButton.scaleX = aspectRatio;
                this.challengerInfoButton.scaleY = 1;
            } else {
                this.challengerInfoButton.scaleX = widthScale;
                this.challengerInfoButton.scaleY = heightScale;
            }
            if (this.challengerInfoButton) {
                this.challengerInfoButton.x = this.hudView.x - this.challengerInfoButton.width - 6;
                this.challengerInfoButton.y = 80;
            }
        }
    }

    private function onTimerCounterClick(event: MouseEvent):void {
        this.gsc_.playerText(Parameters.phaseName + " time left: " + toTimeCode(Parameters.phaseChangeAt - getTimer()));
    }

    private function onFocusOut(event: Event):void {
        if (Parameters.data.FocusFPS) {
            stage.frameRate = Parameters.data.bgFPS;
        }
    }

    private function onFocusIn(event: Event):void {
        if (Parameters.data.FocusFPS) {
            stage.frameRate = Parameters.data.fgFPS;
        }
    }

    private function onMoneyChanged(event: Event):void {
        gsc_.checkCredits();
    }

    private function onEnterFrame(event: Event):void {
        var _local4:int = 0;
        var _local3:int = 0;
        var _local6:Number = NaN;
        var time:int = getTimer();
        var _local2:int = time - lastUpdate_;
        if (mui_.held) {
            _local4 = WebMain.STAGE.mouseX - mui_.heldX;
            Parameters.data.cameraAngle = mui_.heldAngle + _local4 * 0.0174532925199433;
            if (Parameters.data.tiltCam) {
                _local3 = WebMain.STAGE.mouseY - mui_.heldY;
                mui_.heldY = WebMain.STAGE.mouseY;
                this.camera_.nonPPMatrix_.appendRotation(_local3, Vector3D.X_AXIS, null);
            }
        }
        if (time - this.lastUpdateInteractiveTime > 100) {
            this.lastUpdateInteractiveTime = time;
            this.updateNearestInteractive();
        }
        this.map.update(time, _local2);
        for each (var _local5:Hit in this.hitQueue) {
            this.gsc_.playerHit(_local5.bulletId, _local5.objectId);
            _local5 = null;
        }
        this.hitQueue.length = 0;
        this.camera_.update(_local2);
        if (Parameters.data.showQuestBar && this.questBar) {
            updateQuestBar();
        } else if (this.questBar) {
            this.questBar.visible = false;
        }
        if (Parameters.timerActive && Parameters.data.showTimers) {
            if (this.timerCounter == null) {
                this.addTimer();
            }
            if (time >= Parameters.phaseChangeAt) {
                Parameters.phaseChangeAt = 0x7fffffff;
                Parameters.timerActive = false;
                this.timerCounter.visible = false;
            } else {
                updateTimer(time);
            }
        }
        if (Parameters.data.liteMonitor) {
            if (this.stats) {
                this.updateStats(time);
            }
        }
        if (this.enemyCounter && Parameters.data.showEnemyCounter) {
            this.enemyCounter.visible = true;
        }
        var _local7:Player = map.player_;
        if (this.focus) {
            camera_.configureCamera(this.focus, _local7.isHallucinating);
            map.draw(camera_, time);
        }
        if (_local7) {
            if (Parameters.fameBot) {
                if (map.name_ == "Nexus") {
                    if (Parameters.data.famebotContinue == 2) {
                        if (Parameters.fameWalkSleep_toFountainOrHall == 0) {
                            Parameters.fameWalkSleep_toFountainOrHall = 5000 + RandomUtil.randomRange(-2500, 5000);
                        }
                        if (Parameters.fameWalkSleep_toRealms == 0) {
                            Parameters.fameWalkSleep_toRealms = Parameters.fameWalkSleep_toFountainOrHall + 1000 + RandomUtil.randomRange(0, 2000);
                        }
                        if (Parameters.fameWalkSleep2 == 0) {
                            Parameters.fameWalkSleep2 = Parameters.fameWalkSleep_toRealms + 5000 + RandomUtil.randomRange(-2500, 5000);
                        }
                        if (Parameters.fameWalkSleepStart == 0) {
                            Parameters.fameWalkSleepStart = time;
                        }
                        if (_local7.hp_ < _local7.maxHP_) {
                            if (time - Parameters.fameWalkSleepStart > Parameters.fameWalkSleep_toFountainOrHall) {
                                _local7.followPos.x = nexusFountains.x + Math.cos(time << 4) * 1.9;
                                _local7.followPos.y = nexusFountains.y + Math.sin(time << 2);
                            }
                        } else if (_local7.y_ > nexusRealms.y + 7 + Math.sin(time / 100) * 3) {
                            _local7.followPos.x = nexusRealms.x + Math.cos(time / 100) * 1.6;
                            _local7.followPos.y = nexusRealms.y + Math.sin(time / 100) * 2.6;
                        } else if (Parameters.fameBotPortal) {
                            _local6 = _local7.getDistSquared(_local7.x_, _local7.y_, Parameters.fameBotPortal.x_, Parameters.fameBotPortal.y_);
                            if (_local6 <= 1 && Parameters.fameBotPortal.active_) {
                                this.gsc_.usePortal(Parameters.fameBotPortalId);
                            } else if (_local6 <= 100) {
                                _local7.followPos.x = Parameters.fameBotPortalPoint.x;
                                _local7.followPos.y = Parameters.fameBotPortalPoint.y;
                            }
                        } else if (time - Parameters.fameWalkSleepStart > Parameters.fameWalkSleep_toFountainOrHall) {
                            if (_local7.getDistSquared(_local7.x_, _local7.y_, _local7.followPos.x, _local7.followPos.y) >= 29) {
                                _local7.followPos.x = nexusHallway.x + Math.cos(time << 4) * 1.5;
                                _local7.followPos.y = nexusHallway.y + Math.sin(time << 2) * 5;
                            } else {
                                Parameters.fameWalkSleep_toFountainOrHall = 0x7fffffff;
                            }
                        } else if (time - Parameters.fameWalkSleepStart > Parameters.fameWalkSleep_toRealms) {
                            if (_local7.getDistSquared(_local7.x_, _local7.y_, _local7.followPos.x, _local7.followPos.y) >= 1) {
                                _local7.followPos.x = nexusRealms.x + Math.cos(time << 4);
                                _local7.followPos.y = nexusRealms.y + Math.sin(time << 2);
                            } else {
                                Parameters.fameWalkSleep_toFountainOrHall = 0x7fffffff;
                                _local7.textNotification("Pick a Realm!", 0xff0000, 0);
                            }
                        }
                    } else if (Parameters.data.famebotContinue == 1 && _local7.hp_ < _local7.maxHP_) {
                        _local7.followPos.x = nexusFountains.x + Math.cos(time << 4);
                        _local7.followPos.y = nexusFountains.y;
                    } else if (Parameters.data.famebotContinue == 1 && this.gsc_.lastTickId_ > 2) {
                        if (Parameters.reconRealm) {
                            this.dispatchEvent(Parameters.reconRealm);
                        } else {
                            Parameters.reconNexus.gameId_ = -3;
                            this.dispatchEvent(Parameters.reconNexus);
                            Parameters.reconNexus.gameId_ = -2;
                        }
                        return;
                    }
                } else if (map.name_ == "Vault") {
                    if (_local7.hp_ < _local7.maxHP_) {
                        _local7.followPos.x = vaultFountain.x;
                        _local7.followPos.y = vaultFountain.y;
                    } else if (Parameters.data.famebotContinue == 2) {
                        if (Parameters.data.vaultOnly) {
                            if (Parameters.fameWaitNTTime == 0) {
                                Parameters.fameWaitNTTime = 60 * 1000 + RandomUtil.randomRange(-5000, 34000);
                            }
                            if (Parameters.fameWaitStartTime == 0) {
                                Parameters.fameWaitStartTime = time;
                            }
                            _local7.textNotification("Waiting " + int(Parameters.fameWaitNTTime / 1000) + " seconds to \"/nexustutorial\"", 0x3030ff, 0);
                            if (time - Parameters.fameWaitStartTime > Parameters.fameWaitNTTime) {
                                this.dispatchEvent(Parameters.reconRealm);
                                Parameters.fameWaitNTTime = 0;
                                Parameters.fameWaitStartTime = 0;
                            }
                        } else {
                            this.dispatchEvent(Parameters.reconNexus);
                        }
                    } else if (Parameters.data.famebotContinue == 1 && this.gsc_.lastTickId_ > 2) {
                        this.dispatchEvent(Parameters.reconRealm);
                        return;
                    }
                } else {
                    if (time - lastCalcTime >= Parameters.data.fameCheckMS) {
                        _local7.followPos = _local7.calcFollowPos();
                        lastCalcTime = time;
                    }
                    if (time - _local7.lastTpTime_ > Parameters.data.fameTpCdTime && _local7.getDistSquared(_local7.x_, _local7.y_, _local7.followPos.x, _local7.followPos.y) > Parameters.data.teleDistance) {
                        _local7.lastTpTime_ = time;
                        _local7.teleToClosestPoint(_local7.followPos);
                    }
                }
            } else if (Parameters.followPlayer) {
                _local7.followPos.x = Parameters.followPlayer.x_;
                _local7.followPos.y = Parameters.followPlayer.y_;
            }
            this.drawCharacterWindow.dispatch(_local7);
            if (Parameters.data.showFameGoldRealms) {
                this.creditDisplay_.visible = true;
                if (this.isSafeMap) {
                    this.rankText_.draw(_local7.numStars_, _local7.starsBg_);
                    this.guildText_.draw(_local7.guildName_, _local7.guildRank_);
                    this.creditDisplay_.draw(_local7.credits_, _local7.fame_, _local7.tokens_);
                } else {
                    this.creditDisplay_.draw(_local7.credits_, _local7.fame_, _local7.tokens_);
                }
            } else if (this.isSafeMap) {
                this.rankText_.draw(_local7.numStars_, _local7.starsBg_);
                this.guildText_.draw(_local7.guildName_, _local7.guildRank_);
                this.creditDisplay_.draw(_local7.credits_, _local7.fame_, _local7.tokens_);
            } else {
                this.creditDisplay_.visible = false;
            }
            if (_local7.isPaused) {
                map.mouseEnabled = false;
                map.mouseChildren = false;
                hudView.filters = [PAUSED_FILTER];
                hudView.mouseEnabled = false;
                hudView.mouseChildren = false;
            } else if (map.filters.length > 0 || hudView.filters.length > 0) {
                map.filters = [];
                map.mouseEnabled = true;
                map.mouseChildren = true;
                hudView.filters = [];
                hudView.mouseEnabled = true;
                hudView.mouseChildren = true;
            }
            moveRecords_.addRecord(time, _local7.x_, _local7.y_);
        }
        lastUpdate_ = time;
    }
}
}
