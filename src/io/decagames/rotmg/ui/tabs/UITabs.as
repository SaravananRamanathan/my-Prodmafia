package io.decagames.rotmg.ui.tabs {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    
    import io.decagames.rotmg.social.signals.TabSelectedSignal;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    
    import org.osflash.signals.Signal;
    
    public class UITabs extends Sprite {
        
        
        public function UITabs(_arg_1: int, _arg_2: Boolean = false) {
            buttonsRenderedSignal = new Signal();
            tabSelectedSignal = new TabSelectedSignal();
            super();
            this.tabsWidth = _arg_1;
            this.borderlessMode = _arg_2;
            this.addEventListener("addedToStage", this.onAddedHandler);
            this.content = new Vector.<UITab>(0);
            this.buttons = new Vector.<TabButton>(0);
            if (!_arg_2) {
                this.background = new TabContentBackground();
                this.background.addMargin(0, 3);
                this.background.width = _arg_1;
                this.background.height = 405;
                this.background.x = 0;
                this.background.y = 41;
                addChild(this.background);
            } else {
                this.tabsButtonMargin = 3;
            }
        }
        
        public var buttonsRenderedSignal: Signal;
        public var tabSelectedSignal: TabSelectedSignal;
        private var tabsXSpace: int = 3;
        private var tabsButtonMargin: int = 14;
        private var content: Vector.<UITab>;
        private var buttons: Vector.<TabButton>;
        private var tabsWidth: int;
        private var background: TabContentBackground;
        private var currentContent: UITab;
        private var defaultSelectedIndex: int = 0;
        private var borderlessMode: Boolean;
        
        private var _currentTabLabel: String;
        
        public function get currentTabLabel(): String {
            return this._currentTabLabel;
        }
        
        public function addTab(_arg_1: UITab, _arg_2: Boolean = false): void {
            this.content.push(_arg_1);
            _arg_1.y = !!this.borderlessMode ? 34 : 56;
            if (_arg_2) {
                this.defaultSelectedIndex = this.content.length - 1;
                this.currentContent = _arg_1;
                this._currentTabLabel = _arg_1.tabName;
                addChild(_arg_1);
            }
            if (this._currentTabLabel == "") {
                this._currentTabLabel = _arg_1.tabName;
            }
        }
        
        public function getTabButtonByLabel(_arg_1: String): TabButton {
            var _local2: * = null;
            var _local4: int = 0;
            var _local3: * = this.buttons;
            for each(_local2 in this.buttons) {
                if (_local2.label.text == _arg_1) {
                    return _local2;
                }
            }
            return null;
        }
        
        public function dispose(): void {
            var _local1: * = null;
            var _local2: * = null;
            if (this.background) {
                this.background.dispose();
            }
            var _local4: int = 0;
            var _local3: * = this.buttons;
            for each(_local1 in this.buttons) {
                _local1.dispose();
            }
            var _local6: int = 0;
            var _local5: * = this.content;
            for each(_local2 in this.content) {
                _local2.dispose();
            }
            this.currentContent.dispose();
            this.content = null;
            this.buttons = null;
        }
        
        private function createTabButtons(): void {
            var _local6: int = 0;
            var _local2: int = 0;
            var _local1: * = null;
            var _local4: * = null;
            var _local3: * = null;
            var _local5: * = null;
            _local6 = 1;
            _local2 = (this.tabsWidth - (this.content.length - 1) * this.tabsXSpace - this.tabsButtonMargin * 2) / this.content.length;
            var _local8: int = 0;
            var _local7: * = this.content;
            for each(_local3 in this.content) {
                if (_local6 == 1) {
                    _local1 = "left";
                } else if (_local6 == this.content.length) {
                    _local1 = "right";
                } else {
                    _local1 = "center";
                }
                _local5 = this.createTabButton(_local3.tabName, _local1);
                _local5.width = _local2;
                _local5.selected = this.defaultSelectedIndex == _local6 - 1;
                if (_local5.selected) {
                    _local4 = _local5;
                }
                _local5.y = 3;
                _local5.x = this.tabsButtonMargin + _local2 * (_local6 - 1) + this.tabsXSpace * (_local6 - 1);
                addChild(_local5);
                _local5.clickSignal.add(this.onButtonSelected);
                this.buttons.push(_local5);
                _local6++;
            }
            if (this.background) {
                this.background.addDecor(_local4.x - 4, _local4.x + _local4.width - 12, this.defaultSelectedIndex, this.buttons.length);
            }
            this.onButtonSelected(_local4);
            this.buttonsRenderedSignal.dispatch();
        }
        
        private function onButtonSelected(_arg_1: TabButton): void {
            var _local3: * = null;
            var _local2: int = this.buttons.indexOf(_arg_1);
            _arg_1.y = 0;
            this._currentTabLabel = _arg_1.label.text;
            this.tabSelectedSignal.dispatch(_arg_1.label.text);
            var _local5: int = 0;
            var _local4: * = this.buttons;
            for each(_local3 in this.buttons) {
                if (_local3 != _arg_1) {
                    _local3.selected = false;
                    _local3.y = 3;
                    this.updateTabButtonGraphicState(_local3, _local2);
                } else {
                    _local3.selected = true;
                }
            }
            if (this.currentContent) {
                this.currentContent.displaySignal.dispatch(false);
                this.currentContent.alpha = 0;
                this.currentContent.mouseChildren = false;
                this.currentContent.mouseEnabled = false;
            }
            this.currentContent = this.content[_local2];
            if (this.background) {
                this.background.addDecor(_arg_1.x - 5, _arg_1.x + _arg_1.width - 12, _local2, this.buttons.length);
            }
            addChild(this.currentContent);
            this.currentContent.displaySignal.dispatch(true);
            this.currentContent.alpha = 1;
            this.currentContent.mouseChildren = true;
            this.currentContent.mouseEnabled = true;
        }
        
        private function updateTabButtonGraphicState(_arg_1: TabButton, _arg_2: int): void {
            var _local3: int = this.buttons.indexOf(_arg_1);
            if (this.borderlessMode) {
                _arg_1.changeBitmap("tab_button_borderless_idle", new Point(0, !!this.borderlessMode ? 0 : 3));
                _arg_1.bitmap.alpha = 0;
            } else if (_local3 > _arg_2) {
                _arg_1.changeBitmap("tab_button_right_idle", new Point(0, !!this.borderlessMode ? 0 : 3));
            } else {
                _arg_1.changeBitmap("tab_button_left_idle", new Point(0, !!this.borderlessMode ? 0 : 3));
            }
        }
        
        private function createTabButton(_arg_1: String, _arg_2: String): TabButton {
            var _local3: TabButton = new TabButton(!!this.borderlessMode ? "borderless" : _arg_2);
            _local3.setLabel(_arg_1, DefaultLabelFormat.defaultInactiveTab);
            return _local3;
        }
        
        private function onAddedHandler(_arg_1: Event): void {
            this.removeEventListener("addedToStage", this.onAddedHandler);
            this.createTabButtons();
        }
    }
}
