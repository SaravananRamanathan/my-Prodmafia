package io.decagames.rotmg.social {
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    import io.decagames.rotmg.social.widgets.FriendListItem;
    import io.decagames.rotmg.social.widgets.GuildInfoItem;
    import io.decagames.rotmg.social.widgets.GuildListItem;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import io.decagames.rotmg.ui.gird.UIGrid;
    import io.decagames.rotmg.ui.gird.UIGridElement;
    import io.decagames.rotmg.ui.labels.UILabel;
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import io.decagames.rotmg.ui.tabs.TabButton;
    import io.decagames.rotmg.ui.tabs.UITab;
    import io.decagames.rotmg.ui.tabs.UITabs;
    import io.decagames.rotmg.ui.textField.InputTextField;
    import io.decagames.rotmg.ui.texture.TextureParser;
    
    public class SocialPopupView extends ModalPopup {
        
        public static const SOCIAL_LABEL: String = "Social";
        
        public static const FRIEND_TAB_LABEL: String = "Friends";
        
        public static const GUILD_TAB_LABEL: String = "Guild";
        
        public static const MAX_VISIBLE_INVITATIONS: int = 3;
        
        public static const DEFAULT_NO_GUILD_MESSAGE: String = "You have not yet joined a Guild,\njoin a Guild to find Players to play with or\n create your own Guild.";
        
        public function SocialPopupView() {
            super(350, 505, "Social", DefaultLabelFormat.defaultSmallPopupTitle, new Rectangle(0, 0, 350, 565));
            this.init();
        }
        
        public var search: InputTextField;
        public var addButton: SliceScalingButton;
        private var contentInset: SliceScalingBitmap;
        private var friendsGrid: UIGrid;
        private var guildsGrid: UIGrid;
        private var _tabContent: Sprite;
        
        private var _tabs: UITabs;
        
        public function get tabs(): UITabs {
            return this._tabs;
        }
        
        public function addFriendCategory(_arg_1: String): void {
            var _local3: * = null;
            var _local2: UIGridElement = new UIGridElement();
            _local3 = new UILabel();
            _local3.text = _arg_1;
            DefaultLabelFormat.defaultSmallPopupTitle(_local3);
            _local2.addChild(_local3);
            this.friendsGrid.addGridElement(_local2);
        }
        
        public function addFriend(_arg_1: FriendListItem): void {
            var _local2: UIGridElement = new UIGridElement();
            _local2.addChild(_arg_1);
            this.friendsGrid.addGridElement(_local2);
        }
        
        public function addGuildInfo(_arg_1: GuildInfoItem): void {
            var _local2: * = null;
            _local2 = new UIGridElement();
            _local2.addChild(_arg_1);
            _local2.x = (_contentWidth - _local2.width) / 2;
            _local2.y = 10;
            this._tabContent.addChild(_local2);
        }
        
        public function addGuildCategory(_arg_1: String): void {
            var _local2: UIGridElement = new UIGridElement();
            var _local3: UILabel = new UILabel();
            _local3.text = _arg_1;
            DefaultLabelFormat.defaultSmallPopupTitle(_local3);
            _local2.addChild(_local3);
            this.guildsGrid.addGridElement(_local2);
        }
        
        public function addGuildDefaultMessage(_arg_1: String): void {
            var _local2: * = null;
            var _local3: * = null;
            _local2 = new UIGridElement();
            _local3 = new UILabel();
            _local3.width = 5 * 60;
            _local3.multiline = true;
            _local3.wordWrap = true;
            _local3.text = _arg_1;
            _local3.x = 5;
            DefaultLabelFormat.guildInfoLabel(_local3, 14, 0xb3b3b3, "center");
            _local2.addChild(_local3);
            this.guildsGrid.addGridElement(_local2);
        }
        
        public function addGuildMember(_arg_1: GuildListItem): void {
            var _local2: UIGridElement = new UIGridElement();
            _local2.addChild(_arg_1);
            this.guildsGrid.addGridElement(_local2);
        }
        
        public function addInvites(_arg_1: FriendListItem): void {
            var _local2: UIGridElement = new UIGridElement();
            _local2.addChild(_arg_1);
            this.friendsGrid.addGridElement(_local2);
        }
        
        public function showInviteIndicator(_arg_1: Boolean, _arg_2: String): void {
            var _local3: TabButton = this._tabs.getTabButtonByLabel(_arg_2);
            if (_local3) {
                _local3.showIndicator = _arg_1;
            }
        }
        
        public function clearFriendsList(): void {
            this.friendsGrid.clearGrid();
            this.showInviteIndicator(false, "Friends");
        }
        
        public function clearGuildList(): void {
            this.guildsGrid.clearGrid();
            this.showInviteIndicator(false, "Guild");
        }
        
        private function init(): void {
            this.friendsGrid = new UIGrid(350, 1, 3);
            this.friendsGrid.x = 9;
            this.friendsGrid.y = 15;
            this.guildsGrid = new UIGrid(350, 1, 3);
            this.guildsGrid.x = 9;
            this.createContentInset();
            this.createContentTabs();
            this.addTabs();
        }
        
        private function addTabs(): void {
            this._tabs = new UITabs(350, true);
            var _local1: Sprite = new Sprite();
            this._tabs.addTab(this.createTab("Friends", _local1, this.friendsGrid, true), true);
            var _local2: Sprite = new Sprite();
            this._tabs.addTab(this.createTab("Guild", _local2, this.guildsGrid), false);
            this._tabs.y = 6;
            this._tabs.x = 0;
            addChild(this._tabs);
        }
        
        private function createContentTabs(): void {
            var _local1: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "tab_inset_content_background", 350);
            _local1.height = 45;
            _local1.x = 0;
            _local1.y = 5;
            addChild(_local1);
        }
        
        private function createContentInset(): void {
            this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 350);
            this.contentInset.height = 465;
            this.contentInset.x = 0;
            this.contentInset.y = 40;
            addChild(this.contentInset);
        }
        
        private function createSearchInputField(_arg_1: int): InputTextField {
            var _local2: InputTextField = new InputTextField("Filter");
            DefaultLabelFormat.defaultSmallPopupTitle(_local2);
            _local2.width = _arg_1;
            return _local2;
        }
        
        private function createSearchIcon(): Bitmap {
            var _local1: BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig", 40), 20, true, 0);
            return new Bitmap(_local1);
        }
        
        private function createAddButton(): SliceScalingButton {
            return new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "add_button"));
        }
        
        private function createSearchInset(_arg_1: int): SliceScalingBitmap {
            var _local2: SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", _arg_1);
            _local2.height = 30;
            return _local2;
        }
        
        private function createTab(_arg_1: String, _arg_2: Sprite, _arg_3: UIGrid, _arg_4: Boolean = false): UITab {
            var _local7: * = null;
            var _local8: UITab = new UITab(_arg_1, true);
            this._tabContent = new Sprite();
            _arg_2.x = this.contentInset.x;
            this._tabContent.addChild(_arg_2);
            if (_arg_4) {
                this.createSearchAndAdd();
            }
            _arg_2.y = !!_arg_4 ? 50 : 85;
            _arg_2.addChild(_arg_3);
            var _local6: int = !!_arg_4 ? 410 : Number(375);
            var _local5: UIScrollbar = new UIScrollbar(_local6);
            _local5.mouseRollSpeedFactor = 1;
            _local5.scrollObject = _local8;
            _local5.content = _arg_2;
            _local5.x = this.contentInset.x + this.contentInset.width - 25;
            _local5.y = _arg_2.y;
            this._tabContent.addChild(_local5);
            _local7 = new Sprite();
            _local7.graphics.beginFill(0);
            _local7.graphics.drawRect(0, 0, 350, _local6 - 5);
            _local7.x = _arg_2.x;
            _local7.y = _arg_2.y;
            _arg_2.mask = _local7;
            this._tabContent.addChild(_local7);
            _local8.addContent(this._tabContent);
            return _local8;
        }
        
        private function createSearchAndAdd(): void {
            var _local2: * = null;
            this.addButton = this.createAddButton();
            this.addButton.x = 7;
            this.addButton.y = 6;
            this._tabContent.addChild(this.addButton);
            var _local1: SliceScalingBitmap = this.createSearchInset(296);
            _local1.x = this.addButton.x + this.addButton.width;
            _local1.y = 10;
            this._tabContent.addChild(_local1);
            _local2 = this.createSearchIcon();
            _local2.x = _local1.x;
            _local2.y = 5;
            this._tabContent.addChild(_local2);
            this.search = this.createSearchInputField(250);
            this.search.autoSize = "none";
            this.search.multiline = false;
            this.search.wordWrap = false;
            this.search.x = _local2.x + _local2.width - 5;
            this.search.y = _local1.y + 7;
            this._tabContent.addChild(this.search);
        }
    }
}
