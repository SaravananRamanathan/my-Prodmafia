package io.decagames.rotmg.pets.panels {
    import com.company.assembleegameclient.game.AGameSprite;
    import com.company.assembleegameclient.ui.panels.Panel;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import io.decagames.rotmg.pets.components.tooltip.PetTooltip;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
    
    import kabam.rotmg.editor.view.StaticTextButton;
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    import org.osflash.signals.Signal;
    import org.osflash.signals.natives.NativeSignal;
    
    public class PetPanel extends Panel {
        
        private static const FONT_SIZE: int = 16;
        
        private static const INVENTORY_PADDING: int = 6;
        
        private static const HUD_PADDING: int = 5;
        
        
        public const addToolTip: Signal = new Signal(ToolTip);
        
        private const nameTextField: TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(0xffffff, 16, true);
        
        private const rarityTextField: TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(0xb6b6b6, 12, false);
        
        private static function sendToBottom(_arg_1: StaticTextButton): void {
            _arg_1.y = 84 - _arg_1.height - 4;
        }
        
        public function PetPanel(_arg_1: AGameSprite, _arg_2: PetVO) {
            petBitmapContainer = new Sprite();
            super(_arg_1);
            this.petVO = _arg_2;
            this.petBitmapRollover = new NativeSignal(this.petBitmapContainer, "mouseOver");
            this.petBitmapRollover.add(this.onRollOver);
            if (_arg_2)
                this.petBitmap = _arg_2.getSkinBitmap();
            this.addChildren();
            this.positionChildren();
            this.updateTextFields();
            this.createButtons();
        }
        
        public var petBitmapRollover: NativeSignal;
        public var petBitmapContainer: Sprite;
        public var followButton: StaticTextButton;
        public var releaseButton: StaticTextButton;
        public var unFollowButton: StaticTextButton;
        public var petVO: PetVO;
        private var petBitmap: Bitmap;
        
        public function setState(_arg_1: uint): void {
            this.toggleButtons(_arg_1 == 1);
        }
        
        public function toggleButtons(_arg_1: Boolean): void {
            this.followButton.visible = _arg_1;
            this.releaseButton.visible = _arg_1;
            this.unFollowButton.visible = !_arg_1;
        }
        
        private function createButtons(): void {
            this.followButton = this.makeButton("Pets.follow");
            this.releaseButton = this.makeButton("PetPanel.release");
            this.unFollowButton = this.makeButton("Pets.unfollow");
            this.alignButtons();
        }
        
        private function makeButton(_arg_1: String): StaticTextButton {
            var _local2: StaticTextButton = new StaticTextButton(16, _arg_1);
            addChild(_local2);
            return _local2;
        }
        
        private function addChildren(): void {
            this.petBitmapContainer.addChild(this.petBitmap);
            addChild(this.petBitmapContainer);
            addChild(this.nameTextField);
            addChild(this.rarityTextField);
        }
        
        private function updateTextFields(): void {
            this.nameTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.name)).setColor(this.petVO.rarity.color).setSize(this.petVO.name.length > 17 ? 11 : 15);
            this.rarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.rarity.rarityKey));
        }
        
        private function positionChildren(): void {
            this.petBitmap.x = 4;
            this.petBitmap.y = -3;
            this.nameTextField.x = 58;
            this.nameTextField.y = 21;
            this.rarityTextField.x = 58;
            this.rarityTextField.y = 35;
        }
        
        private function alignButtons(): void {
            this.positionFollow();
            this.positionRelease();
            this.positionUnfollow();
        }
        
        private function positionFollow(): void {
            this.followButton.x = 6;
            sendToBottom(this.followButton);
        }
        
        private function positionRelease(): void {
            this.releaseButton.x = 188 - this.releaseButton.width - 6 - 5;
            sendToBottom(this.releaseButton);
        }
        
        private function positionUnfollow(): void {
            this.unFollowButton.x = (188 - this.unFollowButton.width) / 2;
            sendToBottom(this.unFollowButton);
        }
        
        private function onRollOver(_arg_1: MouseEvent): void {
            var _local2: PetTooltip = new PetTooltip(this.petVO);
            _local2.attachToTarget(this);
            this.addToolTip.dispatch(_local2);
        }
    }
}
