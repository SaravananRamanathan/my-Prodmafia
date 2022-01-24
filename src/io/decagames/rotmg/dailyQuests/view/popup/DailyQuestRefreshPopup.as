package io.decagames.rotmg.dailyQuests.view.popup {
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    
    public class DailyQuestRefreshPopup extends ModalPopup {
        
        
        private const TITLE: String = "Refresh Daily Quests";
        
        private const TEXT: String = "Do you want to refresh your Daily Quests? All Daily Quests will be refreshed!";
        
        private const WIDTH: int = 300;
        
        private const HEIGHT: int = 100;
        
        public function DailyQuestRefreshPopup(_arg_1: int) {
            super(5 * 60, 100, "Refresh Daily Quests");
            this._refreshPrice = _arg_1;
            this.init();
        }
        
        private var _refreshPrice: int;
        
        private var _buyQuestRefreshButton: BuyQuestRefreshButton;
        
        public function get buyQuestRefreshButton(): BuyQuestRefreshButton {
            return this._buyQuestRefreshButton;
        }
        
        private function init(): void {
            var _local1: UILabel = new UILabel();
            _local1.width = 280;
            _local1.multiline = true;
            _local1.wordWrap = true;
            _local1.text = "Do you want to refresh your Daily Quests? All Daily Quests will be refreshed!";
            DefaultLabelFormat.defaultSmallPopupTitle(_local1, "center");
            _local1.x = (300 - _local1.width) / 2;
            _local1.y = 10;
            addChild(_local1);
            this._buyQuestRefreshButton = new BuyQuestRefreshButton(this._refreshPrice);
            this._buyQuestRefreshButton.x = (300 - this._buyQuestRefreshButton.width) / 2;
            this._buyQuestRefreshButton.y = 60;
            addChild(this._buyQuestRefreshButton);
        }
    }
}
