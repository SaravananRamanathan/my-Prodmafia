package com.company.assembleegameclient.ui.board {
    import com.company.assembleegameclient.ui.dialogs.Dialog;
    import com.company.util.MoreObjectUtil;
    
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    
    import kabam.rotmg.account.core.Account;
    import kabam.rotmg.appengine.api.AppEngineClient;
    import kabam.rotmg.core.StaticInjectorContext;
    
    public class GuildBoardWindow extends Sprite {
        
        public function GuildBoardWindow(editable: Boolean) {
            super();
            this.canEdit_ = editable;
            this.darkBox_ = new Shape();
            var guildBox: Graphics = this.darkBox_.graphics;
            guildBox.clear();
            guildBox.beginFill(0, 0.8);
            guildBox.drawRect(0, 0, 800, 10 * 60);
            guildBox.endFill();
            addChild(this.darkBox_);
            this.load();
        }
        
        private var canEdit_: Boolean;
        private var darkBox_: Shape;
        private var dialog_: Dialog;
        private var text_: String;
        private var viewBoard_: ViewBoard;
        private var editBoard_: EditBoard;
        private var client: AppEngineClient;
        
        private function load(): void {
            var account: Account = StaticInjectorContext.getInjector().getInstance(Account);
            this.client = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
            this.client.complete.addOnce(this.onGetBoardComplete);
            this.client.sendRequest("/guild/getBoard", account.getCredentials());
            this.dialog_ = new Dialog(null, "Loading...", null, null, null);
            addChild(this.dialog_);
            this.darkBox_.visible = false;
        }
        
        private function onGetBoardComplete(success: Boolean, result: *): void {
            if (success) {
                this.showGuildBoard(result);
            } else {
                this.reportError(result);
            }
        }
        
        private function showGuildBoard(boardText: String): void {
            this.darkBox_.visible = true;
            removeChild(this.dialog_);
            this.dialog_ = null;
            this.text_ = boardText;
            this.show();
        }
        
        private function show(): void {
            this.viewBoard_ = new ViewBoard(this.text_, this.canEdit_);
            this.viewBoard_.addEventListener("complete", this.onViewComplete, false, 0, true);
            this.viewBoard_.addEventListener("change", this.onViewChange, false, 0, true);
            addChild(this.viewBoard_);
        }
        
        private function reportError(_arg_1: String): void {
        }
        
        private function onSetBoardComplete(success: Boolean, result: *): void {
            if (success) {
                this.onSaveDone(result);
            } else {
                this.onSaveError(result);
            }
        }
        
        private function onSaveDone(newText: String): void {
            this.darkBox_.visible = true;
            removeChild(this.dialog_);
            this.dialog_ = null;
            this.text_ = newText;
            this.show();
        }
        
        private function onSaveError(event: String): void {
        }
        
        private function onViewComplete(event: Event): void {
            parent.removeChild(this);
        }
        
        private function onViewChange(event: Event): void {
            removeChild(this.viewBoard_);
            this.viewBoard_ = null;
            this.editBoard_ = new EditBoard(this.text_);
            this.editBoard_.addEventListener("cancel", this.onEditCancel, false, 0, true);
            this.editBoard_.addEventListener("complete", this.onEditComplete, false, 0, true);
            addChild(this.editBoard_);
        }
        
        private function onEditCancel(event: Event): void {
            removeChild(this.editBoard_);
            this.editBoard_ = null;
            this.show();
        }
        
        private function onEditComplete(event: Event): void {
            var account: Account = StaticInjectorContext.getInjector().getInstance(Account);
            var requestData: Object = {"board": this.editBoard_.getText()};
            MoreObjectUtil.addToObject(requestData, account.getCredentials());
            this.client = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
            this.client.complete.addOnce(this.onSetBoardComplete);
            this.client.sendRequest("/guild/setBoard", requestData);
            removeChild(this.editBoard_);
            this.editBoard_ = null;
            this.dialog_ = new Dialog(null, "Saving board...", null, null, null);
            addChild(this.dialog_);
            this.darkBox_.visible = false;
        }
    }
}
