package io.decagames.rotmg.social.widgets {
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui.icons.IconButton;
    import com.company.assembleegameclient.util.TimeUtil;
    
    import flash.events.Event;
    
    import io.decagames.rotmg.social.model.FriendVO;
    
    public class FriendListItem extends BaseListItem {
        
        
        public function FriendListItem(_arg_1: FriendVO, _arg_2: int) {
            super(_arg_2);
            this._vo = _arg_1;
            this.init();
        }
        
        public var teleportButton: IconButton;
        public var messageButton: IconButton;
        public var removeButton: IconButton;
        public var acceptButton: IconButton;
        public var rejectButton: IconButton;
        public var blockButton: IconButton;
        
        private var _vo: FriendVO;
        
        public function get vo(): FriendVO {
            return this._vo;
        }
        
        override protected function init(): void {
            super.init();
            addEventListener("removedFromStage", this.onRemoved);
            this.setState();
            createListLabel(this._vo.getName());
            createListPortrait(this._vo.getPortrait());
        }
        
        private function setState(): void {
            var _local2: * = null;
            var _local3: * = null;
            var _local1: * = null;
            switch (int(_state) - 1) {
            case 0:
                _local2 = this._vo.getServerName();
                _local3 = !!Parameters.data.preferredServer ? Parameters.data.preferredServer : Parameters.data.bestServer;
                if (_local3 != _local2) {
                    _local1 = "Your friend is playing on server: " + _local2 + ". " + "Clicking this will take you to this server.";
                    this.teleportButton = addButton("lofiInterface2", 3, 230, 12, "Friend.TeleportTitle", _local1);
                }
                this.messageButton = addButton("lofiInterfaceBig", 21, 255, 12, "PlayerMenu.PM");
                this.removeButton = addButton("lofiInterfaceBig", 12, 280, 12, "Friend.RemoveRight");
                return;
            case 1:
                hoverTooltipDelegate.setDisplayObject(_characterContainer);
                setToolTipTitle("Last Seen:");
                setToolTipText(TimeUtil.humanReadableTime(this._vo.lastLogin) + " ago!");
                this.removeButton = addButton("lofiInterfaceBig", 12, 280, 12, "Friend.RemoveRight", "Friend.RemoveRightDesc");
                return;
            case 2:
                this.acceptButton = addButton("lofiInterfaceBig", 11, 230, 12, "Guild.accept");
                this.rejectButton = addButton("lofiInterfaceBig", 12, 255, 12, "Guild.rejection");
                this.blockButton = addButton("lofiInterfaceBig", 8, 280, 12, "Friend.BlockRight", "Friend.BlockRightDesc");
            }
        }
        
        private function onRemoved(_arg_1: Event): void {
            removeEventListener("removedFromStage", this.onRemoved);
            this.teleportButton && this.teleportButton.destroy();
            this.messageButton && this.messageButton.destroy();
            this.removeButton && this.removeButton.destroy();
            this.acceptButton && this.acceptButton.destroy();
            this.rejectButton && this.rejectButton.destroy();
        }
    }
}
