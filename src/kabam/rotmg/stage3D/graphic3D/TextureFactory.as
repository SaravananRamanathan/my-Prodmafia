package kabam.rotmg.stage3D.graphic3D {
import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.geom.Point;
import flash.utils.Dictionary;

import kabam.rotmg.stage3D.proxies.Context3DProxy;
import kabam.rotmg.stage3D.proxies.TextureProxy;

public class TextureFactory {
    [Inject]
    public var context3D:Context3DProxy;

    private static var textures:Dictionary = new Dictionary();
    private static var count:int = 0;

    public function TextureFactory() {
        super();
    }

    public static function disposeTextures() : void {
        for each (var texProxy:TextureProxy in textures) {
            texProxy.dispose();
            texProxy = null;
        }

        textures = new Dictionary();
        count = 0;
    }

    private static function getNextPowerOf2(base:int) : Number {
        base--;
        base |= base >> 1;
        base |= base >> 2;
        base |= base >> 4;
        base |= base >> 8;
        base |= base >> 16;
        base++
        return base;
    }

    public function make(tex:BitmapData) : TextureProxy {
        var powW:int = 0;
        var powH:int = 0;
        var texProxy:TextureProxy = null;
        if (tex == null)
            return null;

        if (tex in textures)
            return textures[tex];

        powW = getNextPowerOf2(tex.width);
        powH = getNextPowerOf2(tex.height);
        texProxy = this.context3D.createTexture(powW, powH, Context3DTextureFormat.BGRA, true);
        var modTex:BitmapData = new BitmapData(powW, powH, true, 0);
        modTex.copyPixels(tex, tex.rect, new Point(0, 0));
        texProxy.uploadFromBitmapData(modTex);

        if (count > 1000)
            disposeTextures();

        textures[tex] = texProxy;
        count++;
        return texProxy;
    }
}
}