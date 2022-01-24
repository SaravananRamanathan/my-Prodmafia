package kabam.rotmg.messaging.impl {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.game.MoveRecords;
import com.company.assembleegameclient.game.events.GuildResultEvent;
import com.company.assembleegameclient.game.events.KeyInfoResponseSignal;
import com.company.assembleegameclient.game.events.NameResultEvent;
import com.company.assembleegameclient.game.events.ReconnectEvent;
import com.company.assembleegameclient.map.AbstractMap;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.objects.FlashDescription;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Merchant;
import com.company.assembleegameclient.objects.NameChanger;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Pet;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.objects.Projectile;
import com.company.assembleegameclient.objects.ProjectileProperties;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.objects.StatusFlashDescription;
import com.company.assembleegameclient.objects.particles.AOEEffect;
import com.company.assembleegameclient.objects.particles.BurstEffect;
import com.company.assembleegameclient.objects.particles.CircleTelegraph;
import com.company.assembleegameclient.objects.particles.CollapseEffect;
import com.company.assembleegameclient.objects.particles.ConeBlastEffect;
import com.company.assembleegameclient.objects.particles.FlowEffect;
import com.company.assembleegameclient.objects.particles.GildedEffect;
import com.company.assembleegameclient.objects.particles.HealEffect;
import com.company.assembleegameclient.objects.particles.HolyBeamEffect;
import com.company.assembleegameclient.objects.particles.InspireEffect;
import com.company.assembleegameclient.objects.particles.LightningEffect;
import com.company.assembleegameclient.objects.particles.LineEffect;
import com.company.assembleegameclient.objects.particles.MeteorEffect;
import com.company.assembleegameclient.objects.particles.NovaEffect;
import com.company.assembleegameclient.objects.particles.OrbEffect;
import com.company.assembleegameclient.objects.particles.PoisonEffect;
import com.company.assembleegameclient.objects.particles.RingEffect;
import com.company.assembleegameclient.objects.particles.RisingFuryEffect;
import com.company.assembleegameclient.objects.particles.ShockeeEffect;
import com.company.assembleegameclient.objects.particles.ShockerEffect;
import com.company.assembleegameclient.objects.particles.SmokeCloudEffect;
import com.company.assembleegameclient.objects.particles.SpritesProjectEffect;
import com.company.assembleegameclient.objects.particles.StreamEffect;
import com.company.assembleegameclient.objects.particles.TeleportEffect;
import com.company.assembleegameclient.objects.particles.ThrowEffect;
import com.company.assembleegameclient.objects.particles.ThunderEffect;
import com.company.assembleegameclient.objects.thrown.ThrowProjectileEffect;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.PicView;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
import com.company.assembleegameclient.ui.panels.GuildInvitePanel;
import com.company.assembleegameclient.ui.panels.TradeRequestPanel;
import com.company.assembleegameclient.util.FreeList;
import com.company.assembleegameclient.util.RandomUtil;
import com.company.util.Random;
import com.gskinner.motion.GTween;
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.util.Base64;
import com.hurlant.util.der.PEM;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
import io.decagames.rotmg.classes.NewClassUnlockSignal;
import io.decagames.rotmg.dailyQuests.messages.incoming.QuestFetchResponse;
import io.decagames.rotmg.dailyQuests.signal.QuestFetchCompleteSignal;
import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
import io.decagames.rotmg.pets.data.PetsModel;
import io.decagames.rotmg.pets.data.vo.HatchPetVO;
import io.decagames.rotmg.pets.signals.DeletePetSignal;
import io.decagames.rotmg.pets.signals.HatchPetSignal;
import io.decagames.rotmg.pets.signals.NewAbilitySignal;
import io.decagames.rotmg.pets.signals.PetFeedResultSignal;
import io.decagames.rotmg.pets.signals.UpdateActivePet;
import io.decagames.rotmg.pets.signals.UpdatePetYardSignal;
import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.social.model.SocialModel;
import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.lib.net.api.MessageMap;
import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.ChatSocketServer;
import kabam.lib.net.impl.ChatSocketServerModel;
import kabam.lib.net.impl.Message;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.view.PurchaseConfirmationDialog;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.arena.control.ArenaDeathSignal;
import kabam.rotmg.arena.control.ImminentArenaWaveSignal;
import kabam.rotmg.arena.model.CurrentArenaRunModel;
import kabam.rotmg.arena.view.BattleSummaryDialog;
import kabam.rotmg.arena.view.ContinueOrQuitDialog;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkinState;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dailyLogin.message.ClaimDailyRewardMessage;
import kabam.rotmg.dailyLogin.message.ClaimDailyRewardResponse;
import kabam.rotmg.dailyLogin.signal.ClaimDailyRewardResponseSignal;
import kabam.rotmg.death.control.HandleDeathSignal;
import kabam.rotmg.death.control.ZombifySignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.focus.control.SetGameFocusSignal;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
import kabam.rotmg.messaging.impl.data.GroundTileData;
import kabam.rotmg.messaging.impl.data.ObjectData;
import kabam.rotmg.messaging.impl.data.ObjectStatusData;
import kabam.rotmg.messaging.impl.data.SlotObjectData;
import kabam.rotmg.messaging.impl.data.StatData;
import kabam.rotmg.messaging.impl.incoming.AccountList;
import kabam.rotmg.messaging.impl.incoming.AllyShoot;
import kabam.rotmg.messaging.impl.incoming.Aoe;
import kabam.rotmg.messaging.impl.incoming.BuyResult;
import kabam.rotmg.messaging.impl.incoming.ChatToken;
import kabam.rotmg.messaging.impl.incoming.ClientStat;
import kabam.rotmg.messaging.impl.incoming.CreateSuccess;
import kabam.rotmg.messaging.impl.incoming.Damage;
import kabam.rotmg.messaging.impl.incoming.Death;
import kabam.rotmg.messaging.impl.incoming.EnemyShoot;
import kabam.rotmg.messaging.impl.incoming.EvolvedMessageHandler;
import kabam.rotmg.messaging.impl.incoming.EvolvedPetMessage;
import kabam.rotmg.messaging.impl.incoming.Failure;
import kabam.rotmg.messaging.impl.incoming.File;
import kabam.rotmg.messaging.impl.incoming.GlobalNotification;
import kabam.rotmg.messaging.impl.incoming.Goto;
import kabam.rotmg.messaging.impl.incoming.GuildResult;
import kabam.rotmg.messaging.impl.incoming.InvResult;
import kabam.rotmg.messaging.impl.incoming.InvitedToGuild;
import kabam.rotmg.messaging.impl.incoming.KeyInfoResponse;
import kabam.rotmg.messaging.impl.incoming.MapInfo;
import kabam.rotmg.messaging.impl.incoming.NameResult;
import kabam.rotmg.messaging.impl.incoming.NewAbilityMessage;
import kabam.rotmg.messaging.impl.incoming.NewCharacterInformation;
import kabam.rotmg.messaging.impl.incoming.NewTick;
import kabam.rotmg.messaging.impl.incoming.Notification;
import kabam.rotmg.messaging.impl.incoming.PasswordPrompt;
import kabam.rotmg.messaging.impl.incoming.Pic;
import kabam.rotmg.messaging.impl.incoming.Ping;
import kabam.rotmg.messaging.impl.incoming.PlaySound;
import kabam.rotmg.messaging.impl.incoming.QuestObjId;
import kabam.rotmg.messaging.impl.incoming.QuestRedeemResponse;
import kabam.rotmg.messaging.impl.incoming.QueueInformation;
import kabam.rotmg.messaging.impl.incoming.RealmHeroesResponse;
import kabam.rotmg.messaging.impl.incoming.Reconnect;
import kabam.rotmg.messaging.impl.incoming.ReskinUnlock;
import kabam.rotmg.messaging.impl.incoming.ServerPlayerShoot;
import kabam.rotmg.messaging.impl.incoming.ShowEffect;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeDone;
import kabam.rotmg.messaging.impl.incoming.TradeRequested;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.messaging.impl.incoming.UnlockInformation;
import kabam.rotmg.messaging.impl.incoming.Update;
import kabam.rotmg.messaging.impl.incoming.VerifyEmail;
import kabam.rotmg.messaging.impl.incoming.arena.ArenaDeath;
import kabam.rotmg.messaging.impl.incoming.arena.ImminentArenaWave;
import kabam.rotmg.messaging.impl.incoming.pets.DeletePetMessage;
import kabam.rotmg.messaging.impl.incoming.pets.HatchPetMessage;
import kabam.rotmg.messaging.impl.outgoing.AcceptTrade;
import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
import kabam.rotmg.messaging.impl.outgoing.AoeAck;
import kabam.rotmg.messaging.impl.outgoing.Buy;
import kabam.rotmg.messaging.impl.outgoing.CancelTrade;
import kabam.rotmg.messaging.impl.outgoing.ChangeGuildRank;
import kabam.rotmg.messaging.impl.outgoing.ChangePetSkin;
import kabam.rotmg.messaging.impl.outgoing.ChangeTrade;
import kabam.rotmg.messaging.impl.outgoing.ChatHello;
import kabam.rotmg.messaging.impl.outgoing.CheckCredits;
import kabam.rotmg.messaging.impl.outgoing.ChooseName;
import kabam.rotmg.messaging.impl.outgoing.Create;
import kabam.rotmg.messaging.impl.outgoing.CreateGuild;
import kabam.rotmg.messaging.impl.outgoing.EditAccountList;
import kabam.rotmg.messaging.impl.outgoing.EnemyHit;
import kabam.rotmg.messaging.impl.outgoing.Escape;
import kabam.rotmg.messaging.impl.outgoing.GoToQuestRoom;
import kabam.rotmg.messaging.impl.outgoing.GotoAck;
import kabam.rotmg.messaging.impl.outgoing.GroundDamage;
import kabam.rotmg.messaging.impl.outgoing.GuildInvite;
import kabam.rotmg.messaging.impl.outgoing.GuildRemove;
import kabam.rotmg.messaging.impl.outgoing.Hello;
import kabam.rotmg.messaging.impl.outgoing.InvDrop;
import kabam.rotmg.messaging.impl.outgoing.InvSwap;
import kabam.rotmg.messaging.impl.outgoing.JoinGuild;
import kabam.rotmg.messaging.impl.outgoing.KeyInfoRequest;
import kabam.rotmg.messaging.impl.outgoing.Load;
import kabam.rotmg.messaging.impl.outgoing.Move;
import kabam.rotmg.messaging.impl.outgoing.OtherHit;
import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
import kabam.rotmg.messaging.impl.outgoing.PlayerHit;
import kabam.rotmg.messaging.impl.outgoing.PlayerShoot;
import kabam.rotmg.messaging.impl.outgoing.PlayerText;
import kabam.rotmg.messaging.impl.outgoing.Pong;
import kabam.rotmg.messaging.impl.outgoing.RequestTrade;
import kabam.rotmg.messaging.impl.outgoing.ResetDailyQuests;
import kabam.rotmg.messaging.impl.outgoing.Reskin;
import kabam.rotmg.messaging.impl.outgoing.SetCondition;
import kabam.rotmg.messaging.impl.outgoing.ShootAck;
import kabam.rotmg.messaging.impl.outgoing.SquareHit;
import kabam.rotmg.messaging.impl.outgoing.Teleport;
import kabam.rotmg.messaging.impl.outgoing.UseItem;
import kabam.rotmg.messaging.impl.outgoing.UsePortal;
import kabam.rotmg.messaging.impl.outgoing.arena.EnterArena;
import kabam.rotmg.messaging.impl.outgoing.arena.QuestRedeem;
import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.model.Key;
import kabam.rotmg.ui.signals.RealmHeroesSignal;
import kabam.rotmg.ui.signals.RealmQuestLevelSignal;
import kabam.rotmg.ui.signals.ShowHideKeyUISignal;
import kabam.rotmg.ui.signals.ShowKeySignal;
import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
import kabam.rotmg.ui.view.NotEnoughGoldDialog;
import kabam.rotmg.ui.view.TitleView;

import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.api.ILogger;

public class GameServerConnectionConcrete extends GameServerConnection {

    private static const TO_MILLISECONDS:int = 1000;
    private static const MAX_RECONNECT_ATTEMPTS:int = 5;
    public static var connectionGuid:String = "";
    public static var lastConnectionFailureMessage:String = "";
    public static var lastConnectionFailureID:String = "";
    private var serverFull_:Boolean = false;
    public var petUpdater:PetUpdater;
    private var loader:URLLoader;
    private var messages:MessageProvider;
    private var player:Player;
    private var retryConnection_:Boolean = true;
    private var rand_:Random = null;
    private var giftChestUpdateSignal:GiftStatusUpdateSignal;
    private var death:Death;
    private var retryTimer_:Timer;
    private var delayBeforeReconnect:int = 2;
    private var addTextLine:AddTextLineSignal;
    private var addSpeechBalloon:AddSpeechBalloonSignal;
    private var updateGroundTileSignal:UpdateGroundTileSignal;
    private var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
    private var logger:ILogger;
    private var handleDeath:HandleDeathSignal;
    private var zombify:ZombifySignal;
    private var setGameFocus:SetGameFocusSignal;
    private var updateBackpackTab:UpdateBackpackTabSignal;
    private var petFeedResult:PetFeedResultSignal;
    private var closeDialogs:CloseDialogsSignal;
    private var openDialog:OpenDialogSignal;
    private var showPopupSignal:ShowPopupSignal;
    private var arenaDeath:ArenaDeathSignal;
    private var imminentWave:ImminentArenaWaveSignal;
    private var questFetchComplete:QuestFetchCompleteSignal;
    private var questRedeemComplete:QuestRedeemCompleteSignal;
    private var keyInfoResponse:KeyInfoResponseSignal;
    private var claimDailyRewardResponse:ClaimDailyRewardResponseSignal;
    private var newClassUnlockSignal:NewClassUnlockSignal;
    private var currentArenaRun:CurrentArenaRunModel;
    private var classesModel:ClassesModel;
    private var seasonalEventModel:SeasonalEventModel;
    private var injector:Injector;
    private var model:GameModel;
    private var updateActivePet:UpdateActivePet;
    private var petsModel:PetsModel;
    private var socialModel:SocialModel;
    private var chatServerConnection:ChatSocketServer;
    private var chatServerModel:ChatSocketServerModel;
    private var _isReconnecting:Boolean;
    private var _numberOfReconnectAttempts:int;
    private var _chatReconnectionTimer:Timer;
    private var statsTracker:CharactersMetricsTracker;
    private var isNexusing:Boolean;
    private var serverModel:ServerModel;
    private var showHideKeyUISignal:ShowHideKeyUISignal;
    private var realmHeroesSignal:RealmHeroesSignal;
    private var realmQuestLevelSignal:RealmQuestLevelSignal;
    private var hudModel:HUDModel;

    private static function isStatPotion(_arg_1:int):Boolean {
        return _arg_1 == 2591 || _arg_1 == 5465 || _arg_1 == 9064 || (_arg_1 == 2592 || _arg_1 == 5466 || _arg_1 == 9065) || (_arg_1 == 2593 || _arg_1 == 5467 || _arg_1 == 9066) || (_arg_1 == 2612 || _arg_1 == 5468 || _arg_1 == 9067) || (_arg_1 == 2613 || _arg_1 == 5469 || _arg_1 == 9068) || (_arg_1 == 2636 || _arg_1 == 5470 || _arg_1 == 9069) || (_arg_1 == 2793 || _arg_1 == 5471 || _arg_1 == 9070) || (_arg_1 == 2794 || _arg_1 == 5472 || _arg_1 == 9071) || (_arg_1 == 9724 || _arg_1 == 9725 || _arg_1 == 9726 || _arg_1 == 9727 || _arg_1 == 9728 || _arg_1 == 9729 || _arg_1 == 9730 || _arg_1 == 9731);
    }

    public function GameServerConnectionConcrete(_arg_1:AGameSprite, _arg_2:Server, _arg_3:int, _arg_4:Boolean, _arg_5:int, _arg_6:int, _arg_7:ByteArray, _arg_8:String, _arg_9:Boolean) {
        loader = new URLLoader();
        super();
        this.injector = StaticInjectorContext.getInjector();
        this.giftChestUpdateSignal = this.injector.getInstance(GiftStatusUpdateSignal);
        this.addTextLine = this.injector.getInstance(AddTextLineSignal);
        this.addSpeechBalloon = this.injector.getInstance(AddSpeechBalloonSignal);
        this.updateGroundTileSignal = this.injector.getInstance(UpdateGroundTileSignal);
        this.updateGameObjectTileSignal = this.injector.getInstance(UpdateGameObjectTileSignal);
        this.petFeedResult = this.injector.getInstance(PetFeedResultSignal);
        this.updateBackpackTab = StaticInjectorContext.getInjector().getInstance(UpdateBackpackTabSignal);
        this.updateActivePet = this.injector.getInstance(UpdateActivePet);
        this.petsModel = this.injector.getInstance(PetsModel);
        this.socialModel = this.injector.getInstance(SocialModel);
        this.closeDialogs = this.injector.getInstance(CloseDialogsSignal);
        this.openDialog = this.injector.getInstance(OpenDialogSignal);
        this.showPopupSignal = this.injector.getInstance(ShowPopupSignal);
        this.arenaDeath = this.injector.getInstance(ArenaDeathSignal);
        this.imminentWave = this.injector.getInstance(ImminentArenaWaveSignal);
        this.questFetchComplete = this.injector.getInstance(QuestFetchCompleteSignal);
        this.questRedeemComplete = this.injector.getInstance(QuestRedeemCompleteSignal);
        this.keyInfoResponse = this.injector.getInstance(KeyInfoResponseSignal);
        this.claimDailyRewardResponse = this.injector.getInstance(ClaimDailyRewardResponseSignal);
        this.newClassUnlockSignal = this.injector.getInstance(NewClassUnlockSignal);
        this.showHideKeyUISignal = this.injector.getInstance(ShowHideKeyUISignal);
        this.realmHeroesSignal = this.injector.getInstance(RealmHeroesSignal);
        this.realmQuestLevelSignal = this.injector.getInstance(RealmQuestLevelSignal);
        this.statsTracker = this.injector.getInstance(CharactersMetricsTracker);
        this.logger = this.injector.getInstance(ILogger);
        this.handleDeath = this.injector.getInstance(HandleDeathSignal);
        this.zombify = this.injector.getInstance(ZombifySignal);
        this.setGameFocus = this.injector.getInstance(SetGameFocusSignal);
        this.classesModel = this.injector.getInstance(ClassesModel);
        this.seasonalEventModel = this.injector.getInstance(SeasonalEventModel);
        serverConnection = this.injector.getInstance(SocketServer);
        this.messages = this.injector.getInstance(MessageProvider);
        this.model = this.injector.getInstance(GameModel);
        this.hudModel = this.injector.getInstance(HUDModel);
        this.serverModel = this.injector.getInstance(ServerModel);
        this.currentArenaRun = this.injector.getInstance(CurrentArenaRunModel);
        gs_ = _arg_1;
        server_ = _arg_2;
        gameId_ = _arg_3;
        createCharacter_ = _arg_4;
        charId_ = _arg_5;
        keyTime_ = _arg_6;
        key_ = _arg_7;
        mapJSON_ = _arg_8;
        isFromArena_ = _arg_9;
        this.socialModel.loadInvitations();
        this.socialModel.setCurrentServer(server_);
        this.getPetUpdater();
        instance = this;
        this.loader.addEventListener("httpStatus", loaderStatus);
    }

    override public function disconnect():void {
        Parameters.savingMap_ = false;
        this.removeServerConnectionListeners();
        this.unmapMessages();
        serverConnection.disconnect();
    }

    override public function connect():void {
        this.addServerConnectionListeners();
        this.mapMessages();

        var chatNotif: ChatMessage = new ChatMessage();
        chatNotif.name = "ProdMafia";
        chatNotif.text = "chat.connectingTo";

        var mapName: String = server_.name;
        if (mapName == "{\"text\":\"server.vault\"}") {
            mapName = "Vault";
        }
        mapName = LineBuilder.getLocalizedStringFromKey(mapName);
        chatNotif.tokens = {"serverName": mapName};

        this.addTextLine.dispatch(chatNotif);
        serverConnection.connect(server_.address, server_.port);
        Parameters.paramIPJoinedOnce = false;
    }

    override public function isConnected():Boolean {
        return serverConnection.isConnected();
    }

    override public function peekNextDamage(_arg_1:uint, _arg_2:uint):uint {
        return this.rand_.nextIntRange(_arg_1, _arg_2);
    }

    override public function getNextDamage(_arg_1:uint, _arg_2:uint):uint {
        return this.rand_.nextIntRange(_arg_1, _arg_2);
    }

    override public function enableJitterWatcher():void {
        if (jitterWatcher_ == null) {
            jitterWatcher_ = new JitterWatcher();
        }
    }

    override public function disableJitterWatcher():void {
        if (jitterWatcher_) {
            jitterWatcher_ = null;
        }
    }

    override public function playerShoot(time: int, proj: Projectile):void {
        var playerShootPacket: PlayerShoot = this.messages.require(30) as PlayerShoot;
        playerShootPacket.time_ = time;
        playerShootPacket.bulletId_ = proj.bulletId_;
        playerShootPacket.containerType_ = proj.containerType_;
        playerShootPacket.startingPos_.x_ = proj.x_;
        playerShootPacket.startingPos_.y_ = proj.y_;
        playerShootPacket.angle_ = proj.angle_;
        playerShootPacket.lifeMult_ = proj.lifeMul_;
        playerShootPacket.speedMult_ = proj.speedMul_;

        serverConnection.sendMessage(playerShootPacket);
    }

    override public function playerHit(bulletId: int, objectId: int):void {
        var playerHitPacket: PlayerHit = this.messages.require(90) as PlayerHit;
        playerHitPacket.bulletId_ = bulletId;
        playerHitPacket.objectId_ = objectId;

        serverConnection.sendMessage(playerHitPacket);
    }

    override public function enemyHit(time: int, bulletId: int, targetId: int, killed: Boolean):void {
        var enemyHitPacket: EnemyHit = this.messages.require(25) as EnemyHit;
        enemyHitPacket.time_ = time;
        enemyHitPacket.bulletId_ = bulletId;
        enemyHitPacket.targetId_ = targetId;
        enemyHitPacket.kill_ = killed;

        serverConnection.sendMessage(enemyHitPacket);
    }

    override public function otherHit(time: int, bulletId: int, objectId: int, targetId: int):void {
        var otherHitPacket: OtherHit = this.messages.require(20) as OtherHit;
        otherHitPacket.time_ = time;
        otherHitPacket.bulletId_ = bulletId;
        otherHitPacket.objectId_ = objectId;
        otherHitPacket.targetId_ = targetId;

        serverConnection.sendMessage(otherHitPacket);
    }

    override public function squareHit(time: int, bulletId: int, objectId: int):void {
        var hitPacket: SquareHit = this.messages.require(40) as SquareHit;
        hitPacket.time_ = time;
        hitPacket.bulletId_ = bulletId;
        hitPacket.objectId_ = objectId;

        serverConnection.sendMessage(hitPacket);
    }

    override public function groundDamage(time: int, posX: Number, posY: Number):void {
        var aoePacket: GroundDamage = this.messages.require(103) as GroundDamage;
        aoePacket.time_ = time;
        aoePacket.position_.x_ = posX;
        aoePacket.position_.y_ = posY;

        serverConnection.sendMessage(aoePacket);
    }

    override public function playerText(messageText: String):void {
        var textPacket: PlayerText = this.messages.require(10) as PlayerText;
        textPacket.text_ = messageText;

        serverConnection.sendMessage(textPacket);
    }

    override public function invSwap(currentPlayer: Player, objFrom: GameObject, slotFrom: int, objFromType: int, objTo: GameObject, slotTo: int, objToType: int): Boolean {
        if (!this.gs_) {
            return false;
        }
        if (this.gs_.lastUpdate_ - this.lastInvSwapTime < 500) {
            return false;
        }

        var swapPacket: InvSwap = this.messages.require(19) as InvSwap;
        swapPacket.time_ = this.gs_.lastUpdate_;
        swapPacket.position_.x_ = currentPlayer.x_;
        swapPacket.position_.y_ = currentPlayer.y_;
        swapPacket.slotObject1_.objectId_ = objFrom.objectId_;
        swapPacket.slotObject1_.slotId_ = slotFrom;
        swapPacket.slotObject1_.objectType_ = objFromType;
        swapPacket.slotObject2_.objectId_ = objTo.objectId_;
        swapPacket.slotObject2_.slotId_ = slotTo;
        swapPacket.slotObject2_.objectType_ = objToType;
        serverConnection.sendMessage(swapPacket);

        this.lastInvSwapTime = swapPacket.time_;
        var _local9:int = objFrom.equipment_[slotFrom];
        objFrom.equipment_[slotFrom] = objTo.equipment_[slotTo];
        objTo.equipment_[slotTo] = _local9;
        SoundEffectLibrary.play("inventory_move_item");
        return true;
    }

    override public function invSwapRaw(posX: Number, posY: Number, objFromId: int, slotFrom: int, objFromType: int, objToId: int, slotTo: int, objToType: int) : Boolean {
        if(!gs_) {
            return false;
        }
        if(this.gs_.lastUpdate_ - this.lastInvSwapTime < 500) {
            return false;
        }

        var swapPacket: InvSwap = this.messages.require(19) as InvSwap;
        swapPacket.time_ = gs_.lastUpdate_;
        swapPacket.position_.x_ = posX;
        swapPacket.position_.y_ = posY;
        swapPacket.slotObject1_.objectId_ = objFromId;
        swapPacket.slotObject1_.slotId_ = slotFrom;
        swapPacket.slotObject1_.objectType_ = objFromType;
        swapPacket.slotObject2_.objectId_ = objToId;
        swapPacket.slotObject2_.slotId_ = slotTo;
        swapPacket.slotObject2_.objectType_ = objToType;
        serverConnection.sendMessage(swapPacket);

        this.lastInvSwapTime = swapPacket.time_;
        SoundEffectLibrary.play("inventory_move_item");
        return true;
    }

    override public function invSwapPotion(currentPlayer: Player, _arg_2:GameObject, _arg_3:int, _arg_4:int, _arg_5:GameObject, _arg_6:int, _arg_7:int):Boolean {
        if (!gs_) {
            return false;
        }
        if (this.gs_.lastUpdate_ - this.lastInvSwapTime < 500) {
            return false;
        }
        var swapPacket: InvSwap = this.messages.require(19) as InvSwap;
        swapPacket.time_ = gs_.lastUpdate_;
        swapPacket.position_.x_ = currentPlayer.x_;
        swapPacket.position_.y_ = currentPlayer.y_;
        swapPacket.slotObject1_.objectId_ = _arg_2.objectId_;
        swapPacket.slotObject1_.slotId_ = _arg_3;
        swapPacket.slotObject1_.objectType_ = _arg_4;
        swapPacket.slotObject2_.objectId_ = _arg_5.objectId_;
        swapPacket.slotObject2_.slotId_ = _arg_6;
        swapPacket.slotObject2_.objectType_ = _arg_7;

        _arg_2.equipment_[_arg_3] = -1;
        if (_arg_4 == 2594) {
            currentPlayer.healthPotionCount_++;
        } else if (_arg_4 == 2595) {
            currentPlayer.magicPotionCount_++;
        }

        serverConnection.sendMessage(swapPacket);
        this.lastInvSwapTime = swapPacket.time_;
        SoundEffectLibrary.play("inventory_move_item");
        return true;
    }

    override public function invDrop(_arg_1:GameObject, _arg_2:int, _arg_3:int):void {
        var _local4:InvDrop = this.messages.require(55) as InvDrop;
        _local4.slotObject_.objectId_ = _arg_1.objectId_;
        _local4.slotObject_.slotId_ = _arg_2;
        _local4.slotObject_.objectType_ = _arg_3;
        serverConnection.sendMessage(_local4);
        if (_arg_2 != 254 && _arg_2 != 255) {
            _arg_1.equipment_[_arg_2] = -1;
        }
    }

    override public function invDropRaw(_arg_1:int, _arg_2:int, _arg_3:int):void {
        var _local4:InvDrop = this.messages.require(55) as InvDrop;
        _local4.slotObject_.objectId_ = _arg_1;
        _local4.slotObject_.slotId_ = _arg_2;
        _local4.slotObject_.objectType_ = _arg_3;
        serverConnection.sendMessage(_local4);
    }

    override public function useItem(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Number, _arg_7:int):void {
        var _local8:* = null;
        if (Parameters.data.fameBlockAbility && _arg_2 == this.playerId_ && _arg_3 == 1) {
            this.player.textNotification("Ignored ability use, Mundane enabled", 14835456);
            return;
        }
        if (Parameters.data.fameBlockThirsty && _arg_2 == this.playerId_ && _arg_3 > 3 && _arg_3 < 254) {
            _local8 = ObjectLibrary.propsLibrary_[this.player.equipment_[_arg_3]];
            if (_local8 && _local8.isPotion_) {
                this.player.textNotification("Ignored potion use, Thirsty enabled", 14835456);
                return;
            }
        }
        var _local9:UseItem = this.messages.require(11) as UseItem;
        _local9.time_ = _arg_1;
        _local9.slotObject_.objectId_ = _arg_2;
        _local9.slotObject_.slotId_ = _arg_3;
        _local9.slotObject_.objectType_ = _arg_4;
        _local9.itemUsePos_.x_ = _arg_5;
        _local9.itemUsePos_.y_ = _arg_6;
        _local9.useType_ = _arg_7;
        serverConnection.sendMessage(_local9);
    }

    override public function useItem_new(_arg_1:GameObject, _arg_2:int):Boolean {
        var _local3:* = null;
        if (Parameters.data.fameBlockAbility && _arg_1.objectId_ == this.playerId_ && _arg_2 == 1) {
            this.player.textNotification("Ignored ability use, Mundane enabled", 14835456);
            return false;
        }
        if (Parameters.data.fameBlockThirsty && _arg_1.objectId_ == this.playerId_ && _arg_2 > 3 && _arg_2 < 254) {
            _local3 = ObjectLibrary.propsLibrary_[_arg_1.equipment_[_arg_2]];
            if (_local3 && _local3.isPotion_) {
                this.player.textNotification("Ignored potion use, Thirsty enabled", 14835456);
                return false;
            }
        }
        if (_arg_1 == null || _arg_1.equipment_ == null) {
            return false;
        }
        var _local5:int = _arg_1.equipment_[_arg_2];
        var _local4:XML = ObjectLibrary.xmlLibrary_[_local5];
        if (_local4 && !_arg_1.isPaused && ("Consumable" in _local4 || "InvUse" in _local4)) {
            if (!this.validStatInc(_local5, _arg_1)) {
                this.addTextLine.dispatch(ChatMessage.make("", _local4.attribute("id") + " not consumed. Already at Max."));
                return false;
            }
            if (isStatPotion(_local5)) {
                this.addTextLine.dispatch(ChatMessage.make("", _local4.attribute("id") + " Consumed ++"));
            }
            this.applyUseItem(_arg_1, _arg_2, _local5, _local4);
            if ("Key" in _local4) {
                SoundEffectLibrary.play("use_key");
            } else {
                SoundEffectLibrary.play("use_potion");
            }
            return true;
        }
        if (this.swapEquip(_arg_1, _arg_2, _local4)) {
            return true;
        }
        SoundEffectLibrary.play("error");
        return false;
    }

    override public function setCondition(_arg_1:uint, _arg_2:Number):void {
        var _local3:SetCondition = this.messages.require(60) as SetCondition;
        _local3.conditionEffect_ = _arg_1;
        _local3.conditionDuration_ = _arg_2;
        serverConnection.sendMessage(_local3);
    }

    override public function teleport(_arg_1:int):void {
        if (Parameters.data.fameBlockTP) {
            this.player.textNotification("Ignored teleport - Boots on the Ground block enabled", 14835456);
            return;
        }
        var _local2:Teleport = this.messages.require(74) as Teleport;
        _local2.objectId_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function usePortal(_arg_1:int):void {
        var _local2:* = null;
        if (Parameters.usingPortal) {
            Parameters.portalID = _arg_1;
        }
        var _local3:UsePortal = this.messages.require(47) as UsePortal;
        _local3.objectId_ = _arg_1;
        serverConnection.sendMessage(_local3);
    }

    override public function buy(_arg_1:int, _arg_2:int):void {
        var param1:int = _arg_1;
        var param2:int = _arg_2;
        var sellableObjectId:int = param1;
        var quantity:int = param2;
        if (outstandingBuy_) {
            return;
        }
        var sObj:SellableObject = gs_.map.goDict_[sellableObjectId];
        if (sObj == null) {
            return;
        }
        var converted:Boolean = false;
        if (sObj.currency_ == 0) {
            converted = gs_.model.getConverted() || this.player.credits_ > 100 || sObj.price_ > this.player.credits_;
        }
        if (sObj.soldObjectName() == "Vault.chest") {
            this.openDialog.dispatch(new PurchaseConfirmationDialog(function ():void {
                buyConfirmation(sObj, converted, sellableObjectId, quantity);
            }));
        } else {
            this.buyConfirmation(sObj, converted, sellableObjectId, quantity);
        }
    }

    override public function buyRaw(_arg_1:int, _arg_2:int):void {
        var _local3:Buy = this.messages.require(85) as Buy;
        _local3.objectId_ = _arg_1;
        _local3.quantity_ = _arg_2;
        serverConnection.sendMessage(_local3);
    }

    override public function editAccountList(_arg_1:int, _arg_2:Boolean, _arg_3:int):void {
        var _local4:EditAccountList = this.messages.require(27) as EditAccountList;
        _local4.accountListId_ = _arg_1;
        _local4.add_ = _arg_2;
        _local4.objectId_ = _arg_3;
        serverConnection.sendMessage(_local4);
    }

    override public function chooseName(_arg_1:String):void {
        var _local2:ChooseName = this.messages.require(97) as ChooseName;
        _local2.name_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function createGuild(_arg_1:String):void {
        var _local2:CreateGuild = this.messages.require(59) as CreateGuild;
        _local2.name_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function guildRemove(_arg_1:String):void {
        var _local2:GuildRemove = this.messages.require(15) as GuildRemove;
        _local2.name_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function guildInvite(_arg_1:String):void {
        var _local2:GuildInvite = this.messages.require(104) as GuildInvite;
        _local2.name_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function requestTrade(_arg_1:String):void {
        var _local2:RequestTrade = this.messages.require(5) as RequestTrade;
        _local2.name_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function changeTrade(_arg_1:Vector.<Boolean>):void {
        var _local2:ChangeTrade = this.messages.require(56) as ChangeTrade;
        _local2.offer_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function acceptTrade(_arg_1:Vector.<Boolean>, _arg_2:Vector.<Boolean>):void {
        var _local3:AcceptTrade = this.messages.require(36) as AcceptTrade;
        _local3.myOffer_ = _arg_1;
        _local3.yourOffer_ = _arg_2;
        serverConnection.sendMessage(_local3);
    }

    override public function cancelTrade():void {
        serverConnection.sendMessage(this.messages.require(91));
    }

    override public function checkCredits():void {
        serverConnection.sendMessage(this.messages.require(102));
    }

    override public function escape():void {
        if (this.playerId_ == -1) {
            return;
        }
        if (gs_.map && gs_.map.name_ == "Arena") {
            serverConnection.sendMessage(this.messages.require(80));
        } else {
            this.isNexusing = true;
            serverConnection.sendMessage(this.messages.require(105));
            this.showHideKeyUISignal.dispatch(false);
        }
    }

    override public function gotoQuestRoom():void {
        serverConnection.sendMessage(this.messages.require(48));
    }

    override public function joinGuild(_arg_1:String):void {
        var _local2:JoinGuild = this.messages.require(7) as JoinGuild;
        _local2.guildName_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function changeGuildRank(_arg_1:String, _arg_2:int):void {
        var _local3:ChangeGuildRank = this.messages.require(37) as ChangeGuildRank;
        _local3.name_ = _arg_1;
        _local3.guildRank_ = _arg_2;
        serverConnection.sendMessage(_local3);
    }

    override public function changePetSkin(_arg_1:int, _arg_2:int, _arg_3:int):void {
        var _local4:ChangePetSkin = this.messages.require(33) as ChangePetSkin;
        _local4.petId = _arg_1;
        _local4.skinType = _arg_2;
        _local4.currency = _arg_3;
        serverConnection.sendMessage(_local4);
    }

    override public function fakeDeath():void {
        this.addTextLine.dispatch(ChatMessage.make("", this.player.name_ + " died at level " + this.player.level_ + ", killed by Epic Prank"));
        var _local1:BitmapData = new BitmapData(gs_.stage.stageWidth, gs_.stage.stageHeight, true, 0);
        _local1.draw(gs_);
        setBackground(_local1);
        this.escape();
        this.disconnect();
    }

    override public function questFetch():void {
        serverConnection.sendMessage(this.messages.require(98));
    }

    override public function questRedeem(_arg_1:String, _arg_2:Vector.<SlotObjectData>, _arg_3:int = -1):void {
        var _local4:QuestRedeem = this.messages.require(58) as QuestRedeem;
        _local4.questID = _arg_1;
        _local4.item = _arg_3;
        _local4.slots = _arg_2;
        serverConnection.sendMessage(_local4);
    }

    override public function keyInfoRequest(_arg_1:int):void {
        var _local2:KeyInfoRequest = this.messages.require(94) as KeyInfoRequest;
        _local2.itemType_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    override public function petUpgradeRequest(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int):void {
        var _local7:PetUpgradeRequest = this.messages.require(16) as PetUpgradeRequest;
        _local7.objectId = _arg_5;
        _local7.paymentTransType = _arg_1;
        _local7.petTransType = _arg_2;
        _local7.PIDOne = _arg_3;
        _local7.PIDTwo = _arg_4;
        _local7.slotsObject = new Vector.<SlotObjectData>();
        _local7.slotsObject.push(new SlotObjectData());
        _local7.slotsObject[0].objectId_ = this.playerId_;
        _local7.slotsObject[0].slotId_ = _arg_6;
        if (this.player.equipment_.length >= _arg_6) {
            _local7.slotsObject[0].objectType_ = this.player.equipment_[_arg_6];
        } else {
            _local7.slotsObject[0].objectType_ = -1;
        }
        this.serverConnection.sendMessage(_local7);
    }

    override public function reskin(currentPlayer: Player, skinId: int):void {
        var reskinPacket: Reskin = this.messages.require(51) as Reskin;
        reskinPacket.skinID = skinId;
        reskinPacket.player = currentPlayer;

        serverConnection.sendMessage(reskinPacket);
    }

    override public function resetDailyQuests():void {
        var _local1:ResetDailyQuests = this.messages.require(52) as ResetDailyQuests;
        serverConnection.sendMessage(_local1);
    }

    public function addServerConnectionListeners():void {
        serverConnection.connected.add(this.onConnected);
        serverConnection.closed.add(this.onClosed);
        serverConnection.error.add(this.onError);
    }

    public function mapMessages():void {
        var _local1:MessageMap = this.injector.getInstance(MessageMap);
        _local1.map(61).toMessage(Create);
        _local1.map(30).toMessage(PlayerShoot);
        _local1.map(42).toMessage(Move);
        _local1.map(10).toMessage(PlayerText);
        _local1.map(81).toMessage(Message);
        _local1.map(19).toMessage(InvSwap);
        _local1.map(11).toMessage(UseItem);
        _local1.map(1).toMessage(Hello);
        _local1.map(55).toMessage(InvDrop);
        _local1.map(31).toMessage(Pong);
        _local1.map(57).toMessage(Load);
        _local1.map(60).toMessage(SetCondition);
        _local1.map(74).toMessage(Teleport);
        _local1.map(47).toMessage(UsePortal);
        _local1.map(85).toMessage(Buy);
        _local1.map(90).toMessage(PlayerHit);
        _local1.map(25).toMessage(EnemyHit);
        _local1.map(89).toMessage(AoeAck);
        _local1.map(100).toMessage(ShootAck);
        _local1.map(20).toMessage(OtherHit);
        _local1.map(40).toMessage(SquareHit);
        _local1.map(65).toMessage(GotoAck);
        _local1.map(103).toMessage(GroundDamage);
        _local1.map(97).toMessage(ChooseName);
        _local1.map(59).toMessage(CreateGuild);
        _local1.map(15).toMessage(GuildRemove);
        _local1.map(104).toMessage(GuildInvite);
        _local1.map(5).toMessage(RequestTrade);
        _local1.map(56).toMessage(ChangeTrade);
        _local1.map(36).toMessage(AcceptTrade);
        _local1.map(91).toMessage(CancelTrade);
        _local1.map(102).toMessage(CheckCredits);
        _local1.map(105).toMessage(Escape);
        _local1.map(48).toMessage(GoToQuestRoom);
        _local1.map(7).toMessage(JoinGuild);
        _local1.map(37).toMessage(ChangeGuildRank);
        _local1.map(27).toMessage(EditAccountList);
        _local1.map(24).toMessage(ActivePetUpdateRequest);
        _local1.map(16).toMessage(PetUpgradeRequest);
        _local1.map(17).toMessage(EnterArena);
        _local1.map(80).toMessage(OutgoingMessage);
        _local1.map(98).toMessage(OutgoingMessage);
        _local1.map(58).toMessage(QuestRedeem);
        _local1.map(52).toMessage(ResetDailyQuests);
        _local1.map(94).toMessage(KeyInfoRequest);
        _local1.map(53).toMessage(ReskinPet);
        _local1.map(3).toMessage(ClaimDailyRewardMessage);
        _local1.map(33).toMessage(ChangePetSkin);
        _local1.map(0).toMessage(Failure).toMethod(this.onFailure);
        _local1.map(101).toMessage(CreateSuccess).toMethod(this.onCreateSuccess);
        _local1.map(12).toMessage(ServerPlayerShoot).toMethod(this.onServerPlayerShoot);
        _local1.map(75).toMessage(Damage).toMethod(this.onDamage);
        _local1.map(62).toMessage(Update).toMethod(this.onUpdate);
        _local1.map(67).toMessage(Notification).toMethod(this.onNotification);
        _local1.map(66).toMessage(GlobalNotification).toMethod(this.onGlobalNotification);
        _local1.map(9).toMessage(NewTick).toMethod(this.onNewTick);
        _local1.map(13).toMessage(ShowEffect).toMethod(this.onShowEffect);
        _local1.map(18).toMessage(Goto).toMethod(this.onGoto);
        _local1.map(95).toMessage(InvResult).toMethod(this.onInvResult);
        _local1.map(45).toMessage(Reconnect).toMethod(this.onReconnect);
        _local1.map(8).toMessage(Ping).toMethod(this.onPing);
        _local1.map(92).toMessage(MapInfo).toMethod(this.onMapInfo);
        _local1.map(83).toMessage(Pic).toMethod(this.onPic);
        _local1.map(46).toMessage(Death).toMethod(this.onDeath);
        _local1.map(22).toMessage(BuyResult).toMethod(this.onBuyResult);
        _local1.map(64).toMessage(Aoe).toMethod(this.onAoe);
        _local1.map(99).toMessage(AccountList).toMethod(this.onAccountList);
        _local1.map(82).toMessage(QuestObjId).toMethod(this.onQuestObjId);
        _local1.map(21).toMessage(NameResult).toMethod(this.onNameResult);
        _local1.map(26).toMessage(GuildResult).toMethod(this.onGuildResult);
        _local1.map(49).toMessage(AllyShoot).toMethod(this.onAllyShoot);
        _local1.map(35).toMessage(EnemyShoot).toMethod(this.onEnemyShoot);
        _local1.map(88).toMessage(TradeRequested).toMethod(this.onTradeRequested);
        _local1.map(86).toMessage(TradeStart).toMethod(this.onTradeStart);
        _local1.map(28).toMessage(TradeChanged).toMethod(this.onTradeChanged);
        _local1.map(34).toMessage(TradeDone).toMethod(this.onTradeDone);
        _local1.map(14).toMessage(TradeAccepted).toMethod(this.onTradeAccepted);
        _local1.map(69).toMessage(ClientStat).toMethod(this.onClientStat);
        _local1.map(106).toMessage(File).toMethod(this.onFile);
        _local1.map(77).toMessage(InvitedToGuild).toMethod(this.onInvitedToGuild);
        _local1.map(38).toMessage(PlaySound).toMethod(this.onPlaySound);
        _local1.map(76).toMessage(ActivePet).toMethod(this.onActivePetUpdate);
        _local1.map(41).toMessage(NewAbilityMessage).toMethod(this.onNewAbility);
        _local1.map(78).toMessage(PetYard).toMethod(this.onPetYardUpdate);
        _local1.map(87).toMessage(EvolvedPetMessage).toMethod(this.onEvolvedPet);
        _local1.map(4).toMessage(DeletePetMessage).toMethod(this.onDeletePet);
        _local1.map(23).toMessage(HatchPetMessage).toMethod(this.onHatchPet);
        _local1.map(50).toMessage(ImminentArenaWave).toMethod(this.onImminentArenaWave);
        _local1.map(68).toMessage(ArenaDeath).toMethod(this.onArenaDeath);
        _local1.map(39).toMessage(VerifyEmail).toMethod(this.onVerifyEmail);
        _local1.map(107).toMessage(ReskinUnlock).toMethod(this.onReskinUnlock);
        _local1.map(79).toMessage(PasswordPrompt).toMethod(this.onPasswordPrompt);
        _local1.map(6).toMessage(QuestFetchResponse).toMethod(this.onQuestFetchResponse);
        _local1.map(96).toMessage(QuestRedeemResponse).toMethod(this.onQuestRedeemResponse);
        _local1.map(63).toMessage(KeyInfoResponse).toMethod(this.onKeyInfoResponse);
        _local1.map(93).toMessage(ClaimDailyRewardResponse).toMethod(this.onLoginRewardResponse);
        _local1.map(84).toMessage(RealmHeroesResponse).toMethod(this.onRealmHeroesResponse);
        _local1.map(108).toMessage(NewCharacterInformation).toMethod(this.onNewCharacterInformation);
        _local1.map(109).toMessage(UnlockInformation).toMethod(this.onUnlockInformation);
        _local1.map(112).toMessage(QueueInformation).toMethod(this.onQueuePosition);
    }

    private function onNewCharacterInformation(param1:NewCharacterInformation) : void {
        // empty for now til reversed
    }

    private function onUnlockInformation(param1:UnlockInformation) : void {
        // empty for now til reversed
    }

    private function onQueuePosition(param1:QueueInformation) : void {
        // empty for now til reversed
    }

    public function aoeAck(_arg_1:int, _arg_2:Number, _arg_3:Number):void {
        var _local4:AoeAck = this.messages.require(89) as AoeAck;
        _local4.time_ = _arg_1;
        _local4.position_.x_ = _arg_2;
        _local4.position_.y_ = _arg_3;
        serverConnection.sendMessage(_local4);
    }

    public function shootAck(_arg_1:int):void {
        var _local2:ShootAck = this.messages.require(100) as ShootAck;
        _local2.time_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    public function swapEquip(currentPlayer: GameObject, _arg_2:int, itemData:XML):Boolean {
        var _local4: int = 0;
        var equipSlots: * = undefined;
        var slotCounter: int = 0;
        var _local5: int = 0;

        if (itemData && !currentPlayer.isPaused && "SlotType" in itemData) {
            _local4 = itemData.SlotType;
            equipSlots = currentPlayer.slotTypes_.slice(0, 4);
            slotCounter = 0;
            for each(_local5 in equipSlots) {
                if (_local5 == _local4) {
                    this.swapItems(currentPlayer, slotCounter, _arg_2);
                    return true;
                }
                slotCounter++;
            }
        }
        return false;
    }

    public function swapItems(currentPlayer: GameObject, _arg_2:int, _arg_3:int):void {
        var currentInventory:Vector.<int> = currentPlayer.equipment_;
        this.invSwap(currentPlayer as Player, currentPlayer, _arg_2, currentInventory[_arg_2], currentPlayer, _arg_3, currentInventory[_arg_3]);
    }

    public function move(param1:int, param2:uint, param3:Player) : void {
        var _local7:* = 0;
        var _local9:* = 0;
        var _local5:* = -1;
        var _local6:* = -1;
        if(param3 && !param3.isPaused) {
            _local5 = Number(param3.x_);
            _local6 = Number(param3.y_);
        }
        var _local4:Move = this.messages.require(42) as Move;
        _local4.tickId_ = param1;
        _local4.time_ = this.gs_.lastUpdate_;
        _local4.serverRealTimeMSofLastNewTick_ = param2;
        _local4.newPosition_.x_ = _local5;
        _local4.newPosition_.y_ = _local6;
        var _local8:MoveRecords = this.gs_.moveRecords_;
        _local4.records_.length = 0;
        if(_local8.lastClearTime_ >= 0 && _local4.time_ - _local8.lastClearTime_ > 125) {
            _local7 = uint(Math.min(10,_local8.records_.length));
            _local9 = uint(0);
            while(_local9 < _local7) {
                if(_local8.records_[_local9].time_ < _local4.time_ - 25) {
                    _local4.records_.push(_local8.records_[_local9]);
                    _local9++;
                    continue;
                }
                break;
            }
        }
        _local8.clear(_local4.time_);
        this.serverConnection.sendMessage(_local4);
        if(param3) {
            param3.onMove();
        }
    }

    public function gotoAck(_arg_1:int):void {
        var _local2:GotoAck = this.messages.require(65) as GotoAck;
        _local2.time_ = _arg_1;
        serverConnection.sendMessage(_local2);
    }

    public function setPlayerSkinTemplate(_arg_1:Player, _arg_2:int):void {
        var _local3:Reskin = this.messages.require(51) as Reskin;
        _local3.skinID = _arg_2;
        _local3.player = _arg_1;
        _local3.consume();
    }

    public function setBackground(_arg_1:BitmapData):void {
        this.gs_.deathOverlay.bitmapData = _arg_1;
        var _local2:GTween = new GTween(this.gs_.deathOverlay, 2, {"alpha": 0});
        _local2.onComplete = this.onFadeComplete;
        SoundEffectLibrary.play("death_screen");
    }

    public function onFadeComplete(_arg_1:GTween):void {
        this.gs_.removeChild(this.gs_.deathOverlay);
        this.gs_.deathOverlay = null;
        this.gs_.deathOverlay = new Bitmap();
        this.gs_.addChild(this.gs_.deathOverlay);
        this.gs_.dispatchEvent(Parameters.reconNexus);
    }

    private function getPetUpdater():void {
        this.injector.map(AGameSprite).toValue(gs_);
        this.petUpdater = this.injector.getInstance(PetUpdater);
        this.injector.unmap(AGameSprite);
    }

    private function removeServerConnectionListeners():void {
        serverConnection.connected.remove(this.onConnected);
        serverConnection.closed.remove(this.onClosed);
        serverConnection.error.remove(this.onError);
    }

    private function onHatchPet(_arg_1:HatchPetMessage):void {
        var _local2:HatchPetSignal = this.injector.getInstance(HatchPetSignal);
        var _local3:HatchPetVO = new HatchPetVO();
        _local3.itemType = _arg_1.itemType;
        _local3.petSkin = _arg_1.petSkin;
        _local3.petName = _arg_1.petName;
        _local2.dispatch(_local3);
    }

    private function onDeletePet(_arg_1:DeletePetMessage):void {
        var _local2:DeletePetSignal = this.injector.getInstance(DeletePetSignal);
        this.injector.getInstance(PetsModel).deletePet(_arg_1.petID);
        _local2.dispatch(_arg_1.petID);
    }

    private function onNewAbility(_arg_1:NewAbilityMessage):void {
        var _local2:NewAbilitySignal = this.injector.getInstance(NewAbilitySignal);
        _local2.dispatch(_arg_1.type);
    }

    private function onPetYardUpdate(_arg_1:PetYard):void {
        var _local2:UpdatePetYardSignal = StaticInjectorContext.getInjector().getInstance(UpdatePetYardSignal);
        _local2.dispatch(_arg_1.type);
    }

    private function onEvolvedPet(_arg_1:EvolvedPetMessage):void {
        var _local2:EvolvedMessageHandler = this.injector.getInstance(EvolvedMessageHandler);
        _local2.handleMessage(_arg_1);
    }

    private function onActivePetUpdate(_arg_1:ActivePet):void {
        this.updateActivePet.dispatch(_arg_1.instanceID);
        var _local2:String = _arg_1.instanceID > 0 ? this.petsModel.getPet(_arg_1.instanceID).name : "";
        var _local3:String = _arg_1.instanceID < 0 ? "Pets.notFollowing" : "Pets.following";
        this.addTextLine.dispatch(ChatMessage.make("", _local3, -1, -1, "", false, {"petName": _local2}));
    }

    private function unmapMessages():void {
        var _local1:MessageMap = this.injector.getInstance(MessageMap);
        _local1.unmap(61);
        _local1.unmap(30);
        _local1.unmap(42);
        _local1.unmap(10);
        _local1.unmap(81);
        _local1.unmap(19);
        _local1.unmap(11);
        _local1.unmap(1);
        _local1.unmap(55);
        _local1.unmap(31);
        _local1.unmap(57);
        _local1.unmap(60);
        _local1.unmap(74);
        _local1.unmap(47);
        _local1.unmap(85);
        _local1.unmap(90);
        _local1.unmap(25);
        _local1.unmap(89);
        _local1.unmap(100);
        _local1.unmap(20);
        _local1.unmap(40);
        _local1.unmap(65);
        _local1.unmap(103);
        _local1.unmap(97);
        _local1.unmap(59);
        _local1.unmap(15);
        _local1.unmap(104);
        _local1.unmap(5);
        _local1.unmap(56);
        _local1.unmap(36);
        _local1.unmap(91);
        _local1.unmap(102);
        _local1.unmap(105);
        _local1.unmap(48);
        _local1.unmap(7);
        _local1.unmap(37);
        _local1.unmap(27);
        _local1.unmap(0);
        _local1.unmap(101);
        _local1.unmap(12);
        _local1.unmap(75);
        _local1.unmap(62);
        _local1.unmap(67);
        _local1.unmap(66);
        _local1.unmap(9);
        _local1.unmap(13);
        _local1.unmap(18);
        _local1.unmap(95);
        _local1.unmap(45);
        _local1.unmap(8);
        _local1.unmap(92);
        _local1.unmap(83);
        _local1.unmap(46);
        _local1.unmap(22);
        _local1.unmap(64);
        _local1.unmap(99);
        _local1.unmap(82);
        _local1.unmap(21);
        _local1.unmap(26);
        _local1.unmap(49);
        _local1.unmap(35);
        _local1.unmap(88);
        _local1.unmap(86);
        _local1.unmap(28);
        _local1.unmap(34);
        _local1.unmap(14);
        _local1.unmap(69);
        _local1.unmap(106);
        _local1.unmap(77);
        _local1.unmap(38);
        _local1.unmap(84);
    }

    private function encryptConnection():void {
        serverConnection.setOutgoingCipher(Crypto.getCipher("rc4", Parameters.RANDOM1_BA));
        serverConnection.setIncomingCipher(Crypto.getCipher("rc4", Parameters.RANDOM2_BA));
    }

    private function setChatEncryption():void {
        this.chatServerConnection.setOutgoingCipher(Crypto.getCipher("rc4", Parameters.RANDOM1_BA));
        this.chatServerConnection.setIncomingCipher(Crypto.getCipher("rc4", Parameters.RANDOM2_BA));
    }

    private function create():void {
        var _local1:CharacterClass = this.classesModel.getSelected();
        var _local2:Create = this.messages.require(61) as Create;
        _local2.classType = _local1.id;
        _local2.skinType = _local1.skins.getSelectedSkin().id;
        _local2.isChallenger = this.seasonalEventModel.isChallenger == 1;
        serverConnection.sendMessage(_local2);
        Parameters.Cache_CHARLIST_valid = false;
        Parameters.lockRecon = true;
    }

    private function load():void {
        var _local1:Load = this.messages.require(57) as Load;
        _local1.charId_ = charId_;
        _local1.isFromArena_ = isFromArena_;
        _local1.isChallenger_ = this.seasonalEventModel.isChallenger == 1;
        serverConnection.sendMessage(_local1);
        if (isFromArena_) {
            this.openDialog.dispatch(new BattleSummaryDialog());
        }
        Parameters.lockRecon = true;
    }

    private function validStatInc(_arg_1:int, _arg_2:GameObject):Boolean {
        var _local5:* = null;
        var _local6:Boolean = false;
        var _local3:* = _arg_1;
        var _local4:* = _arg_2;
        try {
            if (_local4 is Player) {
                _local5 = _local4 as Player;
            } else {
                _local5 = this.player;
            }
            if ((_local3 == 2591 || _local3 == 5465 || _local3 == 9064 || _local3 == 9729) && _local5.attackMax_ == _local5.attack_ - _local5.attackBoost_ || (_local3 == 2592 || _local3 == 5466 || _local3 == 9065 || _local3 == 9727) && _local5.defenseMax_ == _local5.defense_ - _local5.defenseBoost_ || (_local3 == 2593 || _local3 == 5467 || _local3 == 9066 || _local3 == 9726) && _local5.speedMax_ == _local5.speed_ - _local5.speedBoost_ || (_local3 == 2612 || _local3 == 5468 || _local3 == 9067 || _local3 == 9724) && _local5.vitalityMax_ == _local5.vitality_ - _local5.vitalityBoost_ || (_local3 == 2613 || _local3 == 5469 || _local3 == 9068 || _local3 == 9725) && _local5.wisdomMax_ == _local5.wisdom_ - _local5.wisdomBoost_ || (_local3 == 2636 || _local3 == 5470 || _local3 == 9069 || _local3 == 9728) && _local5.dexterityMax_ == _local5.dexterity_ - _local5.dexterityBoost_ || (_local3 == 2793 || _local3 == 5471 || _local3 == 9070 || _local3 == 9731) && _local5.maxHPMax_ == _local5.maxHP_ - _local5.maxHPBoost_ || (_local3 == 2794 || _local3 == 5472 || _local3 == 9071 || _local3 == 9730) && _local5.maxMPMax_ == _local5.maxMP_ - _local5.maxMPBoost_) {
                _local6 = false;
                var _local8:* = _local6;
                return _local8;
            }
        } catch (err:Error) {
            logger.error("PROBLEM IN STAT INC " + err.getStackTrace());
        }
        return true;
    }

    private function applyUseItem(_arg_1:GameObject, _arg_2:int, _arg_3:int, _arg_4:XML):void {
        var _local5:UseItem = this.messages.require(11) as UseItem;
        _local5.time_ = getTimer();
        _local5.slotObject_.objectId_ = _arg_1.objectId_;
        _local5.slotObject_.slotId_ = _arg_2;
        _local5.slotObject_.objectType_ = _arg_3;
        _local5.itemUsePos_.x_ = 0;
        _local5.itemUsePos_.y_ = 0;
        serverConnection.sendMessage(_local5);
        if ("Consumable" in _arg_4) {
            _arg_1.equipment_[_arg_2] = -1;
        }
    }

    private function buyConfirmation(_arg_1:SellableObject, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:Boolean = false):void {
        outstandingBuy_ = new OutstandingBuy(_arg_1.soldObjectInternalName(), _arg_1.price_, _arg_1.currency_, _arg_2);
        var _local6:Buy = this.messages.require(85) as Buy;
        _local6.objectId_ = _arg_3;
        _local6.quantity_ = _arg_4;
        serverConnection.sendMessage(_local6);
    }

    private function rsaEncrypt(_arg_1:String):String {
        var _local2:RSAKey = PEM.readRSAPublicKey(Parameters.RSA_PUBLIC_KEY);
        var _local4:ByteArray = new ByteArray();
        _local4.writeUTFBytes(_arg_1);
        var _local3:ByteArray = new ByteArray();
        _local2.encrypt(_local4, _local3, _local4.length);
        return Base64.encodeByteArray(_local3);
    }

    public function onConnected() : void {
        this.isNexusing = false;
        this.encryptConnection();
        var _local1:Account = StaticInjectorContext.getInjector().getInstance(Account);
        this.addTextLine.dispatch(ChatMessage.make(Parameters.CLIENT_CHAT_NAME, TextKey.CHAT_CONNECTED));
        var helloPacket:Hello = this.messages.require(HELLO) as Hello;
        helloPacket.buildVersion_ = (Parameters.data.customVersion == "" ?
        Parameters.CLIENT_VERSION : Parameters.data.customVersion);
        var gameId:int = gameId_;
        helloPacket.gameId_ = gameId;
        helloPacket.guid_ = this.rsaEncrypt(_local1.getUserId());
        helloPacket.password_ = this.rsaEncrypt(_local1.getPassword());
        helloPacket.secret_ = this.rsaEncrypt(_local1.getSecret());
        helloPacket.keyTime_ = keyTime_;
        helloPacket.key_.length = 0;
        this.key_ && helloPacket.key_.writeBytes(this.key_);
        helloPacket.mapJSON_ = mapJSON_ == null ? "" : this.mapJSON_;
        helloPacket.entrytag_ = _local1.getEntryTag();
        helloPacket.gameNet = "rotmg";
        helloPacket.gameNetUserId = _local1.gameNetworkUserId();
        helloPacket.playPlatform = "rotmg";
        helloPacket.platformToken = _local1.getPlatformToken();
        helloPacket.userToken = _local1.getToken();
        helloPacket.previousConnectionGuid = connectionGuid;
        serverConnection.sendMessage(helloPacket);
    }

    private function onCreateSuccess(_arg_1:CreateSuccess):void {
        Parameters.iDrankVaultUnlocker = false;
        this.playerId_ = _arg_1.objectId_;
        charId_ = _arg_1.charId_;
        gs_.initialize();
        createCharacter_ = false;
        Parameters.lockRecon = false;
    }

    private function onDamage(_arg_1:Damage):void {
        var _local6:int = 0;
        var _local4:* = false;
        var _local8:* = undefined;
        var _local7:* = undefined;
        var _local2:* = null;
        if (Parameters.lowCPUMode) {
            if (_arg_1.objectId_ != this.player.objectId_ || _arg_1.targetId_ != this.player.objectId_) {
                return;
            }
        }
        var _local5:AbstractMap = gs_.map;
        if (_arg_1.objectId_ >= 0 && _arg_1.bulletId_ > 0) {
            _local6 = Projectile.findObjId(_arg_1.objectId_, _arg_1.bulletId_);
            _local2 = _local5.boDict_[_local6] as Projectile;
            if (_local2 && !_local2.projProps_.multiHit_) {
                _local5.removeObj(_local6);
            }
        }
        var _local3:GameObject = _local5.goDict_[_arg_1.targetId_];
        if (_local3 && _local3.props_.isEnemy_) {
            _local4 = _arg_1.objectId_ == this.player.objectId_;
            _local3.damage(_local4, _arg_1.damageAmount_, _arg_1.effects_, _arg_1.kill_, _local2, _arg_1.armorPierce_);
            if (_local4) {
                if (isNaN(Parameters.dmgCounter[_arg_1.targetId_])) {
                    Parameters.dmgCounter[_arg_1.targetId_] = 0;
                }
                _local8 = _arg_1.targetId_;
                _local7 = Parameters.dmgCounter[_local8] + _arg_1.damageAmount_;
                Parameters.dmgCounter[_local8] = _local7;
            }
        }
    }

    private function onServerPlayerShoot(_arg_1:ServerPlayerShoot):void {
        var _local5:* = _arg_1.ownerId_ == this.playerId_;
        var _local2:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
        if (_local2 == null || _local2.dead_) {
            if (_local5) {
                this.shootAck(-1);
            }
            return;
        }
        if (_local2.objectId_ != this.playerId_ && Parameters.data.disableAllyShoot) {
            return;
        }
        var _local4:Projectile = FreeList.newObject(Projectile) as Projectile;
        var _local3:Player = _local2 as Player;
        if (_local3) {
            _local4.reset(_arg_1.containerType_, 0, _arg_1.ownerId_, _arg_1.bulletId_, _arg_1.angle_, gs_.lastUpdate_, _local3.projectileIdSetOverrideNew, _local3.projectileIdSetOverrideOld);
        } else {
            _local4.reset(_arg_1.containerType_, 0, _arg_1.ownerId_, _arg_1.bulletId_, _arg_1.angle_, gs_.lastUpdate_);
        }
        _local4.setDamage(_arg_1.damage_);
        gs_.map.addObj(_local4, _arg_1.startingPos_.x_, _arg_1.startingPos_.y_);
        if (_local5) {
            this.shootAck(gs_.lastUpdate_);
            if (!_local4.update(_local4.startTime_, 0)) {
                gs_.map.removeObj(_local4.objectId_);
            }
        }
    }

    private function onAllyShoot(param1:AllyShoot) : void {
        var _local5:* = null;
        var _local6:* = null;
        var _local3:* = NaN;
        var _local2:* = NaN;
        var _local4:GameObject = this.gs_.map.goDict_[param1.ownerId_];
        if(_local4) {
            if(_local4.dead_) {
                return;
            }
            if(Parameters.data.disableAllyShoot == 1) {
                return;
            }
            _local4.setAttack(param1.containerType_,param1.angle_);
            if(Parameters.data.disableAllyShoot == 2) {
                return;
            }
            _local5 = FreeList.newObject(Projectile) as Projectile;
            _local6 = _local4 as Player;
            if(_local6) {
                _local3 = Number(_local6.projectileLifeMul_);
                _local2 = Number(_local6.projectileSpeedMult_);
                if(!param1.bard_) {
                    _local3 = 1;
                    _local2 = 1;
                }
                _local5.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,this.gs_.lastUpdate_,_local6.projectileIdSetOverrideNew,_local6.projectileIdSetOverrideOld,_local3,_local2);
            } else {
                _local5.reset(param1.containerType_,0,param1.ownerId_,param1.bulletId_,param1.angle_,this.gs_.lastUpdate_);
            }
            this.gs_.map.addObj(_local5,_local4.x_,_local4.y_);
        }
    }

    private function onReskinUnlock(_arg_1:ReskinUnlock):void {
        var _local3:* = 0;
        var _local2:* = null;
        var _local4:* = null;
        if (_arg_1.isPetSkin == 0) {
            var _local6:int = 0;
            var _local5:* = this.model.player.lockedSlot;
            for (_local3 in this.model.player.lockedSlot) {
                if (this.model.player.lockedSlot[_local3] == _arg_1.skinID) {
                    this.model.player.lockedSlot[_local3] = 0;
                }
            }
            _local2 = this.classesModel.getCharacterClass(this.model.player.objectType_).skins.getSkin(_arg_1.skinID);
            _local2.setState(CharacterSkinState.OWNED);
        } else {
            _local4 = StaticInjectorContext.getInjector().getInstance(PetsModel);
            _local4.unlockSkin(_arg_1.skinID);
        }
    }

    private function onEnemyShoot(_arg_1:EnemyShoot):void {
        var _local4:int = 0;
        var _local6:Projectile = null;
        var _local5:Number = NaN;
        var _local3:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
        if (_local3 == null || _local3.dead_) {
            this.shootAck(-1);
            return;
        }
        if (Parameters.suicideMode) {
            _arg_1.startingPos_.x_ = player.x_;
            _arg_1.startingPos_.y_ = player.y_;
        }
        var _local2:ObjectProperties = ObjectLibrary.propsLibrary_[_local3.objectType_];
        var _local7:ProjectileProperties = _local2.projectiles_[_arg_1.bulletType_];
        _local4 = 0;
        while (_local4 < _arg_1.numShots_) {
            _local6 = FreeList.newObject(Projectile) as Projectile;
            _local5 = _arg_1.angle_ + _arg_1.angleInc_ * _local4;
            _local6.reset(_local3.objectType_, _arg_1.bulletType_, _arg_1.ownerId_, (_arg_1.bulletId_ + _local4) % 256, _local5, gs_.lastUpdate_, "", "", 1, 1, _local2, _local7);
            _local6.setDamage(_arg_1.damage_);
            gs_.map.addObj(_local6, _arg_1.startingPos_.x_, _arg_1.startingPos_.y_);
            _local4++;
        }
        this.shootAck(gs_.lastUpdate_);
        _local3.setAttack(_local3.objectType_, _arg_1.angle_ + _arg_1.angleInc_ * ((_arg_1.numShots_ - 1) * 0.5));
    }

    private function onTradeRequested(_arg_1:TradeRequested):void {
        if (Parameters.autoAcceptTrades || Parameters.receivingPots) {
            this.requestTrade(_arg_1.name_);
            return;
        }
        if (!Parameters.data.chatTrade) {
            return;
        }
        if (Parameters.data.tradeWithFriends && !this.socialModel.isMyFriend(_arg_1.name_)) {
            return;
        }
        if (Parameters.data.showTradePopup) {
            gs_.hudView.interactPanel.setOverride(new TradeRequestPanel(gs_, _arg_1.name_));
        }
        this.addTextLine.dispatch(ChatMessage.make("", _arg_1.name_ + " wants to " + "trade with you.  Type \"/trade " + _arg_1.name_ + "\" to trade."));
    }

    private function onTradeStart(_arg_1:TradeStart):void {
        gs_.hudView.startTrade(gs_, _arg_1);
        if (Parameters.givingPotions) {
            this.changeTrade(Parameters.potionsToTrade);
            this.acceptTrade(Parameters.potionsToTrade, Parameters.emptyOffer);
            Parameters.givingPotions = false;
        }
    }

    private function onTradeChanged(_arg_1:TradeChanged):void {
        gs_.hudView.tradeChanged(_arg_1);
        if (Parameters.receivingPots) {
            this.acceptTrade(Parameters.emptyOffer, _arg_1.offer_);
            Parameters.receivingPots = false;
        }
    }

    private function onTradeDone(_arg_1:TradeDone):void {
        var _local4:* = null;
        var _local3:* = null;
        gs_.hudView.tradeDone();
        var _local2:String = "";
        try {
            _local3 = JSON.parse(_arg_1.description_);
            _local2 = _local3.key;
            _local4 = _local3.tokens;
        } catch (e:Error) {
        }
        this.addTextLine.dispatch(ChatMessage.make("", _local2, -1, -1, "", false, _local4));
        if (Parameters.autoDrink && _arg_1.code_ == 0) {
            Parameters.watchInv = true;
        }
    }

    private function onTradeAccepted(_arg_1:TradeAccepted):void {
        gs_.hudView.tradeAccepted(_arg_1);
        if (Parameters.autoAcceptTrades || Parameters.receivingPots) {
            acceptTrade(_arg_1.myOffer_, _arg_1.yourOffer_);
        }
    }

    private function addObject(_arg1:ObjectData):void {
        var _local2:AbstractMap = gs_.map;
        var _local3:GameObject = ObjectLibrary.getObjectFromType(_arg1.objectType_);
        if (_local3 == null) {
            return;
        }
        var _local4:ObjectStatusData = _arg1.status_;
        _local3.setObjectId(_local4.objectId_);
        _local2.addObj(_local3, _local4.pos_.x_, _local4.pos_.y_);
        if ((_local3 is Player)) {
            this.handleNewPlayer((_local3 as Player), _local2);
        }
        this.processObjectStatus(_local4, 0, -1);
        if (((((_local3.props_.static_) && (_local3.props_.occupySquare_))) && (!(_local3.props_.noMiniMap_)))) {
            this.updateGameObjectTileSignal.dispatch(_local3.x_, _local3.y_, _local3);
        }
    }

    private function handleNewPlayer(_arg1:Player, _arg2:AbstractMap):void {
        this.setPlayerSkinTemplate(_arg1, 0);
        if (_arg1.objectId_ == this.playerId_) {
            this.player = _arg1;
            this.model.player = _arg1;
            _arg2.player_ = _arg1;
            gs_.setFocus(_arg1);
            this.setGameFocus.dispatch(this.playerId_.toString());
        }
    }

    private function onUpdate(_arg1:Update):void {
        var _local3:int;
        var _local4:GroundTileData;
        var _local2:Message = this.messages.require(UPDATEACK);
        serverConnection.queueMessage(_local2);
        _local3 = 0;
        while (_local3 < _arg1.tiles_.length) {
            _local4 = _arg1.tiles_[_local3];
            gs_.map.setGroundTile(_local4.x_, _local4.y_, _local4.type_);
            this.updateGroundTileSignal.dispatch(_local4.x_, _local4.y_, _local4.type_);
            _local3++;
        }
        _local3 = 0;
        while (_local3 < _arg1.drops_.length) {
            gs_.map.removeObj(_arg1.drops_[_local3]);
            _local3++;
        }
        _local3 = 0;
        while (_local3 < _arg1.newObjs_.length) {
            this.addObject(_arg1.newObjs_[_local3]);
            _local3++;
        }
        gs_.map.calcVulnerables();
    }

    private function onNotification(notif:Notification) : void {
        var lineBuilder:LineBuilder = null;
        var go:GameObject = this.gs_.map.goDict_[notif.objectId_];
        if (go) {
            lineBuilder = LineBuilder.fromJSON(notif.message);
            if (Parameters.data.ignoreStatusText && lineBuilder.key == "server.no_effect")
                return;

            switch (lineBuilder.key) {
                case "server.plus_symbol":
                    notif.message = "+" + lineBuilder.tokens.amount;
                    break;
                case "server.no_effect":
                    notif.message = "No Effect";
                    break;
                case "server.class_quest_complete":
                    notif.message = "Class Quest Completed!";
                    break;
                case "server.quest_complete":
                    notif.message = "Quest Complete!";
                    break;
                case "blank":
                    notif.message = lineBuilder.tokens.data;
                    break;
            }

            if (go.objectId_ == this.player.objectId_) {
                if (notif.message == "Quest Complete!")
                    this.gs_.map.quest_.completed();
                else if (lineBuilder.key == "server.plus_symbol" && notif.color_ == 0xff00)
                    this.player.addHealth(lineBuilder.tokens.amount);

                this.makeNotification(notif.message, go, notif.color_, 1000);
            } else if (go.props_.isEnemy_ || !Parameters.data.noAllyNotifications)
                this.makeNotification(notif.message, go, notif.color_, 1000);
        }
    }

    private function makeNotification(_arg_1:String, _arg_2:GameObject, _arg_3:uint, _arg_4:int):void {
        var _local5:CharacterStatusText = new CharacterStatusText(_arg_2, _arg_3, _arg_4);
        _local5.setText(_arg_1);
        gs_.map.mapOverlay_.addStatusText(_local5);
    }

    private function onGlobalNotification(_arg_1:GlobalNotification):void {
        var _local2:* = _arg_1.text;
        switch (_local2) {
            case "yellow":
                ShowKeySignal.instance.dispatch(Key.YELLOW);
                return;
            case "red":
                ShowKeySignal.instance.dispatch(Key.RED);
                return;
            case "green":
                ShowKeySignal.instance.dispatch(Key.GREEN);
                return;
            case "purple":
                ShowKeySignal.instance.dispatch(Key.PURPLE);
                return;
            case "showKeyUI":
                this.showHideKeyUISignal.dispatch(false);
                return;
            case "giftChestOccupied":
                this.giftChestUpdateSignal.dispatch(true);
                return;
            case "giftChestEmpty":
                this.giftChestUpdateSignal.dispatch(false);
                return;
            case "beginnersPackage":
                return;
            default:
                return;
        }
    }

    private var ticksElapsed:int = 0;
    private function onNewTick(_arg_1:NewTick):void {
        var _local2:int = 0;
        var _local4:Boolean = false;
        if (this.jitterWatcher_) {
            this.jitterWatcher_.record();
        }
        lastServerRealTimeMS_ = _arg_1.serverRealTimeMS_;
        this.move(_arg_1.tickId_, this.lastServerRealTimeMS_, this.player);
        this.ticksElapsed++;
        for each(var _local3:ObjectStatusData in _arg_1.statuses_) {
            this.processObjectStatus(_local3, _arg_1.tickTime_, _arg_1.tickId_);
        }
        this.lastTickId_ = _arg_1.tickId_;
        this.gs_.map.calcVulnerables();
        if (Parameters.usingPortal) {
            _local2 = 0;
            while (_local2 < Parameters.portalSpamRate) {
                usePortal(Parameters.portalID);
                _local2++;
            }
        }
        if (Parameters.watchInv) {
            _local2 = 4;
            while (_local2 < 12) {
                if (player.equipment_[_local2] != -1) {
                    if (player.shouldDrink(player.getPotType(player.equipment_[_local2]))) {
                        useItem(gs_.lastUpdate_, player.objectId_, _local2, player.equipment_[_local2], player.x_, player.y_, 1);
                        _local4 = true;
                    }
                }
                _local2++;
            }
            if (_local4) {
                Parameters.watchInv = false;
            }
        }
    }

    private function canShowEffect(_arg_1:GameObject):Boolean {
        if (_arg_1) {
            return true;
        }
        if (_arg_1.objectId_ != this.playerId_ && _arg_1.props_.isPlayer_ && Parameters.data.disableAllyShoot) {
            return false;
        }
        return true;
    }

    private function onShowEffect(param1:ShowEffect) : void {
        var _local2:* = null;
        var _local4:* = null;
        var _local3:int = 0;
        var _local6:AbstractMap = gs_.map;
        var _local5:GameObject = _local6.goDict_[param1.targetObjectId_];
        if(_local5) {
            if(param1.effectType_ == 12 && param1.color_ == 0xff0088) {
                Parameters.mystics.push(_local5.name_ + " " + getTimer());
            }
            if(_local5.props_.isPlayer_ && _local5.objectId_ != this.playerId_ && Parameters.data.alphaOnOthers) {
                return;
            }
        }
        if(Parameters.lowCPUMode && !(param1.effectType_ == 23 || param1.effectType_ == 22 || param1.effectType_ == 26 || param1.effectType_ == 24)) {
            return;
        }
        if(Parameters.data.liteParticle && !(param1.effectType_ == 4 || param1.effectType_ == 12 || param1.effectType_ == 16 || param1.effectType_ == 15 || param1.effectType_ == 23 || param1.effectType_ == 22 || param1.effectType_ == 26 || param1.effectType_ == 24)) {
            return;
        }
        if(Parameters.data.noParticlesMaster && (param1.effectType_ == 1 || param1.effectType_ == 2 || param1.effectType_ == 3 || param1.effectType_ == 6 || param1.effectType_ == 7 || param1.effectType_ == 9 || param1.effectType_ == 12 || param1.effectType_ == 13 || param1.effectType_ == 20)) {
            return;
        }
        var _local7:uint = param1.effectType_;
        switch (_local7) {
            case 1:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local6.addObj(new HealEffect(_local5, param1.color_), _local5.x_, _local5.y_);
                break;
            case 2:
                _local6.addObj(new TeleportEffect(), param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 3:
                _local2 = new StreamEffect(param1.pos1_, param1.pos2_, param1.color_);
                _local6.addObj(_local2, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 4:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                _local4 = _local5 != null ? new Point(_local5.x_, _local5.y_) : param1.pos2_.toPoint();
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new ThrowEffect(_local4, param1.pos1_.toPoint(), param1.color_, param1.duration_ * 1000);
                _local6.addObj(_local2, _local4.x, _local4.y);
                break;
            case 5:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new NovaEffect(_local5, param1.pos1_.x_, param1.color_);
                _local6.addObj(_local2, _local5.x_, _local5.y_);
            case 20:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new PoisonEffect(_local5, param1.pos1_, param1.pos2_, param1.color_);
                _local6.addObj(_local2, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 6:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new LineEffect(_local5, param1.pos1_, param1.color_);
                _local6.addObj(_local2, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 7:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new BurstEffect(_local5, param1.pos1_, param1.pos2_, param1.color_);
                _local6.addObj(_local2, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 8:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new FlowEffect(param1.pos1_, _local5, param1.color_);
                _local6.addObj(_local2, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 9:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new RingEffect(_local5, param1.pos1_.x_, param1.color_);
                _local6.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 10:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new LightningEffect(_local5, param1.pos1_, param1.color_, param1.pos2_.x_);
                _local6.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 11:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new CollapseEffect(_local5, param1.pos1_, param1.pos2_, param1.color_);
                _local6.addObj(_local2, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 13:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new ConeBlastEffect(_local5, param1.pos1_, param1.pos2_.x_, param1.color_);
                _local6.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 14:
                gs_.camera_.startJitter();
                break;
            case 15:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.flash = new FlashDescription(getTimer(), param1.color_, param1.pos1_.x_, param1.pos1_.y_);
                break;
            case 16:
                _local4 = param1.pos1_.toPoint();
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new ThrowProjectileEffect(param1.color_, param1.pos2_.toPoint(), param1.pos1_.toPoint(), param1.duration_ * 1000);
                _local6.addObj(_local2, _local4.x, _local4.y);
                break;
            case 21:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                if (_local5 && _local5.spritesProjectEffect) {
                    _local5.spritesProjectEffect.destroy();
                }
                _local6.addObj(new InspireEffect(_local5, 16759296, 5), _local5.x_, _local5.y_);
                _local5.flash = new FlashDescription(getTimer(), param1.color_, param1.pos2_.x_, param1.pos2_.y_);
                _local2 = new SpritesProjectEffect(_local5, param1.pos1_.x_);
                _local5.spritesProjectEffect = SpritesProjectEffect(_local2);
                this.gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 17:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                if (_local5 && !_local5.shockEffect) {
                    _local2 = new ShockerEffect(_local5);
                    _local5.shockEffect = ShockerEffect(_local2);
                    gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                }
                break;
            case 18:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                if (!_local5.hasShock) {
                    _local2 = new ShockeeEffect(_local5);
                    gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                }
                break;
            case 19:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local7 = param1.pos1_.x_ * 1000;
                _local2 = new RisingFuryEffect(_local5, _local7);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 22:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new HolyBeamEffect(_local5, param1.pos1_.x_ * 1000, 0);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 23:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new CircleTelegraph(_local5, param1.pos1_.x_ * 1000, param1.pos1_.y_);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 24:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new HolyBeamEffect(_local5, param1.pos1_.x_ * 1000, 1);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 25:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new SmokeCloudEffect(_local5, param1.pos1_.x_ * 1000, param1.pos1_.y_, 2 * 60, 1);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                _local2 = new SmokeCloudEffect(_local5, param1.pos1_.x_ * 750, param1.pos1_.y_ * 1.5, 60, 0.33);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 26:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local2 = new MeteorEffect(_local5, param1.pos1_.x_ * 1000, 0);
                gs_.map.addObj(_local2, _local5.x_, _local5.y_);
                break;
            case 27:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.flash = new FlashDescription(getTimer(), 16768115, 0.5, 9);
                _local6.addObj(new GildedEffect(_local5, 16768115, 16751104, 10904576, 2, 75 * 60), _local5.x_, _local5.y_);
                break;
            case 28:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.flash = new FlashDescription(getTimer(), 4736621, 0.5, 9);
                _local6.addObj(new GildedEffect(_local5, 4736621, 4031656, 4640207, 2, 75 * 60), _local5.x_, _local5.y_);
                break;
            case 29:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.flash = new FlashDescription(getTimer(), 3675232, 0.5, 9);
                _local6.addObj(new GildedEffect(_local5, 3675232, 11673446, 16659566, 2, 75 * 60), _local5.x_, _local5.y_);
                break;
            case 30:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.flash = new FlashDescription(getTimer(), 16768115, 0.25, 1);
                _local6.addObj(new ThunderEffect(_local5), _local5.x_, _local5.y_);
                break;
            case 31:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.statusFlash_ = new StatusFlashDescription(getTimer(), param1.color_, param1.pos1_.x_);
                break;
            case 32:
                _local5 = _local6.goDict_[param1.targetObjectId_];
                if (_local5 == null || !this.canShowEffect(_local5)) {
                    return;
                }
                _local5.flash = new FlashDescription(getTimer(), 11673446, 0.25, 1);
                _local6.addObj(new OrbEffect(_local5, 11673446, 3675232, 16659566, 1.5, 2500, param1.pos1_.toPoint()), param1.pos1_.x_, param1.pos1_.y_);
                break;
        }
    }

    private function onGoto(_arg_1:Goto):void {
        this.gotoAck(gs_.lastUpdate_);
        var _local2:GameObject = gs_.map.goDict_[_arg_1.objectId_];
        if (_local2 == null) {
            return;
        }
        _local2.onGoto(_arg_1.pos_.x_, _arg_1.pos_.y_, gs_.lastUpdate_);
    }

    private var updatedPet:Boolean;
    private function updateGameObject(param1:GameObject, param2:Vector.<StatData>, param3:Boolean, param4:Boolean) : void {
        var _local5:int = 0;
        var _local12:int = 0;
        var _local7:int = 0;
        var _local10:* = null;
        var _local9:int = 0;
        var _local14:Player = param1 as Player;
        var _local8:Merchant = param1 as Merchant;
        var _local13:Pet = param1 as Pet;
        if(_local13) {
            this.petUpdater.updatePet(_local13,param2);
            if (this.gs_.map.isPetYard)
                this.petUpdater.updatePetVOs(_local13,param2);
            param1.updateStatuses();
            return;
        }
        var _local6:int = param2.length;
        var _local11:Boolean = false;
        _local9 = 0;
        while(_local9 < _local6) {
            _local10 = param2[_local9];
            _local12 = _local10.statValue_;
            _local5 = _local10.statType_;
            switch (_local5) {
                case StatData.MAX_HP_STAT:
                    if (param3) {
                        _local14.maxHpChanged(_local12);
                        param1.maxHP_ = _local12;
                        _local14.calcHealthPercent();
                    } else {
                        param1.maxHP_ = _local12;
                    }
                    break;
                case StatData.HP_STAT:
                    if (param3) {
                        if (param4) {
                            _local14.clientHp = _local12;
                            _local14.maxHpChanged(_local12);
                        }
                        _local14.hp2 = _local12;
                    }
                    param1.hp_ = _local12;
                    if (param1.dead_ && _local12 > 1 && param1.props_.isEnemy_ && _local15 >= 2) {
                        param1.dead_ = false;
                    }
                    break;
                case StatData.SIZE_STAT:
                    param1.size_ = _local12;
                    break;
                case StatData.MAX_MP_STAT:
                    _local14.maxMP_ = _local12;
                    if (param3) {
                        _local14.calcManaPercent();
                    }
                    break;
                case StatData.MP_STAT:
                    _local14.mp_ = _local12;
                    if (_local12 == 0) {
                        _local14.mpZeroed_ = true;
                    }
                    break;
                case StatData.NEXT_LEVEL_EXP_STAT:
                    _local14.nextLevelExp_ = _local12;
                    break;
                case StatData.EXP_STAT:
                    _local14.exp_ = _local12;
                    break;
                case StatData.LEVEL_STAT:
                    param1.level_ = _local12;
                    if (param3) {
                        this.realmQuestLevelSignal.dispatch(_local12);
                    }
                    break;
                case StatData.ATTACK_STAT:
                    _local14.attack_ = _local12;
                    break;
                case StatData.DEFENSE_STAT:
                    param1.defense_ = _local12;
                    break;
                case StatData.SPEED_STAT:
                    _local14.speed_ = _local12;
                    break;
                case StatData.DEXTERITY_STAT:
                    _local14.dexterity_ = _local12;
                    break;
                case StatData.VITALITY_STAT:
                    _local14.vitality_ = _local12;
                    break;
                case StatData.WISDOM_STAT:
                    _local14.wisdom = _local12;
                    break;
                case StatData.CONDITION_STAT:
                    param1.condition_[0] = _local12;
                    param1.updateStatuses();
                    break;
                case StatData.INVENTORY_0_STAT:
                case StatData.INVENTORY_1_STAT:
                case StatData.INVENTORY_2_STAT:
                case StatData.INVENTORY_3_STAT:
                case StatData.INVENTORY_4_STAT:
                case StatData.INVENTORY_5_STAT:
                case StatData.INVENTORY_6_STAT:
                case StatData.INVENTORY_7_STAT:
                case StatData.INVENTORY_8_STAT:
                case StatData.INVENTORY_9_STAT:
                case StatData.INVENTORY_10_STAT:
                case StatData.INVENTORY_11_STAT:
                    _local7 = _local10.statType_ - 8;
                    if (_local12 != -1) {
                        param1.lockedSlot[_local7] = 0;
                    }
                    param1.equipment_[_local7] = _local12;
                    break;
                case StatData.NUM_STARS_STAT:
                    _local14.numStars_ = _local12;
                    break;
                case StatData.CHALLENGER_STARBG_STAT:
                    _local14.starsBg_ = _local12 >= 0 ? int(_local12) : 0;
                    break;
                case StatData.NAME_STAT:
                    if (param1.name_ != _local10.strStatValue_) {
                        param1.name_ = _local10.strStatValue_;
                        param1.nameBitmapData_ = null;
                        if (param1.name_.toUpperCase() == Parameters.followName) {
                            Parameters.followPlayer = param1;
                        }
                    }
                    break;
                case StatData.TEX1_STAT:
                    _local12 >= 0 && param1.setTex1(_local12);
                    break;
                case StatData.TEX2_STAT:
                    _local12 >= 0 && param1.setTex2(_local12);
                    break;
                case StatData.MERCHANDISE_TYPE_STAT:
                    _local8.setMerchandiseType(_local12);
                    break;
                case StatData.CREDITS_STAT:
                    _local14.setCredits(_local12);
                    break;
                case StatData.MERCHANDISE_PRICE_STAT:
                    if (param1 is SellableObject) {
                        param1.setPrice(_local12);
                    }
                    break;
                case StatData.ACTIVE_STAT:
                    (param1 as Portal).active_ = _local12 != 0;
                    break;
                case StatData.ACCOUNT_ID_STAT:
                    _local14.accountId_ = param2[_local9].strStatValue_;
                    break;
                case StatData.FAME_STAT:
                    _local14.setFame(_local12);
                    break;
                case StatData.FORTUNE_TOKEN_STAT:
                    _local14.setTokens(_local12);
                    break;
                case StatData.SUPPORTER_POINTS_STAT:
                    if (_local14) {
                        _local14.supporterPoints = _local12;
                        _local14.clearTextureCache();
                        if (param3) {
                            this.injector.getInstance(SupporterCampaignModel).updatePoints(_local12);
                        }
                    }
                    break;
                case StatData.SUPPORTER_STAT:
                    if (_local14) {
                        _local14.setSupporterFlag(_local12);
                    }
                    break;
                case StatData.MERCHANDISE_CURRENCY_STAT:
                    (param1 as SellableObject).setCurrency(_local12);
                    break;
                case StatData.CONNECT_STAT:
                    param1.connectType_ = _local12;
                    break;
                case StatData.MERCHANDISE_COUNT_STAT:
                    _local8.count_ = _local12;
                    _local8.untilNextMessage_ = 0;
                    break;
                case StatData.MERCHANDISE_MINS_LEFT_STAT:
                    _local8.minsLeft_ = _local12;
                    _local8.untilNextMessage_ = 0;
                    break;
                case StatData.MERCHANDISE_DISCOUNT_STAT:
                    _local8.discount_ = _local12;
                    _local8.untilNextMessage_ = 0;
                    break;
                case StatData.MERCHANDISE_RANK_REQ_STAT:
                    (param1 as SellableObject).setRankReq(_local12);
                    break;
                case StatData.MAX_HP_BOOST_STAT:
                    if (param3) {
                        _local11 = true;
                    }
                    _local14.maxHPBoost_ = _local12;
                    break;
                case StatData.MAX_MP_BOOST_STAT:
                    _local14.maxMPBoost_ = _local12;
                    break;
                case StatData.ATTACK_BOOST_STAT:
                    _local14.attackBoost_ = _local12;
                    break;
                case StatData.DEFENSE_BOOST_STAT:
                    _local14.defenseBoost_ = _local12;
                    break;
                case StatData.SPEED_BOOST_STAT:
                    _local14.speedBoost_ = _local12;
                    break;
                case StatData.VITALITY_BOOST_STAT:
                    _local14.vitalityBoost_ = _local12;
                    break;
                case StatData.WISDOM_BOOST_STAT:
                    _local14.wisdomBoost_ = _local12;
                    break;
                case StatData.DEXTERITY_BOOST_STAT:
                    _local14.dexterityBoost_ = _local12;
                    break;
                case StatData.OWNER_ACCOUNT_ID_STAT:
                    (param1 as Container).setOwnerId(param2[_local9].strStatValue_);
                    break;
                case StatData.RANK_REQUIRED_STAT:
                    (param1 as NameChanger).setRankRequired(_local12);
                    break;
                case StatData.NAME_CHOSEN_STAT:
                    _local14.nameChosen_ = _local12 != 0;
                    param1.nameBitmapData_ = null;
                    break;
                case StatData.CURR_FAME_STAT:
                    _local14.currFame_ = _local12;
                    break;
                case StatData.NEXT_CLASS_QUEST_FAME_STAT:
                    _local14.nextClassQuestFame_ = _local12;
                    break;
                case StatData.LEGENDARY_RANK_STAT:
                    _local14.legendaryRank_ = _local12;
                    break;
                case StatData.SINK_LEVEL_STAT:
                    if (!param3) {
                        _local14.sinkLevel = _local12;
                    }
                    break;
                case StatData.ALT_TEXTURE_STAT:
                    param1.setAltTexture(_local12);
                    break;
                case StatData.GUILD_NAME_STAT:
                    _local14.setGuildName(param2[_local9].strStatValue_);
                    break;
                case StatData.GUILD_RANK_STAT:
                    _local14.guildRank_ = _local12;
                    break;
                case StatData.BREATH_STAT:
                    _local14.breath_ = _local12;
                    break;
                case StatData.XP_BOOSTED_STAT:
                    _local14.xpBoost_ = _local12;
                    break;
                case StatData.XP_TIMER_STAT:
                    _local14.xpTimer = _local12 * 1000;
                    break;
                case StatData.LD_TIMER_STAT:
                    _local14.dropBoost = _local12 * 1000;
                    break;
                case StatData.LT_TIMER_STAT:
                    _local14.tierBoost = _local12 * 1000;
                    break;
                case StatData.HEALTH_POTION_STACK_STAT:
                    _local14.healthPotionCount_ = _local12;
                    break;
                case StatData.MAGIC_POTION_STACK_STAT:
                    _local14.magicPotionCount_ = _local12;
                    break;
                case StatData.PROJECTILE_LIFE_MULT:
                    _local14.projectileLifeMult = _local12 / 1000;
                    break;
                case StatData.PROJECTILE_SPEED_MULT:
                    _local14.projectileSpeedMult = _local12 / 1000;
                    break;
                case StatData.TEXTURE_STAT:
                    if (_local14) {
                        _local14.skinId != _local12 && _local12 >= 0 && this.setPlayerSkinTemplate(_local14, _local12);
                    } else if (param1.objectType_ == 1813 && _local12 > 0) {
                        param1.setTexture(_local12);
                    }
                    break;
                case StatData.HASBACKPACK_STAT:
                    (param1 as Player).hasBackpack_ = Boolean(_local12);
                    if (param3) {
                        this.updateBackpackTab.dispatch(Boolean(_local12));
                    }
                    break;
                case StatData.BACKPACK_0_STAT:
                case StatData.BACKPACK_1_STAT:
                case StatData.BACKPACK_2_STAT:
                case StatData.BACKPACK_3_STAT:
                case StatData.BACKPACK_4_STAT:
                case StatData.BACKPACK_5_STAT:
                case StatData.BACKPACK_6_STAT:
                case StatData.BACKPACK_7_STAT:
                    _local7 = _local10.statType_ - 71 + 4 + 8;
                    (param1 as Player).equipment_[_local7] = _local12;
                    break;
                case StatData.NEW_CON_STAT:
                    param1.condition_[1] = _local12;
                    param1.updateStatuses();
                    break;
                case StatData.EXALTED_HP:
                  (param1 as Player).exaltedHealth = _local12;
                  continue;
                case StatData.EXALTED_MANA:
                  (param1 as Player).exaltedMana = _local12;
                  continue;
                case StatData.EXALTED_ATT:
                  (param1 as Player).exaltedAttack = _local12;
                  continue;
                case StatData.EXALTED_DEF:
                  (param1 as Player).exaltedDefense = _local12;
                  continue;
                case StatData.EXALTED_SPD:
                  (param1 as Player).exaltedSpeed = _local12;
                  continue;
                case StatData.EXALTED_DEX:
                  (param1 as Player).exaltedDexterity = _local12;
                  continue;
                case StatData.EXALTED_VIT:
                  (param1 as Player).exaltedVitality = _local12;
                  continue;
                case StatData.EXALTED_WIS:
                  (param1 as Player).exaltedWisdom = _local12;
                  continue;
                case StatData.EXALTED_HP:
                  (param1 as Player).exaltationDamageMultiplier = _local12 / 10;
                  continue;
                case StatData.IC_REDUCTION:
                  _loc16_ = param1 as Player;
                  trace("Exaltation IC Reduction: " + _loc5_ + " on Player \'" + _loc16_.name_ + "\'\n" + "Attack: " + _loc16_.exaltedAttack + "\n" + "Defense: " + _loc16_.exaltedDefense + "\n" + "Dexterity: " + _loc16_.exaltedDexterity + "\n" + "Speed: " + _loc16_.exaltedSpeed + "\n" + "Vitality: " + _loc16_.exaltedVitality + "\n" + "Wisdom: " + _loc16_.exaltedWisdom + "\n" + "Health: " + _loc16_.exaltedHealth + "\n" + "Mana: " + _loc16_.exaltedMana);
                  continue;
                case StatData.OPENED_AT:
                  (param1 as Portal).openedAtTimestamp = _local12;
                  continue;
                case UNKNOWN:
                    continue;
                default:
                    trace("Unhandled stat type:",_local5_,"statVal:",_local12,"strStatVal:",_local10.strStatValue_,"name:",param1.name_);
                    continue;
            }
            _local9++;
        }
        if(param3) {
            if(_local11) {
                _local14.triggerHealBuffer();
            }
            if(Parameters.data.AutoSyncClientHP && Math.abs(_local14.clientHp - _local14.hp_) > 60) {
                var _local15:Number = _local14.ticksHPLastOff;
                _local14.ticksHPLastOff = _local15 + 1;
                if(_local15 > 3) {
                    _local14.ticksHPLastOff = 0;
                    _local14.clientHp = _local14.hp_;
                }
            }
        }
    }
    private function processObjectStatus(_arg_1:ObjectStatusData, _arg_2:int, _arg_3:int):void {
        var _local14:int = 0;
        var _local11:int = 0;
        var _local5:int = 0;
        var _local10:int = 0;
        var _local13:* = null;
        var _local15:* = null;
        var _local17:* = null;
        var _local18:* = null;
        var _local4:int = 0;
        var _local6:* = null;
        var _local9:* = null;
        var _local8:* = null;
        var _local16:GameObject = this.gs_.map.goDict_[_arg_1.objectId_];
        if (_local16 == null) {
            return;
        }
        var _local7:* = _arg_1.objectId_ == this.playerId_;
        if (_arg_2 != 0) {
            if (!_local7) {
                _local16.onTickPos(_arg_1.pos_.x_, _arg_1.pos_.y_, _arg_2, _arg_3);
            } else {
                _local16.tickPosition_.x = _arg_1.pos_.x_;
                _local16.tickPosition_.y = _arg_1.pos_.y_;
            }
        }
        var _local12:Player = _local16 as Player;
        if (_local12) {
            _local14 = _local12.level_;
            _local11 = _local12.exp_;
            _local5 = _local12.skinId;
            _local10 = _local12.currFame_;
        }
        this.updateGameObject(_local16, _arg_1.stats_, _local7, _arg_2 == 0);
        if (_local12) {
            if (_local7) {
                _local13 = this.classesModel.getCharacterClass(_local12.objectType_);
                if (_local13.getMaxLevelAchieved() < _local12.level_) {
                    _local13.setMaxLevelAchieved(_local12.level_);
                }
            }
            if (_local12.skinId != _local5) {
                if (ObjectLibrary.skinSetXMLDataLibrary_[_local12.skinId]) {
                    _local15 = ObjectLibrary.skinSetXMLDataLibrary_[_local12.skinId] as XML;
                    _local17 = _local15.attribute("color");
                    _local18 = _local15.attribute("bulletType");
                    if (_local14 != -1 && _local17.length > 0) {
                        _local12.levelUpParticleEffect(parseInt(_local17));
                    }
                    if (_local18.length > 0) {
                        _local12.projectileIdSetOverrideNew = _local18;
                        _local4 = _local12.equipment_[0];
                        _local6 = ObjectLibrary.propsLibrary_[_local4];
                        _local9 = _local6.projectiles_[0];
                        _local12.projectileIdSetOverrideOld = _local9.objectId_;
                    }
                } else if (ObjectLibrary.skinSetXMLDataLibrary_[_local12.skinId] == null) {
                    _local12.projectileIdSetOverrideNew = "";
                    _local12.projectileIdSetOverrideOld = "";
                }
            }
            if (_local14 != -1 && _local12.level_ > _local14) {
                if (_local7) {
                    _local8 = gs_.model.getNewUnlocks(_local12.objectType_, _local12.level_);
                    _local12.handleLevelUp(_local8.length != 0);
                    if (_local8.length > 0) {
                        this.newClassUnlockSignal.dispatch(_local8);
                    }
                } else if (!Parameters.data.noAllyNotifications) {
                    _local12.levelUpEffect("Level Up!");
                }
            } else if (_local14 != -1 && _local12.exp_ > _local11) {
                if (_local16 || !Parameters.data.noAllyNotifications) {
                    _local12.handleExpUp(_local12.exp_ - _local11);
                }
            }
            if (_local10 != -1 && _local12.currFame_ > _local10) {
                if (_local7) {
                    Parameters.fpmGain++;
                    if (Parameters.data.showFameGain) {
                        _local12.updateFame(_local12.currFame_ - _local10);
                    }
                }
            }
            this.socialModel.updateFriendVO(_local12.getName(), _local12);
        }
    }

    private function onInvResult(_arg_1:InvResult):void {
        if (_arg_1.result_ != 0) {
            this.handleInvFailure();
        }
    }

    private function handleInvFailure():void {
        SoundEffectLibrary.play("error");
        this.gs_.hudView.interactPanel.redraw();
    }

    private function onReconnect(packet :Reconnect):void {
        
        if (Parameters.ignoreRecon) {
            if (!Parameters.usingPortal) {
                this.addTextLine.dispatch(ChatMessage.make(packet.key_.length.toString(), packet.toString()));
            }
            return;
        }

        var CurrentServer:Server = new Server().setName(packet.name_).setAddress(packet.host_ != "" ? packet.host_ : server_.address).setPort(packet.host_ != "" ? packet.port_ : int(server_.port));
        var gameId:int = packet.gameId_;
        var newChar:Boolean = createCharacter_;
        var charId:int = this.charId_;
        var keyTime:int = packet.keyTime_;
        var key:ByteArray = packet.key_;
        isFromArena_ = packet.isFromArena_;
        
        var reconPacket:ReconnectEvent = new ReconnectEvent(CurrentServer, gameId, newChar, charId, keyTime, key, isFromArena_);
        reconPacket.createCharacter_ = false;
        Parameters.reconList[packet.gameId_] = reconPacket;
        
        this.disconnect();
        
        if (packet.name_ == "server.vault" || packet.name_ == "Exalted Tutorial") {
            var vaultReconKey = packet.key_
        }
        if (packet.name_ == "Exalted Tutorial") {
            
        }
        this.isNexusing = false;
        gs_.dispatchEvent(reconPacket);
    }

    private function shouldSetDungRecon(_arg_1:String):Boolean {
        var _local2:* = _arg_1;
        switch (_local2) {
            case "{\"text\":\"server.realm_of_the_mad_god\"}":
                if (this.gs_.map.name_ == "Lair of Draconis") {
                    return true;
                }
            case "Exalted Tutorial":
            case "Nexus Explanation":
            case "{\"text\":\"server.enter_the_portal\"}":
            case "Nexus":
            case "{\"text\":\"server.nexus\"}":
            case "Pet Yard":
            case "{\"text\":\"server.petyard\"}":
            case "Daily Quest Room":
            case "Vault":
            case "{\"text\":\"server.vault\"}":
            case "{\"text\":\"server.vault_explanation\"}":
            case "Guild Hall":
            case "{\"text\":\"server.guildhall\"}":
            case "Guild Explanation":
                return false;
            default:
                return true;
        }
    }

    private function onPing(_arg_1:Ping):void {
        var _local2:Pong = this.messages.require(31) as Pong;
        _local2.serial_ = _arg_1.serial_;
        _local2.time_ = getTimer();
        serverConnection.sendMessage(_local2);
        if (Parameters.fameBot) {
            Parameters.famePoint.x = Parameters.famePointOffset * RandomUtil.randomRange(0.8, 1.2);
            Parameters.famePoint.y = Parameters.famePointOffset * RandomUtil.randomRange(0.8, 1.2);
        }
    }

    private function parseXML(_arg_1:String):void {
        var _local2:XML = XML(_arg_1);
        GroundLibrary.parseFromXML(_local2);
        ObjectLibrary.parseFromXML(_local2);
        ObjectLibrary.parseFromXML(_local2);
    }

    private function setupReconnects(_arg_1:String):void {
        var _local2:* = null;
        if (_arg_1 == "Nexus") {
            _local2 = new ReconnectEvent(new Server().setName("Nexus").setAddress(this.server_.address).setPort(this.server_.port), -2, false, this.charId_, 0, null, this.isFromArena_);
            Parameters.reconNexus = _local2;
        }
        if (Parameters.reconNexus == null) {
            Parameters.reconNexus = new ReconnectEvent(new Server().setName("Nexus").setAddress(this.server_.address).setPort(this.server_.port), -2, false, this.charId_, 0, null, this.isFromArena_);
        }
        if (Parameters.reconNexus) {
            Parameters.reconNexus.charId_ = this.charId_;
        }
        if (Parameters.reconRealm) {
            Parameters.reconRealm.charId_ = this.charId_;
        }
        if (Parameters.reconOryx) {
            Parameters.reconOryx.charId_ = this.charId_;
        }
    }

    private function onMapInfo(param1:MapInfo) : void {
        var _local4:* = null;
        var _local6:* = null;
        var _local5:* = null;
        Parameters.realmJoining = false;
        this.setupReconnects(param1.name_);
        var _local8:int = 0;
        var _local7:* = param1.clientXML_;
        for each(_local4 in param1.clientXML_) {
            this.parseXML(_local4);
        }
        var _local10:int = 0;
        var _local9:* = param1.extraXML_;
        for each(_local6 in param1.extraXML_) {
            this.parseXML(_local6);
        }
        this.changeMapSignal.dispatch();
        this.closeDialogs.dispatch();
        this.gs_.applyMapInfo(param1);
        this.rand_ = new Random(param1.fp_);
        Parameters.suicideMode = false;
        Parameters.suicideAT = -1;
        if(Parameters.data.famebotContinue == 0) {
            Parameters.fameBot = false;
        }
        if(Parameters.needToRecalcDesireables) {
            Parameters.setAutolootDesireables();
            Parameters.needToRecalcDesireables = false;
        }
        Parameters.fameWaitStartTime = 0;
        Parameters.fameWaitNTTime = 0;
        Parameters.fameWalkSleep_toFountainOrHall = 0;
        Parameters.fameWalkSleep_toRealms = 0;
        Parameters.fameWalkSleep2 = 0;
        Parameters.fameWalkSleepStart = 0;
        Parameters.questFollow = false;
        Parameters.VHS = 0;
        Parameters.swapINVandBP = 0;
        if(param1.name_ == "Realm of the Mad God") {
            Parameters.mystics.length = 0;
        } else if(param1.name_ == "Tutorial") {
            if(Parameters.manualTutorial) {
                Parameters.manualTutorial = false;
            } else {
                this.disconnect();
                this.gs_.dispatchEvent(Parameters.reconNexus);
                Parameters.data.needsTutorial = false;
                Parameters.save();
                return;
            }
        }
        if(Parameters.preload) {
            this.charId_ = Parameters.forceCharId;
            this.load();
        } else if(this.createCharacter_) {
            this.create();
        } else {
            this.load();
        }
        connectionGuid = param1.connectionGuid_;
        this.gs_.deathOverlay = new Bitmap();
        this.gs_.addChild(this.gs_.deathOverlay);
        Parameters.ignoredShotCount = 0;
        Parameters.dmgCounter.length = 0;
        Parameters.needsMapCheck = this.gs_.map.needsMapHack(param1.name_);
    }

    private function onPic(_arg_1:Pic):void {
        gs_.addChild(new PicView(_arg_1.bitmapData_));
    }

    private function onDeath(_arg_1:Death):void {
        this.death = _arg_1;
        var _local2:BitmapData = new BitmapData(gs_.stage.stageWidth, gs_.stage.stageHeight, true, 0);
        _local2.draw(gs_);
        _arg_1.background = _local2;
        if (!gs_.isEditor) {
            this.handleDeath.dispatch(_arg_1);
        }
        if (gs_.map.name_ == "Davy Jones\' Locker") {
            this.showHideKeyUISignal.dispatch(false);
        }
        Parameters.Cache_CHARLIST_valid = false;
        Parameters.suicideMode = false;
        Parameters.suicideAT = -1;
        Parameters.fameBot = false;
    }

    private function onBuyResult(_arg_1:BuyResult):void {
        outstandingBuy_ = null;
        this.handleBuyResultType(_arg_1);
    }

    private function handleBuyResultType(_arg_1:BuyResult):void {
        var _local2:* = null;
        switch (int(_arg_1.result_) - -1) {
            case 0:
                _local2 = ChatMessage.make("", _arg_1.resultString_);
                this.addTextLine.dispatch(_local2);
                return;
            default:
                this.handleDefaultResult(_arg_1);
                return;
            case 4:
                this.showPopupSignal.dispatch(new NotEnoughGoldDialog());
                return;
            case 7:
                this.openDialog.dispatch(new NotEnoughFameDialog());
                return;
        }
    }

    private function handleDefaultResult(_arg_1:BuyResult):void {
        var _local2:LineBuilder = LineBuilder.fromJSON(_arg_1.resultString_);
        var _local4:Boolean = _arg_1.result_ == 0 || _arg_1.result_ == 7;
        var _local3:ChatMessage = ChatMessage.make(!!_local4 ? "" : "*Error*", _local2.key);
        _local3.tokens = _local2.tokens;
        this.addTextLine.dispatch(_local3);
    }

    private function onAccountList(_arg_1:AccountList):void {
        if (_arg_1.accountListId_ == 0) {
            if (_arg_1.lockAction_ != -1) {
                if (_arg_1.lockAction_ == 1) {
                    gs_.map.party_.setStars(_arg_1);
                } else {
                    gs_.map.party_.removeStars(_arg_1);
                }
            } else {
                gs_.map.party_.setStars(_arg_1);
            }
        } else if (_arg_1.accountListId_ == 1) {
            gs_.map.party_.setIgnores(_arg_1);
        }
    }

    private function onQuestObjId(_arg_1:QuestObjId):void {
        gs_.map.quest_.setObject(_arg_1.objectId_);
    }

    private function onAoe(_arg_1:Aoe):void {
        var _local4:int = 0;
        var _local2:* = undefined;
        if (this.player == null) {
            this.aoeAck(gs_.lastUpdate_, 0, 0);
            return;
        }
        var _local3:AOEEffect = new AOEEffect(_arg_1.pos_.toPoint(), _arg_1.radius_, _arg_1.color_);
        gs_.map.addObj(_local3, _arg_1.pos_.x_, _arg_1.pos_.y_);
        if (this.player.isInvincible || this.player.isPaused) {
            this.aoeAck(gs_.lastUpdate_, this.player.x_, this.player.y_);
            return;
        }
        if (this.player.distTo(_arg_1.pos_) < _arg_1.radius_) {
            _local4 = this.player.damageWithDefense(_arg_1.damage_, this.player.defense_, _arg_1.armorPierce_, this.player.condition_);
            _local2 = null;
            if (_arg_1.effect_ != 0) {
                _local2 = new Vector.<uint>();
                _local2.push(_arg_1.effect_);
            }
            if (this.player.subtractDamage(_local4)) {
                return;
            }
            this.player.damage(true, _local4, _local2, false, null, _arg_1.armorPierce_);
        }
        this.aoeAck(gs_.lastUpdate_, this.player.x_, this.player.y_);
    }

    private function onNameResult(_arg_1:NameResult):void {
        gs_.dispatchEvent(new NameResultEvent(_arg_1));
    }

    private function onGuildResult(_arg_1:GuildResult):void {
        var _local2:* = null;
        if (_arg_1.lineBuilderJSON == "") {
            gs_.dispatchEvent(new GuildResultEvent(_arg_1.success_, "", {}));
        } else {
            _local2 = LineBuilder.fromJSON(_arg_1.lineBuilderJSON);
            this.addTextLine.dispatch(ChatMessage.make("*Error*", _local2.key, -1, -1, "", false, _local2.tokens));
            gs_.dispatchEvent(new GuildResultEvent(_arg_1.success_, _local2.key, _local2.tokens));
        }
    }

    private function onClientStat(_arg_1:ClientStat):void {
        var _local2:* = null;
        if (Parameters.data.showClientStat) {
            if (!Parameters.usingPortal) {
                this.addTextLine.dispatch(ChatMessage.make("#" + _arg_1.name_, _arg_1.value_.toString()));
                _local2 = StaticInjectorContext.getInjector().getInstance(Account);
                _local2.reportIntStat(_arg_1.name_, _arg_1.value_);
            }
        }
    }

    private function onFile(_arg_1:File):void {
        new FileReference().save(_arg_1.file_, _arg_1.filename_);
    }

    private function onInvitedToGuild(_arg_1:InvitedToGuild):void {
        if (Parameters.data.showGuildInvitePopup) {
            gs_.hudView.interactPanel.setOverride(new GuildInvitePanel(gs_, _arg_1.name_, _arg_1.guildName_));
        }
        this.addTextLine.dispatch(ChatMessage.make("", "You have been invited by " + _arg_1.name_ + " to join the guild " + _arg_1.guildName_ + ".\n  If you wish to join type \"/join " + _arg_1.guildName_ + "\""));
    }

    private function onPlaySound(_arg_1:PlaySound):void {
        var _local2:GameObject = gs_.map.goDict_[_arg_1.ownerId_];
    }

    private function onImminentArenaWave(_arg_1:ImminentArenaWave):void {
        this.imminentWave.dispatch(_arg_1.currentRuntime);
    }

    private function onArenaDeath(_arg_1:ArenaDeath):void {
        this.addTextLine.dispatch(ChatMessage.make("ArenaDeath", "Cost: " + _arg_1.cost));
        this.currentArenaRun.costOfContinue = _arg_1.cost;
        this.openDialog.dispatch(new ContinueOrQuitDialog(_arg_1.cost, false));
        this.arenaDeath.dispatch();
    }

    private function onVerifyEmail(_arg_1:VerifyEmail):void {
        TitleView.queueEmailConfirmation = true;
        if (gs_ != null) {
            gs_.closed.dispatch();
        }
        var _local2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
        if (_local2 != null) {
            _local2.dispatch();
        }
    }

    private function onPasswordPrompt(_arg_1:PasswordPrompt):void {
        if (_arg_1.cleanPasswordStatus == 3) {
            TitleView.queuePasswordPromptFull = true;
        } else if (_arg_1.cleanPasswordStatus == 2) {
            TitleView.queuePasswordPrompt = true;
        } else if (_arg_1.cleanPasswordStatus == 4) {
            TitleView.queueRegistrationPrompt = true;
        }
        if (gs_ != null) {
            gs_.closed.dispatch();
        }
        var _local2:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
        if (_local2 != null) {
            _local2.dispatch();
        }
    }

    private function onQuestFetchResponse(_arg_1:QuestFetchResponse):void {
        this.questFetchComplete.dispatch(_arg_1);
        if (Parameters.dailyCalendar2RunOnce) {
            this.gs_.showDailyLoginCalendar();
            Parameters.dailyCalendar2RunOnce = false;
            this.escape();
        }
    }

    private function onQuestRedeemResponse(_arg_1:QuestRedeemResponse):void {
        this.questRedeemComplete.dispatch(_arg_1);
    }

    private function onKeyInfoResponse(_arg_1:KeyInfoResponse):void {
        this.keyInfoResponse.dispatch(_arg_1);
    }

    private function onLoginRewardResponse(_arg_1:ClaimDailyRewardResponse):void {
        this.claimDailyRewardResponse.dispatch(_arg_1);
    }

    private function onChatToken(_arg_1:ChatToken):void {
        this.chatServerModel.chatToken = _arg_1.token_;
        this.chatServerModel.port = _arg_1.port_;
        this.chatServerModel.server = _arg_1.host_;
        this.addChatServerConnectionListeners();
        this.loginToChatServer();
    }

    private function addChatServerConnectionListeners():void {
        this.chatServerConnection.chatConnected.add(this.onChatConnected);
        this.chatServerConnection.chatClosed.add(this.onChatClosed);
        this.chatServerConnection.chatError.add(this.onChatError);
    }

    private function removeChatServerConnectionListeners():void {
        this.chatServerConnection.chatConnected.remove(this.onChatConnected);
        this.chatServerConnection.chatClosed.remove(this.onChatClosed);
        this.chatServerConnection.chatError.remove(this.onChatError);
    }

    private function loginToChatServer():void {
        this.chatServerConnection.connect(this.chatServerModel.server, this.chatServerModel.port);
    }

    private function onChatConnected():void {
        var _local1:ChatHello = this.messages.require(206) as ChatHello;
        _local1.accountId = this.rsaEncrypt(this.player.accountId_);
        _local1.token = this.chatServerModel.chatToken;
        this.chatServerConnection.sendMessage(_local1);
        if (this.chatServerConnection.isChatConnected()) {
            this.addTextLine.dispatch(ChatMessage.make("*Client*", "Chat Server connected"));
            this._isReconnecting = false;
        } else {
            this.chatServerConnection.isConnecting = false;
        }
    }

    private function onChatClosed():void {
        if (!this.chatServerConnection.isChatConnected() && this._numberOfReconnectAttempts < 5) {
        this._numberOfReconnectAttempts++;
            if (serverConnection.isConnected() && !this._isReconnecting) {
                this._isReconnecting = true;
                this.removeChatServerConnectionListeners();
                this.chatServerConnection.dispose();
                this.chatServerConnection = null;
                this.chatServerConnection = this.injector.getInstance(ChatSocketServer);
                this.setChatEncryption();
                this.chatServerConnection.isConnecting = true;
                this.addChatServerConnectionListeners();
                this.addTextLine.dispatch(ChatMessage.make("*Error*", "Chat Connection closed!  Reconnecting..."));
                this.chatReconnectTimer(10);
            }
        } else {
            this.addTextLine.dispatch(ChatMessage.make("*Error*", "Chat Connection closed!  Unable to reconnect - Please restart game!"));
        }
    }

    private function onChatError(_arg_1:String):void {
        this.addTextLine.dispatch(ChatMessage.make("*Error*", _arg_1));
    }

    private function chatReconnectTimer(_arg_1:int):void {
        if (!this._chatReconnectionTimer) {
            this._chatReconnectionTimer = new Timer(_arg_1 * 1000, 1);
        } else {
            this._chatReconnectionTimer.delay = _arg_1 * 1000;
        }
        this._chatReconnectionTimer.addEventListener("timerComplete", this.onChatRetryTimer);
        this._chatReconnectionTimer.start();
    }

    private function onRealmHeroesResponse(_arg_1:RealmHeroesResponse):void {
        this.realmHeroesSignal.dispatch(_arg_1.numberOfRealmHeroes);
    }

    private function onClosed():void {
        var _local1:* = null;
        var _local2:* = null;
        var _local3:* = null;
        if (!this.isNexusing) {
            if (this.playerId_ != -1) {
                gs_.closed.dispatch();
            } else if (this.retryConnection_) {
                if (this.delayBeforeReconnect < 10) {
                    if (this.delayBeforeReconnect == 6) {
                        _local1 = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
                        _local1.dispatch();
                    }
                    var _local4:Number = this.delayBeforeReconnect;
                    this.delayBeforeReconnect++;
                    this.retry(_local4);
                    if(!this.serverFull_) {
                        this.addTextLine.dispatch(ChatMessage.make("*Error*", "Connection failed!  Retrying..."));
                    }                } else {
                    gs_.closed.dispatch();
                }
            }
        } else {
            this.isNexusing = false;
            _local2 = this.serverModel.getServer();
            _local3 = new ReconnectEvent(_local2, -2, false, charId_, 1, new ByteArray(), isFromArena_);
            gs_.dispatchEvent(_local3);
        }
    }

    private function retry(_arg_1:int):void {
        this.retryTimer_ = new Timer(_arg_1 * 1000, 1);
        this.retryTimer_.addEventListener("timerComplete", this.onRetryTimer, false, 0, true);
        this.retryTimer_.start();
    }

    private function onVaultUpdate(_arg_1:VaultUpdate) : void
      {
         var _loc2_:VaultUpdateSignal = this.injector.getInstance(VaultUpdateSignal);
         _loc2_.dispatch(_arg_1.vaultContents,_arg_1.giftContents,_arg_1.potionContents);
      }

    private function onError(_arg_1:String):void {
        this.addTextLine.dispatch(ChatMessage.make("*Error*", _arg_1));
    }

    private function onFailure(_arg_1:Failure):void {
        lastConnectionFailureMessage = _arg_1.errorDescription_;
        lastConnectionFailureID = _arg_1.errorConnectionId_;
        this.serverFull_ = false;
        if ("is dead" in LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_) || "is dead" in _arg_1.errorDescription_) {
            Parameters.Cache_CHARLIST_valid = false;
        }
        switch (int(_arg_1.errorId_) - 4) {
            case 0:
                this.handleIncorrectVersionFailure(_arg_1);
                break;
            case 1:
                this.handleBadKeyFailure(_arg_1);
                break;
            case 2:
                this.handleInvalidTeleportTarget(_arg_1);
                break;
            case 3:
                this.handleEmailVerificationNeeded(_arg_1);
                break;
            default:
                this.handleDefaultFailure(_arg_1);
                break;
            case 5:
                this.handleRealmTeleportBlock(_arg_1);
                break;
            case 6:
                this.handleWrongServerEnter(_arg_1);
                break;
            case 11:
                this.handleServerFull(_arg_1);
        }
        if (_arg_1.errorDescription_.indexOf("Client Token Error") != -1) {
            this.addTextLine.dispatch(ChatMessage.make("", "The client is outdated, please wait for a new version to be released then redownload the client."));
        }
    }

    private function handleServerFull(param1:Failure) : void {
        this.addTextLine.dispatch(ChatMessage.make("", param1.errorDescription_));
        this.retryConnection_ = true;
        this.delayBeforeReconnect = 5;
        this.serverFull_ = true;
    }

    private function handleEmailVerificationNeeded(_arg_1:Failure):void {
        this.retryConnection_ = false;
        gs_.closed.dispatch();
    }

    private function handleRealmTeleportBlock(_arg_1:Failure):void {
        this.addTextLine.dispatch(ChatMessage.make("", "You need to wait at least " + _arg_1.errorDescription_ + " seconds before a non guild member teleport."));
        this.player.nextTeleportAt_ = getTimer() + parseFloat(_arg_1.errorDescription_) * 1000;
    }

    private function handleWrongServerEnter(_arg_1:Failure):void {
        this.addTextLine.dispatch(ChatMessage.make("", _arg_1.errorDescription_));
        this.retryConnection_ = false;
        gs_.closed.dispatch();
    }

    private function handleInvalidTeleportTarget(_arg_1:Failure):void {
        var _local2:String = LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_);
        if (_local2 == "") {
            _local2 = _arg_1.errorDescription_;
        }
        this.addTextLine.dispatch(ChatMessage.make("*Error*", _local2));
        this.player.nextTeleportAt_ = 0;
    }

    private function handleBadKeyFailure(_arg_1:Failure):void {
        var _local2:String = LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_);
        if (_local2 == "") {
            _local2 = _arg_1.errorDescription_;
        }
        this.addTextLine.dispatch(ChatMessage.make("*Error*", _local2));
        this.retryConnection_ = false;
        gs_.closed.dispatch();
    }

    private function handleIncorrectVersionFailure(param1:Failure) : void {
        this.addTextLine.dispatch(ChatMessage.make("", "The client is outdated, please wait for a new version to be released then redownload the client."));
        var _local2:Dialog = new Dialog("ClientUpdate.title","","ClientUpdate.leftButton",null,"/clientUpdate");
        _local2.setTextParams("ClientUpdate.description",{
            "client":Parameters.CLIENT_VERSION,
            "server":param1.errorDescription_
        });
        _local2.addEventListener("dialogLeftButton",this.onDoClientUpdate,false,0,true);
        gs_.stage.addChild(_local2);
        this.retryConnection_ = false;
    }

    private function handleDefaultFailure(_arg_1:Failure):void {
        var _local2:String = LineBuilder.getLocalizedStringFromJSON(_arg_1.errorDescription_);
        if (_local2 == "") {
            _local2 = _arg_1.errorDescription_;
        }
        this.addTextLine.dispatch(ChatMessage.make("*Error*", _local2));
    }

    private function loaderStatus(evt:HTTPStatusEvent):void {
        this.hudModel.gameSprite.gsc_.pingReceivedAt = getTimer() - this.hudModel.gameSprite.gsc_.pingSentAt;
    }

    private function conRecon(_arg_1:ReconnectEvent):void {
        this.gs_.dispatchEvent(_arg_1);
    }

    private function onChatRetryTimer(_arg_1:TimerEvent):void {
        this._chatReconnectionTimer.removeEventListener("timerComplete", this.onChatRetryTimer);
        this.loginToChatServer();
    }

    private function onRetryTimer(_arg_1:TimerEvent):void {
        serverConnection.connect(server_.address, server_.port);
    }

    private function onDoClientUpdate(_arg_1:Event):void {
        var _local2:Dialog = _arg_1.currentTarget as Dialog;
        _local2.parent.removeChild(_local2);
        gs_.closed.dispatch();
    }
}
}
