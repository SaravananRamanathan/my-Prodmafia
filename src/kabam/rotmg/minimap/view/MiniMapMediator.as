package kabam.rotmg.minimap.view {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;

import flash.utils.Dictionary;

import kabam.rotmg.core.view.Layers;
import kabam.rotmg.game.focus.control.SetGameFocusSignal;
import kabam.rotmg.game.signals.ExitGameSignal;
import kabam.rotmg.minimap.control.MiniMapZoomSignal;
import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.signals.UpdateHUDSignal;

import robotlegs.bender.extensions.mediatorMap.api.IMediator;

public class MiniMapMediator implements IMediator {


    public function MiniMapMediator() {
        super();
    }
    [Inject]
    public var view:MiniMap;
    [Inject]
    public var model:HUDModel;
    [Inject]
    public var setFocus:SetGameFocusSignal;
    [Inject]
    public var updateGroundTileSignal:UpdateGroundTileSignal;
    [Inject]
    public var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
    [Inject]
    public var miniMapZoomSignal:MiniMapZoomSignal;
    [Inject]
    public var updateHUD:UpdateHUDSignal;
    [Inject]
    public var exitGameSignal:ExitGameSignal;
    [Inject]
    public var layers:Layers;

    public function initialize():void {
        this.view.setMap(this.model.gameSprite.map);
        this.setFocus.add(this.onSetFocus);
        this.updateHUD.add(this.onUpdateHUD);
        this.updateGameObjectTileSignal.add(this.onUpdateGameObjectTile);
        this.updateGroundTileSignal.add(this.onUpdateGroundTile);
        this.miniMapZoomSignal.add(this.onMiniMapZoom);
        this.exitGameSignal.add(this.onExitGame);
        this.view.menuLayer = this.layers.top;
    }

    public function destroy():void {
        this.setFocus.remove(this.onSetFocus);
        this.updateHUD.remove(this.onUpdateHUD);
        this.updateGameObjectTileSignal.remove(this.onUpdateGameObjectTile);
        this.updateGroundTileSignal.remove(this.onUpdateGroundTile);
        this.miniMapZoomSignal.remove(this.onMiniMapZoom);
        this.exitGameSignal.remove(this.onExitGame);
    }

    private function onExitGame():void {
        this.view.deactivate();
    }

    private function onSetFocus(_arg_1:String):void {
        var _local2:GameObject = this.getFocusById(_arg_1);
        this.view.setFocus(_local2);
    }

    private function getFocusById(_arg_1:String):GameObject {
        var _local3:* = null;
        if (_arg_1 == "") {
            return this.view.map.player_;
        }
        var _local2:Dictionary = this.view.map.goDict_;
        var _local5:int = 0;
        var _local4:* = _local2;
        for each(_local3 in _local2) {
            if (_local3.name_ == _arg_1) {
                return _local3;
            }
        }
        return this.view.map.player_;
    }

    private function onUpdateGroundTile(_arg_1:int, _arg_2:int, _arg_3:uint):void {
        this.view.setGroundTile(_arg_1, _arg_2, _arg_3);
    }

    private function onUpdateGameObjectTile(_arg_1:int, _arg_2:int, _arg_3:GameObject):void {
        this.view.setGameObjectTile(_arg_1, _arg_2, _arg_3);
    }

    private function onMiniMapZoom(_arg_1:String):void {
        if (_arg_1 == "IN") {
            this.view.zoomIn();
        } else if (_arg_1 == "OUT") {
            this.view.zoomOut();
        }
    }

    private function onUpdateHUD(_arg_1:Player):void {
        this.view.draw();
    }
}
}
