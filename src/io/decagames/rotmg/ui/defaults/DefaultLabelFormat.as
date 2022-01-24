package io.decagames.rotmg.ui.defaults {
    import com.company.assembleegameclient.util.FilterUtil;
    
    import flash.filters.DropShadowFilter;
    import flash.text.TextFormat;
    
    import io.decagames.rotmg.ui.labels.UILabel;
    
    import kabam.rotmg.text.model.FontModel;
    
    public class DefaultLabelFormat {
        
        
        public static function createLabelFormat(_arg_1: UILabel, _arg_2: int = 12, _arg_3: Number = 16777215, _arg_4: String = "left", _arg_5: Boolean = false, _arg_6: Array = null): void {
            var _local7: TextFormat = createTextFormat(_arg_2, _arg_3, _arg_4, _arg_5);
            applyTextFormat(_local7, _arg_1);
            if (_arg_6) {
                _arg_1.filters = _arg_6;
            }
        }
        
        public static function defaultButtonLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 16, 0xffffff, "center");
        }
        
        public static function defaultPopupTitle(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 32, 0xeaeaea, "left", true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function defaultMediumPopupTitle(_arg_1: UILabel, _arg_2: String = "left"): void {
            createLabelFormat(_arg_1, 22, 0xeaeaea, _arg_2, true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function defaultSmallPopupTitle(_arg_1: UILabel, _arg_2: String = "left"): void {
            createLabelFormat(_arg_1, 14, 0xeaeaea, _arg_2, true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function friendsItemLabel(_arg_1: UILabel, _arg_2: Number = 16777215): void {
            createLabelFormat(_arg_1, 14, _arg_2, "left", true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function guildInfoLabel(_arg_1: UILabel, _arg_2: int = 14, _arg_3: Number = 16777215, _arg_4: String = "left"): void {
            createLabelFormat(_arg_1, _arg_2, _arg_3, _arg_4, true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function characterViewNameLabel(_arg_1: UILabel, _arg_2: int = 18): void {
            createLabelFormat(_arg_1, _arg_2, 0xb3b3b3, "left", true, [new DropShadowFilter(0, 0, 0)]);
        }
        
        public static function characterFameNameLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xffffff, "left", true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function characterFameInfoLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0x8c8c8c, "left", true, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function characterToolTipLabel(_arg_1: UILabel, _arg_2: Number): void {
            createLabelFormat(_arg_1, 12, _arg_2, "left", true);
        }
        
        public static function coinsFieldLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xffffff, "right");
        }
        
        public static function numberSpinnerLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xeaeaea, "center");
        }
        
        public static function shopTag(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0xffffff, "left", true, FilterUtil.getUILabelDropShadowFilter02());
        }
        
        public static function popupTag(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 24, 0xffffff, "left", true, FilterUtil.getUILabelDropShadowFilter02());
        }
        
        public static function shopBoxTitle(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xeaeaea, "left");
        }
        
        public static function defaultModalTitle(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xffffff, "left", false, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function defaultTextModalText(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xffffff, "center");
        }
        
        public static function mysteryBoxContentInfo(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0x999999, "center", true);
        }
        
        public static function mysteryBoxContentItemName(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xffffff, "left");
        }
        
        public static function popupEndsIn(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 24, 16684800, "left", true, FilterUtil.getUILabelComboFilter());
        }
        
        public static function mysteryBoxEndsIn(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 16684800, "left", true, FilterUtil.getUILabelComboFilter());
        }
        
        public static function popupStartsIn(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 24, 16728576, "left", true, FilterUtil.getUILabelComboFilter());
        }
        
        public static function mysteryBoxStartsIn(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 16728576, "left", true, FilterUtil.getUILabelComboFilter());
        }
        
        public static function priceButtonLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xeaeaea, "left", false, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function originalPriceButtonLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 16, 0xeaeaea, "left", false, FilterUtil.getUILabelComboFilter());
        }
        
        public static function defaultInactiveTab(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0x616161, "left", true);
        }
        
        public static function defaultActiveTab(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xeaeaea, "left", true, FilterUtil.getUILabelDropShadowFilter02());
        }
        
        public static function mysteryBoxVaultInfo(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 16684800, "left", true, FilterUtil.getUILabelDropShadowFilter02());
        }
        
        public static function currentFameLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 22, 16760388, "left", true);
        }
        
        public static function deathFameLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xeaeaea, "left", true);
        }
        
        public static function deathFameCount(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 16762880, "right", true);
        }
        
        public static function tierLevelLabel(_arg_1: UILabel, _arg_2: int = 12, _arg_3: Number = 16777215, _arg_4: String = "right"): void {
            createLabelFormat(_arg_1, _arg_2, _arg_3, _arg_4, true);
        }
        
        public static function questRefreshLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xa3a3a3, "center", true);
        }
        
        public static function questCompletedLabel(_arg_1: UILabel, _arg_2: Boolean, _arg_3: Boolean): void {
            var _local4: Number = !_arg_2 ? 13224136 : 3971635;
            createLabelFormat(_arg_1, 16, _local4, "left", true);
        }
        
        public static function questNameLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 20, 15241232, "center", true);
        }
        
        public static function notificationLabel(_arg_1: UILabel, _arg_2: int, _arg_3: Number, _arg_4: String, _arg_5: Boolean): void {
            createLabelFormat(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, FilterUtil.getUILabelDropShadowFilter01());
        }
        
        public static function createTextFormat(_arg_1: int, _arg_2: uint, _arg_3: String, _arg_4: Boolean): TextFormat {
            var _local5: TextFormat = new TextFormat();
            _local5.color = _arg_2;
            _local5.bold = _arg_4;
            _local5.font = FontModel.DEFAULT_FONT_NAME;
            _local5.size = _arg_1;
            _local5.align = _arg_3;
            return _local5;
        }
        
        public static function questDescriptionLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 16, 13224136, "center");
        }
        
        public static function questRewardLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 16, 0xffffff, "center", true);
        }
        
        public static function questChoiceLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 13224136, "center");
        }
        
        public static function questButtonCompleteLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xffffff, "center", true);
        }
        
        public static function questNameListLabel(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 14, _arg_2, "left", true);
        }
        
        public static function petNameLabel(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 18, _arg_2, "center", true);
        }
        
        public static function petNameLabelSmall(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 14, _arg_2, "center", true);
        }
        
        public static function petFamilyLabel(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 14, _arg_2, "center", true, FilterUtil.getUILabelComboFilter());
        }
        
        public static function petInfoLabel(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 12, _arg_2, "center");
        }
        
        public static function petStatLabelLeft(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 12, _arg_2, "left");
        }
        
        public static function petStatLabelRight(_arg_1: UILabel, _arg_2: uint, _arg_3: Boolean = false): void {
            createLabelFormat(_arg_1, 12, _arg_2, "right", _arg_3);
        }
        
        public static function petStatLabelLeftSmall(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 11, _arg_2, "left");
        }
        
        public static function petStatLabelRightSmall(_arg_1: UILabel, _arg_2: uint, _arg_3: Boolean = false): void {
            createLabelFormat(_arg_1, 11, _arg_2, "right", _arg_3);
        }
        
        public static function fusionStrengthLabel(_arg_1: UILabel, _arg_2: uint, _arg_3: int): void {
            var _local4: Number = _arg_3 != 0 ? _arg_2 : 0xffffff;
            createLabelFormat(_arg_1, 14, _local4, "center", true);
        }
        
        public static function feedPetInfo(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xffffff, "center", true);
        }
        
        public static function wardrobeCollectionLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0xffffff, "center", true);
        }
        
        public static function petYardRarity(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0xa2a2a2, "center", true);
        }
        
        public static function petYardUpgradeInfo(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0x8c8c8c, "center", true);
        }
        
        public static function petYardUpgradeRarityInfo(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0xffffff, "center", true);
        }
        
        public static function newAbilityInfo(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 12, 0x999999, "center", true);
        }
        
        public static function newAbilityName(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 8971493, "center", true);
        }
        
        public static function newSkinHatched(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 14, 0x939393, "center", true);
        }
        
        public static function infoTooltipText(_arg_1: UILabel, _arg_2: uint): void {
            createLabelFormat(_arg_1, 14, _arg_2, "left");
        }
        
        public static function newSkinLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 9, 0, "center", true);
        }
        
        public static function donateAmountLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xeaeaea, "right", false);
        }
        
        public static function pointsAmountLabel(_arg_1: UILabel): void {
            createLabelFormat(_arg_1, 18, 0xeaeaea, "center", false);
        }
        
        private static function applyTextFormat(_arg_1: TextFormat, _arg_2: UILabel): void {
            _arg_2.defaultTextFormat = _arg_1;
            _arg_2.setTextFormat(_arg_1);
        }
        
        public function DefaultLabelFormat() {
            super();
        }
    }
}
