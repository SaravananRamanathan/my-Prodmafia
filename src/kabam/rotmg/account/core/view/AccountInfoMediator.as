package kabam.rotmg.account.core.view {
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
import kabam.rotmg.account.web.WebAccount;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.ui.signals.NameChangedSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class AccountInfoMediator extends Mediator {


    public function AccountInfoMediator() {
        super();
    }
    [Inject]
    public var account:Account;
    [Inject]
    public var view:AccountInfoView;
    [Inject]
    public var update:UpdateAccountInfoSignal;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var nameChanged:NameChangedSignal;

    override public function initialize():void {
        this.nameChanged.add(this.onNameChanged);
        this.view.setInfo(this.account.getUserName(), this.account.isRegistered());
        this.updateDisplayName();
        this.update.add(this.updateLogin);
    }

    override public function destroy():void {
        this.update.remove(this.updateLogin);
    }

    private function onNameChanged(_arg_1:String):void {
        this.updateDisplayName();
    }

    private function updateDisplayName():void {
        var _local1:* = null;
        var _local2:* = null;
        if (this.account is WebAccount) {
            _local2 = this.account as WebAccount;
            if (_local2 == null) {
                return;
            }
            _local1 = this.playerModel.getName();
            if (!_local1 && _local2.userDisplayName != null && _local2.userDisplayName.length > 0) {
                _local1 = _local2.userDisplayName;
            }
            this.view.setInfo(_local1, this.account.isRegistered());
        }
    }

    private function updateLogin():void {
        this.view.setInfo(this.account.getUserName(), this.account.isRegistered());
        this.updateDisplayName();
    }
}
}
