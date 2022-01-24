package kabam.rotmg.ui.model {
import com.company.assembleegameclient.game.GameSprite;

import kabam.rotmg.ui.view.KeysView;

public class HUDModel {


    public function HUDModel() {
        super();
    }
    public var gameSprite:GameSprite;

    private var _keysView:KeysView;
    
    // contents of the players vault chests
    public var vaultContents:Vector.<int>;
    public var giftContents:Vector.<int>;
    public var potContents:Vector.<int>;

    public function get keysView():KeysView {
        return this._keysView;
    }

    public function set keysView(_arg_1:KeysView):void {
        this._keysView = _arg_1;
    }

    public function getPlayerName():String {
        return !!this.gameSprite.model.getName() ? this.gameSprite.model.getName() : this.gameSprite.map.player_.name_;
    }

    public function getButtonType():String {
        return this.gameSprite.gsc_.gameId_ == -2 ? "OPTIONS_BUTTON" : "NEXUS_BUTTON";
    }
}
}
