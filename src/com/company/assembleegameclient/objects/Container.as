package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.map.Camera;
    import com.company.assembleegameclient.map.Map;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.sound.SoundEffectLibrary;
    import com.company.assembleegameclient.ui.panels.Panel;
    import com.company.assembleegameclient.ui.panels.itemgrids.ContainerGrid;
    import com.company.util.GraphicsUtil;

    import flash.display.BitmapData;
    import flash.display.GraphicsBitmapFill;
    import flash.display.GraphicsPath;
    import flash.geom.Matrix;

    public class Container extends GameObject implements IInteractiveObject {
        public function Container(_arg_1:XML) {
            lastEquips = new <int>[0, 0, 0, 0, 0, 0, 0, 0];
            super(_arg_1);
            isInteractive_ = true;
            this.isLoot_ = "Loot" in _arg_1;
            this.canHaveSoulbound_ = "CanPutSoulboundObjects" in _arg_1;
            this.ownerId_ = "";
        }
        public var isLoot_:Boolean;
        public var canHaveSoulbound_:Boolean;
        public var drawMeBig_:Boolean;
        public var ownerId_:String;
        private var lastEquips:Vector.<int>;
        private var icons_:Vector.<BitmapData> = null;
        private var iconFills_:Vector.<GraphicsBitmapFill> = null;
        private var iconPaths_:Vector.<GraphicsPath> = null;

        override public function addTo(param1:Map, param2:Number, param3:Number):Boolean {
            var _local6:Boolean = false;
            var _local5:Boolean = false;
            if (!super.addTo(param1, param2, param3)) {
                return false;
            }
            if (map_.player_ == null) {
                return true;
            }
            var _local4:Number = map_.player_.getDistSquared(map_.player_.x_, map_.player_.y_, param2, param3);
            if (this.isLoot_) {
                if (Parameters.announcedBags.indexOf(this.objectId_) == -1) {
                    if (this.isWhiteBag()) {
                        if (Parameters.data.showWhiteBagEffect) {
                            !_local6 && this.map_.player_.textNotification("White Bag!", 0xffffff, 2000, true);
                        }
                    } else if (shouldOrangeBagNotify()) {
                        !_local5 && this.map_.player_.textNotification("Orange Bag!", 16744736, 2000, true);
                    }
                }
                if (_local4 < 100) {
                    SoundEffectLibrary.play("loot_appears");
                }
                if (shouldSendBag(this.objectType_)) {
                    this.drawMeBig_ = true;
                }
            }
            return true;
        }

        private function shouldOrangeBagNotify():Boolean {
            return Parameters.data.showOrangeBagEffect && (this.objectType_ == 1295 || this.objectType_ == 1727);
        }

        override public function removeFromMap():void {
            super.removeFromMap();
        }

        override public function draw(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
            super.draw(_arg_1, _arg_2, _arg_3);
            if (Parameters.data.lootPreview) {
                drawItems(_arg_1, _arg_2, _arg_3);
            }
        }

        public function setOwnerId(_arg_1:String):void {
            this.ownerId_ = _arg_1;
            var _local2:Boolean = this.isBoundToCurrentAccount();
            isInteractive_ = this.ownerId_ == "" || _local2;
        }

        public function isBoundToCurrentAccount():Boolean {
            return map_.player_.accountId_ == this.ownerId_;
        }

        public function getPanel(_arg_1:GameSprite):Panel {
            var _local2:Player = _arg_1 && _arg_1.map ? _arg_1.map.player_ : null;
            return new ContainerGrid(this, _local2);
        }

        public function updateItemSprites(_arg_1:Vector.<BitmapData>):void {
            var _local3:int = 0;
            var _local2:* = null;
            var _local5:int = -1;
            var _local4:uint = this.equipment_.length;
            _local3 = 0;
            while (_local3 < _local4) {
                _local5 = this.equipment_[_local3];
                _local2 = ObjectLibrary.getItemIcon(_local5);
                _arg_1.push(_local2);
                _local3++;
            }
        }

        public function vectorsAreEqual(_arg_1:Vector.<int>):Boolean {
            return _arg_1[0] == lastEquips[0] && _arg_1[1] == lastEquips[1] && _arg_1[2] == lastEquips[2] && _arg_1[3] == lastEquips[3] && _arg_1[4] == lastEquips[4] && _arg_1[5] == lastEquips[5] && _arg_1[6] == lastEquips[6] && _arg_1[7] == lastEquips[7];
        }

        public function drawItems(_arg_1:Vector.<GraphicsBitmapFill>, _arg_2:Camera, _arg_3:int):void {
            var _local6:Number = NaN;
            var _local8:Number = NaN;
            var _local13:int = 0;
            var _local10:int = 0;
            var _local14:* = null;
            var _local12:* = null;
            var _local4:* = null;
            var _local5:* = null;
            if (this.icons_ == null) {
                this.icons_ = new Vector.<BitmapData>();
                this.iconFills_ = new Vector.<GraphicsBitmapFill>();
                this.iconPaths_ = new Vector.<GraphicsPath>();
                this.icons_.length = 0;
                updateItemSprites(this.icons_);
            } else if (!vectorsAreEqual(equipment_)) {
                this.icons_.length = 0;
                lastEquips[0] = equipment_[0];
                lastEquips[1] = equipment_[1];
                lastEquips[2] = equipment_[2];
                lastEquips[3] = equipment_[3];
                lastEquips[4] = equipment_[4];
                lastEquips[5] = equipment_[5];
                lastEquips[6] = equipment_[6];
                lastEquips[7] = equipment_[7];
                updateItemSprites(this.icons_);
            }
            var _local9:Number = posS_[3];
            var _local11:Number = this.vS_[1];
            var _local7:int = this.icons_.length;
            _local13 = 0;
            while (_local13 < _local7) {
                _local14 = this.icons_[_local13];
                if (_local13 >= this.iconFills_.length) {
                    this.iconFills_.push(new GraphicsBitmapFill(null, new Matrix(), false, false));
                    this.iconPaths_.push(new GraphicsPath(GraphicsUtil.QUAD_COMMANDS, new Vector.<Number>()));
                }
                _local12 = this.iconFills_[_local13];
                _local4 = this.iconPaths_[_local13];
                _local12.bitmapData = _local14;
                _local10 = _local13 * 0.25;
                _local6 = _local9 - _local14.width * 2 + _local13 % 4 * _local14.width;
                _local8 = _local11 - _local14.height * 0.5 + _local10 * (_local14.height + 5) - (_local10 * 5 + 20);
                _local4.data.length = 0;
                _local4.data.push(_local6, _local8, _local6 + _local14.width, _local8, _local6 + _local14.width, _local8 + _local14.height, _local6, _local8 + _local14.height);
                _local5 = _local12.matrix;
                _local5.identity();
                _local5.translate(_local6, _local8);
                _arg_1.push(_local12);
                _local13++;
            }
        }

        private function shouldSendBag(_arg_1:int):Boolean {
            return _arg_1 >= 1287 && _arg_1 <= 1289 || _arg_1 == 1291 || _arg_1 == 1292 || _arg_1 >= 1294 && _arg_1 <= 1296 || _arg_1 == 1708 || _arg_1 >= 1722 && _arg_1 <= 1728;
        }

        private function isWhiteBag():Boolean {
            return this.objectType_ == 1292 || this.objectType_ == 1296;
        }
    }
}
