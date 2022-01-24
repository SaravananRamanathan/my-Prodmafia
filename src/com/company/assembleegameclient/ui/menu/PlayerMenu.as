package com.company.assembleegameclient.ui.menu {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.GameObjectListItem;
import com.company.util.AssetLibrary;

import flash.events.Event;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.social.model.FriendRequestVO;
import io.decagames.rotmg.social.signals.FriendActionSignal;

import kabam.rotmg.chat.control.ShowChatInputSignal;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class PlayerMenu extends Menu {


    public function PlayerMenu() {
        super(0x363636, 0xffffff);
    }
    public var gs_:AGameSprite;
    public var playerName_:String;
    public var player_:Player;
    public var playerPanel_:GameObjectListItem;
    public var namePlate_:TextFieldDisplayConcrete;

    public function initDifferentServer(_arg_1:AGameSprite, _arg_2:String, _arg_3:Boolean = false, _arg_4:Boolean = false):void {
        var _local5:* = null;
        this.gs_ = _arg_1;
        this.playerName_ = _arg_2;
        this.player_ = null;
        this.namePlate_ = new TextFieldDisplayConcrete().setSize(13).setColor(16572160).setHTML(true);
        this.namePlate_.setStringBuilder(new LineBuilder().setParams(this.playerName_));
        this.namePlate_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.namePlate_);
        this.yOffset = this.yOffset - 13;
        _local5 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 21), 0xffffff, "PlayerMenu.PM");
        _local5.addEventListener("click", this.onPrivateMessage, false, 0, true);
        addOption(_local5);
        _local5 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 8), 0xffffff, "Friend.BlockRight");
        _local5.addEventListener("click", this.onIgnoreDifferentServer, false, 0, true);
        addOption(_local5);
        _local5 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 18), 0xffffff, "Add Friend");
        _local5.addEventListener("click", this.onAddFriend, false, 0, true);
        addOption(_local5);
    }

    public function init(_arg_1:AGameSprite, _arg_2:Player):void {
        var _local3:* = null;
        this.gs_ = _arg_1;
        this.playerName_ = _arg_2.name_;
        this.player_ = _arg_2;
        this.playerPanel_ = new GameObjectListItem(0xb3b3b3, true, this.player_, true);
        this.yOffset = this.yOffset + 7;
        addChild(this.playerPanel_);
        if (Player.isAdmin || Player.isMod) {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 10), 0xffffff, "Ban MultiBoxer");
            _local3.addEventListener("click", this.onKickMultiBox, false, 0, true);
            addOption(_local3);
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 10), 0xffffff, "Ban RWT");
            _local3.addEventListener("click", this.onKickRWT, false, 0, true);
            addOption(_local3);
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 10), 0xffffff, "Ban Cheat");
            _local3.addEventListener("click", this.onKickCheat, false, 0, true);
            addOption(_local3);
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 4), 0xffffff, "PlayerMenu.Mute");
            _local3.addEventListener("click", this.onMute, false, 0, true);
            addOption(_local3);
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 3), 0xffffff, "PlayerMenu.UnMute");
            _local3.addEventListener("click", this.onUnMute, false, 0, true);
            addOption(_local3);
        }
        if (this.gs_.map.allowPlayerTeleport() && this.player_.isTeleportEligible(this.player_)) {
            _local3 = new TeleportMenuOption(this.gs_.map.player_);
            _local3.addEventListener("click", this.onTeleport, false, 0, true);
            addOption(_local3);
        }
        if (this.gs_.map.player_.guildRank_ >= 20 && (_arg_2.guildName_ == null || _arg_2.guildName_.length == 0)) {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 10), 0xffffff, "PlayerMenu.Invite");
            _local3.addEventListener("click", this.onInvite, false, 0, true);
            addOption(_local3);
        }
        if (!this.player_.starred_) {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2", 5), 0xffffff, "PlayerMenu.Lock");
            _local3.addEventListener("click", this.onLock, false, 0, true);
            addOption(_local3);
        } else {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2", 6), 0xffffff, "PlayerMenu.UnLock");
            _local3.addEventListener("click", this.onUnlock, false, 0, true);
            addOption(_local3);
        }
        _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 7), 0xffffff, "PlayerMenu.Trade");
        _local3.addEventListener("click", this.onTrade, false, 0, true);
        addOption(_local3);
        _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 21), 0xffffff, "PlayerMenu.PM");
        _local3.addEventListener("click", this.onPrivateMessage, false, 0, true);
        addOption(_local3);
        if (this.player_.isFellowGuild_) {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 21), 0xffffff, "PlayerMenu.GuildChat");
            _local3.addEventListener("click", this.onGuildMessage, false, 0, true);
            addOption(_local3);
        }
        if (!this.player_.ignored_) {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 8), 0xffffff, "PlayerMenu.Ignore");
            _local3.addEventListener("click", this.onIgnore, false, 0, true);
            addOption(_local3);
        } else {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 9), 0xffffff, "PlayerMenu.Unignore");
            _local3.addEventListener("click", this.onUnignore, false, 0, true);
            addOption(_local3);
        }
        if (Parameters.data.extraPlayerMenu) {
            _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 5), 0xffffff, "Anchor");
            _local3.addEventListener("click", this.onSetAnchor, false, 0, true);
            addOption(_local3);
            if (Parameters.followName == this.player_.name_.toUpperCase()) {
                _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 19), 0xff0000, "Stop Follow");
            } else {
                _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 19), 0xffffff, "Follow");
            }
            _local3.addEventListener("click", this.onSetFollow, false, 0, true);
            addOption(_local3);
        }
        _local3 = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 18), 0xffffff, "Add Friend");
        _local3.addEventListener("click", this.onAddFriend, false, 0, true);
        addOption(_local3);
    }

    private function onIgnoreDifferentServer(_arg_1:Event):void {
        this.gs_.gsc_.playerText("/ignore " + this.playerName_);
        remove();
    }

    private function onSetAnchor(_arg_1:Event):void {
        Parameters.data.anchorName = this.player_.name_;
        remove();
    }

    private function onSetFollow(_arg_1:Event):void {
        if (Parameters.followName == this.player_.name_.toUpperCase()) {
            Parameters.followName = "";
            Parameters.followingName = false;
            Parameters.followPlayer = null;
        } else {
            Parameters.followName = this.player_.name_.toUpperCase();
            Parameters.followingName = true;
            Parameters.followPlayer = this.player_;
        }
        remove();
    }

    private function onKickMultiBox(_arg_1:Event):void {
        this.gs_.gsc_.playerText("/akick " + this.player_.name_ + " Multiboxing");
        remove();
    }

    private function onKickRWT(_arg_1:Event):void {
        this.gs_.gsc_.playerText("/akick " + this.player_.name_ + " RWT");
        remove();
    }

    private function onKickCheat(_arg_1:Event):void {
        this.gs_.gsc_.playerText("/akick " + this.player_.name_ + " Cheating");
        remove();
    }

    private function onMute(_arg_1:Event):void {
        this.gs_.gsc_.playerText("/mute " + this.player_.name_);
        remove();
    }

    private function onUnMute(_arg_1:Event):void {
        this.gs_.gsc_.playerText("/unmute " + this.player_.name_);
        remove();
    }

    private function onPrivateMessage(_arg_1:Event):void {
        var _local2:ShowChatInputSignal = StaticInjectorContext.getInjector().getInstance(ShowChatInputSignal);
        _local2.dispatch(true, "/tell " + this.playerName_ + " ");
        remove();
    }

    private function onAddFriend(_arg_1:Event):void {
        var _local2:FriendActionSignal = StaticInjectorContext.getInjector().getInstance(FriendActionSignal);
        _local2.dispatch(new FriendRequestVO("/requestFriend", this.playerName_));
        remove();
    }

    private function onGuildMessage(_arg_1:Event):void {
        var _local2:ShowChatInputSignal = StaticInjectorContext.getInjector().getInstance(ShowChatInputSignal);
        _local2.dispatch(true, "/g ");
        remove();
    }

    private function onTeleport(_arg_1:Event):void {
        this.gs_.map.player_.teleportTo(this.player_);
        remove();
    }

    private function onInvite(_arg_1:Event):void {
        this.gs_.gsc_.guildInvite(this.playerName_);
        remove();
    }

    private function onLock(_arg_1:Event):void {
        this.gs_.map.party_.lockPlayer(this.player_);
        remove();
    }

    private function onUnlock(_arg_1:Event):void {
        this.gs_.map.party_.unlockPlayer(this.player_);
        remove();
    }

    private function onTrade(_arg_1:Event):void {
        this.gs_.gsc_.requestTrade(this.playerName_);
        remove();
    }

    private function onIgnore(_arg_1:Event):void {
        this.gs_.map.party_.ignorePlayer(this.player_);
        remove();
    }

    private function onUnignore(_arg_1:Event):void {
        this.gs_.map.party_.unignorePlayer(this.player_);
        remove();
    }
}
}
