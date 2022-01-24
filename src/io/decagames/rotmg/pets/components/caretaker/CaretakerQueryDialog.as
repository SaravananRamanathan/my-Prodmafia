package io.decagames.rotmg.pets.components.caretaker {
    import com.company.assembleegameclient.ui.DeprecatedTextButton;
    
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
    
    import kabam.rotmg.pets.view.components.PopupWindowBackground;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.view.SignalWaiter;
    import kabam.rotmg.util.graphics.ButtonLayoutHelper;
    
    import org.osflash.signals.Signal;
    import org.osflash.signals.natives.NativeMappedSignal;
    
    public class CaretakerQueryDialog extends Sprite {
        
        public static const WIDTH: int = 480;
        
        public static const HEIGHT: int = 428;
        
        public static const TITLE: String = "CaretakerQueryDialog.title";
        
        public static const QUERY: String = "CaretakerQueryDialog.query";
        
        public static const CLOSE: String = "Close.text";
        
        public static const BACK: String = "Screens.back";
        
        public static const CATEGORIES: Array = [{
            "category": "CaretakerQueryDialog.category_petYard",
            "info": "CaretakerQueryDialog.info_petYard"
        }, {
            "category": "CaretakerQueryDialog.category_pets",
            "info": "CaretakerQueryDialog.info_pets"
        }, {
            "category": "CaretakerQueryDialog.category_abilities",
            "info": "CaretakerQueryDialog.info_abilities"
        }, {
            "category": "CaretakerQueryDialog.category_feedingPets",
            "info": "CaretakerQueryDialog.info_feedingPets"
        }, {
            "category": "CaretakerQueryDialog.category_fusingPets",
            "info": "CaretakerQueryDialog.info_fusingPets"
        }, {
            "category": "CaretakerQueryDialog.category_evolution",
            "info": "CaretakerQueryDialog.info_evolution"
        }];
        
        
        private const layoutWaiter: SignalWaiter = makeDeferredLayout();
        
        private const container: DisplayObjectContainer = makeContainer();
        
        private const background: PopupWindowBackground = makeBackground();
        
        private const caretaker: CaretakerQueryDialogCaretaker = makeCaretaker();
        
        private const title: TextFieldDisplayConcrete = makeTitle();
        
        private const categories: CaretakerQueryDialogCategoryList = makeCategoryList();
        
        private const backButton: DeprecatedTextButton = makeBackButton();
        
        private const closeButton: DeprecatedTextButton = makeCloseButton();
        
        public const closed: Signal = new NativeMappedSignal(closeButton, "click");
        
        public function CaretakerQueryDialog() {
            super();
        }
        
        public function setCaretakerIcon(_arg_1: BitmapData): void {
            this.caretaker.setCaretakerIcon(_arg_1);
        }
        
        private function makeDeferredLayout(): SignalWaiter {
            var _local1: SignalWaiter = new SignalWaiter();
            _local1.complete.addOnce(this.onLayout);
            return _local1;
        }
        
        private function onLayout(): void {
            var _local1: ButtonLayoutHelper = new ButtonLayoutHelper();
            _local1.layout(8 * 60, this.closeButton);
            _local1.layout(8 * 60, this.backButton);
        }
        
        private function makeContainer(): DisplayObjectContainer {
            var _local1: * = null;
            _local1 = new Sprite();
            _local1.x = 160;
            _local1.y = 86;
            addChild(_local1);
            return _local1;
        }
        
        private function makeBackground(): PopupWindowBackground {
            var _local1: PopupWindowBackground = new PopupWindowBackground();
            _local1.draw(8 * 60, 428);
            _local1.divide("HORIZONTAL_DIVISION", 34);
            this.container.addChild(_local1);
            return _local1;
        }
        
        private function makeCaretaker(): CaretakerQueryDialogCaretaker {
            var _local1: * = null;
            _local1 = new CaretakerQueryDialogCaretaker();
            _local1.x = 20;
            _local1.y = 50;
            this.container.addChild(_local1);
            return _local1;
        }
        
        private function makeTitle(): TextFieldDisplayConcrete {
            var _local1: * = null;
            _local1 = PetsViewAssetFactory.returnTextfield(0xffffff, 18, true);
            _local1.setStringBuilder(new LineBuilder().setParams("CaretakerQueryDialog.title"));
            _local1.setAutoSize("center");
            _local1.x = 4 * 60;
            _local1.y = 24;
            this.container.addChild(_local1);
            return _local1;
        }
        
        private function makeBackButton(): DeprecatedTextButton {
            var _local1: DeprecatedTextButton = new DeprecatedTextButton(16, "Screens.back", 80);
            _local1.y = 382;
            _local1.visible = false;
            _local1.addEventListener("click", this.onBack);
            this.container.addChild(_local1);
            this.layoutWaiter.push(_local1.textChanged);
            return _local1;
        }
        
        private function makeCloseButton(): DeprecatedTextButton {
            var _local1: DeprecatedTextButton = new DeprecatedTextButton(16, "Close.text", 110);
            _local1.y = 382;
            this.container.addChild(_local1);
            this.layoutWaiter.push(_local1.textChanged);
            return _local1;
        }
        
        private function makeCategoryList(): CaretakerQueryDialogCategoryList {
            var _local1: CaretakerQueryDialogCategoryList = new CaretakerQueryDialogCategoryList(CATEGORIES);
            _local1.x = 20;
            _local1.y = 110;
            _local1.selected.add(this.onCategorySelected);
            this.container.addChild(_local1);
            this.layoutWaiter.push(_local1.ready);
            return _local1;
        }
        
        private function onCategorySelected(_arg_1: String): void {
            this.categories.visible = false;
            this.closeButton.visible = false;
            this.backButton.visible = true;
            this.caretaker.showDetail(_arg_1);
        }
        
        private function onBack(_arg_1: MouseEvent): void {
            this.caretaker.showSpeech();
            this.categories.visible = true;
            this.closeButton.visible = true;
            this.backButton.visible = false;
        }
    }
}
