package io.decagames.rotmg.pets.components.tooltip {
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.assembleegameclient.ui.LineBreakDesign;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;
    import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petStatsGrid.PetStatsGrid;
    import io.decagames.rotmg.pets.data.family.PetFamilyColors;
    import io.decagames.rotmg.pets.data.family.PetFamilyKeys;
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.IPetVO;
    import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
    import io.decagames.rotmg.ui.gird.UIGrid;
    
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class PetTooltip extends ToolTip {
        
        
        private const petsContent: Sprite = new Sprite();
        
        private const titleTextField: TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(0xffffff, 16, true);
        
        private const petRarityTextField: TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(0xb3b3b3, 12, false);
        
        private const petFamilyTextField: TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(0xb3b3b3, 12, false);
        
        private const petProbabilityInfoField: TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(0xb3b3b3, 12, false);
        
        private const lineBreak: LineBreakDesign = PetsViewAssetFactory.returnTooltipLineBreak();
        
        public function PetTooltip(_arg_1: IPetVO) {
            this.petVO = _arg_1;
            super(0x363636, 1, 0xffffff, 1, true);
            this.petsContent.name = "Pets";
        }
        
        private var petBitmap: Bitmap;
        private var petVO: IPetVO;
        
        private function get hasAbilities(): Boolean {
            var _local1: * = null;
            var _local3: int = 0;
            var _local2: * = this.petVO.abilityList;
            for each(_local1 in this.petVO.abilityList) {
                if (_local1.getUnlocked() && _local1.level > 0) {
                    return true;
                }
            }
            return false;
        }
        
        public function init(): void {
            this.petBitmap = this.petVO.getSkinBitmap();
            this.addChildren();
            if (this.hasAbilities) {
                this.addAbilities();
            }
            this.positionChildren();
            this.updateTextFields();
        }
        
        private function updateTextFields(): void {
            this.titleTextField.setColor(this.petVO.rarity.color);
            this.titleTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.name));
            this.petRarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.rarity.rarityKey));
            this.petFamilyTextField.setStringBuilder(new LineBuilder().setParams(PetFamilyKeys.getTranslationKey(this.petVO.family))).setColor(PetFamilyColors.getColorByFamilyKey(this.petVO.family));
            this.petProbabilityInfoField.setHTML(true).setText(this.getProbabilityTip());
        }
        
        private function getProbabilityTip(): String {
            var _local1: XML = ObjectLibrary.xmlLibrary_[this.petVO.getType()];
            if (_local1 == null) {
                return "";
            }
            if (_local1.hasOwnProperty("NoHatchOrFuse")) {
                return this.makeProbabilityTipLine("not", 0xff0000);
            }
            if (_local1.hasOwnProperty("BasicPet")) {
                return this.makeProbabilityTipLine("commonly", 0xff00);
            }
            return this.makeProbabilityTipLine("rarely", 0xffff8f);
        }
        
        private function makeProbabilityTipLine(_arg_1: String, _arg_2: uint): String {
            return "Can " + TooltipHelper.wrapInFontTag(_arg_1, "#" + _arg_2.toString(16)) + " be obtained\nthrough hatching or fusion.";
        }
        
        private function addChildren(): void {
            this.clearChildren();
            this.petsContent.graphics.beginFill(0, 0);
            this.petsContent.graphics.drawRect(0, 0, 185, !this.hasAbilities ? 70 : Number(150));
            this.petsContent.addChild(this.petBitmap);
            this.petsContent.addChild(this.titleTextField);
            this.petsContent.addChild(this.petRarityTextField);
            this.petsContent.addChild(this.petFamilyTextField);
            this.petsContent.addChild(this.petProbabilityInfoField);
            if (this.hasAbilities) {
                this.petsContent.addChild(this.lineBreak);
            }
            if (!contains(this.petsContent)) {
                addChild(this.petsContent);
            }
        }
        
        private function clearChildren(): void {
            this.petsContent.graphics.clear();
            while (this.petsContent.numChildren > 0) {
                this.petsContent.removeChildAt(0);
            }
        }
        
        private function addAbilities(): void {
            var _local1: UIGrid = new PetStatsGrid(178, this.petVO);
            this.petsContent.addChild(_local1);
            _local1.y = 104;
            _local1.x = 2;
        }
        
        private function getNumAbilities(): uint {
            var _local1: Boolean = this.petVO.rarity.rarityKey == PetRarityEnum.DIVINE.rarityKey || this.petVO.rarity.rarityKey == PetRarityEnum.LEGENDARY.rarityKey;
            if (_local1) {
                return 2;
            }
            return 3;
        }
        
        private function positionChildren(): void {
            this.titleTextField.x = 55;
            this.titleTextField.y = 21;
            this.petRarityTextField.x = 55;
            this.petRarityTextField.y = 35;
            this.petFamilyTextField.x = 55;
            this.petFamilyTextField.y = 48;
            this.petProbabilityInfoField.x = 0;
            this.petProbabilityInfoField.y = 54;
        }
    }
}
