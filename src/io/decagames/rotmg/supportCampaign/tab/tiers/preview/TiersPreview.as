package io.decagames.rotmg.supportCampaign.tab.tiers.preview {
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.greensock.easing.Expo;

import flash.display.DisplayObject;
import flash.display.Sprite;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.labels.UILabel;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

public class TiersPreview extends Sprite {


    public function TiersPreview(_arg_1:Array, _arg_2:int) {
        super();
        this._ranks = _arg_1;
        this._componentWidth = _arg_2;
        this.init();
    }
    private var background:DisplayObject;
    private var supportIcon:SliceScalingBitmap;
    private var donateButtonBackground:SliceScalingBitmap;
    private var _componentWidth:int;
    private var requiredPointsContainer:Sprite;
    private var _ranks:Array;
    private var selectTween:TimelineMax;
    private var _tier:int;
    private var _currentRank:int;
    private var _claimed:int;

    private var _leftArrow:SliceScalingButton;

    public function get leftArrow():SliceScalingButton {
        return this._leftArrow;
    }

    private var _rightArrow:SliceScalingButton;

    public function get rightArrow():SliceScalingButton {
        return this._rightArrow;
    }

    private var _startTier:int;

    public function get startTier():int {
        return this._currentRank;
    }

    private var _claimButton:SliceScalingButton;

    public function get claimButton():SliceScalingButton {
        return this._claimButton;
    }

    public function showTier(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:DisplayObject):void {
        this._tier = _arg_1;
        this._currentRank = _arg_2;
        this._claimed = _arg_3;
        if (this.background && this.background.parent) {
            removeChild(this.background);
        }
        this.background = _arg_4;
        addChildAt(this.background, 0);
        this.renderButtons(this._tier, this._currentRank, this._claimed);
    }

    public function selectAnimation():void {
        if (!this.selectTween) {
            this.selectTween = new TimelineMax();
            this.selectTween.add(TweenMax.to(this, 0.05, {"tint": 0xffffff}));
            this.selectTween.add(TweenMax.to(this, 0.3, {
                "tint": null,
                "ease": Expo.easeOut
            }));
        } else {
            this.selectTween.play(0);
        }
    }

    private function init():void {
        this.createClaimButton();
        this.createArrows();
    }

    private function createClaimButton():void {
        this._claimButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
        this._claimButton.setLabel("Claim", DefaultLabelFormat.defaultButtonLabel);
    }

    private function createArrows():void {
        this._rightArrow = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "tier_arrow"));
        addChild(this._rightArrow);
        this._rightArrow.x = 533;
        this._rightArrow.y = 103;
        this._leftArrow = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "tier_arrow"));
        this._leftArrow.rotation = 3 * 60;
        this._leftArrow.x = -3;
        this._leftArrow.y = 133;
        addChild(this._leftArrow);
    }

    private function renderButtons(_arg_1:int, _arg_2:int, _arg_3:int):void {
        var _local5:* = null;
        var _local4:* = null;
        if (this.donateButtonBackground && this.donateButtonBackground.parent) {
            removeChild(this.donateButtonBackground);
        }
        if (this._claimButton && this._claimButton.parent) {
            removeChild(this._claimButton);
        }
        if (this.requiredPointsContainer && this.requiredPointsContainer.parent) {
            removeChild(this.requiredPointsContainer);
        }
        if (_arg_1 > _arg_3 && _arg_1 != this._ranks.length + 1) {
            this.donateButtonBackground = TextureParser.instance.getSliceScalingBitmap("UI", "main_button_decoration_dark", 160);
            this.donateButtonBackground.x = Math.round((this._componentWidth - this.donateButtonBackground.width) / 2);
            this.donateButtonBackground.y = 178;
            addChild(this.donateButtonBackground);
            if (_arg_2 >= _arg_1) {
                this._claimButton.width = this.donateButtonBackground.width - 48;
                this._claimButton.y = this.donateButtonBackground.y + 6;
                this._claimButton.x = this.donateButtonBackground.x + 24;
                addChild(this._claimButton);
            } else {
                this.requiredPointsContainer = new Sprite();
                _local5 = new UILabel();
                DefaultLabelFormat.createLabelFormat(_local5, 22, 15585539, "center", true);
                this.requiredPointsContainer.addChild(_local5);
                this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
                this.requiredPointsContainer.addChild(this.supportIcon);
                _local5.text = this._ranks[_arg_1 - 1].toString();
                _local5.x = this.donateButtonBackground.x + Math.round((this.donateButtonBackground.width - _local5.width) / 2) - 10;
                _local5.y = this.donateButtonBackground.y + 13;
                this.supportIcon.y = _local5.y + 3;
                this.supportIcon.x = _local5.x + _local5.width;
                addChild(this.requiredPointsContainer);
            }
        } else if (_arg_3) {
            this.requiredPointsContainer = new Sprite();
            _local4 = new UILabel();
            DefaultLabelFormat.createLabelFormat(_local4, 22, 4958208, "center", true);
            this.requiredPointsContainer.addChild(_local4);
            _local4.text = "Claimed";
            _local4.x = Math.round((this._componentWidth - _local4.width) / 2);
            _local4.y = 190;
            addChild(this.requiredPointsContainer);
        }
    }
}
}
