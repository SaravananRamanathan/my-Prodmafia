 
package kabam.rotmg.messaging.impl.incoming {
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

public class Pic extends IncomingMessage {
       
      
      public var bitmapData_:BitmapData = null;
      
      public function Pic(param1:uint, param2:Function) {
         super(param1,param2);
      }
      
      override public function parseFromInput(param1:IDataInput) : void {
         var _local2:int = param1.readInt();
         var _local3:int = param1.readInt();
         var _local4:ByteArray = new ByteArray();
         param1.readBytes(_local4,0,_local2 * _local3 * 4);
         this.bitmapData_ = new BitmapData(_local2,_local3,true,0);
         this.bitmapData_.setPixels(this.bitmapData_.rect,_local4);
      }
      
      override public function toString() : String {
         return formatToString("PIC","bitmapData_");
      }
   }
}
