package kabam.rotmg.characters.reskin.control {
import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.messaging.impl.outgoing.Reskin;

public class ReskinHandler {


    public function ReskinHandler() {
        super();
    }
    [Inject]
    public var model:GameModel;
    [Inject]
    public var classes:ClassesModel;
    [Inject]
    public var factory:CharacterFactory;

    public function execute(_arg_1:Reskin):void {
        var _local2:* = null;
        var _local6:int = 0;
        var _local4:* = null;
        var _local3:* = null;
        _local2 = _arg_1.player || this.model.player;
        _local6 = _arg_1.skinID;
        _local4 = this.classes.getCharacterClass(_local2.objectType_);
        _local3 = this.classes.getCharacterClass(0xffff);
        var _local5:CharacterSkin = _local3.skins.getSkin(_local6) || _local4.skins.getSkin(_local6);
        _local2.skinId = _local6;
        _local2.skin = this.factory.makeCharacter(_local5.template);
        _local2.isDefaultAnimatedChar = false;
    }
}
}
