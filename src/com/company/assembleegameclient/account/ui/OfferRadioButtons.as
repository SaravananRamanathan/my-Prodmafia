package com.company.assembleegameclient.account.ui {
import com.company.assembleegameclient.account.ui.components.Selectable;
import com.company.assembleegameclient.account.ui.components.SelectionGroup;
import com.company.assembleegameclient.util.offer.Offer;
import com.company.assembleegameclient.util.offer.Offers;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;

import kabam.lib.ui.api.Layout;
import kabam.lib.ui.impl.VerticalLayout;
import kabam.rotmg.account.core.model.MoneyConfig;

public class OfferRadioButtons extends Sprite {


    public function OfferRadioButtons(_arg_1:Offers, _arg_2:MoneyConfig) {
        super();
        this.offers = _arg_1;
        this.config = _arg_2;
        this.makeGoldChoices();
        this.alignGoldChoices();
        this.makeSelectionGroup();
    }
    private var offers:Offers;
    private var config:MoneyConfig;
    private var choices:Vector.<OfferRadioButton>;
    private var group:SelectionGroup;

    public function getChoice():OfferRadioButton {
        return this.group.getSelected() as OfferRadioButton;
    }

    public function showBonuses(_arg_1:Boolean):void {
        var _local2:int = this.choices.length;
        while (true) {
            _local2--;
            if (!_local2) {
                break;
            }
            this.choices[_local2].showBonus(_arg_1);
        }
    }

    private function makeGoldChoices():void {
        var _local2:int = 0;
        var _local1:int = this.offers.offerList.length;
        this.choices = new Vector.<OfferRadioButton>(_local1, true);
        while (_local2 < _local1) {
            this.choices[_local2] = this.makeGoldChoice(this.offers.offerList[_local2]);
            _local2++;
        }
    }

    private function makeGoldChoice(_arg_1:Offer):OfferRadioButton {
        var _local2:OfferRadioButton = new OfferRadioButton(_arg_1, this.config);
        _local2.addEventListener("click", this.onSelected);
        addChild(_local2);
        return _local2;
    }

    private function alignGoldChoices():void {
        var _local1:Vector.<DisplayObject> = this.castChoicesToDisplayList();
        var _local2:Layout = new VerticalLayout();
        _local2.setPadding(5);
        _local2.layout(_local1);
    }

    private function castChoicesToDisplayList():Vector.<DisplayObject> {
        var _local1:int = 0;
        var _local3:int = this.choices.length;
        var _local2:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
        while (_local1 < _local3) {
            _local2[_local1] = this.choices[_local1];
            _local1++;
        }
        return _local2;
    }

    private function makeSelectionGroup():void {
        var _local1:Vector.<Selectable> = this.castBoxesToSelectables();
        this.group = new SelectionGroup(_local1);
        this.group.setSelected(this.choices[0].getValue());
    }

    private function castBoxesToSelectables():Vector.<Selectable> {
        var _local1:int = 0;
        var _local3:int = this.choices.length;
        var _local2:Vector.<Selectable> = new Vector.<Selectable>(0);
        while (_local1 < _local3) {
            _local2[_local1] = this.choices[_local1];
            _local1++;
        }
        return _local2;
    }

    private function onSelected(_arg_1:MouseEvent):void {
        var _local2:Selectable = _arg_1.currentTarget as Selectable;
        this.group.setSelected(_local2.getValue());
    }
}
}
