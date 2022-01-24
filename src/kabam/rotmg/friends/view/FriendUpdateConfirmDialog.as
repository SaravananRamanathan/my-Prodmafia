package kabam.rotmg.friends.view {
import com.company.assembleegameclient.ui.dialogs.CloseDialogComponent;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.dialogs.DialogCloser;

import flash.events.Event;

import io.decagames.rotmg.social.model.FriendRequestVO;
import io.decagames.rotmg.social.signals.FriendActionSignal;

import kabam.rotmg.core.StaticInjectorContext;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class FriendUpdateConfirmDialog extends Dialog implements DialogCloser {


    private const closeDialogComponent:CloseDialogComponent = new CloseDialogComponent();

    public function FriendUpdateConfirmDialog(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:FriendRequestVO, _arg_6:Object = null) {
        super(_arg_1, _arg_2, _arg_3, _arg_4, null, _arg_6);
        this._friendRequestVO = _arg_5;
        this.closeDialogComponent.add(this, "dialogRightButton");
        this.closeDialogComponent.add(this, "dialogLeftButton");
        addEventListener("dialogRightButton", this.onRightButton);
    }
    private var _friendRequestVO:FriendRequestVO;

    public function getCloseSignal():Signal {
        return this.closeDialogComponent.getCloseSignal();
    }

    private function onRightButton(_arg_1:Event):void {
        removeEventListener("dialogRightButton", this.onRightButton);
        var _local2:Injector = StaticInjectorContext.getInjector();
        var _local3:FriendActionSignal = _local2.getInstance(FriendActionSignal);
        _local3.dispatch(this._friendRequestVO);
    }
}
}
