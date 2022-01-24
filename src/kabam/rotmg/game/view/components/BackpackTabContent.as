package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;

import flash.display.Sprite;

import kabam.rotmg.ui.view.PotionInventoryView;

public class BackpackTabContent extends Sprite {


    public function BackpackTabContent(_arg_1:Player) {
        backpackContent = new Sprite();
        backpackPotionsInventory = new PotionInventoryView();
        super();
        this.init(_arg_1);
        this.addChildren();
        this.positionChildren();
        name = "Backpack";
    }
    private var backpackContent:Sprite;
    private var backpackPotionsInventory:PotionInventoryView;

    private var _backpack:InventoryGrid;

    public function get backpack():InventoryGrid {
        return this._backpack;
    }

    private function init(_arg_1:Player):void {
        name = "Backpack";
        this._backpack = new InventoryGrid(_arg_1, _arg_1, 12, true);
    }

    private function positionChildren():void {
        this.backpackContent.x = 7;
        this.backpackContent.y = 7;
        this.backpackPotionsInventory.y = this._backpack.height + 4;
    }

    private function addChildren():void {
        this.backpackContent.addChild(this._backpack);
        this.backpackContent.addChild(this.backpackPotionsInventory);
        addChild(this.backpackContent);
    }
}
}
