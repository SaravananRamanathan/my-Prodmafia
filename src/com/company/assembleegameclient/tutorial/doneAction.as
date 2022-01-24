package com.company.assembleegameclient.tutorial {
    import com.company.assembleegameclient.game.AGameSprite;
    
    public function doneAction(sprite: AGameSprite, message: String): void {
        if (sprite.tutorial_ == null) {
            return;
        }
        sprite.tutorial_.doneAction(message);
    }
}