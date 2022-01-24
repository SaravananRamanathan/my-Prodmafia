package io.decagames.rotmg.pets.utils {
    import io.decagames.rotmg.pets.components.petIcon.PetIcon;
    import io.decagames.rotmg.pets.components.petIcon.PetIconFactory;
    import io.decagames.rotmg.pets.components.petItem.PetItem;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    
    public class PetItemFactory {
        
        
        public function PetItemFactory() {
            super();
        }
        
        [Inject]
        public var petIconFactory: PetIconFactory;
        
        public function create(_arg_1: PetVO, _arg_2: int, _arg_3: uint = 5526612, _arg_4: Number = 1): PetItem {
            var _local5: PetItem = new PetItem(_arg_3);
            var _local6: PetIcon = this.petIconFactory.create(_arg_1, _arg_2);
            _local5.setPetIcon(_local6);
            _local5.setSize(_arg_2);
            _local5.setBackground("regular", _arg_3, _arg_4);
            return _local5;
        }
    }
}
