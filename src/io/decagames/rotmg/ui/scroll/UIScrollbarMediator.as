package io.decagames.rotmg.ui.scroll {
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.framework.api.ILogger;
    
    public class UIScrollbarMediator extends Mediator {
        
        
        public function UIScrollbarMediator() {
            super();
        }
        
        [Inject]
        public var view: UIScrollbar;
        [Inject]
        public var logger: ILogger;
        private var startDragging: Boolean;
        private var startY: Number;
        
        override public function initialize(): void {
            this.view.addEventListener("enterFrame", this.onUpdateHandler);
            this.view.slider.addEventListener("mouseDown", this.onMouseDown);
            WebMain.STAGE.addEventListener("mouseUp", this.onMouseUp);
            WebMain.STAGE.addEventListener("mouseWheel", this.onMouseWheel);
        }
        
        override public function destroy(): void {
            this.view.removeEventListener("enterFrame", this.onUpdateHandler);
            this.view.slider.removeEventListener("mouseDown", this.onMouseDown);
            if (this.view.scrollObject) {
                this.view.scrollObject.removeEventListener("mouseWheel", this.onMouseWheel);
            }
            WebMain.STAGE.removeEventListener("mouseUp", this.onMouseUp);
            WebMain.STAGE.removeEventListener("mouseWheel", this.onMouseWheel);
            this.view.dispose();
        }
        
        private function onMouseWheel(_arg_1: MouseEvent): void {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
            this.view.updatePosition(-_arg_1.delta * this.view.mouseRollSpeedFactor);
        }
        
        private function onMouseDown(_arg_1: Event): void {
            this.startDragging = true;
            this.startY = WebMain.STAGE.mouseY;
        }
        
        private function onMouseUp(_arg_1: Event): void {
            this.startDragging = false;
        }
        
        private function onUpdateHandler(_arg_1: Event): void {
            if (this.view.scrollObject && !this.view.scrollObject.hasEventListener("mouseWheel")) {
                this.view.scrollObject.addEventListener("mouseWheel", this.onMouseWheel);
            }
            if (this.startDragging) {
                this.view.updatePosition(WebMain.STAGE.mouseY - this.startY);
                this.startY = WebMain.STAGE.mouseY;
            }
            this.view.update();
        }
    }
}
