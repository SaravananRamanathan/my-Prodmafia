package kabam.rotmg.chat.control {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.TextureDataConcrete;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TimeUtil;

import flash.utils.Dictionary;

import io.decagames.rotmg.seasonalEvent.data.SeasonalEventModel;
import io.decagames.rotmg.social.model.SocialModel;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.view.ConfirmEmailModal;
import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.chat.model.TellModel;
import kabam.rotmg.chat.view.ChatListItemFactory;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.AddSpeechBalloonVO;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.messaging.impl.incoming.Text;
import kabam.rotmg.news.view.NewsTicker;
import kabam.rotmg.servers.api.ServerModel;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.signals.RealmServerNameSignal;

public class TextHandler {


    private const NORMAL_SPEECH_COLORS:TextColors = new TextColors(14802908, 0xffffff, 0x545454);
    private const ENEMY_SPEECH_COLORS:TextColors = new TextColors(5644060, 16549442, 13484223);
    private const TELL_SPEECH_COLORS:TextColors = new TextColors(2493110, 0xf0ff, 13880567);
    private const GUILD_SPEECH_COLORS:TextColors = new TextColors(4098560, 10944349, 13891532);

    [Inject]
    public var account:Account;
    [Inject]
    public var model:GameModel;
    [Inject]
    public var addTextLine:AddTextLineSignal;
    [Inject]
    public var addSpeechBalloon:AddSpeechBalloonSignal;
    [Inject]
    public var stringMap:StringMap;
    [Inject]
    public var tellModel:TellModel;
    [Inject]
    public var spamFilter:SpamFilter;
    [Inject]
    public var openDialogSignal:OpenDialogSignal;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var socialModel:SocialModel;
    [Inject]
    public var setup:ApplicationSetup;
    [Inject]
    public var realmServerNameSignal:RealmServerNameSignal;
    [Inject]
    public var seasonalEventModel:SeasonalEventModel;

    private var similar:Dictionary;

    public function TextHandler() {
        var _local5:int = 0;
        var _local2:int = 0;
        var _local4:int = 0;
        var _local1:int = 0;
        var _local3:int = 0;
        super();
        if (similar == null) {
            _local5 = "w".charCodeAt(0);
            _local2 = "r".charCodeAt(0);
            _local4 = "g".charCodeAt(0);
            _local1 = "t".charCodeAt(0);
            _local3 = "o".charCodeAt(0);
            similar = new Dictionary(true);
            similar["Ŕ"] = _local2;
            similar["ŕ"] = _local2;
            similar["Ŗ"] = _local2;
            similar["ŗ"] = _local2;
            similar["Ř"] = _local2;
            similar["ř"] = _local2;
            similar["Ŵ"] = _local5;
            similar["ŵ"] = _local5;
            similar["Ţ"] = _local1;
            similar["ţ"] = _local1;
            similar["Ť"] = _local1;
            similar["ť"] = _local1;
            similar["Ŧ"] = _local1;
            similar["ŧ"] = _local1;
            similar["Ț"] = _local1;
            similar["ț"] = _local1;
            similar["†"] = _local1;
            similar["‡"] = _local1;
            similar["Ĝ"] = _local4;
            similar["ĝ"] = _local4;
            similar["Ğ"] = _local4;
            similar["ğ"] = _local4;
            similar["Ġ"] = _local4;
            similar["ġ"] = _local4;
            similar["Ģ"] = _local4;
            similar["ģ"] = _local4;
        }
    }


    public function execute(_arg_1:Text):void {
        var _local7:int = 0;
        var _local5:* = null;
        var _local12:* = null;
        var _local9:* = null;
        var _local13:* = null;
        var _local3:* = null;
        var _local10:* = null;
        if (Parameters.lowCPUMode && _arg_1.recipient_.length == 0) {
            if (Parameters.data.hideLowCPUModeChat && _arg_1.numStars_ > -1) {
                return;
            }
        }
        var _local11:* = _arg_1.numStars_ == -1;
        var _local8:Boolean = _arg_1.name_ != this.model.player.name_ && !_local11 && !this.isSpecialRecipientChat(_arg_1.recipient_);
        var _local2:Boolean = this.seasonalEventModel.isChallenger;
        if (!_local2 && _arg_1.numStars_ < Parameters.data.chatStarRequirement && _local8) {
            return;
        }
        if (_arg_1.recipient_ != "" && Parameters.data.chatFriend && !this.socialModel.isMyFriend(_arg_1.recipient_)) {
            return;
        }
        if (!Parameters.data.chatAll && _local8) {
            if (!(_arg_1.recipient_ == "*Guild*" && Parameters.data.chatGuild)) {
                if (!(!_local2 && _arg_1.numStars_ < Parameters.data.chatStarRequirement && _arg_1.recipient_ != "" && Parameters.data.chatWhisper)) {
                    if (!(_local2 && _arg_1.recipient_ != "" && Parameters.data.chatWhisper)) {
                        return;
                    }
                }
            }
        }
        if (this.useCleanString(_arg_1)) {
            _local5 = _arg_1.cleanText_;
            _arg_1.cleanText_ = this.replaceIfSlashServerCommand(_arg_1.cleanText_);
        } else {
            _local5 = _arg_1.text_;
            _arg_1.text_ = this.replaceIfSlashServerCommand(_arg_1.text_);
        }
        if (_local11 && this.isToBeLocalized(_local5)) {
            _local5 = this.getLocalizedString(_local5);
        }
        if (!_local11) {
            _local13 = getCustomMultiColors(_arg_1.text_.toLowerCase());
            for each(var _local6:String in Parameters.filtered) {
                if (_local13.indexOf(_local6) != -1) {
                    return;
                }
            }
            for each(_local6 in Parameters.appendage) {
                if (_local13.indexOf(_local6) != -1) {
                    return;
                }
            }
        } else if (_arg_1.text_.indexOf("Current number of") != -1) {
            _local3 = "Enemies: " + _arg_1.text_.substring(40, _arg_1.text_.length - 1);
            this.hudModel.gameSprite.updateEnemyCounter(_local3);
            return;
        }
        if (_arg_1.recipient_) {
            if (_arg_1.recipient_ != this.model.player.name_ && !this.isSpecialRecipientChat(_arg_1.recipient_)) {
                this.tellModel.push(_arg_1.recipient_);
                this.tellModel.resetRecipients();
            } else if (_arg_1.recipient_ == this.model.player.name_) {
                /*if (§§dup(MoreStringUtil)["enterFrame"](_local5)
            )
                {
                    return;
                }*/
                this.tellModel.push(_arg_1.name_);
                this.tellModel.resetRecipients();
            }
        }
        if (_local11 && TextureDataConcrete.remoteTexturesUsed) {
            TextureDataConcrete.remoteTexturesUsed = false;
            if (this.setup.isServerLocal()) {
                _local12 = _arg_1.name_;
                _local9 = _arg_1.text_;
                _arg_1.name_ = "";
                _arg_1.text_ = "Remote Textures used in this build";
                this.addTextAsTextLine(_arg_1);
                _arg_1.name_ = _local12;
                _arg_1.text_ = _local9;
            }
        }
        if (_local11) {
            if (Parameters.fameBot && _arg_1.text_.indexOf("server.teleport_cooldown") != -1) {
                return;
            }
            if (_arg_1.text_ == "Please verify your email before chat" && this.hudModel != null && this.hudModel.gameSprite.map.name_ == "Nexus" && this.openDialogSignal != null) {
                this.openDialogSignal.dispatch(new ConfirmEmailModal());
            } else if (_arg_1.name_ == "@ANNOUNCEMENT") {
                if (this.hudModel && this.hudModel.gameSprite && this.hudModel.gameSprite.newsTicker) {
                    this.hudModel.gameSprite.newsTicker.activateNewScrollText(_arg_1.text_);
                } else {
                    NewsTicker.setPendingScrollText(_arg_1.text_);
                }
            }
            if (Parameters.data.AutoResponder) {
                if (_arg_1.name_ == "#Thessal the Mermaid Goddess" && _arg_1.text_ == "Is King Alexander alive?") {
                    this.model.player.map_.gs_.gsc_.playerText("He lives and reigns and conquers the world");
                } else if (_arg_1.name_ == "#Ghost of Skuld" && _arg_1.text_.indexOf("\'READY\'") != -1) {
                    this.model.player.map_.gs_.gsc_.playerText("ready");
                } else if (_arg_1.name_ == "#Craig, Intern of the Mad God" && _arg_1.text_.indexOf("say SKIP and") != -1) {
                    this.model.player.map_.gs_.gsc_.playerText("skip");
                } else if (_arg_1.name_ == "#Computer" && _arg_1.text_.indexOf("Password:") != -1) {
                    this.model.player.map_.gs_.gsc_.playerText("Dr Terrible");
                } else if (_arg_1.name_ == "#Master Rat") {
                    _local10 = getSplinterReply(_arg_1.text_);
                    if (_local10 != "") {
                        this.hudModel.gameSprite.gsc_.playerText(_local10);
                    }
                }
            }
            _local7 = Parameters.timerPhaseTimes[_arg_1.text_];
            if (_local7 > 0) {
                Parameters.timerActive = true;
                Parameters.phaseChangeAt = TimeUtil.getTrueTime() + _local7;
                Parameters.phaseName = Parameters.timerPhaseNames[_arg_1.text_];
            }
        }
        if (_arg_1.objectId_ >= 0) {
            this.showSpeechBaloon(_arg_1, _local5);
        }
        if (_local11 || this.account.isRegistered() && (!Parameters.data.hidePlayerChat || this.isSpecialRecipientChat(_arg_1.name_))) {
            if (_arg_1.text_.search("NexusPortal.") != -1) {
                this.dispatchServerName(_arg_1.text_);
            }
            this.addTextAsTextLine(_arg_1);
        }
    }

    public function getSplinterReply(_arg_1:String):String {
        var _local2:* = _arg_1;
        switch (_local2) {
            case "What time is it?":
                return "It\'s pizza time!";
            case "Where is the safest place in the world?":
                return "Inside my shell.";
            case "What is fast, quiet and hidden by the night?":
                return "A ninja of course!";
            case "How do you like your pizza?":
                return "Extra cheese, hold the anchovies.";
            case "Who did this to me?":
                return "Dr. Terrible, the mad scientist.";
            default:
                return "";
        }
    }

    public function addTextAsTextLine(_arg_1:Text):void {
        var _local2:ChatMessage = new ChatMessage();
        _local2.name = _arg_1.name_;
        _local2.objectId = _arg_1.objectId_;
        _local2.numStars = _arg_1.numStars_;
        _local2.recipient = _arg_1.recipient_;
        _local2.isWhisper = _arg_1.recipient_ && !this.isSpecialRecipientChat(_arg_1.recipient_);
        _local2.isToMe = _arg_1.recipient_ == this.model.player.name_;
        _local2.isFromSupporter = _arg_1.isSupporter;
        _local2.starBg = _arg_1.starBg;
        this.addMessageText(_arg_1, _local2);
        this.addTextLine.dispatch(_local2);
    }

    public function addMessageText(_arg_1:Text, _arg_2:ChatMessage):void {
        var _local5:* = null;
        var _local4:* = _arg_1;
        var _local3:* = _arg_2;
        try {
            _local5 = LineBuilder.fromJSON(_local4.text_);
        } catch (error:Error) {
        }
        if (_local5) {
            _local3.text = _local5.key;
            _local3.tokens = _local5.tokens;
        } else {
            _local3.text = !!useCleanString(_local4) ? _local4.cleanText_ : _local4.text_;
        }
    }

    private function isSpecialRecipientChat(_arg_1:String):Boolean {
        return _arg_1.length > 0 && (_arg_1.charAt(0) == "#" || _arg_1.charAt(0) == "*");
    }

    private function dispatchServerName(_arg_1:String):void {
        var _local2:String = _arg_1.substring(_arg_1.indexOf(".") + 1);
        this.realmServerNameSignal.dispatch(_local2);
    }

    private function replaceIfSlashServerCommand(_arg_1:String):String {
        var _local2:* = null;
        if (_arg_1.substr(0, 7) == "74026S9") {
            _local2 = StaticInjectorContext.getInjector().getInstance(ServerModel);
            if (_local2 && _local2.getServer()) {
                return _arg_1.replace("74026S9", _local2.getServer().name + ", ");
            }
        }
        return _arg_1;
    }

    private function isToBeLocalized(_arg_1:String):Boolean {
        return _arg_1.charAt(0) == "{" && _arg_1.charAt(_arg_1.length - 1) == "}";
    }

    private function getLocalizedString(_arg_1:String):String {
        var _local2:LineBuilder = LineBuilder.fromJSON(_arg_1);
        _local2.setStringMap(this.stringMap);
        return _local2.getString();
    }

    private function showSpeechBaloon(_arg_1:Text, _arg_2:String):void {
        var _local3:* = null;
        var _local7:Boolean = false;
        var _local5:Boolean = false;
        var _local4:* = null;
        var _local6:GameObject = this.model.getGameObject(_arg_1.objectId_);
        if (_local6) {
            _local3 = this.getColors(_arg_1, _local6);
            _local7 = ChatListItemFactory.isTradeMessage(_arg_1.numStars_, _arg_1.objectId_, _arg_2);
            _local5 = ChatListItemFactory.isGuildMessage(_arg_1.name_);
            _local4 = new AddSpeechBalloonVO(_local6, _arg_2, _arg_1.name_, _local7, _local5, _local3.back, 1, _local3.outline, 1, _local3.text, _arg_1.bubbleTime_, false, true);
            this.addSpeechBalloon.dispatch(_local4);
        }
    }

    private function getColors(_arg_1:Text, _arg_2:GameObject):TextColors {
        if (_arg_2.props_.isEnemy_) {
            return this.ENEMY_SPEECH_COLORS;
        }
        if (_arg_1.recipient_ == "*Guild*") {
            return this.GUILD_SPEECH_COLORS;
        }
        if (_arg_1.recipient_ != "") {
            return this.TELL_SPEECH_COLORS;
        }
        return this.NORMAL_SPEECH_COLORS;
    }

    private function useCleanString(_arg_1:Text):Boolean {
        return Parameters.data.filterLanguage && _arg_1.cleanText_.length > 0 && _arg_1.objectId_ != this.model.player.objectId_;
    }

    private function getCustomMultiColors(_arg_1:String):String {
        var _local3:int = 0;
        var _local5:int = 0;
        var _local6:* = null;
        var _local4:* = [];
        var _local2:int = _arg_1.length;
        _local5 = 0;
        while (_local5 < _local2) {
            _local6 = _arg_1.charAt(_local5);
            if (_local6 in similar) {
                _local3 = similar[_local6];
            } else {
                _local3 = _arg_1.charCodeAt(_local5);
            }
            if (_local3 >= 48 && _local3 <= 57 || _local3 >= 97 && _local3 <= 122) {
                _local4.push(_local3);
            }
            _local5++;
        }
        return String.fromCharCode.apply(String, _local4);
    }
}
}
