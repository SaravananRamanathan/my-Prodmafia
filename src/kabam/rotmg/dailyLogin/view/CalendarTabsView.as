package kabam.rotmg.dailyLogin.view {
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.geom.Rectangle;

public class CalendarTabsView extends Sprite {


    public function CalendarTabsView() {
        fill_ = new GraphicsSolidFill(0x363636, 1);
        fillTransparent_ = new GraphicsSolidFill(0x363636, 0);
        lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xffffff));
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        graphicsDataBackgroundTransparent = new <IGraphicsData>[lineStyle_, fillTransparent_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
    }
    private var fill_:GraphicsSolidFill;
    private var fillTransparent_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var path_:GraphicsPath;
    private var graphicsDataBackgroundTransparent:Vector.<IGraphicsData>;
    private var modalRectangle:Rectangle;
    private var tabs:Vector.<CalendarTabButton>;
    private var calendar:CalendarView;

    public function init(_arg_1:Rectangle):void {
        this.modalRectangle = _arg_1;
        this.tabs = new Vector.<CalendarTabButton>();
    }

    public function addCalendar(_arg_1:String, _arg_2:String, _arg_3:String):CalendarTabButton {
        var _local4:* = null;
        _local4 = new CalendarTabButton(_arg_1, _arg_3, _arg_2, "idle", this.tabs.length);
        this.addChild(_local4);
        _local4.x = 199 * this.tabs.length;
        this.tabs.push(_local4);
        return _local4;
    }

    public function selectTab(_arg_1:String):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.tabs;
        for each(_local2 in this.tabs) {
            if (_local2.calendarType == _arg_1) {
                _local2.state = "selected";
            } else {
                _local2.state = "idle";
            }
        }
        if (this.calendar) {
            removeChild(this.calendar);
        }
        this.calendar = new CalendarView();
        addChild(this.calendar);
        this.calendar.x = 10;
    }

    public function drawTabs():void {
        this.drawBorder();
    }

    private function drawBorder():void {
        var _local1:Sprite = new Sprite();
        this.drawRectangle(_local1, this.modalRectangle.width, this.modalRectangle.height);
        addChild(_local1);
        _local1.y = 30;
    }

    private function drawRectangle(_arg_1:Sprite, _arg_2:int, _arg_3:int):void {
        _arg_1.addChild(CalendarDayBox.drawRectangleWithCuts([0, 0, 1, 1], _arg_2, _arg_3, 0x363636, 1, this.graphicsDataBackgroundTransparent, this.path_));
    }
}
}
