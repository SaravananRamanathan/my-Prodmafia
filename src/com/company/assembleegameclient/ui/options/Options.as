package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;

import io.decagames.rotmg.ui.scroll.UIScrollbar;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.game.view.components.StatView;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.UIUtils;
import kabam.rotmg.ui.signals.ToggleShowTierTagSignal;

public class Options extends Sprite {

    public static const Y_POSITION:int = 550;
    public static const SCROLL_HEIGHT:int = 420;
    public static const SCROLL_Y_OFFSET:int = 102;
    public static const CHAT_COMMAND:String = "chatCommand";
    public static const CHAT:String = "chat";
    public static const TELL:String = "tell";
    public static const GUILD_CHAT:String = "guildChat";
    public static const SCROLL_CHAT_UP:String = "scrollChatUp";
    public static const SCROLL_CHAT_DOWN:String = "scrollChatDown";
    private static var registeredCursors:Vector.<String> = new Vector.<String>(0);

    public static function refreshCursor():void {
        var _local1:* = null;
        var _local2:* = undefined;
        if (Parameters.data.cursorSelect != "auto" && registeredCursors.indexOf(Parameters.data.cursorSelect) == -1) {
            _local1 = new MouseCursorData();
            _local1.hotSpot = new Point(15, 15);
            _local2 = new Vector.<BitmapData>(1, true);
            _local2[0] = AssetLibrary.getImageFromSet("cursorsEmbed", Parameters.data.cursorSelect);
            _local1.data = _local2;
            Mouse.registerCursor(Parameters.data.cursorSelect, _local1);
            registeredCursors.push(Parameters.data.cursorSelect);
        }
        Mouse.cursor = Parameters.data.cursorSelect;
    }

    public static function calculateIgnoreBitmask():void {
        var _local2:* = 0;
        var _local1:* = 0;
        var _local3:* = 0;
        if (Parameters.data.ignoreQuiet) {
            _local2 = uint(_local2 | 4);
        }
        if (Parameters.data.ignoreWeak) {
            _local2 = uint(_local2 | 8);
        }
        if (Parameters.data.ignoreSlowed) {
            _local2 = uint(_local2 | 16);
        }
        if (Parameters.data.ignoreSick) {
            _local2 = uint(_local2 | 32);
        }
        if (Parameters.data.ignoreDazed) {
            _local2 = uint(_local2 | 64);
        }
        if (Parameters.data.ignoreStunned) {
            _local2 = uint(_local2 | 128);
        }
        if (Parameters.data.ignoreParalyzed) {
            _local2 = uint(_local2 | 16384);
        }
        if (Parameters.data.ignoreBleeding) {
            _local2 = uint(_local2 | 65536);
        }
        if (Parameters.data.ignoreArmorBroken) {
            _local2 = uint(_local2 | 134217728);
        }
        if (Parameters.data.ignorePetStasis) {
            _local2 = uint(_local2 | 4194304);
        }
        if (Parameters.data.ignorePetrified) {
            _local1 = uint(_local1 | 8);
        }
        if (Parameters.data.ignoreSilenced) {
            _local1 = uint(_local1 | 65536);
        }
        if (Parameters.data.ignoreBlind) {
            _local3 = uint(_local3 | 256);
        }
        if (Parameters.data.ignoreHallucinating) {
            _local3 = uint(_local3 | 512);
        }
        if (Parameters.data.ignoreDrunk) {
            _local3 = uint(_local3 | 1024);
        }
        if (Parameters.data.ignoreConfused) {
            _local3 = uint(_local3 | 2048);
        }
        if (Parameters.data.ignoreUnstable) {
            _local3 = uint(_local3 | 1073741824);
        }
        if (Parameters.data.ignoreDarkness) {
            _local3 = uint(_local3 | -2147483648);
        }
        Parameters.data.ssdebuffBitmask = _local2;
        Parameters.data.ssdebuffBitmask2 = _local1;
        Parameters.data.ccdebuffBitmask = _local3;
    }

