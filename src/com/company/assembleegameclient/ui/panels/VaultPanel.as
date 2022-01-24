package com.company.assembleegameclient.ui.panels {
    import com.company.assembleegameclient.game.AGameSprite;
    import com.company.assembleegameclient.objects.VaultContainer;
    
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    
    import kabam.rotmg.core.StaticInjectorContext;
    import kabam.rotmg.text.view.StaticTextDisplay;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.util.components.LegacyBuyButton;
    
    public class VaultPanel extends Panel {
    
        private var owner: VaultContainer;
        private var nameText: StaticTextDisplay;
        private var upgradeButton: LegacyBuyButton;
        
        private static function countValidItems(vaultContents: Vector.<int>): int {
            var validCounter: int = 0;
            var totalCounter: int = 0;
            while (totalCounter < vaultContents.length) {
                if (vaultContents[totalCounter] != -1) {
                    validCounter++;
                }
                totalCounter++;
            }
            return validCounter;
        }
        
        public function VaultPanel(panel: AGameSprite, vaultBox: VaultContainer) {
            super(panel);
            var panelHUD: HUDModel = StaticInjectorContext.getInjector().getInstance(HUDModel);
            this.owner = vaultBox;
            this.nameText = new StaticTextDisplay();
            this.nameText.setSize(18).setColor(16777215).setTextWidth(188).setWordWrap(true).setMultiLine(true).setAutoSize("center").setBold(true).setHTML(true);
            this.nameText.setStringBuilder(new LineBuilder().setParams("Vault\n" + countValidItems(panelHUD.vaultContents) + "/" + panelHUD.vaultContents.length).setPrefix("<p align=\"center\">").setPostfix("</p>"));
            this.nameText.filters = [new DropShadowFilter(0, 0, 0)];
            addChild(this.nameText);
            this.upgradeButton = new LegacyBuyButton("Upgrade {cost}", 18, this.owner.price_, 0);
            this.upgradeButton.addEventListener("click", this.onUpgradeClick);
            //todo: allow dragging items here to add to vault
            this.upgradeButton.y = 45;
            this.upgradeButton.x = 25;
            addChild(this.upgradeButton);
        }
        
        override public function draw(): void {
        }
        
        private function onUpgradeClick(param1: Event): void {
            this.gs_.gsc_.buy(this.owner.objectId_, 1);
        }
    }
}
