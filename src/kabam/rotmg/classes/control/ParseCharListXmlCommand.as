package kabam.rotmg.classes.control {
import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;

import kabam.rotmg.classes.model.CharacterSkinState;
import kabam.rotmg.classes.model.ClassesModel;

import robotlegs.bender.framework.api.ILogger;

public class ParseCharListXmlCommand {


    public function ParseCharListXmlCommand() {
        super();
    }
    [Inject]
    public var data:XML;
    [Inject]
    public var model:ClassesModel;
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var statsTracker:CharactersMetricsTracker;

    public function execute():void {
        this.parseChallengers();
        this.parseMaxLevelsAchieved();
        this.parseItemCosts();
        this.parseOwnership();
        this.statsTracker.parseCharListData(this.data);
    }

    private function parseChallengers():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:XMLList = this.data.Char;
        var _local5:int = 0;
        var _local4:* = _local3;
        for each(_local2 in _local3) {
            _local1 = this.model.getCharacterClass(_local2.ObjectType);
            _local1.isChallenger = _local2.IsChanllenger == 1;
        }
    }

    private function parseMaxLevelsAchieved():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:XMLList = this.data.MaxClassLevelList.MaxClassLevel;
        var _local5:int = 0;
        var _local4:* = _local3;
        for each(_local2 in _local3) {
            _local1 = this.model.getCharacterClass(_local2.@classType);
            _local1.setMaxLevelAchieved(_local2.@maxLevel);
        }
    }

    private function parseItemCosts():void {
        var _local2:* = null;
        var _local1:* = null;
        var _local3:XMLList = this.data.ItemCosts.ItemCost;
        var _local5:int = 0;
        var _local4:* = _local3;
        for each(_local2 in _local3) {
            _local1 = this.model.getCharacterSkin(_local2.@type);
            if (_local1) {
                _local1.cost = _local2;
                _local1.limited = Boolean(_local2.@expires);
                if (!_local2.@purchasable && _local1.id != 0) {
                    _local1.setState(CharacterSkinState.UNLISTED);
                }
            } else {
                this.logger.warn("Cannot set Character Skin cost: type {0} not found", [_local2.@type]);
            }
        }
    }

    private function parseOwnership():void {
        var _local2:int = 0;
        var _local1:* = null;
        var _local3:Array = !!this.data.OwnedSkins.length() ? this.data.OwnedSkins.split(",") : [];
        var _local5:int = 0;
        var _local4:* = _local3;
        for each(_local2 in _local3) {
            _local1 = this.model.getCharacterSkin(_local2);
            if (_local1) {
                _local1.setState(CharacterSkinState.OWNED);
            } else {
                this.logger.warn("Cannot set Character Skin ownership: itemType {0} not found", [_local2]);
            }
        }
    }
}
}
