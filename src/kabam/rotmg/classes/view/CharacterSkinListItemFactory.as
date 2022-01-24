package kabam.rotmg.classes.view {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.DisplayObject;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.CharacterSkins;
import kabam.rotmg.util.components.LegacyBuyButton;

public class CharacterSkinListItemFactory {


    public function CharacterSkinListItemFactory() {
        super();
    }
    [Inject]
    public var characters:CharacterFactory;

    public function make(_arg_1:CharacterSkins):Vector.<DisplayObject> {
        var _local2:* = undefined;
        var _local5:int = 0;
        var _local3:int = 0;
        _local2 = _arg_1.getListedSkins();
        _local5 = _local2.length;
        var _local4:Vector.<DisplayObject> = new Vector.<DisplayObject>(_local5, true);
        while (_local3 < _local5) {
            _local4[_local3] = this.makeCharacterSkinTile(_local2[_local3]);
            _local3++;
        }
        return _local4;
    }

    private function makeCharacterSkinTile(_arg_1:CharacterSkin):CharacterSkinListItem {
        var _local2:CharacterSkinListItem = new CharacterSkinListItem();
        _local2.setSkin(this.makeIcon(_arg_1));
        _local2.setModel(_arg_1);
        _local2.setLockIcon(AssetLibrary.getImageFromSet("lofiInterface2", 5));
        _local2.setBuyButton(this.makeBuyButton());
        return _local2;
    }

    private function makeBuyButton():LegacyBuyButton {
        return new LegacyBuyButton("", 16, 0, 0);
    }

    private function makeIcon(skin:CharacterSkin) : Bitmap {
        var player:Player = Parameters.player;
        var size:int = Parameters.skinTypes16.indexOf(skin.id) != -1 ? 50 : 100;
        if (player)
            return new Bitmap(this.characters.makeIcon(skin.template, size,
                    player.getTex1(), player.getTex2()));
        return new Bitmap(this.characters.makeIcon(skin.template, size));
    }
}
}
