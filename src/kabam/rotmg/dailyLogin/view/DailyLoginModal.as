package kabam.rotmg.dailyLogin.view {
    import com.company.assembleegameclient.ui.DeprecatedTextButtonStatic;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    
    import kabam.rotmg.dailyLogin.config.CalendarSettings;
    import kabam.rotmg.dailyLogin.model.DailyLoginModel;
    import kabam.rotmg.mysterybox.components.MysteryBoxSelectModal;
    import kabam.rotmg.pets.view.components.DialogCloseButton;
    import kabam.rotmg.pets.view.components.PopupWindowBackground;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
    
    public class DailyLoginModal extends Sprite {
        
        
        public function DailyLoginModal() {
            closeButton = new DialogCloseButton();
            calendarView = new CalendarView();
            super();
        }
        
        public var closeButton: DialogCloseButton;
        public var claimButton: DeprecatedTextButtonStatic;
        private var content: Sprite;
        private var calendarView: CalendarView;
        private var titleTxt: TextFieldDisplayConcrete;
        private var serverTimeTxt: TextFieldDisplayConcrete;
        private var modalRectangle: Rectangle;
        private var daysLeft: int = 300;
        private var tabs: CalendarTabsView;
        
        public function init(_arg_1: DailyLoginModel): void {
            this.daysLeft = _arg_1.daysLeftToCalendarEnd;
            this.modalRectangle = CalendarSettings.getCalendarModalRectangle(_arg_1.overallMaxDays, this.daysLeft < 3);
            this.content = new Sprite();
            addChild(this.content);
            this.createModalBox();
            this.tabs = new CalendarTabsView();
            addChild(this.tabs);
            this.tabs.y = 70;
            if (this.daysLeft < 3) {
                this.tabs.y = this.tabs.y + 20;
            }
            this.centerModal();
        }
        
        public function showLegend(_arg_1: Boolean): void {
            var _local2: * = null;
            var _local5: * = null;
            var _local4: * = null;
            _local2 = new Sprite();
            _local2.y = this.modalRectangle.height - 55;
            var _local6: TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(this.modalRectangle.width).setHorizontalAlign("left");
            _local6.setStringBuilder(new StaticStringBuilder(!!_arg_1 ? "- Reward ready to claim. Click on day to claim reward." : "- Reward ready to claim."));
            var _local3: TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(this.modalRectangle.width).setHorizontalAlign("left");
            _local3.setStringBuilder(new StaticStringBuilder("- Item claimed already."));
            _local6.x = 20;
            _local6.y = 0;
            _local3.x = 20;
            _local3.y = 20;
            var _local7: BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 52);
            _local7.colorTransform(new Rectangle(0, 0, _local7.width, _local7.height), CalendarSettings.GREEN_COLOR_TRANSFORM);
            _local7 = TextureRedrawer.redraw(_local7, 40, true, 0);
            _local5 = new Bitmap(_local7);
            _local5.x = -Math.round(_local5.width / 2) + 10;
            _local5.y = -Math.round(_local5.height / 2) + 9;
            _local2.addChild(_local5);
            _local7 = AssetLibrary.getImageFromSet("lofiInterfaceBig", 11);
            _local7 = TextureRedrawer.redraw(_local7, 20, true, 0);
            _local4 = new Bitmap(_local7);
            _local4.x = -Math.round(_local4.width / 2) + 10;
            _local4.y = -Math.round(_local4.height / 2) + 30;
            _local2.addChild(_local4);
            _local2.addChild(_local6);
            _local2.addChild(_local3);
            if (!_arg_1) {
                this.addClaimButton();
                _local2.x = 20 + this.claimButton.width + 10;
            } else {
                _local2.x = 20;
            }
            addChild(_local2);
        }
        
        public function addCloseButton(): void {
            this.closeButton.y = 4;
            this.closeButton.x = this.modalRectangle.width - this.closeButton.width - 5;
            addChild(this.closeButton);
        }
        
        public function addTitle(_arg_1: String): void {
            this.titleTxt = this.getText(_arg_1, 0, 6, true).setSize(18);
            this.titleTxt.setColor(16768512);
            addChild(this.titleTxt);
        }
        
        public function showServerTime(_arg_1: String, _arg_2: String): void {
            var _local3: * = null;
            this.serverTimeTxt = new TextFieldDisplayConcrete().setSize(14).setColor(0xffffff).setTextWidth(this.modalRectangle.width);
            this.serverTimeTxt.setStringBuilder(new StaticStringBuilder("Server time: " + _arg_1 + ", ends on: " + _arg_2));
            this.serverTimeTxt.x = 20;
            if (this.daysLeft < 3) {
                _local3 = new TextFieldDisplayConcrete().setSize(14).setColor(0xff0000).setTextWidth(this.modalRectangle.width);
                _local3.setStringBuilder(new StaticStringBuilder("Calendar will soon end, remember to claim before it ends."));
                _local3.x = 20;
                _local3.y = 40;
                this.serverTimeTxt.y = 60;
                this.calendarView.y = 90;
                addChild(_local3);
            } else {
                this.calendarView.y = 70;
                this.serverTimeTxt.y = 40;
            }
            addChild(this.serverTimeTxt);
        }
        
        public function getText(_arg_1: String, _arg_2: int, _arg_3: int, _arg_4: Boolean = false): TextFieldDisplayConcrete {
            var _local5: TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(0xffffff).setTextWidth(this.modalRectangle.width);
            _local5.setBold(true);
            if (_arg_4) {
                _local5.setStringBuilder(new StaticStringBuilder(_arg_1));
            } else {
                _local5.setStringBuilder(new LineBuilder().setParams(_arg_1));
            }
            _local5.setWordWrap(true);
            _local5.setMultiLine(true);
            _local5.setAutoSize("center");
            _local5.setHorizontalAlign("center");
            _local5.filters = [new DropShadowFilter(0, 0, 0)];
            _local5.x = _arg_2;
            _local5.y = _arg_3;
            return _local5;
        }
        
        private function addClaimButton(): void {
            this.claimButton = new DeprecatedTextButtonStatic(16, "Go & Claim");
            this.claimButton.textChanged.addOnce(this.alignClaimButton);
            addChild(this.claimButton);
        }
        
        private function alignClaimButton(): void {
            this.claimButton.x = 20;
            this.claimButton.y = this.modalRectangle.height - this.claimButton.height - 20;
            if (this.daysLeft < 3) {
            }
        }
        
        private function createModalBox(): void {
            var _local1: DisplayObject = new MysteryBoxSelectModal.backgroundImageEmbed();
            _local1.width = this.modalRectangle.width - 1;
            _local1.height = this.modalRectangle.height - 27;
            _local1.y = 27;
            _local1.alpha = 0.95;
            this.content.addChild(_local1);
            this.content.addChild(this.makeModalBackground(this.modalRectangle.width, this.modalRectangle.height));
        }
        
        private function makeModalBackground(_arg_1: int, _arg_2: int): PopupWindowBackground {
            var _local3: PopupWindowBackground = new PopupWindowBackground();
            _local3.draw(_arg_1, _arg_2, 1);
            return _local3;
        }
        
        private function centerModal(): void {
            this.x = WebMain.STAGE.stageWidth / 2 - this.width / 2;
            this.y = WebMain.STAGE.stageHeight / 2 - this.height / 2;
            this.tabs.x = 20;
        }
    }
}
