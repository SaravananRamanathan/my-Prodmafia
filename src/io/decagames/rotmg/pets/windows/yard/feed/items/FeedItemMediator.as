package io.decagames.rotmg.pets.windows.yard.feed.items {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
    
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.signals.SelectFeedItemSignal;
    
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.ui.model.HUDModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class FeedItemMediator extends Mediator {
        
        
        public function FeedItemMediator() {
            super();
        }
        
        [Inject]
        public var view: FeedItem;
        [Inject]
        public var showTooltipSignal: ShowTooltipSignal;
        [Inject]
        public var hideTooltipsSignal: HideTooltipsSignal;
        [Inject]
        public var hud: HUDModel;
        [Inject]
        public var selectFeedItemSignal: SelectFeedItemSignal;
        private var tooltip: EquipmentToolTip;
        
        override public function initialize(): void {
            var _local1: Player = this.hud.gameSprite && this.hud.gameSprite.map ? this.hud.gameSprite.map.player_ : null;
            var _local2: int = ObjectLibrary.idToType_[this.view.itemId];
            this.tooltip = new EquipmentToolTip(this.view.itemId, _local1, _local2, "CURRENT_PLAYER");
            this.view.addEventListener("rollOver", this.onRollOverHandler);
            this.view.addEventListener("click", this.onClickHandler);
        }
        
        override public function destroy(): void {
            this.view.removeEventListener("rollOver", this.onRollOverHandler);
            this.view.removeEventListener("click", this.onClickHandler);
            this.view.dispose();
        }
        
        private function onClickHandler(_arg_1: MouseEvent): void {
            this.view.selected = !this.view.selected;
            this.selectFeedItemSignal.dispatch();
            this.hideTooltipsSignal.dispatch();
        }
        
        private function onRollOverHandler(_arg_1: MouseEvent): void {
            this.tooltip.attachToTarget(this.view);
            this.showTooltipSignal.dispatch(this.tooltip);
        }
    }
}
