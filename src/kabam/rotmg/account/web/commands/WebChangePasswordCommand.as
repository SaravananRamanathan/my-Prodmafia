package kabam.rotmg.account.web.commands {
import kabam.lib.tasks.BranchingTask;
import kabam.lib.tasks.DispatchSignalTask;
import kabam.lib.tasks.Task;
import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.account.core.services.ChangePasswordTask;
import kabam.rotmg.account.web.view.WebAccountDetailDialog;
import kabam.rotmg.core.service.TrackingData;
import kabam.rotmg.core.signals.TaskErrorSignal;
import kabam.rotmg.core.signals.TrackEventSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

public class WebChangePasswordCommand {


    public function WebChangePasswordCommand() {
        super();
    }
    [Inject]
    public var task:ChangePasswordTask;
    [Inject]
    public var monitor:TaskMonitor;
    [Inject]
    public var close:CloseDialogsSignal;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var loginError:TaskErrorSignal;
    [Inject]
    public var track:TrackEventSignal;

    public function execute():void {
        var _local1:BranchingTask = new BranchingTask(this.task, this.makeSuccess(), this.makeFailure());
        this.monitor.add(_local1);
        _local1.start();
    }

    private function makeSuccess():Task {
        var _local1:TaskSequence = new TaskSequence();
        _local1.add(new DispatchSignalTask(this.track, this.makeTrackingData()));
        _local1.add(new DispatchSignalTask(this.openDialog, new WebAccountDetailDialog()));
        return _local1;
    }

    private function makeFailure():Task {
        return new DispatchSignalTask(this.loginError, this.task);
    }

    private function makeTrackingData():TrackingData {
        var _local1:TrackingData = new TrackingData();
        _local1.category = "account";
        _local1.action = "passwordChanged";
        return _local1;
    }
}
}
