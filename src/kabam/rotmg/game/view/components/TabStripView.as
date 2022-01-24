package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.objects.ImageFactory;
import com.company.assembleegameclient.ui.icons.IconButtonFactory;
import com.company.ui.BaseSimpleText;
import com.company.util.GraphicsUtil;

import flash.display.Bitmap;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.MouseEvent;

import org.osflash.signals.Signal;

public class TabStripView extends Sprite {


    public const tabSelected:Signal = new Signal(String);

    public const WIDTH:Number = 186;

    public const HEIGHT:Number = 153;

    private const tabSprite:Sprite = new Sprite();

    private const background:Sprite = new Sprite();

    private const containerSprite:Sprite = new Sprite();

    public function TabStripView(_arg_1:Number = 186, _arg_2:Number = 153) {
        tabs = new Vector.<TabView>();
        contents = new Vector.<Sprite>();
        super();
        this._width = _arg_1;
        this._height = _arg_2;
        this.tabSprite.addEventListener("click", this.onTabClicked);
        addChild(this.tabSprite);
        this.drawBackground();
        addChild(this.containerSprite);
        this.containerSprite.y = 27;
    }
    public var iconButtonFactory:IconButtonFactory;
    public var imageFactory:ImageFactory;
    public var tabs:Vector.<TabView>;
    public var currentTabIndex:int;
    private var _width:Number;
    private var _height:Number;
    private var contents:Vector.<Sprite>;

    public function dispose():void {
        this.tabSprite.removeEventListener("click", this.onTabClicked);
        this.tabs.length = 0;
        this.contents.length = 0;
    }

    public function setSelectedTab(_arg_1:uint):void {
        this.selectTab(this.tabs[_arg_1]);
    }

    public function getTabView(_arg_1:Class):* {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.contents;
        for each(_local2 in this.contents) {
            if (_local2 is _arg_1) {
                return _local2 as _arg_1;
            }
        }
        return null;
    }

    public function drawBackground():void {
        var _local3:GraphicsSolidFill = new GraphicsSolidFill(2368034, 1);
        var _local2:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        var _local1:Vector.<IGraphicsData> = new <IGraphicsData>[_local3, _local2, GraphicsUtil.END_FILL];
        GraphicsUtil.drawCutEdgeRect(0, 0, this._width, this._height - 27, 6, [1, 1, 1, 1], _local2);
        this.background.graphics.drawGraphicsData(_local1);
        this.background.y = 27;
        addChild(this.background);
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

    public function addTab(_arg_1:*, _arg_2:Sprite):void {
        var _local3:* = null;
        var _local4:int = this.tabs.length;
        if (_arg_1 is Bitmap) {
            _local3 = this.addIconTab(_local4, _arg_1 as Bitmap);
        } else if (_arg_1 is BaseSimpleText) {
            _local3 = this.addTextTab(_local4, _arg_1 as BaseSimpleText);
        }
        this.tabs.push(_local3);
        this.tabSprite.addChild(_local3);
        this.contents.push(_arg_2);
        this.containerSprite.addChild(_arg_2);
        if (_local4 > 0) {
            _arg_2.visible = false;
        } else {
            _local3.setSelected(true);
            this.showContent(0);
            this.tabSelected.dispatch(_arg_2.name);
        }
    }

    public function removeTab():void {
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

    private function addIconTab(_arg_1:int, _arg_2:Bitmap):TabIconView {
        var _local3:* = null;
        var _local4:Sprite = new TabBackground();
        _local3 = new TabIconView(_arg_1, _local4, _arg_2);
        _local3.x = _arg_1 * (_local4.width + 2);
        _local3.y = 8;
        return _local3;
    }

    private function addTextTab(_arg_1:int, _arg_2:BaseSimpleText):TabTextView {
        var _local4:Sprite = new TabBackground();
        var _local3:TabTextView = new TabTextView(_arg_1, _local4, _arg_2);
        _local3.x = _arg_1 * (_local4.width + 2);
        _local3.y = 8;
        return _local3;
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

    private function onTabClicked(_arg_1:MouseEvent):void {
        this.selectTab(_arg_1.target.parent as TabView);
    }
}
}
