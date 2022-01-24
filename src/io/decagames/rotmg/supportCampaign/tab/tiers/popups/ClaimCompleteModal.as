package io.decagames.rotmg.supportCampaign.tab.tiers.popups {
import io.decagames.rotmg.ui.buttons.BaseButton;
import io.decagames.rotmg.ui.popups.modal.TextModal;
import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;

public class ClaimCompleteModal extends TextModal {


    public function ClaimCompleteModal() {
        var _local1:Vector.<BaseButton> = new Vector.<BaseButton>();
        _local1.push(new ClosePopupButton("OK"));
        super(5 * 60, "Claim complete", "You will find your items in the Gift Chest.", _local1);
    }
}
}
