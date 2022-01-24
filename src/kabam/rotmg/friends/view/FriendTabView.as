package kabam.rotmg.friends.view {
import com.company.ui.BaseSimpleText;
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.MouseEvent;

import kabam.rotmg.game.view.components.TabBackground;
import kabam.rotmg.game.view.components.TabTextView;
import kabam.rotmg.game.view.components.TabView;

import org.osflash.signals.Signal;

public class FriendTabView extends Sprite {


    public const tabSelected:Signal = new Signal(String);

    private const TAB_WIDTH:int = 120;

    private const TAB_HEIGHT:int = 30;

    private const tabSprite:Sprite = new Sprite();

    private const background:Sprite = new Sprite();

    private const containerSprite:Sprite = new Sprite();

    public function FriendTabView(_arg_1:Number, _arg_2:Number) {
        tabs = new Vector.<TabView>();
        contents = new Vector.<Sprite>();
        super();
        this._width = _arg_1;
        this._height = _arg_2;
        this.tabSprite.addEventListener("click", this.onTabClicked);
        addChild(this.tabSprite);
        this.drawBackground();
        addChild(this.containerSprite);
    }
    public var tabs:Vector.<TabView>;
    public var currentTabIndex:int;
    private var _width:Number;
    private var _height:Number;
    private var contents:Vector.<Sprite>;

    public function destroy():void {
        while (numChildren > 0) {
            this.removeChildAt(numChildren - 1);
        }
        this.tabSprite.removeEventListener("click", this.onTabClicked);
        this.tabs = null;
        this.contents = null;
    }

    public function addTab(_arg_1:BaseSimpleText, _arg_2:Sprite):void {
        var _local3:int = this.tabs.length;
        var _local4:TabView = this.addTextTab(_local3, _arg_1 as BaseSimpleText);
        this.tabs.push(_local4);
        this.tabSprite.addChild(_local4);
        _arg_2.y = 35;
        this.contents.push(_arg_2);
        this.containerSprite.addChild(_arg_2);
        if (_local3 > 0) {
            _arg_2.visible = false;
        } else {
            _local4.setSelected(true);
            this.showContent(0);
            this.tabSelected.dispatch(_arg_2.name);
        }
    }

    public function clearTabs():void {
        var _local1:int = 0;
        this.currentTabIndex = 0;
        var _local2:uint = this.tabs.length;
        _local1 = 0;
        while (_local1 < _local2) {
            this.tabSprite.removeChild(this.tabs[_local1]);
            this.containerSprite.removeChild(this.contents[_local1]);
            _local1++;
        }
        this.tabs = new Vector.<TabView>();
        this.contents = new Vector.<Sprite>();
    }

    public function removeTab():void {
    }

    public function setSelectedTab(_arg_1:uint):void {
        this.selectTab(this.tabs[_arg_1]);
    }

    public function showTabBadget(_arg_1:uint, _arg_2:int):void {
        var _local3:TabView = this.tabs[_arg_1];
        (_local3 as TabTextView).setBadge(_arg_2);
    }

    private function selectTab(_arg_1:TabView):void {
        var _local2:* = null;
        if (_arg_1) {
            _local2 = this.tabs[this.currentTabIndex];
            if (_local2.index != _arg_1.index) {
                _local2.setSelected(false);
                _arg_1.setSelected(true);
                this.showContent(_arg_1.index);
                this.tabSelected.dispatch(this.contents[_arg_1.index].name);
            }
        }
    }

    private function addTextTab(_arg_1:int, _arg_2:BaseSimpleText):TabTextView {
        var _local4:* = null;
        var _local3:Sprite = new TabBackground(2 * 60, 30);
        _local4 = new TabTextView(_arg_1, _local3, _arg_2);
        _local4.x = _arg_1 * (_arg_2.width + 12);
        _local4.y = 4;
        return _local4;
    }

    private function showContent(_arg_1:int):void {
        var _local2:* = null;
        var _local3:* = null;
        if (_arg_1 != this.currentTabIndex) {
            _local2 = this.contents[this.currentTabIndex];
            _local3 = this.contents[_arg_1];
            _local2.visible = false;
            _local3.visible = true;
            this.currentTabIndex = _arg_1;
        }
    }

    private function drawBackground():void {
        var _local1:GraphicsSolidFill = new GraphicsSolidFill(2368034, 1);
        var _local2:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        var _local3:Vector.<IGraphicsData> = new <IGraphicsData>[_local1, _local2, GraphicsUtil.END_FILL];
        GraphicsUtil.drawCutEdgeRect(0, 0, this._width, this._height - 27, 6, [1, 1, 1, 1], _local2);
        this.background.graphics.drawGraphicsData(_local3);
        this.background.y = 27;
        addChild(this.background);
    }

    private function onTabClicked(_arg_1:MouseEvent):void {
        this.selectTab(_arg_1.target.parent as TabView);
    }
}
}
