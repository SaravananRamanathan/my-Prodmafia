package io.decagames.rotmg.social.widgets {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.labels.UILabel;
    
    public class GuildInfoItem extends BaseInfoItem {
        
        
        public function GuildInfoItem(_arg_1: String, _arg_2: int) {
            super(332, 70);
            this._gName = _arg_1;
            this._gFame = _arg_2;
            this.init();
        }
        
        private var _gName: String;
        private var _gFame: int;
        
        private function init(): void {
            this.createGuildName();
            this.createGuildFame();
        }
        
        private function createGuildName(): void {
            var _local1: * = null;
            _local1 = new UILabel();
            _local1.text = this._gName;
            DefaultLabelFormat.guildInfoLabel(_local1, 24);
            _local1.x = (_width - _local1.width) / 2;
            _local1.y = 12;
            addChild(_local1);
        }
        
        private function createGuildFame(): void {
            var _local4: * = null;
            var _local1: * = null;
            var _local3: * = null;
            _local4 = new Sprite();
            addChild(_local4);
            var _local2: BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 226);
            _local2 = TextureRedrawer.redraw(_local2, 40, true, 0);
            _local1 = new Bitmap(_local2);
            _local1.y = -6;
            _local4.addChild(_local1);
            _local3 = new UILabel();
            _local3.text = this._gFame.toString();
            DefaultLabelFormat.guildInfoLabel(_local3);
            _local3.x = _local1.width;
            _local3.y = 5;
            _local4.addChild(_local3);
            _local4.x = (_width - _local4.width) / 2;
            _local4.y = 36;
        }
    }
}
