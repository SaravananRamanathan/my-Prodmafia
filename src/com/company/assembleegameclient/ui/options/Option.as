package com.company.assembleegameclient.ui.options {
import flash.display.Sprite;

import org.osflash.signals.Signal;

public class Option extends Sprite {


    public function Option() {
        textChanged = new Signal();
        super();
    }
    public var textChanged:Signal;
}
}
