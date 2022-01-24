package kabam.rotmg.chat.control {
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.parameters.Parameters;
    
    import flash.events.Event;
    import flash.system.System;
    import flash.utils.Dictionary;
    
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.account.core.services.GetConCharListTask;
    import kabam.rotmg.account.core.services.GetConServersTask;
    import kabam.rotmg.chat.model.ChatMessage;
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.game.model.GameInitData;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.game.signals.PlayGameSignal;
    import kabam.rotmg.servers.api.Server;
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.ui.signals.EnterGameSignal;
    
    public class ParseChatMessageCommand {
        
        public static function uint_Zeropadded(integer: uint, param2: int = 0) {
            var padding: * = "0000";
            var intStr: String = integer.toString(16);
            while (intStr.length < param2) {
                intStr = padding.substr(0, param2 - intStr.length) + intStr;
            }
            return intStr;
        }
        
        private static function isServer(serverName: String): Boolean {
            for (var key: String in Server.serverAbbreviations)
                if (key == serverName)
                    return true;
            
            return false;
        }
        
        private static function isChar(charName: String): int {
            var _local2: * = null;
            var _local5: * = null;
            var _local3: int = -1;
            var counter: int = 0;
            while (counter < Parameters.charNames.length) {
                _local2 = charName;
                _local5 = Parameters.charNames[counter];
                if (_local2.substr(_local2.length - 1, 1) == "2" && _local5.substr(_local5.length - 1, 1) == "2") {
                    if (_local5.substring(0, _local2.length - 1) == _local2.substr(0, _local2.length - 1)) {
                        _local3 = Parameters.charIds[counter];
                        break;
                    }
                } else if (_local5.substring(0, _local2.length) == _local2) {
                    _local3 = Parameters.charIds[counter];
                    break;
                }
                counter++;
            }
            if (_local3 > 0) {
                return _local3;
            }
            return -1;
        }
        
        private static function isRealmName(realmName: String): Boolean {
            var realmNames: Vector.<String> = new <String>["pirate", "deathmage", "spectre", "titan",
                "gorgon", "kraken", "satyr", "drake", "chimera", "dragon",
                "wyrm", "hydra", "leviathan", "minotaur", "mummy", "reaper",
                "phoenix", "giant", "unicorn", "harpy", "gargoyle", "snake",
                "cube", "goblin", "hobbit", "skeleton", "scorpion", "bat",
                "ghost", "slime", "lich", "orc", "imp", "spider", "demon",
                "blob", "golem", "sprite", "flayer", "ogre", "djinn",
                "cyclops", "beholder", "medusa"];
            
            return realmNames.indexOf(realmName) != -1;
        }
        
        public function ParseChatMessageCommand() {
            super();
        }
        
        [Inject]
        public var data: String;
        [Inject]
        public var hudModel: HUDModel;
        [Inject]
        public var addTextLine: AddTextLineSignal;
        [Inject]
        public var enterGame: EnterGameSignal;
        [Inject]
        public var playGame: PlayGameSignal;
        [Inject]
        public var account: Account;
        
        public function execute(): void {
            var go: GameObject;
            var split: Array = this.data.split(" ");
            var command: String = (split[0] as String).toLowerCase();
            var fpsText: String = "", fpsParam: String = "";
            
            switch (command) {
            case "/commands":
            case "/h":
            case "/help":
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "helpCommand"));
                return;
            case "/c":
            case "/class":
            case "/classes":
                var objDict: Dictionary = new Dictionary();
                var playerCount: int = 0;
                for each (go in this.hudModel.gameSprite.map.goDict_)
                    if (go.props_.isPlayer_) {
                        objDict[go.objectType_] = objDict[go.objectType_] != undefined ?
                                objDict[go.objectType_] + 1 : 1;
                        playerCount++;
                    }
                
                var text: String = "";
                for (var objType: int in objDict) {
                    text += (" " + ObjectLibrary.typeToDisplayId_[objType] + ": " + objDict[objType]);
                }
                
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Classes online (" + playerCount + "):" + text));
                return;
            case "/chatlength":
            case "/cl":
                if (split.length == 2) {
                    var len: int = parseInt(split[1]);
                    if (!isNaN(len)) {
                        Parameters.data.chatLength = parseInt(split[1]);
                        Parameters.save();
                        this.hudModel.gameSprite.chatBox_.model.setVisibleItemCount();
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Chat length set to: " + Parameters.data.chatLength));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage: /cl <line numbesr>"));
                } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage: /cl <line numbesr>"));
                return;
            case "/bgfps":
                this.handleFPSCommand("Background FPS", "bgFPS", split, command);
                break;
            case "/fgfps":
                this.handleFPSCommand("Foreground FPS", "fgFPS", split, command);
                break;
            case "/fps":
                this.handleFPSCommand("FPS Cap", "customFPS", split, command);
                break;
            case "/ip":
                var server: Server = this.hudModel.gameSprite.gsc_.server_;
                var index: int = server.name.indexOf("NexusPortal.");
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, (index == -1 ? server.name : server.name.substring(index + "NexusPortal.".length)) + ": " + server.address));
                System.setClipboard(server.address);
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Copied IP to clipboard!"));
                return;
            case "/goto":
                if (Parameters.data.shownGotoWarning) {
                    if (split.length == 2) {
                        // todo: regex verify the ip
                        Parameters.enteringRealm = true;
                        this.jumpToIP(split[1]);
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage /goto <ip>"));
                } else {
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "WARNING! /goto can be used to steal your account information, " +
                            "meaning you should only use it on IPs you trust." +
                            "Re-send the message for it to register."));
                    Parameters.data.shownGotoWarning = true;
                }
                return;
            case "/conn":
                if (!Parameters.data.replaceCon)
                    break; // breaking so the playertext sends
            goto ConCommand;
                return;
            case "/con":
                if (Parameters.data.replaceCon)
                    break; // breaking so the playertext sends
            goto ConCommand;
                return;
            case "/pos":
            case "/loc":
            case "/l":
                var player: Player = this.hudModel.gameSprite.map.player_;
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Your location is x=" + player.x_.toFixed(2) + ", y=" + player.y_.toFixed(2)));
                break;
            case "/mapscale":
            case "/mscale":
            case "/ms":
                switch (split.length) {
                case 1:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Your current map scale is: " + Parameters.data.mscale));
                    break;
                case 2:
                    var mscale: Number = parseFloat(split[1]);
                    if (!isNaN(mscale)) {
                        Parameters.data.mscale = mscale;
                        Parameters.save();
                        Parameters.root.dispatchEvent(new Event(Event.RESIZE));
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Map scale set to: " + Parameters.data.mscale));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect length! Make sure you are providing a number."));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage /ms <float>"));
                    break;
                }
                return;
            case '/gkick':
                if (split.length == 2) {
                    this.hudModel.gameSprite.gsc_.guildRemove(split[1]);
                } else {
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Please enter a player to kick: /gkick <player>"));
                    break;
                }
                return;
            case '/gquit':
                this.hudModel.gameSprite.gsc_.guildRemove(this.hudModel.gameSprite.map.player_.name_);
                return;
            case '/grank':
                if (split.length == 3) {
                    this.hudModel.gameSprite.gsc_.changeGuildRank(split[1], int(split[2]));
                } else {
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments: /grank <playername> <rank>"));
                    break;
                }
                return;
            case "/an":
            case "/autonexus":
                if (split.length == 2) {
                    Parameters.data.AutoNexus = Number(split[1]);
                    if (this.hudModel.gameSprite.map.player_) {
                        this.hudModel.gameSprite.map.player_.calcHealthPercent();
                    }
                    if (Parameters.data.AutoNexus == 0) {
                        this.hudModel.gameSprite.map.player_.textNotification("Autonexus 0% (OFF)");
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "WARNING: Autonexus is OFF"));
                    }
                } else {
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments: /an 0.25 = 25% autonexus"));
                }
                break;
            case "/ao":
            case "/ta":
            case "/togglealpha":
                Parameters.data.alphaOnOthers = !Parameters.data.alphaOnOthers;
                Parameters.save();
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Player transparency: " + (Parameters.data.alphaOnOthers ? "ON" : "OFF")));
                break;
            case "/alpha":
                switch (split.length) {
                case 2:
                    var alpha: Number = parseFloat(split[1]);
                    if (!isNaN(alpha)) {
                        Parameters.data.alphaMan = alpha;
                        Parameters.save();
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Player transparency value set to: " + Parameters.data.alphaMan));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage: /alpha <float>"));
                    break;
                case 1:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Your current player transparency value is: " + Parameters.data.alphaMan + "%"));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage: /alpha <float>"));
                    break;
                }
                break;
            case "/setmsg1":
            case "/setmsg2":
            case "/setmsg3":
            case "/setmsg4":
                var msgId: int = parseInt(command.charAt(7)); // this should never be NaN, so no checks
                if (split.length > 1) {
                    Parameters.data["customMessage" + msgId] = this.data.substring(9);
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                            "Message #" + msgId + " set to: " + Parameters.data["customMessage" + msgId]));
                } else
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                            "Your current message #" + msgId + " is: '" + Parameters.data["customMessage" + msgId] + "'"));
                break;
            case "/follow":
                switch (split.length) {
                case 2:
                    var name: String = split[1] as String;
                    Parameters.followName = name;
                    for each (go in this.hudModel.gameSprite.map.goDict_)
                        if (go is Player && go.name_.toUpperCase() == name.toUpperCase()) {
                            Parameters.followPlayer = go;
                            Parameters.followName = name.toUpperCase();
                            Parameters.followingName = true;
                        }
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Now following player: " + Parameters.followName));
                    break;
                case 1:
                    Parameters.followingName = false;
                    Parameters.followName = "";
                    Parameters.followPlayer = null
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "No longer following player: " + Parameters.followName));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Incorrect arguments! Usage: /follow <string>"));
                    break;
                }
                break;
            case "/suicide":
                Parameters.suicideMode = !Parameters.suicideMode;
                Parameters.suicideAT = getTimer();
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Suicide mode: " + (Parameters.suicideMode ? "ON" : "OFF")));
                break;
            case "/spd":
            case "/setspd":
                switch (split.length) {
                case 2:
                    var speed: int = parseInt(split[1]);
                    if (!isNaN(speed)) {
                        this.hudModel.gameSprite.map.player_.speed_ = speed;
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                                "Speed stat set to: " + speed));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /speed <whole number>"));
                    break;
                case 1:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                            "Your current Speed is: " + this.hudModel.gameSprite.map.player_.speed_));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /speed <whole number>"));
                    break;
                }
                break;
            case "/fakelag":
                //todo: check setting and usages for fakelag
                switch (split.length) {
                case 2:
                    var lagMS: int = parseInt(split[1]);
                    if (!isNaN(lagMS)) {
                        Parameters.data.fakeLag = lagMS;
                        Parameters.save();
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                                "Fake lag set to: " + lagMS + "ms"));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /fakelag <whole number>"));
                    break;
                case 1:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                            "Your current Fake Lag is: " + Parameters.data.fakeLag));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /fakelag <whole number>"));
                    break;
                }
                break;
            case "/recondelay":
                switch (split.length) {
                case 2:
                    var reconDelay: int = parseInt(split[1]);
                    if (!isNaN(reconDelay)) {
                        Parameters.data.reconnectDelay = reconDelay;
                        Parameters.save();
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                                "Reconnect delay set to: " + reconDelay + " ms"));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /recondelay <whole number>"));
                    break;
                case 1:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                            "Your current reconnect delay is: " + Parameters.data.reconnectDelay));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /recondelay <whole number>"));
                    break;
                }
                break;
            case "/renderdist":
                switch (split.length) {
                case 2:
                    var renderDist: int = parseInt(split[1]);
                    if (!isNaN(renderDist)) {
                        Parameters.data.renderDistance = renderDist;
                        Parameters.save();
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                                "Render distance set to: " + renderDist + " tiles"));
                    } else this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /renderdist <whole number>"));
                    break;
                case 1:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME,
                            "Your current render distance is: " + Parameters.data.renderDistance));
                    break;
                default:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Incorrect arguments! Usage: /renderdist <whole number>"));
                    break;
                }
                break;
            case "/scui":
            case "/scaleui":
                //todo: check setting for uiscale
                Parameters.data.uiScale = !Parameters.data.uiScale;
                Parameters.save();
                Parameters.root.dispatchEvent(new Event("resize"));
                break;
            case "/cstat":
            case "/clientstat":
                Parameters.data.showClientStat = !Parameters.data.showClientStat;
                Parameters.save();
                break;
            case "/irecon":
                Parameters.ignoreRecon = !Parameters.ignoreRecon;
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Ignoring reconnects: " + Parameters.ignoreRecon));
                break;
            case "/useportal":
                Parameters.usingPortal = !Parameters.usingPortal;
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Spamming a useportal: " + Parameters.usingPortal));
                break;
            case "/portalrate":
                //todo: remove this command after testing rate limit
                Parameters.portalSpamRate = int(split[1]);
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Portal spam rate: " + Parameters.portalSpamRate));
                break;
            case "/mobinfo":
                //todo: check setting for showmobinfo
                Parameters.data.showMobInfo = !Parameters.data.showMobInfo;
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Show mob info: " + Parameters.data.showMobInfo));
                if (!Parameters.data.showMobInfo && this.hudModel.gameSprite.map.mapOverlay_) {
                    this.hudModel.gameSprite.map.mapOverlay_.removeChildren(0);
                }
                break;
            case "/logswap":
                //todo: add setting for loginvswap
                Parameters.data.logInvSwap = !Parameters.data.logInvSwap;
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Logging inv swaps: " + Parameters.data.logInvSwap));
                break;
            case "/name":
                //todo: persist this with a setting across map reloads
                if (split.length == 2) {
                    this.hudModel.gameSprite.hudView.characterDetails.setName(split[1]);
                } else {
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Enter a username: /name newname"));
                }
                break;
            case "/tutmode":
                //todo: add setting for tutorialMode
                Parameters.data.tutorialMode = !Parameters.data.tutorialMode;
                this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Tutorial mode: " + Parameters.data.tutorialMode));
                break;
            case "/timescale":
            case "/ts":
                //todo: fix timescale and add option in parameters
                switch (int(split.length) - 1) {
                case 0:
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Your current timescale is: " + Parameters.data.timeScale + "x"));
                    break;
                case 1:
                    var timeScale: Number = parseFloat(split[1]);
                    
                    if (!isNaN(timeScale)) {
                        Parameters.data.timeScale = timeScale;
                        Parameters.save();
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Time scale set to: " + timeScale + "x"));
                    } else {
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "Provide a multiplier number e.g: /ts 1.2"));
                    }
                }
                break;
            default:
                this.hudModel.gameSprite.gsc_.playerText(this.data);
                return;
            }
            {
                // noinspection UnreachableCodeJS, JSUnusedAssignment
                if (split.length <= 1 || split.length >= 6) {
                    var cmd: String = Parameters.data.replaceCon ? "/conn" : "/con";
                    this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,
                            "Usage: " + cmd + " <server> <character> <realm> <bazaar>"));
                    return;
                }
                
                var charId: int = -1;
                var serverStr: String = "";
                var realmName: String = "";
                var bazSide: String = "";
                // noinspection JSUnusedAssignment
                for each (var argument: String in split) {
                    argument = argument.toLowerCase();
                    if (isServer(argument))
                        serverStr = argument;
                    
                    charId = isChar(argument);
                    
                    if (isRealmName(argument))
                        realmName = argument;
                    
                    if (argument == "left" || argument == "right")
                        bazSide = argument;
                }
                
                if (realmName != "") {
                    Parameters.realmJoining = true;
                    Parameters.realmName = realmName;
                }
                
                if (bazSide != "") {
                    Parameters.bazaarJoining = true;
                    Parameters.bazaarLR = bazSide;
                    Parameters.bazaarDist = Math.random() * 10;
                    if (serverStr == "" && this.hudModel.gameSprite.map.isNexus)
                        return;
                }
                
                jumpToServer(serverStr, charId);
                //noinspection UnnecessaryReturnStatementJS
                return;
            }
            
            /*if (text == "/mystic") {
             text = "Mystics in train: ";
             var _local61:int = 0;
             var _local60:* = hudModel.gameSprite.map.goDict_;
             for each(_local4 in hudModel.gameSprite.map.goDict_) {
             if (_local4.objectType_ == 803) {
             text = text + (_local4.name_ + ", ");
             }
             }
             text = text.substring(0, text.length - 2);
             this.addTextLine.dispatch(ChatMessage.make("", text));
             text = "Mystics with > 0 and < max MP: ";
             var _local63:int = 0;
             var _local62:* = hudModel.gameSprite.map.goDict_;
             for each(_local4 in hudModel.gameSprite.map.goDict_) {
             if (_local4.objectType_ == 803) {
             _local1 = _local4 as Player;
             if (_local1.mp_ > 0 && _local1.mp_ < _local1.maxMP_) {
             text = text + (_local4.name_ + ", ");
             }
             }
             }
             text = text.substring(0, text.length - 2);
             this.addTextLine.dispatch(ChatMessage.make("", text));
             text = "Mystics stasised: ";
             _local9 = getTimer();
             var _local65:int = 0;
             var _local64:* = Parameters.mystics;
             for each(var _local19 in Parameters.mystics) {
             split = _local19.split(" ");
             text = text + (split[0] + " stasised " + (_local9 - split[1] * 1) / 1000 + " seconds ago, ");
             }
             text = text.substring(0, text.length - 2);
             this.addTextLine.dispatch(ChatMessage.make("", text));
             } else if (text == "/fpm" || text == "/fame") {
             _local9 = getTimer() - Parameters.fpmStart;
             _local30 = Math.round(Parameters.fpmGain / _local9 * 60000 * 100) / 100;
             this.hudModel.gameSprite.map.player_.textNotification(Parameters.fpmGain + " fame\n" + Math.floor(_local9 / 60000 * 10) / 10 + " minutes\n" + _local30 + " fame/min", 14835456, 50 * 60);
             } else if (text == "/fpmclear") {
             Parameters.fpmStart = getTimer();
             Parameters.fpmGain = 0;
             } else*/
        }
        
        public function handleFPSCommand(fpsType: String, internalType: String, args: Array, command: String): void {
            switch (int(args.length) - 1) {
            case 0:
                this.addTextLine.dispatch(ChatMessage.make("*Help*", "Your " + fpsType + " is: " + Parameters.data[internalType]));
                break;
            case 1:
                var newFPS: int = parseInt(args[1]);
                if (!isNaN(newFPS)) {
                    Parameters.data[internalType] = parseInt(args[1]);
                    Parameters.save();
                    if (internalType == "customFPS") {
                        WebMain.STAGE.frameRate = Parameters.data[internalType];
                    }
                    this.addTextLine.dispatch(ChatMessage.make("*Help*", fpsType + " set to: " + Parameters.data[internalType]));
                } else {
                    this.addTextLine.dispatch(ChatMessage.make("*Error*", "Incorrect arguments! Usage: " + command + " <whole number>"));
                }
            }
        }
        
        public function jumpToServer(_arg_1: String, _arg_2: int = -1): void {
            var _local5: Boolean = false;
            var _local6: * = null;
            if (_arg_2 != -1 && _arg_1 == "") {
                _local5 = true;
            }
            if (_arg_2 == -1) {
                _arg_2 = this.hudModel.gameSprite.gsc_.charId_;
            }
            if (_arg_1 == "") {
                _arg_1 = Parameters.data.preferredServer;
            }
            _arg_1 = _arg_1.toLowerCase();
            var _local3: Boolean = this.hudModel.gameSprite.map && this.hudModel.gameSprite.map.player_;
            var _local4: String = Server.serverAbbreviations[_arg_1];
            if (_local4 == null && !_local5) {
                if (_local3) {
                    this.hudModel.gameSprite.map.player_.addTextLine.dispatch(ChatMessage.make("*Error*", "Invalid server " + _arg_1));
                }
            } else {
                if (Parameters.data.preferredServer == _local4 && !_local5) {
                    if (_local3) {
                        this.hudModel.gameSprite.map.player_.addTextLine.dispatch(ChatMessage.make("", "Already in " + _local4 + ", joining anyways"));
                    }
                }
                if (_local4 && !_local5) {
                    Parameters.data.preferredServer = _local4;
                }
                Parameters.save();
                this.enterGame.dispatch();
                _local6 = new GameInitData();
                _local6.createCharacter = false;
                _local6.charId = _arg_2;
                _local6.isNewGame = true;
                if (Parameters.reconNexus) {
                    Parameters.reconNexus.server_ = _local6.server;
                }
                this.playGame.dispatch(_local6);
            }
        }
        
        public function jumpToIP(param1: String): void {
            this.enterGame.dispatch();
            var _loc2_: GameInitData = new GameInitData();
            _loc2_.server = new Server();
            _loc2_.server.port = 2050;
            _loc2_.server.setName(param1);
            _loc2_.server.address = param1;
            _loc2_.createCharacter = false;
            _loc2_.charId = this.hudModel.gameSprite.gsc_.charId_;
            _loc2_.isNewGame = true;
            this.playGame.dispatch(_loc2_);
        }
        
        private function handleConCommand(args: Array): void {
            var commandType: * = null;
            var serverTask: * = null;
            var charListTask: * = null;
            
            if (args.length <= 1 || args.length >= 6) {
                commandType = Parameters.data.replaceCon ? "/conn" : "/con";
                this.addTextLine.dispatch(ChatMessage.make("*Error*", "Usage: " + commandType + " <server> <character> <realm> <bazaar>"));
                return;
            }
            
            var characterId: int = -1;
            var serverName: * = "";
            var bazaarSide: * = "";
            
            for each(var arg: String in args) {
                arg = arg.toLowerCase();
                if (isServer(arg)) {
                    serverName = arg;
                }
                characterId = isChar(arg);
                if (arg == "left" || arg == "right") {
                    bazaarSide = arg;
                }
            }
            
            if (serverName != "") {
                serverTask = StaticInjectorContext.getInjector().getInstance(GetConServersTask);
                serverTask.start();
            }
            if (characterId != -1) {
                charListTask = StaticInjectorContext.getInjector().getInstance(GetConCharListTask);
                charListTask.start();
            }
            if (bazaarSide != "") {
                Parameters.bazaarJoining = true;
                Parameters.bazaarLR = bazaarSide;
                Parameters.bazaarDist = Math.random() * 10;
                if (serverName == "" && this.hudModel.gameSprite.map.isNexus) {
                    return;
                }
            }
            jumpToServer(serverName, characterId);
        }
    }
}