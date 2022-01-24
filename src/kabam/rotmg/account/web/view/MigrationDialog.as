package kabam.rotmg.account.web.view {
import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.view.EmptyFrame;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.appengine.impl.SimpleAppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.util.components.SimpleButton;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class MigrationDialog extends EmptyFrame {


    public function MigrationDialog(_arg_1:Account, _arg_2:Number) {
        timerProgressCheck = new Timer(2000, 0);
        super(500, 220, "Maintenance Needed");
        this.isClosed = false;
        setDesc("Press OK to begin maintenance on \n\n" + _arg_1.getUserName() + "\n\nor cancel to login with a different account", true);
        this.makeAndAddLeftButton("Cancel");
        this.makeAndAddRightButton("OK");
        this.account = _arg_1;
        this.status = _arg_2;
        this.client = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        this.okButton = new NativeMappedSignal(this.rightButton_, "click");
        cancel = new NativeMappedSignal(this.leftButton_, "click");
        this.done = new Signal();
        this.okButton.addOnce(this.okButton_doMigrate);
        this.done.addOnce(this.closeMyself);
        cancel.addOnce(this.removeMigrateCallback);
        cancel.addOnce(this.closeMyself);
    }
    public var done:Signal;
    protected var leftButton_:SimpleButton;
    protected var rightButton_:SimpleButton;
    private var okButton:Signal;
    private var account:Account;
    private var client:AppEngineClient;
    private var progressCheckClient:AppEngineClient;
    private var lastPercent:Number = 0;
    private var total:Number = 100;
    private var progBar:ProgressBar;
    private var timerProgressCheck:Timer;
    private var status:Number = 0;
    private var isClosed:Boolean;

    private function okButton_doMigrate():void {
        var _local1:* = null;
        this.rightButton_.setEnabled(false);
        if (this.status == 1) {
            _local1 = this.account.getCredentials();
            this.client.complete.addOnce(this.onMigrateStartComplete);
            this.client.sendRequest("/migrate/doMigration", _local1);
        }
    }

    private function startPercentLoop():void {
        this.timerProgressCheck.addEventListener("timer", this.percentLoop);
        if (this.progressCheckClient == null) {
            this.progressCheckClient = StaticInjectorContext.getInjector().getInstance(SimpleAppEngineClient);
        }
        this.timerProgressCheck.start();
        this.updatePercent(0);
    }

    private function stopPercentLoop():void {
        this.updatePercent(100);
        this.timerProgressCheck.stop();
        this.timerProgressCheck.removeEventListener("timer", this.percentLoop);
    }

    private function onUpdateStatusComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local6:* = null;
        var _local4:* = null;
        var _local3:Number = NaN;
        var _local5:Number = NaN;
        if (_arg_1) {
            if (this.isClosed == true) {
                return;
            }
            _local6 = new XML(_arg_2);
            if ("Percent" in _local6) {
                _local4 = _local6.Percent;
                _local3 = parseFloat(_local4);
                if (_local3 == 100) {
                    if (this.isClosed == false) {
                        this.stopPercentLoop();
                        this.updatePercent(_local3);
                        this.done.dispatch();
                    }
                } else if (_local3 != this.lastPercent) {
                    this.updatePercent(_local3);
                }
            } else if ("MigrateStatus" in _local6) {
                _local5 = _local6.MigrateStatus;
                if (_local5 == 44) {
                    this.stopPercentLoop();
                    this.reset();
                }
            }
        }
    }

    private function updatePercent(_arg_1:Number):void {
        this.progBar.update(_arg_1);
        this.lastPercent = _arg_1;
        setDesc("" + _arg_1 + "%", true);
    }

    private function onMigrateStartComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local4:* = null;
        var _local3:Number = NaN;
        if (this.isClosed) {
            return;
        }
        if (_arg_1) {
            _local4 = new XML(_arg_2);
            if ("MigrateStatus" in _local4) {
                _local3 = _local4.MigrateStatus;
                if (_local3 == 44) {
                    this.stopPercentLoop();
                    this.reset();
                } else if (_local3 == 4) {
                    this.addProgressBar();
                    setTitle("Migration In Progress", true);
                    this.startPercentLoop();
                } else {
                    this.stopPercentLoop();
                    this.reset();
                }
            }
        } else {
            this.stopPercentLoop();
            this.reset();
        }
    }

    private function reset():void {
        setTitle("Error, please try again. Maintenance needed", true);
        setDesc("Press OK to begin maintenance on \n\n" + this.account.getUserName() + "\n\nor cancel to login with a different account", true);
        this.removeProgressBar();
        this.okButton.addOnce(this.okButton_doMigrate);
        this.rightButton_.setEnabled(true);
    }

    private function addProgressBar():void {
        var _local2:Number = NaN;
        this.removeProgressBar();
        _local2 = modalHeight / 3;
        var _local1:Number = modalWidth - 40;
        this.progBar = new ProgressBar(_local1, 40);
        addChild(this.progBar);
        this.progBar.x = 20;
        this.progBar.y = _local2;
    }

    private function removeProgressBar():void {
        if (this.progBar != null && this.progBar.parent != null) {
            removeChild(this.progBar);
        }
    }

    private function removeMigrateCallback():void {
        this.done.removeAll();
    }

    private function closeMyself():void {
        this.isClosed = true;
        var _local1:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
        _local1.dispatch();
    }

    private function makeAndAddLeftButton(_arg_1:String):void {
        this.leftButton_ = new SimpleButton(_arg_1);
        if (_arg_1 != "") {
            this.leftButton_.buttonMode = true;
            addChild(this.leftButton_);
            this.leftButton_.x = modalWidth / 2 - 100 - this.leftButton_.width;
            this.leftButton_.y = modalHeight - 50;
        }
    }

    private function makeAndAddRightButton(_arg_1:String):void {
        this.rightButton_ = new SimpleButton(this.leftButton_.text.text);
        this.rightButton_.freezeSize();
        this.rightButton_.setText(_arg_1);
        if (_arg_1 != "") {
            this.rightButton_.buttonMode = true;
            addChild(this.rightButton_);
            this.rightButton_.x = modalWidth / 2 + 100;
            this.rightButton_.y = modalHeight - 50;
        }
    }

    private function percentLoop(_arg_1:TimerEvent):void {
        var _local2:Object = this.account.getCredentials();
        this.progressCheckClient.complete.addOnce(this.onUpdateStatusComplete);
        this.progressCheckClient.sendRequest("/migrate/progress", _local2);
    }
}
}
