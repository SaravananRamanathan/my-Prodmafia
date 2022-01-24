package kabam.rotmg.legends.view {
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.legends.model.Legend;
import kabam.rotmg.legends.model.Timespan;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.components.ScreenBase;

import org.osflash.signals.Signal;

public class LegendsView extends Sprite {


    public const timespanChanged:Signal = new Signal(Timespan);

    public const showDetail:Signal = new Signal(Legend);

    public const close:Signal = new Signal();

    private const items:Vector.<LegendListItem> = new Vector.<LegendListItem>(0);

    private const tabs:Object = {};

    public function LegendsView() {
        super();
        this.makeScreenBase();
        this.makeTitleText();
        this.makeLoadingBanner();
        this.makeNoLegendsBanner();
        this.makeMainContainer();
        this.makeScreenGraphic();
        this.makeLines();
        this.makeScrollbar();
        this.makeTimespanTabs();
        this.makeCloseButton();
    }
    private var title:TextFieldDisplayConcrete;
    private var loadingBanner:TextFieldDisplayConcrete;
    private var noLegendsBanner:TextFieldDisplayConcrete;
    private var mainContainer:Sprite;
    private var closeButton:TitleMenuOption;
    private var scrollBar:Scrollbar;
    private var listContainer:Sprite;
    private var selectedTab:LegendsTab;
    private var legends:Vector.<Legend>;
    private var count:int;

    public function clear():void {
        this.listContainer && this.clearLegendsList();
        this.listContainer = null;
        this.scrollBar.visible = false;
    }

    public function setLegendsList(_arg_1:Timespan, _arg_2:Vector.<Legend>):void {
        this.clear();
        this.updateTabs(this.tabs[_arg_1.getId()]);
        this.listContainer = new Sprite();
        this.legends = _arg_2;
        this.count = _arg_2.length;
        this.items.length = this.count;
        this.noLegendsBanner.visible = this.count == 0;
        this.makeItemsFromLegends();
        this.mainContainer.addChild(this.listContainer);
        this.updateScrollbar();
    }

    public function showLoading():void {
        this.loadingBanner.visible = true;
    }

    public function hideLoading():void {
        this.loadingBanner.visible = false;
    }

    private function makeScreenBase():void {
        addChild(new ScreenBase());
    }

    private function makeTitleText():void {
        this.title = new TextFieldDisplayConcrete().setSize(32).setColor(0xb3b3b3);
        this.title.setAutoSize("center");
        this.title.setBold(true);
        this.title.setStringBuilder(new LineBuilder().setParams("Screens.legends"));
        this.title.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.title.x = 400 - this.title.width / 2;
        this.title.y = 24;
        addChild(this.title);
    }

    private function makeLoadingBanner():void {
        this.loadingBanner = new TextFieldDisplayConcrete().setSize(22).setColor(0xb3b3b3);
        this.loadingBanner.setBold(true);
        this.loadingBanner.setAutoSize("center").setVerticalAlign("middle");
        this.loadingBanner.setStringBuilder(new LineBuilder().setParams("Loading.text"));
        this.loadingBanner.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.loadingBanner.x = 400;
        this.loadingBanner.y = 5 * 60;
        this.loadingBanner.visible = false;
        addChild(this.loadingBanner);
    }

    private function makeNoLegendsBanner():void {
        this.noLegendsBanner = new TextFieldDisplayConcrete().setSize(22).setColor(0xb3b3b3);
        this.noLegendsBanner.setBold(true);
        this.noLegendsBanner.setAutoSize("center").setVerticalAlign("middle");
        this.noLegendsBanner.setStringBuilder(new LineBuilder().setParams("Legends.EmptyList"));
        this.noLegendsBanner.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.noLegendsBanner.x = 400;
        this.noLegendsBanner.y = 5 * 60;
        this.noLegendsBanner.visible = false;
        addChild(this.noLegendsBanner);
    }

    private function makeMainContainer():void {
        var _local1:* = null;
        _local1 = new Shape();
        var _local2:Graphics = _local1.graphics;
        _local2.beginFill(0);
        _local2.drawRect(0, 0, 756, 430);
        _local2.endFill();
        this.mainContainer = new Sprite();
        this.mainContainer.x = 10;
        this.mainContainer.y = 110;
        this.mainContainer.addChild(_local1);
        this.mainContainer.mask = _local1;
        addChild(this.mainContainer);
    }

    private function makeScreenGraphic():void {
        addChild(new ScreenGraphic());
    }

    private function makeLines():void {
        var _local1:Shape = new Shape();
        addChild(_local1);
        var _local2:Graphics = _local1.graphics;
        _local2.lineStyle(2, 0x545454);
        _local2.moveTo(0, 100);
        _local2.lineTo(800, 100);
    }

    private function makeScrollbar():void {
        this.scrollBar = new Scrollbar(16, 400);
        this.scrollBar.x = 800 - this.scrollBar.width - 4;
        this.scrollBar.y = 104;
        addChild(this.scrollBar);
    }

    private function makeTimespanTabs():void {
        var _local1:int = 0;
        var _local3:Vector.<Timespan> = Timespan.TIMESPANS;
        var _local2:int = _local3.length;
        while (_local1 < _local2) {
            this.makeTab(_local3[_local1], _local1);
            _local1++;
        }
    }

    private function makeTab(_arg_1:Timespan, _arg_2:int):LegendsTab {
        var _local3:LegendsTab = new LegendsTab(_arg_1);
        this.tabs[_arg_1.getId()] = _local3;
        _local3.x = 20 + _arg_2 * 90;
        _local3.y = 70;
        _local3.selected.add(this.onTabSelected);
        addChild(_local3);
        return _local3;
    }

    private function onTabSelected(_arg_1:LegendsTab):void {
        if (this.selectedTab != _arg_1) {
            this.updateTabAndSelectTimespan(_arg_1);
        }
    }

    private function updateTabAndSelectTimespan(_arg_1:LegendsTab):void {
        this.updateTabs(_arg_1);
        this.timespanChanged.dispatch(this.selectedTab.getTimespan());
    }

    private function updateTabs(_arg_1:LegendsTab):void {
        this.selectedTab && this.selectedTab.setIsSelected(false);
        this.selectedTab = _arg_1;
        this.selectedTab.setIsSelected(true);
    }

    private function makeCloseButton():void {
        this.closeButton = new TitleMenuOption("Done.text", 36, false);
        this.closeButton.setAutoSize("center");
        this.closeButton.setVerticalAlign("middle");
        this.closeButton.x = 400;
        this.closeButton.y = 553;
        addChild(this.closeButton);
        this.closeButton.addEventListener("click", this.onCloseClick);
    }

    private function clearLegendsList():void {
        var _local1:* = null;
        var _local3:int = 0;
        var _local2:* = this.items;
        for each(_local1 in this.items) {
            _local1.selected.remove(this.onItemSelected);
        }
        this.items.length = 0;
        this.mainContainer.removeChild(this.listContainer);
        this.listContainer = null;
    }

    private function makeItemsFromLegends():void {
        var _local1:int = 0;
        while (_local1 < this.count) {
            this.items[_local1] = this.makeItemFromLegend(_local1);
            _local1++;
        }
    }

    private function makeItemFromLegend(_arg_1:int):LegendListItem {
        var _local2:Legend = this.legends[_arg_1];
        var _local3:LegendListItem = new LegendListItem(_local2);
        _local3.y = _arg_1 * 56;
        _local3.selected.add(this.onItemSelected);
        this.listContainer.addChild(_local3);
        return _local3;
    }

    private function updateScrollbar():void {
        if (this.listContainer.height > 400) {
            this.scrollBar.visible = true;
            this.scrollBar.setIndicatorSize(400, this.listContainer.height);
            this.scrollBar.addEventListener("change", this.onScrollBarChange);
            this.positionScrollbarToDisplayFocussedLegend();
        } else {
            this.scrollBar.removeEventListener("change", this.onScrollBarChange);
            this.scrollBar.visible = false;
        }
    }

    private function positionScrollbarToDisplayFocussedLegend():void {
        var _local2:int = 0;
        var _local1:int = 0;
        var _local3:Legend = this.getLegendFocus();
        if (_local3) {
            _local2 = this.legends.indexOf(_local3);
            _local1 = (_local2 + 0.5) * 56;
            this.scrollBar.setPos((_local1 - 200) / (this.listContainer.height - 400));
        }
    }

    private function getLegendFocus():Legend {
        var _local1:* = null;
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.legends;
        for each(_local2 in this.legends) {
            if (_local2.isFocus) {
                _local1 = _local2;
                break;
            }
        }
        return _local1;
    }

    private function onItemSelected(_arg_1:Legend):void {
        this.showDetail.dispatch(_arg_1);
    }

    private function onCloseClick(_arg_1:MouseEvent):void {
        this.close.dispatch();
    }

    private function onScrollBarChange(_arg_1:Event):void {
        this.listContainer.y = -this.scrollBar.pos() * (this.listContainer.height - 400);
    }
}
}
