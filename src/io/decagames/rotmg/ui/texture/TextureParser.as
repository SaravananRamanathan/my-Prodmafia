package io.decagames.rotmg.ui.texture {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import io.decagames.rotmg.ui.assets.UIAssets;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    
    import kabam.lib.json.JsonParser;
    import kabam.rotmg.core.StaticInjectorContext;
    
    public class TextureParser {
        
        private static var _instance: TextureParser;
        
        public static function get instance(): TextureParser {
            if (_instance == null) {
                _instance = new TextureParser();
            }
            return _instance;
        }
        
        public function TextureParser() {
            super();
            this.textures = new Dictionary();
            this.json = StaticInjectorContext.getInjector().getInstance(JsonParser);
            this.registerTexture(new UIAssets.UI(), new UIAssets.UI_CONFIG(), new UIAssets.UI_SLICE_CONFIG(), "UI");
        }
        
        private var textures: Dictionary;
        private var json: JsonParser;
        
        public function registerTexture(_arg_1: Bitmap, _arg_2: String, _arg_3: String, _arg_4: String): void {
            this.textures[_arg_4] = {
                "texture": _arg_1,
                "configuration": this.json.parse(_arg_2),
                "sliceRectangles": this.json.parse(_arg_3)
            };
        }
        
        public function getTexture(_arg_1: String, _arg_2: String): Bitmap {
            var _local3: Object = this.getConfiguration(_arg_1, _arg_2);
            return this.getBitmapUsingConfig(_arg_1, _local3);
        }
        
        public function getSliceScalingBitmap(_arg_1: String, _arg_2: String, _arg_3: int = 0): SliceScalingBitmap {
            var _local6: * = null;
            var _local4: Bitmap = this.getTexture(_arg_1, _arg_2);
            var _local8: Object = this.textures[_arg_1].sliceRectangles.slices[_arg_2 + ".png"];
            var _local5: String = SliceScalingBitmap.SCALE_TYPE_NONE;
            if (_local8) {
                _local6 = new Rectangle(_local8.rectangle.x, _local8.rectangle.y, _local8.rectangle.w, _local8.rectangle.h);
                _local5 = _local8.type;
            }
            var _local7: SliceScalingBitmap = new SliceScalingBitmap(_local4.bitmapData, _local5, _local6);
            _local7.sourceBitmapName = _arg_2;
            if (_arg_3 != 0) {
                _local7.width = _arg_3;
            }
            return _local7;
        }
        
        private function getConfiguration(_arg_1: String, _arg_2: String): Object {
            if (!this.textures[_arg_1]) {
                throw new Error("Can\'t find set name " + _arg_1);
            }
            if (!this.textures[_arg_1].configuration.frames[_arg_2 + ".png"]) {
                throw new Error("Can\'t find config for " + _arg_2);
            }
            return this.textures[_arg_1].configuration.frames[_arg_2 + ".png"];
        }
        
        private function getBitmapUsingConfig(_arg_1: String, _arg_2: Object): Bitmap {
            var _local5: Bitmap = this.textures[_arg_1].texture;
            var _local4: ByteArray = _local5.bitmapData.getPixels(new Rectangle(_arg_2.frame.x, _arg_2.frame.y, _arg_2.frame.w, _arg_2.frame.h));
            _local4.position = 0;
            var _local3: BitmapData = new BitmapData(_arg_2.frame.w, _arg_2.frame.h);
            _local3.setPixels(new Rectangle(0, 0, _arg_2.frame.w, _arg_2.frame.h), _local4);
            return new Bitmap(_local3);
        }
    }
}
