package kabam.rotmg.game.model {
public class StatModel {


    public function StatModel(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean) {
        super();
        this.name = _arg_1;
        this.abbreviation = _arg_2;
        this.description = _arg_3;
        this.redOnZero = _arg_4;
    }
    public var name:String;
    public var abbreviation:String;
    public var description:String;
    public var redOnZero:Boolean;
}
}
