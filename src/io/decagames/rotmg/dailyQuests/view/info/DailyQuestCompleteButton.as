package io.decagames.rotmg.dailyQuests.view.info {
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class DailyQuestCompleteButton extends SliceScalingButton {
        
        public static const BUTTON_WIDTH: int = 142;
        
        public function DailyQuestCompleteButton() {
            super(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
            this.setLabel("Complete!", DefaultLabelFormat.questButtonCompleteLabel);
            this.width = 142;
        }
        
        private var _completed: Boolean;
        
        public function get completed(): Boolean {
            return this._completed;
        }
        
        public function set completed(_arg_1: Boolean): void {
            this._completed = _arg_1;
            this.label.text = !!this._completed ? "Completed" : "Complete!";
            render();
        }
    }
}
