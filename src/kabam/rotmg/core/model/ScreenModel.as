package kabam.rotmg.core.model {
import com.company.assembleegameclient.screens.AccountLoadingScreen;

public class ScreenModel {


    public function ScreenModel() {
        super();
    }
    private var currentType:Class;

    public function setCurrentScreenType(_arg_1:Class):void {
        if (_arg_1 != AccountLoadingScreen) {
            this.currentType = _arg_1;
        }
    }

    public function getCurrentScreenType():Class {
        return this.currentType;
    }
}
}
