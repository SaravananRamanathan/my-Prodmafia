package kabam.rotmg.arena.view {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
import io.decagames.rotmg.pets.components.tooltip.PetTooltip;
import io.decagames.rotmg.pets.data.vo.PetVO;

import kabam.rotmg.arena.component.AbridgedPlayerTooltip;
import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;

public class ArenaLeaderboardListItem extends Sprite {

    private static const HEIGHT:int = 60;


    public const showTooltip:Signal = new Signal(Sprite);

    public const hideTooltip:Signal = new Signal();

    public function ArenaLeaderboardListItem() {
        playerIconContainer = new Sprite();
        petIconContainer = new Sprite();
        playerIcon = new Bitmap();
        this.petIconBackground = this.makePetIconBackground();
        this.rankNumber = this.makeTextDisplay();
        this.playerName = this.makeTextDisplay();
        this.waveNumber = this.makeTextDisplay();
        this.runTime = this.makeTextDisplay();
        this.background = this.makeBackground();
        this.rankNumberStringBuilder = new StaticStringBuilder();
        this.playerNameStringBuilder = new StaticStringBuilder();
        this.waveNumberStringBuilder = new LineBuilder();
        this.runTimeStringBuilder = new StaticStringBuilder();
        super();
        this.petIconFactory = StaticInjectorContext.getInjector().getInstance(PetIconFactory);
        this.rankNumber.setAutoSize("right");
        this.addChildren();
        this.addEventListeners();
    }
    private var playerIconContainer:Sprite;
    private var petIconContainer:Sprite;
    private var playerIcon:Bitmap;
    private var playerTooltip:AbridgedPlayerTooltip;
    private var petTooltip:PetTooltip;
    private var rank:int = 0;
    private var petBitmap:Bitmap;
    private var petIconBackground:Sprite;
    private var petIconFactory:PetIconFactory;
    private var rankNumber:StaticTextDisplay;
    private var playerName:StaticTextDisplay;
    private var waveNumber:StaticTextDisplay;
    private var runTime:StaticTextDisplay;
    private var background:Sprite;
    private var isActive:Boolean = false;
    private var isPersonalRecord:Boolean = false;
    private var rankNumberStringBuilder:StaticStringBuilder;
    private var playerNameStringBuilder:StaticStringBuilder;
    private var waveNumberStringBuilder:LineBuilder;
    private var runTimeStringBuilder:StaticStringBuilder;

    public function apply(_arg_1:ArenaLeaderboardEntry, _arg_2:Boolean):void {
        this.isActive = _arg_1 != null;
        if (_arg_1) {
            this.initPlayerData(_arg_1);
            this.initArenaData(_arg_1);
            if (_arg_1.rank && _arg_2) {
                this.rankNumber.visible = true;
                this.rankNumber.setStringBuilder(this.rankNumberStringBuilder.setString(_arg_1.rank + "."));
            } else {
                this.rankNumber.visible = false;
            }
            if (this.petBitmap) {
                this.destroyPetIcon();
            }
            if (_arg_1.pet) {
                this.initPetIcon(_arg_1);
            }
            this.rank = _arg_1.rank;
            this.isPersonalRecord = _arg_1.isPersonalRecord;
            this.setColor();
        } else {
            this.clear();
        }
        this.align();
    }

    public function setColor():void {
        var _local1:int = 0xffffff;
        if (this.isPersonalRecord) {
            _local1 = 16567065;
        } else if (this.rank == 1) {
            _local1 = 0xffff8f;
        }
        this.playerName.setColor(_local1);
        this.waveNumber.setColor(_local1);
        this.runTime.setColor(_local1);
        this.rankNumber.setColor(_local1);
    }

    public function clear():void {
        this.playerIcon.bitmapData = null;
        this.playerName.setStringBuilder(this.playerNameStringBuilder.setString(""));
        this.waveNumber.setStringBuilder(this.waveNumberStringBuilder.setParams(""));
        this.runTime.setStringBuilder(this.runTimeStringBuilder.setString(""));
        this.rankNumber.setStringBuilder(this.rankNumberStringBuilder.setString(""));
        if (this.petBitmap) {
            this.destroyPetIcon();
        }
        this.petBitmap = null;
        this.petIconBackground.visible = false;
        this.rank = 0;
    }

    private function addEventListeners():void {
        addEventListener("mouseOver", this.onMouseOver);
        addEventListener("mouseOut", this.onMouseOut);
        this.playerIconContainer.addEventListener("mouseOver", this.onPlayerIconOver);
        this.playerIconContainer.addEventListener("mouseOut", this.onPlayerIconOut);
        this.petIconContainer.addEventListener("mouseOver", this.onPetIconOver);
        this.petIconContainer.addEventListener("mouseOut", this.onPetIconOut);
    }

    private function addChildren():void {
        addChild(this.background);
        addChild(this.playerIconContainer);
        addChild(this.petIconBackground);
        addChild(this.petIconContainer);
        addChild(this.rankNumber);
        addChild(this.playerName);
        addChild(this.waveNumber);
        addChild(this.runTime);
        this.playerIconContainer.addChild(this.playerIcon);
    }

    private function initArenaData(_arg_1:ArenaLeaderboardEntry):void {
        this.waveNumber.setStringBuilder(this.waveNumberStringBuilder.setParams("ArenaLeaderboardListItem.waveNumber", {"waveNumber": (_arg_1.currentWave - 1).toString()}));
        this.runTime.setStringBuilder(this.runTimeStringBuilder.setString(this.formatTime(Math.floor(_arg_1.runtime))));
    }

    private function initPlayerData(_arg_1:ArenaLeaderboardEntry):void {
        this.playerIcon.bitmapData = _arg_1.playerBitmap;
        this.playerTooltip = new AbridgedPlayerTooltip(_arg_1);
        this.playerName.setStringBuilder(this.playerNameStringBuilder.setString(_arg_1.name));
    }

    private function initPetIcon(_arg_1:ArenaLeaderboardEntry):void {
        this.petTooltip = new PetTooltip(_arg_1.pet);
        this.petBitmap = this.getPetBitmap(_arg_1.pet, 48);
        this.petIconContainer.addChild(this.petBitmap);
        this.petIconBackground.visible = true;
    }

    private function destroyPetIcon():void {
        this.petIconContainer.removeChild(this.petBitmap);
        this.petTooltip = null;
        this.petBitmap = null;
        this.petIconBackground.visible = false;
    }

    private function getPetBitmap(_arg_1:PetVO, _arg_2:int):Bitmap {
        return new Bitmap(this.petIconFactory.getPetSkinTexture(_arg_1, _arg_2));
    }

    private function makeTextDisplay():StaticTextDisplay {
        var _local1:* = null;
        _local1 = new StaticTextDisplay();
        _local1.setBold(true).setSize(24);
        _local1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        return _local1;
    }

    private function makeBackground():Sprite {
        var _local1:Sprite = new Sprite();
        _local1.graphics.beginFill(0, 0.5);
        _local1.graphics.drawRect(0, 0, 750, 60);
        _local1.graphics.endFill();
        _local1.alpha = 0;
        return _local1;
    }

    private function makePetIconBackground():Sprite {
        var _local1:Sprite = new Sprite();
        _local1.graphics.beginFill(0x545454);
        _local1.graphics.drawRoundRect(0, 0, 40, 40, 10, 10);
        _local1.graphics.endFill();
        _local1.visible = false;
        return _local1;
    }

    private function formatTime(_arg_1:int):String {
        var _local2:int = Math.floor(_arg_1 / 60);
        var _local5:String = (_local2 < 10 ? "0" : "") + _local2.toString();
        var _local4:int = _arg_1 % 60;
        var _local3:String = (_local4 < 10 ? "0" : "") + _local4.toString();
        return _local5 + ":" + _local3;
    }

    private function align():void {
        this.rankNumber.x = 75;
        this.rankNumber.y = 30 - this.rankNumber.height / 2;
        this.playerIcon.x = 110;
        this.playerIcon.y = 30 - this.playerIcon.height / 2 - 3;
        if (this.petBitmap) {
            this.petBitmap.x = 170;
            this.petBitmap.y = 30 - this.petBitmap.height / 2;
            this.petIconBackground.x = 175;
            this.petIconBackground.y = 30 - this.petIconBackground.height / 2;
        }
        this.playerName.x = 230;
        this.playerName.y = 30 - this.playerName.height / 2;
        this.waveNumber.x = 485;
        this.waveNumber.y = 30 - this.waveNumber.height / 2;
        this.runTime.x = 635;
        this.runTime.y = 30 - this.runTime.height / 2;
    }

    private function onPlayerIconOut(_arg_1:MouseEvent):void {
        this.hideTooltip.dispatch();
    }

    private function onPlayerIconOver(_arg_1:MouseEvent):void {
        if (this.playerTooltip) {
            this.showTooltip.dispatch(this.playerTooltip);
        }
    }

    private function onPetIconOut(_arg_1:MouseEvent):void {
        this.hideTooltip.dispatch();
    }

    private function onPetIconOver(_arg_1:MouseEvent):void {
        if (this.playerTooltip) {
            this.showTooltip.dispatch(this.petTooltip);
        }
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        if (this.isActive) {
            this.background.alpha = 0;
        }
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        if (this.isActive) {
            this.background.alpha = 1;
        }
    }
}
}
