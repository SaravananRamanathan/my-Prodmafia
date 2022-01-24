package kabam.rotmg.classes.view {
import flash.display.DisplayObject;
import flash.display.Sprite;

import kabam.lib.ui.api.Size;
import kabam.rotmg.util.components.VerticalScrollingList;

public class CharacterSkinListView extends Sprite {

    public static const PADDING:int = 5;

    public static const WIDTH:int = 442;

    public static const HEIGHT:int = 400;


    private const list:VerticalScrollingList = makeList();

    public function CharacterSkinListView() {
        super();
    }
    private var items:Vector.<DisplayObject>;

    public function setItems(_arg_1:Vector.<DisplayObject>):void {
        this.items = _arg_1;
        this.list.setItems(_arg_1);
        this.onScrollStateChanged(this.list.isScrollbarVisible());
    }

    public function getListHeight():Number {
        return this.list.getListHeight();
    }

    private function makeList():VerticalScrollingList {
        var _local1:VerticalScrollingList = new VerticalScrollingList();
        _local1.setSize(new Size(442, 400));
        _local1.scrollStateChanged.add(this.onScrollStateChanged);
        _local1.setPadding(5);
        addChild(_local1);
        return _local1;
    }

    private function onScrollStateChanged(_arg_1:Boolean):void {
        var _local3:* = null;
        var _local2:* = 7 * 60;
        if (!_arg_1) {
            _local2 = _local2 + 22;
        }
        var _local5:int = 0;
        var _local4:* = this.items;
        for each(_local3 in this.items) {
            _local3.setWidth(_local2);
        }
    }
}
}
