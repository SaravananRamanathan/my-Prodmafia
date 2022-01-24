package kabam.rotmg.core.view {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import io.decagames.rotmg.ui.popups.PopupView;

import kabam.rotmg.dialogs.view.DialogsView;
import kabam.rotmg.tooltips.view.TooltipsView;

public class Layers extends Sprite {


    public function Layers() {
        super();
        var _local1:* = new ScreensView();
        this.menu = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.overlay = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.top = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.mouseDisabledTop = _local1;
        addChild(_local1);
        this.mouseDisabledTop.mouseEnabled = false;
        _local1 = new PopupView();
        this.popups = _local1;
        addChild(_local1);
        _local1 = new DialogsView();
        this.dialogs = _local1;
        addChild(_local1);
        _local1 = new TooltipsView();
        this.tooltips = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.api = _local1;
        addChild(_local1);
        _local1 = new Sprite();
        this.console = _local1;
        addChild(_local1);
    }
    public var overlay:DisplayObjectContainer;
    public var top:DisplayObjectContainer;
    public var mouseDisabledTop:DisplayObjectContainer;
    public var api:DisplayObjectContainer;
    public var console:DisplayObjectContainer;
    private var menu:ScreensView;
    private var tooltips:TooltipsView;
    private var dialogs:DialogsView;
    private var popups:PopupView;
}
}
