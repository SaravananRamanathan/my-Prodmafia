package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.PointUtil;

import flash.utils.Dictionary;

import kabam.rotmg.messaging.impl.incoming.AccountList;

public class Party {

    public static const NUM_MEMBERS:int = 6;

    private static const SORT_ON_FIELDS:Array = ["starred_", "distSqFromThisPlayer_", "objectId_"];

    private static const SORT_ON_PARAMS:Array = [18, 16, 16];

    private static const PARTY_DISTANCE_SQ:int = 2500;

    public function Party(_arg_1:Map) {
        members_ = [];
        starred_ = new Dictionary(true);
        ignored_ = new Dictionary(true);
        super();
        this.map_ = _arg_1;
    }
    public var map_:Map;
    public var members_:Array;
    private var starred_:Dictionary;
    private var ignored_:Dictionary;
    private var lastUpdate_:int = -2147483648;

    public function update(_arg_1:int, _arg_2:int):void {
        var _local5:Player = null;
        if (_arg_1 < this.lastUpdate_ + (Parameters.lowCPUMode ? 2500 : Number(500))) {
            return;
        }
        this.lastUpdate_ = _arg_1;
        this.members_.length = 0;
        var _local3:Player = this.map_.player_;
        if (_local3 == null) {
            return;
        }
        for each(var _local4:GameObject in this.map_.goDict_) {
            if (_local4 is Player && _local4 != _local3) {
                _local5 = _local4 as Player;
                _local5.starred_ = this.starred_[_local5.accountId_] != undefined;
                _local5.ignored_ = this.ignored_[_local5.accountId_] != undefined;
                _local5.distSqFromThisPlayer_ = PointUtil.distanceSquaredXY(_local3.x_, _local3.y_, _local5.x_, _local5.y_);
                if (!(_local5.distSqFromThisPlayer_ > 2500 && !_local5.starred_)) {
                    this.members_.push(_local5);
                }
            }
        }
        this.members_.sortOn(SORT_ON_FIELDS, SORT_ON_PARAMS);
        if (this.members_.length > 6) {
            this.members_.length = 6;
        }
    }

    public function lockPlayer(param1:Player) : void {
        var _local2:int = 0;
        this.starred_[param1.accountId_] = 1;
        this.lastUpdate_ = -2147483648;
        this.map_.gs_.gsc_.editAccountList(0,true,param1.objectId_);
        _local2 = this.map_.gs_.model.lockList.indexOf(param1.accountId_);
        if(_local2 == -1) {
            this.map_.gs_.model.lockList.push(param1.accountId_);
        }
    }

    public function unlockPlayer(param1:Player) : void {
        delete this.starred_[param1.accountId_];
        param1.starred_ = false;
        this.lastUpdate_ = -2147483648;
        this.map_.gs_.gsc_.editAccountList(0,false,param1.objectId_);
    }

    public function setStars(_arg_1:AccountList):void {
        var _local4:int = 0;
        var _local3:* = null;
        var _local2:uint = _arg_1.accountIds_.length;
        _local4 = 0;
        while (_local4 < _local2) {
            _local3 = _arg_1.accountIds_[_local4];
            this.starred_[_local3] = 1;
            this.lastUpdate_ = -2147483648;
            _local4++;
        }
    }

    public function removeStars(_arg_1:AccountList):void {
        var _local4:int = 0;
        var _local3:* = null;
        var _local2:uint = _arg_1.accountIds_.length;
        _local4 = 0;
        while (_local4 < _local2) {
            _local3 = _arg_1.accountIds_[_local4];
            delete this.starred_[_local3];
            this.lastUpdate_ = -2147483648;
            _local4++;
        }
    }

    public function ignorePlayer(param1:Player) : void {
        this.ignored_[param1.accountId_] = 1;
        this.lastUpdate_ = -2147483648;
        this.map_.gs_.gsc_.editAccountList(1,true,param1.objectId_);
    }

    public function unignorePlayer(param1:Player) : void {
        delete this.ignored_[param1.accountId_];
        param1.ignored_ = false;
        this.lastUpdate_ = -2147483648;
        this.map_.gs_.gsc_.editAccountList(1,false,param1.objectId_);
    }

    public function setIgnores(_arg_1:AccountList):void {
        var _local4:int = 0;
        var _local3:* = null;
        this.ignored_ = new Dictionary(true);
        var _local2:uint = _arg_1.accountIds_.length;
        _local4 = 0;
        while (_local4 < _local2) {
            _local3 = _arg_1.accountIds_[_local4];
            this.ignored_[_local3] = 1;
            this.lastUpdate_ = -2147483648;
            _local4++;
        }
    }
}
}
