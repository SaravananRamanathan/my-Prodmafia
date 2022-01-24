 
package kabam.rotmg.messaging.impl.incoming {
import com.company.assembleegameclient.util.FreeList;

import flash.utils.IDataInput;

import kabam.rotmg.messaging.impl.data.CompressedInt;
import kabam.rotmg.messaging.impl.data.GroundTileData;
import kabam.rotmg.messaging.impl.data.ObjectData;

public class Update extends IncomingMessage {
       
      
      public var tiles_:Vector.<GroundTileData>;
      
      public var newObjs_:Vector.<ObjectData>;
      
      public var drops_:Vector.<int>;
      
      public function Update(param1:uint, param2:Function) {
         this.tiles_ = new Vector.<GroundTileData>();
         this.newObjs_ = new Vector.<ObjectData>();
         this.drops_ = new Vector.<int>();
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void {
         var _local4:* = 0;
         var _local2:int = CompressedInt.Read(param1);
         var _local3:uint = this.tiles_.length;
         _local4 = uint(_local2);
         while(_local4 < _local3) {
            FreeList.deleteObject(this.tiles_[_local4]);
            _local4++;
         }
         this.tiles_.length = Math.min(_local2,_local3);
         while(this.tiles_.length < _local2) {
            this.tiles_.push(FreeList.newObject(GroundTileData) as GroundTileData);
         }
         _local4 = uint(0);
         while(_local4 < _local2) {
            this.tiles_[_local4].parseFromInput(param1);
            _local4++;
         }
         this.newObjs_.length = 0;
         _local2 = CompressedInt.Read(param1);
         _local3 = this.newObjs_.length;
         _local4 = uint(_local2);
         while(_local4 < _local3) {
            FreeList.deleteObject(this.newObjs_[_local4]);
            _local4++;
         }
         this.newObjs_.length = Math.min(_local2,_local3);
         while(this.newObjs_.length < _local2) {
            this.newObjs_.push(FreeList.newObject(ObjectData) as ObjectData);
         }
         _local4 = uint(0);
         while(_local4 < _local2) {
            this.newObjs_[_local4].parseFromInput(param1);
            _local4++;
         }
         this.drops_.length = 0;
         _local2 = CompressedInt.Read(param1);
         _local4 = uint(0);
         while(_local4 < _local2) {
            this.drops_.push(CompressedInt.Read(param1));
            _local4++;
         }
      }
      
      override public function toString() : String {
         return formatToString("UPDATE","tiles_","newObjs_","drops_");
      }
   }
}
