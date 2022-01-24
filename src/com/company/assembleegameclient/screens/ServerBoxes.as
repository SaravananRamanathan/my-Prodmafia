package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.MouseEvent;

import kabam.rotmg.servers.api.Server;

public class ServerBoxes extends Sprite {


    public static function makeLocalhostServer():Server {
        return new Server().setName("Proxy").setAddress("127.0.0.1").setPort(2050).setLatLong(Infinity, Infinity).setUsage(0).setIsAdminOnly(false);
    }

    public function ServerBoxes(_arg_1:Vector.<Server>, _arg_2:Boolean = false) {
        var _local6:int = 0;
        boxes_ = new Vector.<ServerBox>();
        var _local3:* = null;
        var _local5:* = null;
        var _local7:* = null;
        super();
        this._isChallenger = _arg_2;
        _local3 = new ServerBox(null);
        _local3.setSelected(true);
        _local3.x = 0;
        _local3.addEventListener("mouseDown", this.onMouseDown);
        addChild(_local3);
        this.boxes_.push(_local3);
        var _local4:Server = makeLocalhostServer();
        _local3 = new ServerBox(_local4);
        if (_local4.name == Parameters.data.preferredServer) {
            this.setSelected(_local3);
        }
        _local3.x = 388;
        _local3.addEventListener("mouseDown", this.onMouseDown);
        addChild(_local3);
        this.boxes_.push(_local3);
        _local6 = 2;
        _local7 = !!this._isChallenger ? Parameters.data.preferredChallengerServer : Parameters.data.preferredServer;
        Parameters.paramServerJoinedOnce = false;
        var _local9:int = 0;
        var _local8:* = _arg_1;
        for each(_local5 in _arg_1) {
            if (_local5.address != "127.0.0.1") {
                _local3 = new ServerBox(_local5);
                if (_local5.name == _local7) {
                    this.setSelected(_local3);
                }
                _local3.x = _local6 % 2 * 388;
                _local3.y = int(_local6 / 2) * 56;
                _local3.addEventListener("mouseDown", this.onMouseDown);
                addChild(_local3);
                this.boxes_.push(_local3);
                _local6++;
            }
        }
    }
    private var boxes_:Vector.<ServerBox>;
    private var _isChallenger:Boolean;

    private function setSelected(_arg_1:ServerBox):void {
        var _local2:* = null;
        var _local4:int = 0;
        var _local3:* = this.boxes_;
        for each(_local2 in this.boxes_) {
            _local2.setSelected(false);
        }
        _arg_1.setSelected(true);
    }

    private function onMouseDown(_arg_1:MouseEvent):void {
        var _local3:ServerBox = _arg_1.currentTarget as ServerBox;
        if (_local3 == null) {
            return;
        }
        this.setSelected(_local3);
        var _local2:String = _local3.value_;
        if (this._isChallenger) {
            Parameters.data.preferredChallengerServer = _local2;
        } else {
            Parameters.data.preferredServer = _local2;
        }
        Parameters.save();
    }
}
}
