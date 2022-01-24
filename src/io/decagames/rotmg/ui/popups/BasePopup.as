package io.decagames.rotmg.ui.popups {
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    public class BasePopup extends Sprite {
        
        
        public function BasePopup(_arg_1: int, _arg_2: int, _arg_3: Rectangle = null) {
            super();
            this._popupWidth = _arg_1;
            this._popupHeight = _arg_2;
            this._overrideSizePosition = _arg_3;
        }
        
        protected var _showOnFullScreen: Boolean;
        
        public function get showOnFullScreen(): Boolean {
            return this._showOnFullScreen;
        }
        
        public function set showOnFullScreen(_arg_1: Boolean): void {
            this._showOnFullScreen = _arg_1;
        }
        
        protected var _popupWidth: int;
        
        public function get popupWidth(): int {
            return this._popupWidth;
        }
        
        public function set popupWidth(_arg_1: int): void {
            this._popupWidth = _arg_1;
        }
        
        protected var _popupHeight: int;
        
        public function get popupHeight(): int {
            return this._popupHeight;
        }
        
        public function set popupHeight(_arg_1: int): void {
            this._popupHeight = _arg_1;
        }
        
        protected var _popupFadeColor: uint = 1381653;
        
        public function get popupFadeColor(): Number {
            return this._popupFadeColor;
        }
        
        protected var _popupFadeAlpha: Number = 0.6;
        
        public function get popupFadeAlpha(): Number {
            return this._popupFadeAlpha;
        }
        
        protected var _contentHeight: int;
        
        public function get contentHeight(): int {
            return this._contentHeight;
        }
        
        protected var _contentWidth: int;
        
        public function get contentWidth(): int {
            return this._contentWidth;
        }
        
        private var _overrideSizePosition: Rectangle;
        
        public function get overrideSizePosition(): Rectangle {
            return this._overrideSizePosition;
        }
    }
}
