package kabam.rotmg.dailyLogin.view {
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

public class CalendarTabButton extends Sprite {

    public static const STATE_SELECTED:String = "selected";

    public static const STATE_IDLE:String = "idle";

    public function CalendarTabButton(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:int) {
        path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        fill_ = new GraphicsSolidFill(0x363636, 1);
        fillIdle_ = new GraphicsSolidFill(0x222222, 1);
        lineStyle_ = new GraphicsStroke(2, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xffffff));
        graphicsDataBackground = new <IGraphicsData>[lineStyle_, fill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        graphicsDataBackgroundIdle = new <IGraphicsData>[lineStyle_, fillIdle_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];
        super();
        this._calendarType = _arg_3;
        this.tabName = _arg_1;
        this.hintText = _arg_2;
        this.drawTab();
        this.addEventListener("added", this.onAddedHandler);
    }
    private var path_:GraphicsPath;
    private var fill_:GraphicsSolidFill;
    private var fillIdle_:GraphicsSolidFill;
    private var lineStyle_:GraphicsStroke;
    private var graphicsDataBackground:Vector.<IGraphicsData>;
    private var graphicsDataBackgroundIdle:Vector.<IGraphicsData>;
    private var state_:String = "idle";
    private var tabNameTxt:TextFieldDisplayConcrete;
    private var background:Sprite;
    private var tabName:String;
    private var hintText:String;
    private var tooltip:DailyCalendarInfoIcon;

    private var _calendarType:String;

    public function get calendarType():String {
        return this._calendarType;
    }

    public function set state(_arg_1:String):void {
        if (_arg_1 != this.state_) {
            this.state_ = _arg_1;
            this.drawTab();
        }
    }

    private function drawTab():void {
        if (this.background) {
            removeChild(this.background);
        }
        if (this.tooltip) {
            removeChild(this.tooltip);
        }
        this.background = CalendarDayBox.drawRectangleWithCuts([1, 1, 0, 0], 200, 30, 0x363636, 1, this.state_ == "idle" ? this.graphicsDataBackgroundIdle : this.graphicsDataBackground, this.path_);
        this.addChild(this.background);
        if (this.tabNameTxt) {
            removeChild(this.tabNameTxt);
        }
        this.tabNameTxt = new TextFieldDisplayConcrete().setSize(16).setColor(this.state_ == "idle" ? 0xffffff : 16768512).setTextWidth(200).setAutoSize("center");
        this.tabNameTxt.setStringBuilder(new StaticStringBuilder(this.tabName));
        this.tabNameTxt.y = 7;
        this.tooltip = new DailyCalendarInfoIcon(this.tabName, this.hintText);
        this.tooltip.x = 185;
        this.tooltip.y = 5;
        addChild(this.tooltip);
        if (this.state_ == "idle") {
            this.tabNameTxt.alpha = 0.5;
        }
        this.addChild(this.tabNameTxt);
    }

    private function onAddedHandler(_arg_1:Event):void {
        this.removeEventListener("added", this.onAddedHandler);
        this.addEventListener("removedFromStage", this.onRemovedFromStage);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        this.removeEventListener("removedFromStage", this.onRemovedFromStage);
    }
}
}
