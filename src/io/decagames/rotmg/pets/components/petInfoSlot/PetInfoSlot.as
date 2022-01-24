package io.decagames.rotmg.pets.components.petInfoSlot {
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petPortrait.PetPortrait;
    import io.decagames.rotmg.pets.components.petStatsGrid.PetFeedStatsGrid;
    import io.decagames.rotmg.pets.components.petStatsGrid.PetStatsGrid;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class PetInfoSlot extends Sprite {
        
        public static const INFO_HEIGHT: int = 207;
        
        public static const STATS_WIDTH: int = 150;
        
        public static const FEED_STATS_WIDTH: int = 195;
        
        public function PetInfoSlot(_arg_1: int, _arg_2: Boolean, _arg_3: Boolean, _arg_4: Boolean, _arg_5: Boolean = false, _arg_6: Boolean = false, _arg_7: Boolean = false, _arg_8: Boolean = false, _arg_9: Boolean = false) {
            super();
            this._switchable = _arg_2;
            this._slotWidth = _arg_1;
            this._showFeedPower = _arg_8;
            this._showCurrentPet = _arg_4;
            this.showStats = _arg_3;
            this.animations = _arg_5;
            this.showReleaseButton = _arg_7;
            this.isRarityLabelHidden = _arg_6;
            this._useFeedStats = _arg_9;
            var _local10: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", _arg_1);
            addChild(_local10);
            _local10.height = 207;
            _local10.x = 0;
            _local10.y = 0;
        }
        
        private var petPortrait: PetPortrait;
        private var _switchable: Boolean;
        private var showStats: Boolean;
        private var animations: Boolean;
        private var isRarityLabelHidden: Boolean;
        private var showReleaseButton: Boolean;
        private var _useFeedStats: Boolean;
        private var _showFeedPower: Boolean;
        private var statsGrid: UIGrid;
        
        private var _slotWidth: int;
        
        public function get slotWidth(): int {
            return this._slotWidth;
        }
        
        private var _showCurrentPet: Boolean;
        
        public function get showCurrentPet(): Boolean {
            return this._showCurrentPet;
        }
        
        private var _petVO: IPetVO;
        
        public function get petVO(): IPetVO {
            return this._petVO;
        }
        
        public function showPetInfo(_arg_1: IPetVO, _arg_2: Boolean = true): void {
            var _local3: int = 0;
            this._petVO = _arg_1;
            if (!this.petPortrait) {
                this.petPortrait = new PetPortrait(this._slotWidth, _arg_1, this._switchable, this._showCurrentPet, this.showReleaseButton, this._showFeedPower);
                this.petPortrait.enableAnimation = this.animations;
                addChild(this.petPortrait);
            } else {
                this.petPortrait.petVO = _arg_1;
            }
            if (this.isRarityLabelHidden) {
                this.petPortrait.hideRarityLabel();
            }
            if (this.showStats && _arg_2) {
                this.statsGrid = !!this._useFeedStats ? new PetFeedStatsGrid(195, _arg_1) : new PetStatsGrid(150, _arg_1);
                addChild(this.statsGrid);
                this.statsGrid.y = !!this._useFeedStats ? 132 : Number(130);
                _local3 = !!this._useFeedStats ? 195 : Number(150);
                this.statsGrid.x = Math.round((this._slotWidth - _local3) / 2);
            }
        }
    }
}
