package kabam.rotmg.stage3D  {
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.geom.ColorTransform;
import flash.utils.Dictionary;

public class GraphicsFillExtra {
    private static const DEFAULT_OFFSET:Vector.<Number> = Vector.<Number>([0,0,0,0]);

    private static var textureOffsets:Dictionary = new Dictionary();

    private static var textureOffsetsSize:uint = 0;

    private static var waterSinks:Dictionary = new Dictionary();

    private static var waterSinksSize:uint = 0;

    private static var ctMarkers:Vector.<BitmapData> = new Vector.<BitmapData>();

    private static var colorTransforms:Dictionary = new Dictionary();

    private static var colorTransformsSize:uint = 0;

    private static var nullTfm:ColorTransform = new ColorTransform();


    public function GraphicsFillExtra() {
        super();
    }

    public static function setColorTransform(tex:BitmapData, ct:ColorTransform) : void {
        if(ctMarkers.indexOf(tex) == -1) {
            colorTransformsSize = Number(colorTransformsSize) + 1;
            ctMarkers.push(tex);
            colorTransforms[tex] = ct;
        }
    }

    public static function getColorTransform(tex:BitmapData) : ColorTransform {
        if(ctMarkers.indexOf(tex) != -1) {
            return colorTransforms[tex];
        }
        return nullTfm;
    }

    public static function clearColorTransform(tex:BitmapData) : void {
        var _local2:int = ctMarkers.indexOf(tex);
        if(_local2 != -1) {
            colorTransformsSize = colorTransformsSize - 1;
            ctMarkers.removeAt(_local2);
            delete colorTransforms[tex];
        }
    }

    public static function setOffsetUV(bitmap:GraphicsBitmapFill, x:Number, y:Number) : void {
        if(textureOffsets[bitmap] == null) {
            textureOffsetsSize = Number(textureOffsetsSize) + 1;
            textureOffsets[bitmap] = Vector.<Number>([0,0,0,0]);
        }
        textureOffsets[bitmap][0] = x;
        textureOffsets[bitmap][1] = y;
    }

    public static function getOffsetUV(bitmapFill:GraphicsBitmapFill) : Vector.<Number> {
        if(textureOffsets[bitmapFill] != null) {
            return textureOffsets[bitmapFill];
        }
        return DEFAULT_OFFSET;
    }

    public static function setSinkLevel(bitmapFill:GraphicsBitmapFill, sink:Number) : void {
        if(waterSinks[bitmapFill] == null) {
            waterSinksSize = Number(waterSinksSize) + 1;
        }
        waterSinks[bitmapFill] = sink;
    }

    public static function getSinkLevel(bitmapFill:GraphicsBitmapFill) : Number {
        if(waterSinks[bitmapFill] != null) {
            return waterSinks[bitmapFill];
        }
        return 0;
    }

    public static function clearSink(bitmapFill:GraphicsBitmapFill) : void {
        if(waterSinks[bitmapFill] != null) {
            waterSinksSize = waterSinksSize - 1;
            delete waterSinks[bitmapFill];
        }
    }

    public static function dispose() : void {
        textureOffsets = new Dictionary();
        waterSinks = new Dictionary();
        for each(var _local1:BitmapData in ctMarkers) {
            _local1.dispose();
        }
        ctMarkers = new Vector.<BitmapData>();
        colorTransforms = new Dictionary();
        textureOffsetsSize = 0;
        waterSinksSize = 0;
        colorTransformsSize = 0;
    }

    public static function manageSize() : void {
        if(colorTransformsSize > 2000) {
            ctMarkers = new Vector.<BitmapData>();
            for each (var _local3:BitmapData in ctMarkers) {
                _local3.dispose();
            }
            colorTransforms = new Dictionary();
            colorTransformsSize = 0;
        }
        if(textureOffsetsSize > 2000) {
            textureOffsets = new Dictionary();
            textureOffsetsSize = 0;
        }
        if(waterSinksSize > 2000) {
            waterSinks = new Dictionary();
            waterSinksSize = 0;
        }
    }
}
}