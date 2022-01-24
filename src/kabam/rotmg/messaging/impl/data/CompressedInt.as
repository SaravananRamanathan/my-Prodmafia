 
package kabam.rotmg.messaging.impl.data {
import flash.utils.IDataInput;

public class CompressedInt {
       
      
      public function CompressedInt() {
         super();
      }
      
      public static function Read(param1:IDataInput) : int {
         var _local5:* = 0;
         var _local2:int = param1.readUnsignedByte();
         var _local3:* = (_local2 & 64) != 0;
         var _local4:int = 6;
         _local5 = _local2 & 63;
         while(_local2 & 128) {
            _local2 = param1.readUnsignedByte();
            _local5 = _local5 | (_local2 & 127) << _local4;
            _local4 = _local4 + 7;
         }
         if(_local3) {
            _local5 = int(-_local5);
         }
         return _local5;
      }
   }
}
