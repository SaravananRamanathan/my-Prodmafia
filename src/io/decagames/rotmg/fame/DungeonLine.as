package io.decagames.rotmg.fame {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.objects.TextureDataConcrete;
    import com.company.assembleegameclient.util.TextureRedrawer;
    
    import flash.display.Bitmap;
    
    public class DungeonLine extends StatsLine {
        
        
        public function DungeonLine(_arg_1: String, _arg_2: String, _arg_3: String) {
            this.dungeonTextureName = _arg_2;
            super(_arg_1, _arg_3, "", 1);
        }
        
        private var dungeonTextureName: String;
        private var dungeonBitmap: Bitmap;
        
        override protected function setLabelsPosition(): void {
            var _local2: * = null;
            var _local1: TextureDataConcrete = ObjectLibrary.dungeonToPortalTextureData_[this.dungeonTextureName];
            if (_local1) {
                _local2 = _local1.getTexture();
                _local2 = TextureRedrawer.redraw(_local2, 40, true, 0, false);
                this.dungeonBitmap = new Bitmap(_local2);
                this.dungeonBitmap.x = -Math.round(_local2.width / 2) + 13;
                this.dungeonBitmap.y = -Math.round(_local2.height / 2) + 11;
                addChild(this.dungeonBitmap);
            }
            label.y = 4;
            label.x = 24;
            lineHeight = 25;
            if (fameValue) {
                fameValue.y = 4;
            }
            if (lock) {
                lock.y = -6;
            }
        }
        
        override public function clean(): void {
            super.clean();
            if (this.dungeonBitmap) {
                this.dungeonBitmap.bitmapData.dispose();
            }
        }
    }
}
