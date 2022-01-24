package io.decagames.rotmg.shop.mysteryBox.contentPopup {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
    
    import flash.events.MouseEvent;
    
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.ui.model.HUDModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class ItemBoxMediator extends Mediator {
        
        
        public function ItemBoxMediator() {
            super();
        }
        
        [Inject]
        public var view: ItemBox;
        [Inject]
        public var hud: HUDModel;
        [Inject]
        public var showTooltipSignal: ShowTooltipSignal;
        private var tooltip: EquipmentToolTip;
        
        override public function initialize(): void {
            var _local1: Player = this.hud.gameSprite && this.hud.gameSprite.map ? this.hud.gameSprite.map.player_ : null;
            var _local2: int = ObjectLibrary.idToType_[this.view.itemId];
            this.tooltip = new EquipmentToolTip(parseInt(this.view.itemId), _local1, _local2, "CURRENT_PLAYER");
            this.view.itemBackground.addEventListener("rollOver", this.onRollOverHandler);
        }
        
        override public function destroy(): void {
            this.view.itemBackground.removeEventListener("rollOver", this.onRollOverHandler);
            this.tooltip.detachFromTarget();
        }
        
        private function onRollOverHandler(_arg_1: MouseEvent): void {
            this.tooltip.attachToTarget(this.view);
            this.showTooltipSignal.dispatch(this.tooltip);
        }
    }
}
