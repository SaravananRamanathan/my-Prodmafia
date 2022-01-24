package kabam.rotmg.dialogs.model {
import com.company.assembleegameclient.parameters.Parameters;

import org.osflash.signals.Signal;

public class DialogsModel {


    public function DialogsModel() {
        popupPriority = ["beginners_offer_popup", "news_popup", "daily_login_popup", "packages_offer_popup"];
        queue = new Vector.<PopupQueueEntry>();
        super();
    }
    private var popupPriority:Array;
    private var queue:Vector.<PopupQueueEntry>;

    public function addPopupToStartupQueue(_arg_1:String, _arg_2:Signal, _arg_3:int, _arg_4:Object):void {
        if (_arg_3 == -1 || this.canDisplayPopupToday(_arg_1)) {
            this.queue.push(new PopupQueueEntry(_arg_1, _arg_2, _arg_3, _arg_4));
            this.sortQueue();
        }
    }

    public function flushStartupQueue():PopupQueueEntry {
        if (this.queue.length == 0) {
            return null;
        }
        var _local1:PopupQueueEntry = this.queue.shift();
        Parameters.data[_local1.name] = new Date().time;
        return _local1;
    }

    public function canDisplayPopupToday(_arg_1:String):Boolean {
        var _local2:int = 0;
        var _local3:int = 0;
        if (!Parameters.data[_arg_1]) {
            return true;
        }
        _local2 = Math.floor(Parameters.data[_arg_1] / 86400000);
        _local3 = Math.floor(new Date().time / 86400000);
        return _local3 > _local2;
    }

    public function getPopupPriorityByName(_arg_1:String):int {
        var _local2:int = this.popupPriority.indexOf(_arg_1);
        if (_local2 < 0) {
            _local2 = 0x7fffffff;
        }
        return _local2;
    }

    private function sortQueue():void {
        this.queue.sort(function (param1:PopupQueueEntry, param2:PopupQueueEntry):int {
            var _local4:int = getPopupPriorityByName(param1.name);
            var _local3:int = getPopupPriorityByName(param2.name);
            if (_local4 < _local3) {
                return -1;
            }
            return 1;
        });
    }
}
}
