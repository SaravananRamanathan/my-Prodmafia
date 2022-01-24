package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeSignal;

public class StatView extends Sprite {

    public const DEFAULT_FILTER:DropShadowFilter = new DropShadowFilter(0, 0, 0);
    public static var toMaxTextSignal:Signal = new Signal(Boolean);

    public function StatView(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean) {
        toolTip_ = new TextToolTip(0x363636, 0x9b9b9b, "", "", 200);
        super();
        this.fullName_ = _arg_2;
        this.description_ = _arg_3;
        this.nameText_ = new TextFieldDisplayConcrete().setSize(13).setColor(0xb3b3b3);
        this.nameText_.setStringBuilder(new LineBuilder().setParams(_arg_1));
        this.configureTextAndAdd(this.nameText_);
        this.valText_ = new TextFieldDisplayConcrete().setSize(13).setColor(this.valColor_).setBold(true);
        this.valText_.setStringBuilder(new StaticStringBuilder("-"));
        this.configureTextAndAdd(this.valText_);
        this.redOnZero_ = _arg_4;
        this.mouseOver = new NativeSignal(this, "mouseOver", MouseEvent);
        this.mouseOut = new NativeSignal(this, "mouseOut", MouseEvent);
        toMaxTextSignal.add(this.setNewText);
    }
    public var fullName_:String;
    public var description_:String;
    public var nameText_:TextFieldDisplayConcrete;
    public var valText_:TextFieldDisplayConcrete;
    public var redOnZero_:Boolean;
    public var val_:int = -1;
    public var boost_:int = -1;
    public var max_:int = -1;
    public var valColor_:uint = 11776947;
    public var level_:int = 0;
    public var toolTip_:TextToolTip;
    public var mouseOver:NativeSignal;
    public var mouseOut:NativeSignal;

    public function configureTextAndAdd(_arg_1:TextFieldDisplayConcrete):void {
        _arg_1.setAutoSize("left");
        _arg_1.filters = [DEFAULT_FILTER];
        addChild(_arg_1);
    }

    public function addTooltip():void {
        this.toolTip_.setTitle(new LineBuilder().setParams(this.fullName_));
        this.toolTip_.setText(new LineBuilder().setParams(this.description_));
        if (!stage.contains(this.toolTip_)) {
            stage.addChild(this.toolTip_);
        }
    }

    public function removeTooltip():void {
        if (this.toolTip_.parent != null) {
            this.toolTip_.parent.removeChild(this.toolTip_);
        }
    }

    public function draw(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int = 0):void {
        var _local5:int = 0;
        if (_arg_4 == this.level_ && _arg_1 == this.val_ && _arg_2 == this.boost_) {
            return;
        }
        this.val_ = _arg_1;
        this.boost_ = _arg_2;
        this.max_ = _arg_3;
        this.level_ = _arg_4;
        if (_arg_1 - _arg_2 >= _arg_3) {
            _local5 = 16572160;
        } else if (this.redOnZero_ && this.val_ <= 0 || this.boost_ < 0) {
            _local5 = 16726072;
        } else if (this.boost_ > 0) {
            _local5 = 6206769;
        } else {
            _local5 = 0xb3b3b3;
        }
        if (this.valColor_ != _local5) {
            this.valColor_ = _local5;
            this.valText_.setColor(this.valColor_);
        }
        this.setNewText(Parameters.data.toggleToMaxText);
    }

    public function setNewText(_arg_1:Boolean):void {
        var _local3:int = 0;
        var _local2:String = this.val_.toString();
        if (_arg_1) {
            _local3 = this.max_ - (this.val_ - this.boost_);
            if (this.level_ >= 20 && _local3 > 0) {
                _local2 = _local2 + ("|" + _local3.toString());
            }
        }
        if (this.boost_ != 0) {
            _local2 = _local2 + (" (" + (this.boost_ > 0 ? "+" : "") + this.boost_.toString() + ")");
        }
        this.valText_.setStringBuilder(new StaticStringBuilder(_local2));
        this.valText_.x = 24;
    }
}
}
