package kabam.rotmg.util.components {
import com.company.rotmg.graphics.StarGraphic;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.ColorTransform;

public class StarsView extends Sprite {

    private static const TOTAL:int = 5;

    private static const MARGIN:int = 4;

    private static const CORNER:int = 15;

    private static const BACKGROUND_COLOR:uint = 2434341;

    private static const EMPTY_STAR_COLOR:uint = 8618883;

    private static const FILLED_STAR_COLOR:uint = 16777215;


    private const stars:Vector.<StarGraphic> = makeStars();

    private const background:Sprite = makeBackground();

    public function StarsView() {
        super();
    }

    public function setStars(_arg_1:int):void {
        var _local2:int = 0;
        _local2 = 0;
        while (_local2 < 5) {
            this.updateStar(_local2, _arg_1);
            _local2++;
        }
    }

    private function makeStars():Vector.<StarGraphic> {
        var _local1:Vector.<StarGraphic> = this.makeStarList();
        this.layoutStars(_local1);
        return _local1;
    }

    private function makeStarList():Vector.<StarGraphic> {
        var _local2:int = 0;
        var _local1:Vector.<StarGraphic> = new Vector.<StarGraphic>(5, true);
        while (_local2 < 5) {
            _local1[_local2] = new StarGraphic();
            addChild(_local1[_local2]);
            _local2++;
        }
        return _local1;
    }

    private function layoutStars(_arg_1:Vector.<StarGraphic>):void {
        var _local2:int = 0;
        while (_local2 < 5) {
            _arg_1[_local2].x = 4 + _arg_1[0].width * _local2;
            _arg_1[_local2].y = 4;
            _local2++;
        }
    }

    private function makeBackground():Sprite {
        var _local1:Sprite = new Sprite();
        this.drawBackground(_local1.graphics);
        addChildAt(_local1, 0);
        return _local1;
    }

    private function drawBackground(_arg_1:Graphics):void {
        var _local2:StarGraphic = this.stars[0];
        var _local4:int = _local2.width * 5 + 8;
        var _local3:int = _local2.height + 8;
        _arg_1.clear();
        _arg_1.beginFill(0x252525);
        _arg_1.drawRoundRect(0, 0, _local4, _local3, 15, 15);
        _arg_1.endFill();
    }

    private function updateStar(_arg_1:int, _arg_2:int):void {
        var _local4:StarGraphic = this.stars[_arg_1];
        var _local3:ColorTransform = _local4.transform.colorTransform;
        _local3.color = _arg_1 < _arg_2 ? 0xffffff : 8618883;
        _local4.transform.colorTransform = _local3;
    }
}
}
