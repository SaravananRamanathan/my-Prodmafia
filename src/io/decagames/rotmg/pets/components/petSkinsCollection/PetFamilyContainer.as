package io.decagames.rotmg.pets.components.petSkinsCollection {
    import io.decagames.rotmg.pets.data.family.PetFamilyColors;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.utils.colors.Tint;
    
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class PetFamilyContainer extends UIGridElement {
        
        
        public function PetFamilyContainer(_arg_1: String, _arg_2: int, _arg_3: int) {
            var _local7: * = null;
            var _local6: * = null;
            var _local5: * = null;
            super();
            var _local4: uint = PetFamilyColors.KEYS_TO_COLORS[_arg_1];
            _local7 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_white", 320);
            Tint.add(_local7, _local4, 1);
            addChild(_local7);
            _local7.x = 10;
            _local7.y = 3;
            _local6 = new UILabel();
            DefaultLabelFormat.petFamilyLabel(_local6, 0xffffff);
            _local6.text = LineBuilder.getLocalizedStringFromKey(_arg_1);
            _local6.y = 0;
            _local6.x = 160 - _local6.width / 2 + 10;
            _local5 = TextureParser.instance.getSliceScalingBitmap("UI", "content_divider_smalltitle_white", _local6.width + 20);
            Tint.add(_local5, _local4, 1);
            addChild(_local5);
            _local5.x = 160 - _local5.width / 2 + 10;
            _local5.y = 0;
            addChild(_local6);
        }
    }
}
