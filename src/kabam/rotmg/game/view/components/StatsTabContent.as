package kabam.rotmg.game.view.components {
import flash.display.Sprite;

public class StatsTabContent extends Sprite {


    public function StatsTabContent(_arg_1:uint) {
        stats = new StatsView();
        super();
        this.init();
        this.positionChildren(_arg_1);
        this.addChildren();
        name = "Stats";
    }
    private var stats:StatsView;

    private function addChildren():void {
        addChild(this.stats);
    }

    private function positionChildren(_arg_1:uint):void {
        this.stats.y = (_arg_1 - 27) / 2 - this.stats.height / 2;
    }

    private function init():void {
        this.stats.name = "Stats";
    }
}
}
