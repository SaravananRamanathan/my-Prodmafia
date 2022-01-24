package io.decagames.rotmg.supportCampaign.tab.donate.popup {
import io.decagames.rotmg.shop.ShopBuyButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

public class DonateConfirmationPopup extends ModalPopup {


    public function DonateConfirmationPopup(_arg_1:int, _arg_2:int) {
        var _local5:* = null;
        super(4 * 60, 130, "Boost");
        this._gold = _arg_1;
        var _local6:UILabel = new UILabel();
        _local6.text = "You will receive:";
        DefaultLabelFormat.createLabelFormat(_local6, 14, 0x999999, "center", false);
        _local6.wordWrap = true;
        _local6.width = _contentWidth;
        _local6.y = 5;
        addChild(_local6);
        this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
        addChild(this.supportIcon);
        var _local4:UILabel = new UILabel();
        _local4.text = _arg_2.toString();
        DefaultLabelFormat.createLabelFormat(_local4, 22, 15585539, "center", true);
        _local4.x = _contentWidth / 2 - _local4.width / 2 - 10;
        _local4.y = 25;
        addChild(_local4);
        this.supportIcon.y = _local4.y + 3;
        this.supportIcon.x = _local4.x + _local4.width;
        var _local3:UILabel = new UILabel();
        _local3.text = "Bonus Points";
        DefaultLabelFormat.createLabelFormat(_local3, 14, 0x999999, "center", false);
        _local3.wordWrap = true;
        _local3.width = _contentWidth;
        _local3.y = 50;
        addChild(_local3);
        _local5 = new TextureParser().getSliceScalingBitmap("UI", "main_button_decoration", 148);
        addChild(_local5);
        this._donateButton = new ShopBuyButton(_arg_1);
        this._donateButton.width = _local5.width - 45;
        addChild(this._donateButton);
        _local5.y = _contentHeight - 50;
        _local5.x = Math.round((_contentWidth - _local5.width) / 2);
        this._donateButton.y = _local5.y + 6;
        this._donateButton.x = _local5.x + 22;
    }
    private var supportIcon:SliceScalingBitmap;

    private var _donateButton:ShopBuyButton;

    public function get donateButton():ShopBuyButton {
        return this._donateButton;
    }

    private var _gold:int;

    public function get gold():int {
        return this._gold;
    }
}
}