    private static function makeOnOffLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[makeLineBuilder("Options.On"), makeLineBuilder("Options.Off")];
    }

    private static function makeHighLowLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("High"), new StaticStringBuilder("Low")];
    }

    private static function makeReconDelayLabels() : Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("0 ms"),new StaticStringBuilder("100 ms"),new StaticStringBuilder("250 ms"),new StaticStringBuilder("500 ms"),new StaticStringBuilder("750 ms"),new StaticStringBuilder("1000 ms"),new StaticStringBuilder("1500 ms"),new StaticStringBuilder("2000 ms")];
    }

    private static function makeStarSelectLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("5"), new StaticStringBuilder("10")];
    }

    private static function makeFameDeltaLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("0"), new StaticStringBuilder("0.25"), new StaticStringBuilder("0.5"), new StaticStringBuilder("0.75"), new StaticStringBuilder("1"), new StaticStringBuilder("1.5"), new StaticStringBuilder("2")];
    }

    private static function makeFameCheckLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("50"), new StaticStringBuilder("100"), new StaticStringBuilder("150"), new StaticStringBuilder("225"), new StaticStringBuilder("300"), new StaticStringBuilder("400"), new StaticStringBuilder("500")];
    }

    private static function makeCursorSelectLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("ProX"), new StaticStringBuilder("X2"), new StaticStringBuilder("X3"), new StaticStringBuilder("X4"), new StaticStringBuilder("Corner1"), new StaticStringBuilder("Corner2"), new StaticStringBuilder("Symb"), new StaticStringBuilder("Alien"), new StaticStringBuilder("Xhair"), new StaticStringBuilder("Chusto1"), new StaticStringBuilder("Chusto2")];
    }

    private static function makeLineBuilder(_arg_1:String):LineBuilder {
        return new LineBuilder().setParams(_arg_1);
    }

    private static function onUIQualityToggle():void {
        UIUtils.toggleQuality(Parameters.data.uiQuality);
    }

    private static function onBarTextToggle():void {
        StatusBar.barTextSignal.dispatch(Parameters.data.toggleBarText);
    }

    private static function onToMaxTextToggle():void {
        StatusBar.barTextSignal.dispatch(Parameters.data.toggleBarText);
        StatView.toMaxTextSignal.dispatch(Parameters.data.toggleToMaxText);
    }

    private static function makeDegreeOptions():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("45°"), new StaticStringBuilder("0°")];
    }

    private static function onDefaultCameraAngleChange():void {
        Parameters.data.cameraAngle = Parameters.data.defaultCameraAngle;
        Parameters.save();
    }

    private static function makePetHiddenLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[makeLineBuilder("Hide All"), makeLineBuilder("Show All"), makeLineBuilder("Show Mine")];
    }

    private static function chatLengthLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("4"), new StaticStringBuilder("5"), new StaticStringBuilder("6"), new StaticStringBuilder("7"), new StaticStringBuilder("8"), new StaticStringBuilder("9"), new StaticStringBuilder("10"), new StaticStringBuilder("11"), new StaticStringBuilder("12"), new StaticStringBuilder("13"), new StaticStringBuilder("14"), new StaticStringBuilder("15"), new StaticStringBuilder("16"), new StaticStringBuilder("17"), new StaticStringBuilder("18"), new StaticStringBuilder("19"), new StaticStringBuilder("20")];
    }

    private static function makeRightClickOptions():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("Quest"), new StaticStringBuilder("Ability"), new StaticStringBuilder("Camera")];
    }

    private static function makeAllyShootLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("All"), new StaticStringBuilder("Proj")];
    }

    private static function makeHpBarLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("All"), new StaticStringBuilder("Enemy"), new StaticStringBuilder("Self & En."), new StaticStringBuilder("Self"), new StaticStringBuilder("Ally")];
    }

    private static function makeForceExpLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("On"), new StaticStringBuilder("Self")];
    }

    private static function makeBarTextLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("All"), new StaticStringBuilder("Fame"), new StaticStringBuilder("HP/MP")];
    }

    public function Options(_arg_1:GameSprite) {
        var _local3:* = undefined;
        var _local8:int = 0;
        var _local2:* = null;
        tabs_ = new Vector.<OptionsTabTitle>();
        options_ = new Vector.<Sprite>();
        var _local6:* = null;
        var _local5:* = null;
        _local3 = new <String>["Options.Controls", "Options.HotKeys", "Options.Chat", "Options.Graphics", "Options.Sound", "Options.Friend", "Experimental", "Debuffs", "Auto", "Loot", "World", "Recon", "Visual", "Fame", "Other"];
        super();
        this.gs_ = _arg_1;
        graphics.clear();
        graphics.beginFill(0x2b2b2b, 0.8);
        graphics.drawRect(0, 0, 800, 10 * 60);
        graphics.endFill();
        graphics.lineStyle(1, 0x5e5e5e);
        graphics.moveTo(0, 100);
        graphics.lineTo(800, 100);
        graphics.lineStyle();
        _local6 = new TextFieldDisplayConcrete().setSize(36).setColor(0xffffff);
        _local6.setBold(true);
        _local6.setStringBuilder(new LineBuilder().setParams("Options.title"));
        _local6.setAutoSize("center");
        _local6.filters = [new DropShadowFilter(0, 0, 0)];
        _local6.x = 400 - _local6.width / 2;
        _local6.y = 8;
        addChild(_local6);
        addChild(new ScreenGraphic());
        this.continueButton_ = new TitleMenuOption("Options.continueButton", 36, false);
        this.continueButton_.setVerticalAlign("middle");
        this.continueButton_.setAutoSize("center");
        this.continueButton_.addEventListener("click", this.onContinueClick);
        addChild(this.continueButton_);
        this.resetToDefaultsButton_ = new TitleMenuOption("Options.resetToDefaultsButton", 22, false);
        this.resetToDefaultsButton_.setVerticalAlign("middle");
        this.resetToDefaultsButton_.setAutoSize("left");
        this.resetToDefaultsButton_.addEventListener("click", this.onResetToDefaultsClick);
        addChild(this.resetToDefaultsButton_);
        this.homeButton_ = new TitleMenuOption("Options.homeButton", 22, false);
        this.homeButton_.setVerticalAlign("middle");
        this.homeButton_.setAutoSize("right");
        this.homeButton_.addEventListener("click", this.onHomeClick);
        addChild(this.homeButton_);
        var _local4:int = 14;
        _local8 = 0;
        while (_local8 < _local3.length) {
            _local2 = new OptionsTabTitle(_local3[_local8]);
            _local2.x = _local4;
            _local2.y = 50 + 25 * (int(_local8 / 8));
            if (_local8 % 8 == 0) {
                _local4 = 14;
                _local2.x = _local4;
            }
            _local4 = _local4 + 104;
            if (_local2.text_ == Parameters.data.lastTab) {
                _local5 = _local2;
            }
            addChild(_local2);
            _local2.addEventListener("click", this.onTabClick);
            this.tabs_.push(_local2);
            _local8++;
        }
        if (_local5) {
            this.defaultTab_ = _local5;
        } else {
            this.defaultTab_ = this.tabs_[0];
        }
        addEventListener("addedToStage", this.onAddedToStage);
        addEventListener("removedFromStage", this.onRemovedFromStage);
        var _local7:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
        _local7.dispatch();
        this.createScrollWindow();
        Parameters.realmJoining = false;
    }
    private var gs_:GameSprite;
    private var continueButton_:TitleMenuOption;
    private var resetToDefaultsButton_:TitleMenuOption;
    private var homeButton_:TitleMenuOption;
    private var tabs_:Vector.<OptionsTabTitle>;
    private var selected_:OptionsTabTitle;
    private var options_:Vector.<Sprite>;
    private var defaultTab_:OptionsTabTitle;
    private var scroll:UIScrollbar;
    private var scrollContainer:Sprite;
    private var scrollContainerBottom:Shape;

    public function addAutoOptions():void {
        this.addOptionAndPosition(new KeyMapper("AAHotkey", "AutoAim Hotkey", "Toggle AutoAim"));
        this.addOptionAndPosition(new KeyMapper("AAModeHotkey", "AimMode Hotkey", "Switch AutoAim\'s aim mode"));
        this.addOptionAndPosition(new KeyMapper("AutoAbilityHotkey", "Auto Ability Hotkey", "Toggle Auto Ability"));
        this.addOptionAndPosition(new ChoiceOption("AAOn", makeOnOffLabels(), [true, false], "AutoAim", "Automatically aim at enemies", null));
        this.addOptionAndPosition(new ChoiceOption("AAMinManaPercent", this.AutoManaPercentValues(), [-1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100], "Auto Ability MP %", "Minimum MP value required before Auto Ability uses your ability (if set to 70%, it will use your ability when your mana is at or above 70% and will not use it when your current mp is below 70%", this.resetMPVals));
        this.addOptionAndPosition(new ChoiceOption("AutoNexus", this.AutoNexusValues(), [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60], "Autonexus Percent", "The percent of health at which to autonexus at", resetHPVals));
        this.addOptionAndPosition(new ChoiceOption("AutoSyncClientHP", makeOnOffLabels(), [true, false], "AutoSync ClientHP", "Automatically sets your clientHP to your server HP if the difference between them is more than 60 hp for 600ms [WARNING, you can die with this on]", null));
        this.addOptionAndPosition(new ChoiceOption("AATargetLead", makeOnOffLabels(), [true, false], "AutoAim Target Lead", "Projectile deflection, makes autoaim shoot ahead of enemies so the projectile will collide with the enemy", null));
        this.addOptionAndPosition(new ChoiceOption("autoDecrementHP", makeOnOffLabels(), [true, false], "Remove HP when dealing damage", "Decreases an enemy\'s health when you deal damage to them, this allows you to one shot enemies with spellbombs", null));
        this.addOptionAndPosition(new ChoiceOption("shootAtWalls", makeOnOffLabels(), [true, false], "Shoot at Walls", "Make AutoAim aim at stuff like Walls and Davy barrels", null));
        this.addOptionAndPosition(new ChoiceOption("autoaimAtInvulnerable", makeOnOffLabels(), [true, false], "Aim at Invulnerable", "Make AutoAim aim at invulnerable enemies or not", null));
        this.addOptionAndPosition(new ChoiceOption("AABoundingDist", this.BoundingDistValues(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30, 50], "Bounding Distance", "Restrict AutoAim to see only as far as the bounding distance from the mouse cursor in closest to cursor aim mode", null));
        this.addOptionAndPosition(new ChoiceOption("onlyAimAtExcepted", makeOnOffLabels(), [true, false], "Only Aim at Excepted", "Only AutoAims at the enemies in your exception list", null));
        this.addOptionAndPosition(new ChoiceOption("autoHPPercent", this.AutoHPPotValues(), [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75], "Auto HP Pot Threshold", "Sets the health percentage at which to use an HP potion", resetHPVals));
        this.addOptionAndPosition(new ChoiceOption("autoMPPercent", this.AutoMPPotValues(), [0, -1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75], "Auto MP Pot Threshold", "Sets the mana percentage at which to use an MP potion, Abil % means it will drink until it has enough MP to use your ability", resetMPVals));
        this.addOptionAndPosition(new ChoiceOption("autohpPotDelay", this.AutoHPPotDelayValues(), [100, 200, 5 * 60, 400, 500, 10 * 60, 700, 800, 15 * 60, 1000], "Auto HP Pot Delay", "Sets the delay between drinking HP pots", null));
        this.addOptionAndPosition(new ChoiceOption("autompPotDelay", this.AutoHPPotDelayValues(), [100, 200, 5 * 60, 400, 500, 10 * 60, 700, 800, 15 * 60, 1000], "Auto MP Pot Delay", "Sets the delay between drinking MP pots", null));
        this.addOptionAndPosition(new ChoiceOption("AutoHealPercentage", this.AutoHealValues(), [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 99, 100], "Autoheal Threshold", "Sets the health percentage at which to heal", resetHPVals));
        this.addOptionAndPosition(new ChoiceOption("spellbombHPThreshold", this.spellbombThresholdValues(), [0, 250, 500, 750, 1000, 1250, 25 * 60, 1750, 2000, 2500, 50 * 60, 0xfa0, 5000, 100 * 60, 7000, 0x1f40, 150 * 60, 10000, 250 * 60, 20000], "AutoAbility Health Threshold", "Sets the enemy current health value at which Auto Ability will target enemies (ie, if it is set to 5000, then the auto ability will only attempt to shoot at enemies with greater than 5000 health), use /sbthreshold to set a specific value", null));
        this.addOptionAndPosition(new ChoiceOption("skullHPThreshold", this.skullThresholdValues(), [0, 100, 250, 500, 800, 1000, 2000, 0xfa0, 0x1f40], "AOE AutoAbility Health Threshold", "Sets the enemy current health value at which Auto Ability will target enemies for AOE abilities like Necro, Assassin, Huntress, Sorc, (ie, if it is set to 1000, then the Auto Ability will only attempt to shoot at enemies with greater than 1000 health), use /aathreshold to set a specific value", null));
        this.addOptionAndPosition(new ChoiceOption("skullTargets", this.skullTargetsValues(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Min AOE AutoAbility Targets", "Sets the amount of enemies required in your AOE ability\'s radius before using the ability, use /aatargets to set a specific value", null));
        this.addOptionAndPosition(new ChoiceOption("AutoResponder", makeOnOffLabels(), [true, false], "AutoResponder", "Automatically replies to Thessal/Cem/LoD/Sewer text", null));
        this.addOptionAndPosition(new ChoiceOption("aaDistance", this.aaDistanceValues(), [0, 0.5, 1, 1.5, 2, 2.5, 3], "AutoAim Distance Increase", "Adds additional range to AutoAim\'s range", null));
        this.addOptionAndPosition(new ChoiceOption("BossPriority", makeOnOffLabels(), [true, false], "Boss Priority", "Makes AutoAim prioritize Boss enemies over everything else - \"bosses\" includes all Quests and certain dungeon bosses which are not quests, such as the Shatters bosses", null));
        this.addOptionAndPosition(new ChoiceOption("spamPrismNumber", this.skullTargetsValues(), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Spam Trickster Prism", "Uses non teleporting Trickster prisms when this many enemies are around, with auto ability enabled", null));
    }

    public function addAutoLootOptions():void {
        this.addOptionAndPosition(new KeyMapper("AutoLootHotkey", "Auto Loot", "Toggles Auto Loot which automatically loots nearby items based on customizable criteria"));
        this.addOptionAndPosition(new ChoiceOption("autoLootUpgrades", makeOnOffLabels(), [true, false], "Loot Upgrades", "Pick up items with a higher tier than your current equips (UTs and STs are excluded)", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootWeaponTier", this.ZeroThirteen(), [999, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "Min Weapon Tier", "Minimum tier required for AutoLoot of tiered Weapons", this.updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootAbilityTier", this.ZeroSix(), [999, 0, 1, 2, 3, 4, 5, 6], "Min Ability Tier", "Minimum tier required for AutoLoot of tiered Abilities", this.updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootArmorTier", this.ZeroFourteen(), [999, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "Min Armor Tier", "Minimum tier required for AutoLoot of tiered Armors", this.updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootRingTier", this.ZeroSix(), [999, 0, 1, 2, 3, 4, 5, 6], "Min Ring Tier", "Minimum tier required for AutoLoot of tiered Rings", this.updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootFameBonus", alFBValues(), [-1, 1, 2, 3, 4, 5, 6, 7], "Min Fame Bonus", "Loot all items with a fame bonus equal to or above the specified amount", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootFeedPower", alFPValues(), [-1, 100, 200, 5 * 60, 400, 500, 10 * 60, 700, 800, 15 * 60, 1000, 20 * 60, 1400, 1600, 30 * 60, 2000], "Min Feed Power", "Loot all items with a feed power equal to or above the specified amount", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootHPPots", makeOnOffLabels(), [true, false], "Loot HP Potions", "Loot all HP potions", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootMPPots", makeOnOffLabels(), [true, false], "Loot MP Potions", "Loot all MP potions", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootHPPotsInv", makeOnOffLabels(), [true, false], "Loot HP Potions to Inventory", "Loot excess HP potions to inventory", null));
        this.addOptionAndPosition(new ChoiceOption("autoLootMPPotsInv", makeOnOffLabels(), [true, false], "Loot MP Potions to Inventory", "Loot excess MP potions to inventory", null));
        this.addOptionAndPosition(new ChoiceOption("autoLootLifeManaPots", makeOnOffLabels(), [true, false], "Loot Life/Mana Potions", "Loot all Life and Mana potions", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootRainbowPots", makeOnOffLabels(), [true, false], "Loot Rainbow Potions", "Loot all Atk/Def/Spd/Dex/Vit/Wis potions", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootSkins", makeOnOffLabels(), [true, false], "Loot Skins", "Loot all skins", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootKeys", makeOnOffLabels(), [true, false], "Loot Keys", "Loot all keys", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootPetSkins", makeOnOffLabels(), [true, false], "Loot Pet Skins", "Loot all pet skins", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootUTs", makeOnOffLabels(), [true, false], "Loot UT Items", "Loots White Bag and ST items", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootMarks", makeOnOffLabels(), [true, false], "Loot Marks", "Loot all Dungeon Quest Marks", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootEggs", makeEggLabels(), [-1, 0, 1, 2, 3], "Loot Pet Eggs", "Loot all Pet Eggs above the specified level", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootConsumables", makeOnOffLabels(), [true, false], "Loot Consumables", "Loot all Consumables, which includes (but not limited to) Tinctures, Effusions, Pet Stones, Skins", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootSoulbound", makeOnOffLabels(), [true, false], "Loot Soulbound Items", "Loot everything Soulbound", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootStackables", makeOnOffLabels(), [true, false], "Loot Stackables", "Loot all stackable items", updateWanted));
        this.addOptionAndPosition(new ChoiceOption("autoLootInVault", makeOnOffLabels(), [true, false], "Auto Loot in Vault", "Auto loot from bags in vault", null));
    }

    public function updateWanted():void {
        Parameters.needToRecalcDesireables = true;
    }

    public function ZeroSix():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("0"), new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("4"), new StaticStringBuilder("5"), new StaticStringBuilder("6")];
    }

    public function ZeroThirteen():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("0"), new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("4"), new StaticStringBuilder("5"), new StaticStringBuilder("6"), new StaticStringBuilder("7"), new StaticStringBuilder("8"), new StaticStringBuilder("9"), new StaticStringBuilder("10"), new StaticStringBuilder("11"), new StaticStringBuilder("12"), new StaticStringBuilder("13")];
    }

    public function ZeroFourteen():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("0"), new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("4"), new StaticStringBuilder("5"), new StaticStringBuilder("6"), new StaticStringBuilder("7"), new StaticStringBuilder("8"), new StaticStringBuilder("9"), new StaticStringBuilder("10"), new StaticStringBuilder("11"), new StaticStringBuilder("12"), new StaticStringBuilder("13"), new StaticStringBuilder("14")];
    }

    public function addWorldOptions():void {
        this.addOptionAndPosition(new ChoiceOption("ethDisable", makeOnOffLabels(), [true, false], "Offset Etherite", "Offsets your firing angle if you have an Etherite equipped to make it so your shots are in a straight line", null));
        this.addOptionAndPosition(new ChoiceOption("cultiststaffDisable", makeOnOffLabels(), [true, false], "Reverse Cultist Staff", "Reverses the angle of the Staff of Unholy Sacrifice (which normally shoots backwards) to make it so you shoot forwards", null));
        this.addOptionAndPosition(new ChoiceOption("offsetColossus", makeOnOffLabels(), [true, false], "Offset Colossus Sword", "Attempts to shoot straight, try /colo 0.4 and /colo 0.2", null));
        this.addOptionAndPosition(new ChoiceOption("offsetVoidBow", makeOnOffLabels(), [true, false], "Offset Void Bow", "Offsets your firing angle if you have a Bow of the Void equipped to make it so your shots are in a straight line", null));
        this.addOptionAndPosition(new ChoiceOption("offsetCelestialBlade", makeOnOffLabels(), [true, false], "Offset Celestial Blade", "Offsets your firing angle if you have a Celestial Blade equipped to make it so your shots are in a straight line", null));
        this.addOptionAndPosition(new ChoiceOption("damageIgnored", makeOnOffLabels(), [true, false], "Damage Ignored Enemies", "Prevents your shots from damaging enemies that are ignored", null));
        this.addOptionAndPosition(new KeyMapper("PassesCoverHotkey", "Projectile Noclip", "Toggle allowing projectiles to pass through solid objects like trees and walls"));
        this.addOptionAndPosition(new KeyMapper("anchorTeleport", "Teleport to Anchor", "Teleports you to the player you have anchored (set via /anchor <name> or the player menu)"));
        this.addOptionAndPosition(new KeyMapper("QuestTeleport", "Teleport to Quest", "Teleports to the player closest to your quest"));
        this.addOptionAndPosition(new ChoiceOption("ignoreIce", makeOnOffLabels(), [true, false], "Ignore Ice and Push", "Disables the slidy ice tiles and sprite world pushing tiles", null));
        this.addOptionAndPosition(new ChoiceOption("passThroughInvuln", makeOnOffLabels(), [true, false], "Pass Through Invuln", "Makes your projectiles not hit things that are invulnerable (unless your projectile would inflict a status effect), THIS INCLUDES TUTORIAL TURRETS, TURN IT OFF WHEN ACCURACY FARMING", null));
        this.addOptionAndPosition(new ChoiceOption("safeWalk", makeOnOffLabels(), [true, false], "Safe Walk", "Makes lava tiles act as if they were unwalkable.", null));
        this.addOptionAndPosition(new KeyMapper("TextPause", "/pause", "Say \"/pause\""));
        this.addOptionAndPosition(new KeyMapper("TextThessal", "Dying Thessal Text", "Say the \"He lives\" quote"));
        this.addOptionAndPosition(new KeyMapper("TextCem", "Cem Ready Text", "Say \"ready\""));
        this.addOptionAndPosition(new KeyMapper("sayCustom1", "Custom 1", "Sends a custom message, set this message with /setmsg1"));
        this.addOptionAndPosition(new KeyMapper("sayCustom2", "Custom 2", "Sends a custom message, set this message with /setmsg2"));
        this.addOptionAndPosition(new KeyMapper("sayCustom3", "Custom 3", "Sends a custom message, set this message with /setmsg3"));
        this.addOptionAndPosition(new KeyMapper("sayCustom4", "Custom 4", "Sends a custom message, set this message with /setmsg4"));
        this.addOptionAndPosition(new ChoiceOption("bypassTpPositionCheck",makeOnOffLabels(),[true,false],"Bypass Teleport Restriction","Removes the valid tile restriction on teleport abilities, which lets you teleport over undiscovered areas as trickster or planewalker rogue - may cause DCs",null));
        this.addOptionAndPosition(new ChoiceOption("mysticAAShootGroup",makeOnOffLabels(),[true,false],"Stasis Enemy Group Instead of Self","Make Mystic\'s orbs stasis groups of enemies instead of self",null));
    }

    public function addReconOptions():void {
        this.addOptionAndPosition(new KeyMapper("ReconRealm","Recon Realm","Key that connects the user to the last realm they were in."));
    }

    public function addVisualOptions():void {
        this.addOptionAndPosition(new KeyMapper("LowCPUModeHotKey", "Low CPU Mode", "Disables a lot of rendering and stuff"));
        this.addOptionAndPosition(new ChoiceOption("hideLowCPUModeChat", makeOnOffLabels(), [true, false], "Hide Chat in Low CPU Mode", "Controls whether normal chat is shown in Low CPU Mode", null));
        this.addOptionAndPosition(new ChoiceOption("showQuestBar", makeOnOffLabels(), [true, false], "Show Quest Bar", "Show the HP bar of your Quest at the top", null));
        this.addOptionAndPosition(new ChoiceOption("hideLockList", makeOnOffLabels(), [true, false], "Hide Nonlocked", "Hide non locked players", null));
        this.addOptionAndPosition(new ChoiceOption("hidePets2", makePetHiddenLabels(), [0, 1, 2], "Hide Pets", "Make other players or all players pets hidden", null));
        this.addOptionAndPosition(new ChoiceOption("lootPreview", makeOnOffLabels(), [true, false], "Loot Preview", "Shows previews of equipment over bags", null));
        this.addOptionAndPosition(new ChoiceOption("showDamageOnEnemy", makeOnOffLabels(), [true, false], "Show Dealt %", "Shows the % of damage you\'ve done to an enemy, below that enemy (note, only counts projectile damage, it does not include damage from poison, trap, scepter, etc)", null));
        this.addOptionAndPosition(new ChoiceOption("showMobInfo", makeOnOffLabels(), [true, false], "Show Mob Info", "Shows the object itemType above mobs", this.onShowMobInfo));
        this.addOptionAndPosition(new ChoiceOption("liteMonitor", makeOnOffLabels(), [true, false], "Lite Stats Monitor", "Replaces the Net Jitter stats monitor with a \"lite\" one that also measures ping", null));
        this.addOptionAndPosition(new ChoiceOption("showClientStat", makeOnOffLabels(), [true, false], "Show ClientStat", "Output when you get a ClientStat packet, which shows when things like TilesSeen, GodsKilled, DungeonsCompleted, etc changes", null));
        this.addOptionAndPosition(new ChoiceOption("liteParticle", makeOnOffLabels(), [true, false], "Reduced Particles", "Shows only Bombs/Poisons/Traps/Vents", null));
        this.addOptionAndPosition(new ChoiceOption("ignoreStatusText", makeOnOffLabels(), [true, false], "Ignore Status Effect Text", "Don\'t draw Dazed/Status/Cursed/etc Status Text above enemies", null));
        this.addOptionAndPosition(new ChoiceOption("bigLootBags", makeOnOffLabels(), [true, false], "Big Loot Bags", "Makes soulbound loot bags twice as big", null));
        this.addOptionAndPosition(new ChoiceOption("showCHbar", makeOnOffLabels(), [true, false], "Show Client HP Bar", "Displays the extra client HP bar or not", this.toggleBars));
        this.addOptionAndPosition(new ChoiceOption("alphaOnOthers", makeOnOffLabels(), [true, false], "Make Other Players Transparent", "Makes nonlocked players and their pets transparent, toggleable with /ao and transparency level customizable with /alpha 0.2", null));
        this.addOptionAndPosition(new ChoiceOption("showAOGuildies", makeOnOffLabels(), [true, false], "Show Guildmates with Alpha", "Makes guildmates always visible when /ao is enabled", null));
        this.addOptionAndPosition(new ChoiceOption("keyList", makeOnOffLabels(), [true, false], "Show Player Key List", "Shows the list of keyholders in left-side ui panel", null));
        this.addOptionAndPosition(new ChoiceOption("showFameGoldRealms", makeOnOffLabels(), [true, false], "Always Show Fame/Gold", "Makes Fame/Gold always visible when in Realms and Dungeons", null));
        this.addOptionAndPosition(new ChoiceOption("showEnemyCounter", makeOnOffLabels(), [true, false], "Show Remaining Enemy Counter", "Shows the \"Enemies left in dungeon\" in a text area instead of in chat", null));
        this.addOptionAndPosition(new ChoiceOption("showTimers", makeOnOffLabels(), [true, false], "Show Phase Timers", "Shows a countdown for enemy phase and custom set timers", null));
        this.addOptionAndPosition(new ChoiceOption("noRotate", makeOnOffLabels(), [true, false], "Disable Shot Rotation", "Makes Shots not have their rotation effect, which prevents a lot of lag especially in Lost Halls", null));
        this.addOptionAndPosition(new ChoiceOption("showWhiteBagEffect", makeOnOffLabels(), [true, false], "White Bag Effect", "Shows a particle effect and plays a sound when white bags spawn", null));
        this.addOptionAndPosition(new ChoiceOption("showOrangeBagEffect",makeOnOffLabels(),[true,false],"Orange Bag Effect","Shows a particle effect and plays a sound when orange bags spawn",null));
        this.addOptionAndPosition(new ChoiceOption("mouseCameraMultiplier",mouseCameraDistanceValues(),[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5],"Camera Follows Mouse","Makes the camera offset in the direction of the mouse from the player, much like the what Unity client has",null));
        this.addOptionAndPosition(new ChoiceOption("showInventoryTooltip",makeOnOffLabels(),[true,false],"Show Inventory on Player Tooltips","Shows other people\'s inventories when hovering their name in the player grid, note you can only see when items change",null));
        this.addOptionAndPosition(new ChoiceOption("showRange",makeOnOffLabels(),[true,false],"Weapon Range Indicator","Shows a circle indicating the range of your weapon",null));
    }

    private function mouseCameraDistanceValues() : Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"),new StaticStringBuilder("10%"),new StaticStringBuilder("20%"),new StaticStringBuilder("30%"),new StaticStringBuilder("40%"),new StaticStringBuilder("50%"),new StaticStringBuilder("60%"),new StaticStringBuilder("70%"),new StaticStringBuilder("80%"),new StaticStringBuilder("90%"),new StaticStringBuilder("100%"),new StaticStringBuilder("110%"),new StaticStringBuilder("120%"),new StaticStringBuilder("130%"),new StaticStringBuilder("140%"),new StaticStringBuilder("150%")];
    }

    public function toggleSideBarGradient():void {
        this.gs_.hudView.sidebarGradientOverlay_.visible = Parameters.data.showSidebarGradient;
    }

    public function toggleBars():void {
        this.gs_.hudView.statMeters.dispose();
        this.gs_.hudView.statMeters.init();
    }

    public function addFameOptions():void {
        this.addOptionAndPosition(new KeyMapper("famebotToggleHotkey", "Toggle Famebot", "Toggle famebot mode (WARNING: I AM NOT RESPONSIBLE IF YOU GET BANNED USING THIS, IT IS POSSIBLE AND IT HAS HAPPENED)"));
        this.addOptionAndPosition(new KeyMapper("addMoveRecPoint", "Add Move Point", "Adds the current position to the movement record playback list"));
        this.addOptionAndPosition(new ChoiceOption("trainOffset", makeOffsetLabels(), [0, 500, 1000, 25 * 60], "Offset from Center", "Set the distance from the center to walk (Middle = center of pack, Further = slightly ahead of center, Far = near front, Furthest = spearheading)", null));
        this.addOptionAndPosition(new ChoiceOption("densityThreshold", makeDistThreshLabels(), [5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 35, 40], "Distance Threshold", "Sets the threshold for calculating the most dense center point of players (for each player, check all players within this threshold around that player, whoever has the most players within that threshold becomes the center)", null));
        this.addOptionAndPosition(new ChoiceOption("teleDistance", this.BoundingDistValues(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30], "Tele Distance", "The distance away from the center at which you teleport", null));
        this.addOptionAndPosition(new ChoiceOption("famePointOffset", makePointOffsetLabels(), [0.1, 0.2, 0.3, 0.4, 0.5, 0.75, 1, 1.5, 2, 2.5, 3, 3.5], "Fame Point Offset", "How far away the point randomization is offset by, this helps you walk around rocks if you\'re lucky", null));
        this.addOptionAndPosition(new ChoiceOption("famebotContinue", fbContinueValues(), [0, 1, 2], "Rejoin Train Continuously", "If Off, it will stop when nexused; if set to On, when you nexus, it will immediately reconnect back to the realm; if set to On+Walk, when you nexus, you instead walk up to the realms in a legit looking way and not reconnect back in a hacky way", null));
        this.addOptionAndPosition(new ChoiceOption("fameTpCdTime", makeFameTpCdLabels(), [1000, 2000, 50 * 60, 0xfa0, 5000, 100 * 60, 7000, 0x1f40, 150 * 60, 10000], "Teleport Attempt Cooldown", "Change the self imposed cooldown on requesting a teleport", null));
        this.addOptionAndPosition(new ChoiceOption("fameDistDelta", makeFameDeltaLabels(), [0, 0.25, 0.5, 0.75, 1, 1.5, 2], "Move Distance Delta", "The required distance between you and the new cluster center for you to move", null));
        this.addOptionAndPosition(new ChoiceOption("fameCheckMS", makeFameCheckLabels(), [50, 100, 150, 225, 5 * 60, 400, 500], "Fame Check Delay", "The amount of time in milliseconds between distance checks", null));
        this.addOptionAndPosition(new KeyMapper("TogglePlayerFollow", "Toggle Player Follow", "Set with /follow <name>, press this hotkey to toggle on and off"));
        this.addOptionAndPosition(new ChoiceOption("fameOryx", makeOnOffLabels(), [true, false], "Nexus After Oryx", "If On, will nexus instead of going to Oryx\'s Castle, otherwise it will be disabled in Oryx\'s Castle", null));
        this.addOptionAndPosition(new ChoiceOption("fameBlockTP", makeOnOffLabels(), [true, false], "Boots on the Ground", "Block all teleporting", null, 14835456));
        this.addOptionAndPosition(new ChoiceOption("fameBlockAbility", makeOnOffLabels(), [true, false], "Mundane", "Block all ability usage", null, 14835456));
        this.addOptionAndPosition(new ChoiceOption("fameBlockCubes", makeOnOffLabels(), [true, false], "Friend of the Cubes", "Block all cubes from being hit by you", null, 14835456));
        this.addOptionAndPosition(new ChoiceOption("fameBlockGodsOnly", makeOnOffLabels(), [true, false], "Slayer of the Gods", "Have shots only hit Gods", null, 14835456));
        this.addOptionAndPosition(new ChoiceOption("fameBlockThirsty", makeOnOffLabels(), [true, false], "Thirsty", "Block all potions from being drunk, except from bags", null, 14835456));
    }

    public function onShowMobInfo():void {
        if (!Parameters.data.showMobInfo && this.gs_.map.mapOverlay_) {
            this.gs_.map.mapOverlay_.removeChildren(0);
        }
    }

    public function addOtherOptions():void {
        this.addOptionAndPosition(new KeyMapper("Cam45DegInc", "Rotate 45 Degrees", "Rotates your camera angle by 45 degrees"));
        this.addOptionAndPosition(new KeyMapper("Cam45DegDec", "Rotate -45 Degrees", "Rotates your camera angle by -45 degrees"));
        this.addOptionAndPosition(new KeyMapper("aimAtQuest", "Aim at Quest", "Sets your camera angle in the direction of your quest"));
        this.addOptionAndPosition(new KeyMapper("resetClientHP", "Reset Client HP", "Sets your Client HP to your Server HP, if you need to manually sync Health"));
        this.addOptionAndPosition(new ChoiceOption("instaNexus", makeOnOffLabels(), [true, false], "Instant Nexus (Zauto Compatibility)", "Makes the act of Nexusing instantaneous by directly joining Nexus, instead of the normal way of asking the server for Nexus IP, then when it sends you it, join\n\nTurn this OFF for Zautonexus compatibility", null));
        this.addOptionAndPosition(new ChoiceOption("vaultOnly", makeOnOffLabels(), [true, false], "Vault Only Mode", "Prevents you from entering the Nexus to avoid Realmeye and other detection", null));
        this.addOptionAndPosition(new KeyMapper("SelfTPHotkey", "Tele Self", "Teleports you to yourself for a free second of invicibility"));
        this.addOptionAndPosition(new ChoiceOption("TradeDelay", makeOnOffLabels(), [true, false], "No Trade Delay", "Remove the 3 second trade delay", null));
        this.addOptionAndPosition(new ChoiceOption("skipPopups", makeOnOffLabels(), [true, false], "Ignore Startup Popups", "Hides all popups when you first load the client", null));
        this.addOptionAndPosition(new ChoiceOption("extraPlayerMenu", makeOnOffLabels(), [true, false], "Extended Player Menu", "Show extra options on player menus when you click in chat or in the party list", null));
        this.addOptionAndPosition(new ChoiceOption("replaceCon", makeOnOffLabels(), [true, false], "Replace /con with /conn", "So you can itemType /con to the proxy server", null));
        this.addOptionAndPosition(new ChoiceOption("dynamicHPcolor", makeOnOffLabels(), [true, false], "Dynamic Damage Text Color", "Makes the damage text change color based on health", null));
        this.addOptionAndPosition(new ChoiceOption("mobNotifier", makeOnOffLabels(), [true, false], "Treasure Room Notifier", "Plays a sound when a Troom is opened", null));
        this.addOptionAndPosition(new ChoiceOption("rightClickOption", makeRightClickOptions(), ["Off", "Quest", "Ability", "Camera"], "Right Click Option", "Select the functionality you want on right click: none, quest follow (hold down right click to walk towards your quest), spellbomb/ability assist (uses your ability at the enemy closest to your cursor), camera (rotates your camera when holding right click)", null));
        this.addOptionAndPosition(new ChoiceOption("tiltCam", makeOnOffLabels(), [true, false], "Tilt Camera X Axis", "Allows the Right Click Option, when on Camera, to rotate the X Axis of the Camera\'s perspective", null));
        this.addOptionAndPosition(new ChoiceOption("cacheCharList", makeOnOffLabels(), [true, false], "Cache Character List", "Makes the main menu reload when you go back to it, instead of using the cached version which avoids the 10 minute \"Internal Error\" timeout", null));
        this.addOptionAndPosition(new ChoiceOption("chatLength", chatLengthLabels(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20], "Chat Length", "Determines the number of lines chat shows (5 is the standard, previously it was 10)", this.onChatLengthChange));
        this.addOptionAndPosition(new ChoiceOption("fixTabHotkeys", makeOnOffLabels(), [true, false], "Fix Backpack Tab Hotkeys", "Makes the 1-8 htokeys for using inventory items use backpack items when the backpack tab is selected", null));
        this.addOptionAndPosition(new ChoiceOption("followIntoPortals", makeOnOffLabels(), [true, false], "Follow Into Portal", "If the player you\'re /following enters a portal, having this on tries to join them", null));
        this.addOptionAndPosition(new ChoiceOption("FocusFPS", makeOnOffLabels(), [true, false], "Background FPS", "Lower FPS when the client loses focus (alt tabbing, minimizing, etc), set the background values with /bgfps # and foreground with /fgfps #", null));
        this.addOptionAndPosition(new KeyMapper("TombCycleKey", "Tomb Boss Cycle", "Ignores Tomb bosses in the order of Bes Nut Geb, whichever boss name is shown when pressing the key is the boss that is attackable (works with Ice Tomb bosses as well), you will need Damage Ignored Enemies OFF, type /tomb to clear all Tomb bosses from ignore list if you need to attack all of them"));
        this.addOptionAndPosition(new ChoiceOption("rightClickSelectAll", makeOnOffLabels(), [true, false], "Right Click Trade to Select All", "When in a trade, right clicking the trade button will select all items in the trade at once", null));
        this.addOptionAndPosition(new ChoiceOption("reconnectDelay",makeReconDelayLabels(),[0,100,250,500,750,1000,25 * 60,2000],"Connection Delay","Amount of time to wait between switching maps, normal amount is is 2000 milliseconds, 250 ms will usually work fine without any issues - use /recondelay # for a custom delay",null));
        this.addOptionAndPosition(new KeyMapper("noclipKey","No Clip Key","Allows you to no clip while the key is held down"));
    }

    public function isAirApplication():Boolean {
        return Capabilities.playerType == "Desktop";
    }

    public function addOptionsChoiceOption():void {
        var _local1:String = Capabilities.os.split(" ")[0] == "Mac" ? "Command" : "Ctrl";
        var _local2:ChoiceOption = new ChoiceOption("inventorySwap", makeOnOffLabels(), [true, false], "Options.SwitchItemInBackpack", "", null);
        _local2.setTooltipText(new LineBuilder().setParams("Options.SwitchItemInBackpackDesc", {"key": _local1}));
        this.addOptionAndPosition(_local2);
    }

    public function addInventoryOptions():void {
        var _local2:* = null;
        var _local1:int = 1;
        while (_local1 <= 8) {
            _local2 = new KeyMapper("useInvSlot" + _local1, "", "");
            _local2.setDescription(new LineBuilder().setParams("Options.InventorySlotN", {"n": _local1}));
            _local2.setTooltipText(new LineBuilder().setParams("Options.InventorySlotNDesc", {"n": _local1}));
            this.addOptionAndPosition(_local2);
            _local1++;
        }
    }

    private function AutoNexusValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("5%"), new StaticStringBuilder("10%"), new StaticStringBuilder("15%"), new StaticStringBuilder("20%"), new StaticStringBuilder("25%"), new StaticStringBuilder("30%"), new StaticStringBuilder("35%"), new StaticStringBuilder("40%"), new StaticStringBuilder("45%"), new StaticStringBuilder("50%"), new StaticStringBuilder("60%")];
    }

    private function stopWalkValues():Vector.<StringBuilder> {
        return null;
    }

    private function reqHealValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("20%"), new StaticStringBuilder("25%"), new StaticStringBuilder("30%"), new StaticStringBuilder("35%"), new StaticStringBuilder("40%"), new StaticStringBuilder("45%"), new StaticStringBuilder("50%"), new StaticStringBuilder("55%"), new StaticStringBuilder("60%"), new StaticStringBuilder("65%"), new StaticStringBuilder("70%"), new StaticStringBuilder("75%"), new StaticStringBuilder("80%"), new StaticStringBuilder("85%"), new StaticStringBuilder("90%"), new StaticStringBuilder("95%"), new StaticStringBuilder("100%")];
    }

    private function fbContinueValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("Recon"), new StaticStringBuilder("Walk")];
    }

    private function createScrollWindow():void {
        this.scrollContainerBottom = new Shape();
        this.scrollContainerBottom.graphics.beginFill(0xccff00, 0);
        this.scrollContainerBottom.graphics.drawRect(0, 0, 800, 60);
        var _local1:Shape = new Shape();
        _local1.graphics.beginFill(0xccff00, 0.6);
        _local1.graphics.drawRect(0, 102, 800, 7 * 60);
        addChild(_local1);
        this.scrollContainer = new Sprite();
        this.scrollContainer.mask = _local1;
        addChild(this.scrollContainer);
        this.scroll = new UIScrollbar(7 * 60);
        this.scroll.mouseRollSpeedFactor = 1.5;
        this.scroll.content = this.scrollContainer;
        this.scroll.x = 13 * 60;
        this.scroll.y = 102;
        this.scroll.visible = false;
        addChild(this.scroll);
    }

    private function setSelected(_arg_1:OptionsTabTitle):void {
        if (_arg_1 == this.selected_) {
            return;
        }
        if (this.selected_) {
            this.selected_.setSelected(false);
        }
        this.selected_ = _arg_1;
        this.selected_.setSelected(true);
        this.removeOptions();
        this.scrollContainer.y = 0;
        var _local2:* = this.selected_.text_;
        switch (_local2) {
            case "Options.Controls":
                this.addControlsOptions();
                break;
            case "Options.HotKeys":
                this.addHotKeysOptions();
                break;
            case "Options.Chat":
                this.addChatOptions();
                break;
            case "Options.Graphics":
                this.addGraphicsOptions();
                break;
            case "Options.Sound":
                this.addSoundOptions();
                break;
            case "Options.Misc":
                this.addMiscOptions();
                break;
            case "Options.Friend":
                this.addFriendOptions();
                this.addMiscOptions();
                break;
            case "Experimental":
                this.addExperimentalOptions();
                break;
            case "Debuffs":
                this.addDebuffsOptions();
                break;
            case "Auto":
                this.addAutoOptions();
                break;
            case "Loot":
                this.addAutoLootOptions();
                break;
            case "World":
                this.addWorldOptions();
                break;
            case "Recon":
                this.addReconOptions();
                break;
            case "Visual":
                this.addVisualOptions();
                break;
            case "Fame":
                this.addFameOptions();
                break;
            case "Other":
                this.addOtherOptions();
        }
        this.checkForScroll();
    }

    private function checkForScroll():void {
        if (this.scrollContainer.height >= 7 * 60) {
            this.scrollContainerBottom.y = 102 + this.scrollContainer.height;
            this.scrollContainer.addChild(this.scrollContainerBottom);
            this.scroll.visible = true;
        } else {
            this.scroll.visible = false;
        }
    }

    private function addDebuffsOptions():void {
        this.addOptionAndPosition(new ChoiceOption("ignoreQuiet", makeOnOffLabels(), [true, false], "Ignore Quiet", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreWeak", makeOnOffLabels(), [true, false], "Ignore Weak", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreSlowed", makeOnOffLabels(), [true, false], "Ignore Slowed", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreSick", makeOnOffLabels(), [true, false], "Ignore Sick", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreDazed", makeOnOffLabels(), [true, false], "Ignore Dazed", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreStunned", makeOnOffLabels(), [true, false], "Ignore Stunned", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreParalyzed", makeOnOffLabels(), [true, false], "Ignore Paralyzed", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreBleeding", makeOnOffLabels(), [true, false], "Ignore Bleeding", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreArmorBroken", makeOnOffLabels(), [true, false], "Ignore Armor Broken", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignorePetStasis", makeOnOffLabels(), [true, false], "Ignore Pet Stasis", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignorePetrified", makeOnOffLabels(), [true, false], "Ignore Petrified", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreSilenced", makeOnOffLabels(), [true, false], "Ignore Silence", "Server Sided, can DC, On means ignoring shot", calculateIgnoreBitmask, 0xff0000));
        this.addOptionAndPosition(new ChoiceOption("ignoreBlind", makeOnOffLabels(), [true, false], "Ignore Blind", "Client Sided, safe to ignore", calculateIgnoreBitmask));
        this.addOptionAndPosition(new ChoiceOption("ignoreHallucinating", makeOnOffLabels(), [true, false], "Ignore Hallucinating", "Client Sided, safe to ignore", calculateIgnoreBitmask));
        this.addOptionAndPosition(new ChoiceOption("ignoreDrunk", makeOnOffLabels(), [true, false], "Ignore Drunk", "Client Sided, safe to ignore", calculateIgnoreBitmask));
        this.addOptionAndPosition(new ChoiceOption("ignoreConfused", makeOnOffLabels(), [true, false], "Ignore Confused", "Client Sided, safe to ignore", calculateIgnoreBitmask));
        this.addOptionAndPosition(new ChoiceOption("ignoreUnstable", makeOnOffLabels(), [true, false], "Ignore Unstable", "Client Sided, safe to ignore", calculateIgnoreBitmask));
        this.addOptionAndPosition(new ChoiceOption("ignoreDarkness", makeOnOffLabels(), [true, false], "Ignore Darkness", "Client Sided, safe to ignore", calculateIgnoreBitmask));
    }

    private function resetHPVals():void {
        if (this.gs_ && this.gs_.map && this.gs_.map.player_) {
            this.gs_.map.player_.calcHealthPercent();
        }
    }

    private function resetMPVals():void {
        if (this.gs_ && this.gs_.map && this.gs_.map.player_) {
            this.gs_.map.player_.calcManaPercent();
        }
    }

    private function volumeValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("0.1"), new StaticStringBuilder("0.2"), new StaticStringBuilder("0.3"), new StaticStringBuilder("0.4"), new StaticStringBuilder("0.5"), new StaticStringBuilder("0.6"), new StaticStringBuilder("0.7"), new StaticStringBuilder("0.8"), new StaticStringBuilder("0.9"), new StaticStringBuilder("1.0"), new StaticStringBuilder("1.1"), new StaticStringBuilder("1.2"), new StaticStringBuilder("1.3"), new StaticStringBuilder("1.4"), new StaticStringBuilder("1.5"), new StaticStringBuilder("1.6"), new StaticStringBuilder("1.7"), new StaticStringBuilder("1.8"), new StaticStringBuilder("1.9"), new StaticStringBuilder("2.0")];
    }

    private function make1to8labels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("#0"), new StaticStringBuilder("#1"), new StaticStringBuilder("#2"), new StaticStringBuilder("#3"), new StaticStringBuilder("#4"), new StaticStringBuilder("#5"), new StaticStringBuilder("#6"), new StaticStringBuilder("#7"), new StaticStringBuilder("#8")];
    }

    private function makeEggLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("Common"), new StaticStringBuilder("Uncommon"), new StaticStringBuilder("Rare"), new StaticStringBuilder("Legendary")];
    }

    private function alFBValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("1%"), new StaticStringBuilder("2%"), new StaticStringBuilder("3%"), new StaticStringBuilder("4%"), new StaticStringBuilder("5%"), new StaticStringBuilder("6%"), new StaticStringBuilder("7%")];
    }

    private function alFPValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("100 FP"), new StaticStringBuilder("200 FP"), new StaticStringBuilder("300 FP"), new StaticStringBuilder("400 FP"), new StaticStringBuilder("500 FP"), new StaticStringBuilder("600 FP"), new StaticStringBuilder("700 FP"), new StaticStringBuilder("800 FP"), new StaticStringBuilder("900 FP"), new StaticStringBuilder("1000 FP"), new StaticStringBuilder("1200 FP"), new StaticStringBuilder("1400 FP"), new StaticStringBuilder("1600 FP"), new StaticStringBuilder("1800 FP"), new StaticStringBuilder("2000 FP")];
    }

    private function aaDistanceValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("0"), new StaticStringBuilder("0.5"), new StaticStringBuilder("1"), new StaticStringBuilder("1.5"), new StaticStringBuilder("2"), new StaticStringBuilder("2.5"), new StaticStringBuilder("3")];
    }

    private function BoundingDistValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("4"), new StaticStringBuilder("5"), new StaticStringBuilder("6"), new StaticStringBuilder("7"), new StaticStringBuilder("8"), new StaticStringBuilder("9"), new StaticStringBuilder("10"), new StaticStringBuilder("15"), new StaticStringBuilder("20"), new StaticStringBuilder("30"), new StaticStringBuilder("50")];
    }

    private function AutoHealValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("5%"), new StaticStringBuilder("10%"), new StaticStringBuilder("15%"), new StaticStringBuilder("20%"), new StaticStringBuilder("25%"), new StaticStringBuilder("30%"), new StaticStringBuilder("35%"), new StaticStringBuilder("40%"), new StaticStringBuilder("45%"), new StaticStringBuilder("50%"), new StaticStringBuilder("55%"), new StaticStringBuilder("60%"), new StaticStringBuilder("65%"), new StaticStringBuilder("70%"), new StaticStringBuilder("75%"), new StaticStringBuilder("80%"), new StaticStringBuilder("85%"), new StaticStringBuilder("90%"), new StaticStringBuilder("95%"), new StaticStringBuilder("99%"), new StaticStringBuilder("100%")];
    }

    private function AutoManaPercentValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("5%"), new StaticStringBuilder("10%"), new StaticStringBuilder("15%"), new StaticStringBuilder("20%"), new StaticStringBuilder("25%"), new StaticStringBuilder("30%"), new StaticStringBuilder("35%"), new StaticStringBuilder("40%"), new StaticStringBuilder("45%"), new StaticStringBuilder("50%"), new StaticStringBuilder("55%"), new StaticStringBuilder("60%"), new StaticStringBuilder("65%"), new StaticStringBuilder("70%"), new StaticStringBuilder("75%"), new StaticStringBuilder("80%"), new StaticStringBuilder("85%"), new StaticStringBuilder("90%"), new StaticStringBuilder("95%"), new StaticStringBuilder("100%")];
    }

    private function AutoHPPotValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("5%"), new StaticStringBuilder("10%"), new StaticStringBuilder("15%"), new StaticStringBuilder("20%"), new StaticStringBuilder("25%"), new StaticStringBuilder("30%"), new StaticStringBuilder("35%"), new StaticStringBuilder("40%"), new StaticStringBuilder("45%"), new StaticStringBuilder("50%"), new StaticStringBuilder("55%"), new StaticStringBuilder("60%"), new StaticStringBuilder("65%"), new StaticStringBuilder("70%"), new StaticStringBuilder("75%")];
    }

    private function AutoMPPotValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("Abil %"), new StaticStringBuilder("5%"), new StaticStringBuilder("10%"), new StaticStringBuilder("15%"), new StaticStringBuilder("20%"), new StaticStringBuilder("25%"), new StaticStringBuilder("30%"), new StaticStringBuilder("35%"), new StaticStringBuilder("40%"), new StaticStringBuilder("45%"), new StaticStringBuilder("50%"), new StaticStringBuilder("55%"), new StaticStringBuilder("60%"), new StaticStringBuilder("65%"), new StaticStringBuilder("70%"), new StaticStringBuilder("75%")];
    }

    private function AutoHPPotDelayValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("100ms"), new StaticStringBuilder("200ms"), new StaticStringBuilder("300ms"), new StaticStringBuilder("400ms"), new StaticStringBuilder("500ms"), new StaticStringBuilder("600ms"), new StaticStringBuilder("700ms"), new StaticStringBuilder("800ms"), new StaticStringBuilder("900ms"), new StaticStringBuilder("1000ms")];
    }

    private function spellbombThresholdValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("250 HP"), new StaticStringBuilder("500 HP"), new StaticStringBuilder("750 HP"), new StaticStringBuilder("1000 HP"), new StaticStringBuilder("1250 HP"), new StaticStringBuilder("1500 HP"), new StaticStringBuilder("1750 HP"), new StaticStringBuilder("2000 HP"), new StaticStringBuilder("2500 HP"), new StaticStringBuilder("3000 HP"), new StaticStringBuilder("4000 HP"), new StaticStringBuilder("5000 HP"), new StaticStringBuilder("6000 HP"), new StaticStringBuilder("7000 HP"), new StaticStringBuilder("8000 HP"), new StaticStringBuilder("9000 HP"), new StaticStringBuilder("10000 HP"), new StaticStringBuilder("15000 HP"), new StaticStringBuilder("20000 HP")];
    }

    private function skullThresholdValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("100 HP"), new StaticStringBuilder("250 HP"), new StaticStringBuilder("500 HP"), new StaticStringBuilder("800 HP"), new StaticStringBuilder("1000 HP"), new StaticStringBuilder("2000 HP"), new StaticStringBuilder("4000 HP"), new StaticStringBuilder("8000 HP")];
    }

    private function skullTargetsValues():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Off"), new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("3"), new StaticStringBuilder("4"), new StaticStringBuilder("5"), new StaticStringBuilder("6"), new StaticStringBuilder("7"), new StaticStringBuilder("8"), new StaticStringBuilder("9"), new StaticStringBuilder("10")];
    }

    private function makeFameTpCdLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("1000"), new StaticStringBuilder("2000"), new StaticStringBuilder("3000"), new StaticStringBuilder("4000"), new StaticStringBuilder("5000"), new StaticStringBuilder("6000"), new StaticStringBuilder("7000"), new StaticStringBuilder("8000"), new StaticStringBuilder("9000"), new StaticStringBuilder("10000")];
    }

    private function makePointOffsetLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("0.1"), new StaticStringBuilder("0.2"), new StaticStringBuilder("0.3"), new StaticStringBuilder("0.4"), new StaticStringBuilder("0.5"), new StaticStringBuilder("0.75"), new StaticStringBuilder("1.0"), new StaticStringBuilder("1.5"), new StaticStringBuilder("2.0"), new StaticStringBuilder("2.5"), new StaticStringBuilder("3.0"), new StaticStringBuilder("3.5")];
    }

    private function makeTeleDistLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("1"), new StaticStringBuilder("2"), new StaticStringBuilder("4"), new StaticStringBuilder("8"), new StaticStringBuilder("16"), new StaticStringBuilder("32"), new StaticStringBuilder("64")];
    }

    private function makeDistThreshLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("5"), new StaticStringBuilder("6"), new StaticStringBuilder("7"), new StaticStringBuilder("8"), new StaticStringBuilder("9"), new StaticStringBuilder("10"), new StaticStringBuilder("15"), new StaticStringBuilder("20"), new StaticStringBuilder("25"), new StaticStringBuilder("30"), new StaticStringBuilder("35"), new StaticStringBuilder("40")];
    }

    private function makeOffsetLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[new StaticStringBuilder("Middle"), new StaticStringBuilder("Further"), new StaticStringBuilder("Front"), new StaticStringBuilder("Furthest")];
    }

    private function onChatLengthChange():void {
        this.gs_.chatBox_.model.setVisibleItemCount();
    }

    private function close():void {
        stage.focus = null;
        parent.removeChild(this);
        if (Parameters.needToRecalcDesireables) {
            Parameters.setAutolootDesireables();
            Parameters.needToRecalcDesireables = false;
        }
    }

    private function removeOptions():void {
        var _local1:* = null;
        if (this.scrollContainer.contains(this.scrollContainerBottom)) {
            this.scrollContainer.removeChild(this.scrollContainerBottom);
        }
        var _local3:int = 0;
        var _local2:* = this.options_;
        for each(_local1 in this.options_) {
            this.scrollContainer.removeChild(_local1);
        }
        this.options_.length = 0;
    }

    private function addControlsOptions():void {
        this.addOptionAndPosition(new KeyMapper("moveUp", "Options.MoveUp", "Options.MoveUpDesc"));
        this.addOptionAndPosition(new KeyMapper("moveLeft", "Options.MoveLeft", "Options.MoveLeftDesc"));
        this.addOptionAndPosition(new KeyMapper("moveDown", "Options.MoveDown", "Options.MoveDownDesc"));
        this.addOptionAndPosition(new KeyMapper("moveRight", "Options.MoveRight", "Options.MoveRightDesc"));
        this.addOptionAndPosition(this.makeAllowCameraRotation());
        this.addOptionAndPosition(this.makeAllowMiniMapRotation());
        this.addOptionAndPosition(new KeyMapper("rotateLeft", "Options.RotateLeft", "Options.RotateLeftDesc", !Parameters.data.allowRotation));
        this.addOptionAndPosition(new KeyMapper("rotateRight", "Options.RotateRight", "Options.RotateRightDesc", !Parameters.data.allowRotation));
        this.addOptionAndPosition(new KeyMapper("useSpecial", "Options.UseSpecialAbility", "Options.UseSpecialAbilityDesc"));
        this.addOptionAndPosition(new KeyMapper("autofireToggle", "Options.AutofireToggle", "Options.AutofireToggleDesc"));
        this.addOptionAndPosition(new KeyMapper("toggleHPBar", "Options.ToggleHPBar", "Options.ToggleHPBarDesc"));
        this.addOptionAndPosition(new KeyMapper("resetToDefaultCameraAngle", "Options.ResetCamera", "Options.ResetCameraDesc"));
        this.addOptionAndPosition(new KeyMapper("togglePerformanceStats", "Options.TogglePerformanceStats", "Options.TogglePerformanceStatsDesc"));
        this.addOptionAndPosition(new KeyMapper("toggleCentering", "Options.ToggleCentering", "Options.ToggleCenteringDesc"));
        this.addOptionAndPosition(new KeyMapper("interact", "Options.InteractOrBuy", "Options.InteractOrBuyDesc"));
    }

    private function makeAllowCameraRotation():ChoiceOption {
        return new ChoiceOption("allowRotation", makeOnOffLabels(), [true, false], "Options.AllowRotation", "Options.AllowRotationDesc", this.onAllowRotationChange);
    }

    private function makeAllowMiniMapRotation():ChoiceOption {
        return new ChoiceOption("allowMiniMapRotation", makeOnOffLabels(), [true, false], "Options.AllowMiniMapRotation", "Options.AllowMiniMapRotationDesc", null);
    }

    private function onAllowRotationChange():void {
        var _local2:* = null;
        var _local1:int = 0;
        while (_local1 < this.options_.length) {
            _local2 = this.options_[_local1] as KeyMapper;
            if (_local2 != null) {
                if (_local2.paramName_ == "rotateLeft" || _local2.paramName_ == "rotateRight") {
                    _local2.setDisabled(!Parameters.data.allowRotation);
                }
            }
            _local1++;
        }
    }

    private function addHotKeysOptions():void {
        this.addOptionAndPosition(new KeyMapper("useHealthPotion", "Options.UseBuyHealth", "Options.UseBuyHealthDesc"));
        this.addOptionAndPosition(new KeyMapper("useMagicPotion", "Options.UseBuyMagic", "Options.UseBuyMagicDesc"));
        this.addInventoryOptions();
        this.addOptionAndPosition(new KeyMapper("miniMapZoomIn", "Options.MiniMapZoomIn", "Options.MiniMapZoomInDesc"));
        this.addOptionAndPosition(new KeyMapper("miniMapZoomOut", "Options.MiniMapZoomOut", "Options.MiniMapZoomOutDesc"));
        this.addOptionAndPosition(new KeyMapper("escapeToNexus", "Options.EscapeToNexus", "Options.EscapeToNexusDesc"));
        this.addOptionAndPosition(new KeyMapper("options", "Options.ShowOptions", "Options.ShowOptionsDesc"));
        this.addOptionAndPosition(new KeyMapper("switchTabs", "Options.SwitchTabs", "Options.SwitchTabsDesc"));
        this.addOptionAndPosition(new KeyMapper("GPURenderToggle", "Options.HardwareAccHotkey", "Options.HardwareAccHotkeyDesc"));
        this.addOptionAndPosition(new KeyMapper("toggleRealmQuestDisplay", "Toggle Realm Quests Display", "Toggle Expand/Collapse of the Realm Quests Display"));
        this.addOptionAndPosition(new KeyMapper("walkKey","Walk Key","Allows you to walk (move slowly) while the key is held down"));
        this.addOptionsChoiceOption();
    }

    private function addChatOptions():void {
        this.addOptionAndPosition(new KeyMapper("chat", "Options.ActivateChat", "Options.ActivateChatDesc"));
        this.addOptionAndPosition(new KeyMapper("chatCommand", "Options.StartCommand", "Options.StartCommandDesc"));
        this.addOptionAndPosition(new KeyMapper("tell", "Options.BeginTell", "Options.BeginTellDesc"));
        this.addOptionAndPosition(new KeyMapper("guildChat", "Options.BeginGuildChat", "Options.BeginGuildChatDesc"));
        this.addOptionAndPosition(new ChoiceOption("filterLanguage", makeOnOffLabels(), [true, false], "Options.FilterOffensiveLanguage", "Options.FilterOffensiveLanguageDesc", null));
        this.addOptionAndPosition(new KeyMapper("scrollChatUp", "Options.ScrollChatUp", "Options.ScrollChatUpDesc"));
        this.addOptionAndPosition(new KeyMapper("scrollChatDown", "Options.ScrollChatDown", "Options.ScrollChatDownDesc"));
        this.addOptionAndPosition(new ChoiceOption("forceChatQuality", makeOnOffLabels(), [true, false], "Options.forceChatQuality", "Options.forceChatQualityDesc", null));
        this.addOptionAndPosition(new ChoiceOption("hidePlayerChat", makeOnOffLabels(), [true, false], "Options.hidePlayerChat", "Options.hidePlayerChatDesc", null));
        this.addOptionAndPosition(new ChoiceOption("chatStarRequirement", makeStarSelectLabels(), [0, 1, 2, 3, 5, 10], "Options.starReq", "Options.chatStarReqDesc", null));
        this.addOptionAndPosition(new ChoiceOption("chatAll", makeOnOffLabels(), [true, false], "Options.chatAll", "Options.chatAllDesc", this.onAllChatEnabled));
        this.addOptionAndPosition(new ChoiceOption("chatWhisper", makeOnOffLabels(), [true, false], "Options.chatWhisper", "Options.chatWhisperDesc", this.onAllChatDisabled));
        this.addOptionAndPosition(new ChoiceOption("chatGuild", makeOnOffLabels(), [true, false], "Options.chatGuild", "Options.chatGuildDesc", this.onAllChatDisabled));
        this.addOptionAndPosition(new ChoiceOption("chatTrade", makeOnOffLabels(), [true, false], "Options.chatTrade", "Options.chatTradeDesc", null));
    }

    private function onAllChatDisabled():void {
        var _local2:* = null;
        var _local1:int = 0;
        Parameters.data.chatAll = false;
        while (_local1 < this.options_.length) {
            _local2 = this.options_[_local1] as ChoiceOption;
            if (_local2 != null) {
                var _local3:* = _local2.paramName_;
                if ("chatAll" === _local3) {
                    _local2.refreshNoCallback();
                }
            }
            _local1++;
        }
    }

    private function onAllChatEnabled():void {
        var _local2:* = null;
        var _local1:int = 0;
        Parameters.data.hidePlayerChat = false;
        Parameters.data.chatWhisper = true;
        Parameters.data.chatGuild = true;
        Parameters.data.chatFriend = false;
        for (; _local1 < this.options_.length; _local1++) {
            _local2 = this.options_[_local1] as ChoiceOption;
            if (_local2 != null) {
                var _local3:* = _local2.paramName_;
                switch (_local3) {
                    case "hidePlayerChat":
                    case "chatWhisper":
                    case "chatGuild":
                    case "chatFriend":
                        _local2.refreshNoCallback();
                        continue;
                    default:

                }
            }
        }
    }

    private function addExperimentalOptions():void {
        this.addOptionAndPosition(new ChoiceOption("disableEnemyParticles", makeOnOffLabels(), [true, false], "Disable Enemy Particles", "Disable enemy hit and death particles.", null));
        this.addOptionAndPosition(new ChoiceOption("disableAllyShoot", makeAllyShootLabels(), [0, 1, 2], "Disable Ally Shoot", "Disable showing shooting animations and projectiles shot by allies or only projectiles.", null));
        this.addOptionAndPosition(new ChoiceOption("disablePlayersHitParticles", makeOnOffLabels(), [true, false], "Disable Players Hit Particles", "Disable player and ally hit particles.", null));
        this.addOptionAndPosition(new ChoiceOption("toggleToMaxText", makeOnOffLabels(), [true, false], "Options.ToggleToMaxText", "Options.ToggleToMaxTextDesc", onToMaxTextToggle));
        this.addOptionAndPosition(new ChoiceOption("newMiniMapColors", makeOnOffLabels(), [true, false], "Options.ToggleNewMiniMapColorsText", "Options.ToggleNewMiniMapColorsTextDesc", null));
        this.addOptionAndPosition(new ChoiceOption("noParticlesMaster", makeOnOffLabels(), [true, false], "Disable Particles Master", "Disable all nonessential particles besides enemy and ally hits. Throw, Area and certain other effects will remain.", null));
        this.addOptionAndPosition(new ChoiceOption("noAllyNotifications", makeOnOffLabels(), [true, false], "Disable Ally Notifications", "Disable text notifications above allies.", null));
        this.addOptionAndPosition(new ChoiceOption("noEnemyDamage", makeOnOffLabels(), [true, false], "Disable Enemy Damage Text", "Disable damage from other players above enemies.", null));
        this.addOptionAndPosition(new ChoiceOption("noAllyDamage", makeOnOffLabels(), [true, false], "Disable Ally Damage Text", "Disable damage above allies.", null));
        this.addOptionAndPosition(new ChoiceOption("forceEXP", makeForceExpLabels(), [0, 1, 2], "Always Show EXP", "Show EXP notifications even when level 20.", null));
        this.addOptionAndPosition(new ChoiceOption("showFameGain", makeOnOffLabels(), [true, false], "Show Fame Gain", "Shows notifications for each fame gained.", null));
        this.addOptionAndPosition(new ChoiceOption("curseIndication", makeOnOffLabels(), [true, false], "Curse Indication", "Makes enemies inflicted by Curse glow red.", null));
    }

    private function addGraphicsOptions():void {
        var _local1:* = null;
        var _local2:* = NaN;
        this.addOptionAndPosition(new ChoiceOption("defaultCameraAngle", makeDegreeOptions(), [5.49778714378214, 0], "Options.DefaultCameraAngle", "Options.DefaultCameraAngleDesc", onDefaultCameraAngleChange));
        this.addOptionAndPosition(new ChoiceOption("centerOnPlayer", makeOnOffLabels(), [true, false], "Options.CenterOnPlayer", "Options.CenterOnPlayerDesc", null));
        this.addOptionAndPosition(new ChoiceOption("showQuestPortraits", makeOnOffLabels(), [true, false], "Options.ShowQuestPortraits", "Options.ShowQuestPortraitsDesc", this.onShowQuestPortraitsChange));
        this.addOptionAndPosition(new ChoiceOption("showProtips", makeOnOffLabels(), [true, false], "Options.ShowTips", "Options.ShowTipsDesc", null));
        this.addOptionAndPosition(new ChoiceOption("textBubbles", makeOnOffLabels(), [true, false], "Options.DrawTextBubbles", "Options.DrawTextBubblesDesc", null));
        this.addOptionAndPosition(new ChoiceOption("showTradePopup", makeOnOffLabels(), [true, false], "Options.ShowTradeRequestPanel", "Options.ShowTradeRequestPanelDesc", null));
        this.addOptionAndPosition(new ChoiceOption("showGuildInvitePopup", makeOnOffLabels(), [true, false], "Options.ShowGuildInvitePanel", "Options.ShowGuildInvitePanelDesc", null));
        this.addOptionAndPosition(new ChoiceOption("cursorSelect", makeCursorSelectLabels(), ["auto", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"], "Custom Cursor", "Click here to change the mouse cursor. May help with aiming.", refreshCursor));
        _local1 = "Options.HardwareAccDesc";
        _local2 = 16777215;
        this.addOptionAndPosition(new ChoiceOption("GPURender", makeOnOffLabels(), [true, false], "Options.HardwareAcc", _local1, null, _local2));
        this.addOptionAndPosition(new ChoiceOption("toggleBarText", makeBarTextLabels(), [0, 1, 2, 3], "Toggle Fame and HP/MP Text", "Always show text value for Fame, remaining HP/MP, or both", onBarTextToggle));
        this.addOptionAndPosition(new ChoiceOption("particleEffect", makeHighLowLabels(), [true, false], "Options.ToggleParticleEffect", "Options.ToggleParticleEffectDesc", null));
        this.addOptionAndPosition(new ChoiceOption("uiQuality", makeHighLowLabels(), [true, false], "Options.ToggleUIQuality", "Options.ToggleUIQualityDesc", onUIQualityToggle));
        this.addOptionAndPosition(new ChoiceOption("HPBar", makeHpBarLabels(), [0, 1, 2, 3, 4, 5], "Options.HPBar", "Options.HPBarDesc", null));
        this.addOptionAndPosition(new ChoiceOption("showTierTag", makeOnOffLabels(), [true, false], "Show Tier level", "Show Tier level on gear", this.onToggleTierTag));
        this.addOptionAndPosition(new KeyMapper("toggleProjectiles", "Toggle Ally Projectiles", "This key will toggle rendering of friendly projectiles"));
        this.addOptionAndPosition(new KeyMapper("toggleMasterParticles", "Toggle Particles", "This key will toggle rendering of nonessential particles (Particles Master option)"));
        this.addOptionAndPosition(new ChoiceOption("expandRealmQuestsDisplay", makeOnOffLabels(), [true, false], "Expand Realm Quests", "Expand the Realm Quests Display when entering the realm", null));
        this.addOptionAndPosition(new ChoiceOption("projFace", makeOnOffLabels(), [true, false], "Projectile Rotation", "This toggles whether to force projectiles to face the direction they're heading to", null));
        this.addOptionAndPosition(new ChoiceOption("disableSorting", makeOnOffLabels(), [false, true], "Object Sorting", "This toggles whether to disable object sorting, increasing performance in the process", null));
    }

    private function onToggleTierTag():void {
        StaticInjectorContext.getInjector().getInstance(ToggleShowTierTagSignal).dispatch(Parameters.data.showTierTag);
    }

    private function onCharacterGlow():void {
        var _local1:Player = this.gs_.map.player_;
        if (_local1.hasSupporterFeature(1)) {
            _local1.clearTextureCache();
        }
    }

    private function onShowQuestPortraitsChange():void {
        if (this.gs_ != null && this.gs_.map != null && this.gs_.map.partyOverlay_ != null && this.gs_.map.partyOverlay_.questArrow_ != null) {
            this.gs_.map.partyOverlay_.questArrow_.refreshToolTip();
        }
    }

    private function onFullscreenChange():void {
        stage.displayState = !!Parameters.data.fullscreenMode ? "fullScreenInteractive" : "normal";
    }

    private function addSoundOptions():void {
        this.addOptionAndPosition(new ChoiceOption("playMusic", makeOnOffLabels(), [true, false], "Options.PlayMusic", "Options.PlayMusicDesc", this.onPlayMusicChange));
        this.addOptionAndPosition(new SliderOption("musicVolume", this.onMusicVolumeChange), -120, 15);
        this.addOptionAndPosition(new ChoiceOption("playSFX", makeOnOffLabels(), [true, false], "Options.PlaySoundEffects", "Options.PlaySoundEffectsDesc", this.onPlaySoundEffectsChange));
        this.addOptionAndPosition(new SliderOption("SFXVolume", this.onSoundEffectsVolumeChange), -120, 34);
        this.addOptionAndPosition(new ChoiceOption("playPewPew", makeOnOffLabels(), [true, false], "Options.PlayWeaponSounds", "Options.PlayWeaponSoundsDesc", null));
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new ChoiceOption("customSounds", makeOnOffLabels(), [true, false], "Custom Sounds", "Play sound effects when you receive private messages or drop white bags", this.onCustomSFXVolumeChange));
        this.addOptionAndPosition(new SliderOption("customVolume", this.onCustomSFXVolumeChange),-120,15);
    }

    private function addMiscOptions():void {
        this.addOptionAndPosition(new ChoiceOption("showProtips", new <StringBuilder>[makeLineBuilder("Options.legalView"), makeLineBuilder("Options.legalView")], [Parameters.data.showProtips, Parameters.data.showProtips], "Options.legal1", "Options.legal1Desc", this.onLegalPrivacyClick));
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new ChoiceOption("showProtips", new <StringBuilder>[makeLineBuilder("Options.legalView"), makeLineBuilder("Options.legalView")], [Parameters.data.showProtips, Parameters.data.showProtips], "Options.legal2", "Options.legal2Desc", this.onLegalTOSClick));
    }

    private function addFriendOptions():void {
        this.addOptionAndPosition(new ChoiceOption("tradeWithFriends", makeOnOffLabels(), [true, false], "Options.TradeWithFriends", "Options.TradeWithFriendsDesc", this.onPlaySoundEffectsChange));
        this.addOptionAndPosition(new KeyMapper("friendList", "Options.FriendList", "Options.FriendListDesc"));
        this.addOptionAndPosition(new ChoiceOption("chatFriend", makeOnOffLabels(), [true, false], "Options.ChatFriend", "Options.ChatFriendDesc", null));
        this.addOptionAndPosition(new ChoiceOption("friendStarRequirement", makeStarSelectLabels(), [0, 1, 2, 3, 5, 10], "Options.starReq", "Options.FriendsStarReqDesc", null));
        this.addOptionAndPosition(new NullOption());
        this.addOptionAndPosition(new NullOption());
    }

    private function onPlayMusicChange():void {
        Music.setPlayMusic(Parameters.data.playMusic);
        if (Parameters.data.playMusic) {
            Music.setMusicVolume(1);
        } else {
            Music.setMusicVolume(0);
        }
        this.refresh();
    }

    private function onPlaySoundEffectsChange():void {
        SFX.setPlaySFX(Parameters.data.playSFX);
        if (Parameters.data.playSFX || Parameters.data.playPewPew) {
            SFX.setSFXVolume(1);
        } else {
            SFX.setSFXVolume(0);
        }
        this.refresh();
    }

    private function onMusicVolumeChange(_arg_1:Number):void {
        Music.setMusicVolume(_arg_1);
    }

    private function onSoundEffectsVolumeChange(volume: Number): void {
        SFX.setSFXVolume(volume);
    }

    private function onCustomSFXVolumeChange(volume: Number) : void {
        SFX.setCustomSFXVolume(volume);
    }

    private function onLegalPrivacyClick():void {
        var _local1:URLRequest = new URLRequest();
        _local1.url = "http://legal.decagames.com/privacy/";
        _local1.method = "GET";
    }

    private function onLegalTOSClick():void {
        var _local1:URLRequest = new URLRequest();
        _local1.url = "http://legal.decagames.com/tos/";
        _local1.method = "GET";
    }

    private function addOptionAndPosition(_arg_1:Option, _arg_2:Number = 0, _arg_3:Number = 0, _arg_4:Boolean = false):void {
        _arg_1 = _arg_1;
        _arg_2 = _arg_2;
        _arg_3 = _arg_3;
        _arg_4 = _arg_4;
        var param1:Option = _arg_1;
        var param2:Number = _arg_2;
        var param3:Number = _arg_3;
        var smaller:Boolean = _arg_4;
        var option:Option = param1;
        var offsetX:Number = param2;
        var offsetY:Number = param3;
        var positionOption:Function = function ():void {
            option.x = (options_.length % 2 == 0 ? 20 : Number(415)) + offsetX;
            option.y = int(options_.length / 2) * (!!smaller ? 34 : 44) + (!!smaller ? 109 : 122) + offsetY;
        };
        option.textChanged.addOnce(positionOption);
        this.addOption(option);
    }

    private function addOption(_arg_1:Option):void {
        this.scrollContainer.addChild(_arg_1);
        _arg_1.addEventListener("change", this.onChange);
        this.options_.push(_arg_1);
    }

    private function refresh():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:uint = this.options_.length;
        while (_local3 < _local2) {
            _local1 = this.options_[_local3] as BaseOption;
            if (_local1) {
                _local1.refresh();
            }
            _local3++;
        }
    }

    private function onContinueClick(_arg_1:MouseEvent):void {
        this.close();
    }

    private function onResetToDefaultsClick(_arg_1:MouseEvent):void {
        var _local3:* = null;
        var _local2:int = 0;
        while (_local2 < this.options_.length) {
            _local3 = this.options_[_local2] as BaseOption;
            if (_local3 != null) {
                delete Parameters.data[_local3.paramName_];
            }
            _local2++;
        }
        Parameters.setDefaults();
        Parameters.save();
        this.refresh();
    }

    private function onHomeClick(_arg_1:MouseEvent):void {
        var _local2:PlayerModel = StaticInjectorContext.getInjector().getInstance(PlayerModel);
        _local2.isLogOutLogIn = true;
        this.close();
        Parameters.fameBot = false;
        this.gs_.closed.dispatch();
    }

    private function onTabClick(_arg_1:MouseEvent):void {
        var _local2:OptionsTabTitle = _arg_1.currentTarget as OptionsTabTitle;
        Parameters.data.lastTab = _local2.text_;
        this.setSelected(_local2);
    }

    private function onAddedToStage(_arg_1:Event):void {
        this.continueButton_.x = 400;
        this.continueButton_.y = 550;
        this.resetToDefaultsButton_.x = 20;
        this.resetToDefaultsButton_.y = 550;
        this.homeButton_.x = 13 * 60;
        this.homeButton_.y = 550;
        if (Capabilities.playerType == "Desktop") {
            Parameters.data.fullscreenMode = stage.displayState == "fullScreenInteractive";
            Parameters.save();
        }
        this.setSelected(this.defaultTab_);
        stage.addEventListener("keyDown", this.onKeyDown, false, 1);
        stage.addEventListener("keyUp", this.onKeyUp, false, 1);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        stage.removeEventListener("keyDown", this.onKeyDown, false);
        stage.removeEventListener("keyUp", this.onKeyUp, false);
    }

    private function onKeyDown(_arg_1:KeyboardEvent):void {
        if (Capabilities.playerType == "Desktop" && _arg_1.keyCode == 27) {
            Parameters.data.fullscreenMode = false;
            Parameters.save();
            this.refresh();
        }
        if (_arg_1.keyCode == Parameters.data.options) {
            this.close();
        }
        _arg_1.stopImmediatePropagation();
    }

    private function onKeyUp(_arg_1:KeyboardEvent):void {
        _arg_1.stopImmediatePropagation();
    }

    private function onChange(_arg_1:Event):void {
        this.refresh();
    }
}
}
