package io.decagames.rotmg.dailyQuests.view {
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class DailyQuestRefreshButton extends SliceScalingButton {
        
        
        public function DailyQuestRefreshButton() {
            super(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button", 32));
            this.createRefreshIcon();
        }
        
        private function createRefreshIcon(): void {
            var _local1: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "refresh_icon", 10);
            _local1.x = 7;
            _local1.y = 8;
            addChild(_local1);
        }
    }
}
