package com.company.assembleegameclient.account.ui {
import com.company.assembleegameclient.account.ui.components.Selectable;
import com.company.assembleegameclient.account.ui.components.SelectionGroup;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

import kabam.lib.ui.api.Layout;
import kabam.lib.ui.impl.HorizontalLayout;
import kabam.rotmg.ui.view.SignalWaiter;

public class PaymentMethodRadioButtons extends Sprite {


    private const waiter:SignalWaiter = new SignalWaiter();

    public function PaymentMethodRadioButtons(_arg_1:Vector.<String>) {
        super();
        this.labels = _arg_1;
        this.waiter.complete.add(this.alignRadioButtons);
        this.makeRadioButtons();
        this.alignRadioButtons();
        this.makeSelectionGroup();
    }
    private var labels:Vector.<String>;
    private var boxes:Vector.<PaymentMethodRadioButton>;
    private var group:SelectionGroup;

    public function setSelected(_arg_1:String):void {
        this.group.setSelected(_arg_1);
    }

    public function getSelected():String {
        return this.group.getSelected().getValue();
    }

    private function makeRadioButtons():void {
        var _local2:int = 0;
        var _local1:int = this.labels.length;
        this.boxes = new Vector.<PaymentMethodRadioButton>(_local1, true);
        while (_local2 < _local1) {
            this.boxes[_local2] = this.makeRadioButton(this.labels[_local2]);
            _local2++;
        }
    }

    private function makeRadioButton(_arg_1:String):PaymentMethodRadioButton {
        var _local2:PaymentMethodRadioButton = new PaymentMethodRadioButton(_arg_1);
        _local2.addEventListener("click", this.onSelected);
        this.waiter.push(_local2.textSet);
        addChild(_local2);
        return _local2;
    }

    private function alignRadioButtons():void {
        var _local1:Vector.<DisplayObject> = this.castBoxesToDisplayObjects();
        var _local2:Layout = new HorizontalLayout();
        _local2.setPadding(20);
        _local2.layout(_local1);
    }

    private function castBoxesToDisplayObjects():Vector.<DisplayObject> {
        var _local1:int = 0;
        var _local3:int = this.boxes.length;
        var _local2:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
        while (_local1 < _local3) {
            _local2[_local1] = this.boxes[_local1];
            _local1++;
        }
        return _local2;
    }

    private function makeSelectionGroup():void {
        var _local1:Vector.<Selectable> = this.castBoxesToSelectables();
        this.group = new SelectionGroup(_local1);
        this.group.setSelected(this.boxes[0].getValue());
    }

    private function castBoxesToSelectables():Vector.<Selectable> {
        var _local1:int = 0;
        var _local3:int = this.boxes.length;
        var _local2:Vector.<Selectable> = new Vector.<Selectable>(0);
        while (_local1 < _local3) {
            _local2[_local1] = this.boxes[_local1];
            _local1++;
        }
        return _local2;
    }

    private function onSelected(_arg_1:Event):void {
        var _local2:Selectable = _arg_1.currentTarget as Selectable;
        this.group.setSelected(_local2.getValue());
    }
}
}
