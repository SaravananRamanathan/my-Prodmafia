package io.decagames.rotmg.seasonalEvent.popups {
import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.utils.date.TimeLeft;

public class SeasonalEventComingPopup extends ModalPopup {


    private const WIDTH:int = 330;

    private const HEIGHT:int = 100;

    public function SeasonalEventComingPopup(_arg_1:Date) {
        var _local2:* = null;
        super(330, 100, "Seasonal Event coming!", DefaultLabelFormat.defaultSmallPopupTitle);
        this._scheduledDate = _arg_1;
        _local2 = new TextureParser().getSliceScalingBitmap("UI", "main_button_decoration", 186);
        addChild(_local2);
        _local2.y = 40;
        _local2.x = Math.round((330 - _local2.width) / 2);
        this._okButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
        this._okButton.setLabel("OK", DefaultLabelFormat.questButtonCompleteLabel);
        this._okButton.width = 130;
        this._okButton.x = Math.round(100);
        this._okButton.y = 46;
        addChild(this._okButton);
        var _local4:String = TimeLeft.getStartTimeString(_arg_1);
        var _local3:UILabel = new UILabel();
        DefaultLabelFormat.defaultSmallPopupTitle(_local3);
        _local3.width = 330;
        _local3.autoSize = "center";
        _local3.text = "Seasonal Event starting in: " + _local4;
        _local3.y = 10;
        addChild(_local3);
    }
    private var _scheduledDate:Date;

    private var _okButton:SliceScalingButton;

    public function get okButton():SliceScalingButton {
        return this._okButton;
    }
}
}
