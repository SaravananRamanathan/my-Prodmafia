package kabam.rotmg.packages.control {
import kabam.rotmg.packages.services.PackageModel;
import kabam.rotmg.promotions.model.BeginnersPackageModel;

public class InitPackagesCommand {


    public function InitPackagesCommand() {
        super();
    }
    [Inject]
    public var beginnersPackageModel:BeginnersPackageModel;
    [Inject]
    public var packageModel:PackageModel;
    [Inject]
    public var beginnersPackageAvailable:BeginnersPackageAvailableSignal;
    [Inject]
    public var packageAvailable:PackageAvailableSignal;

    public function execute():void {
        var _local1:Boolean = this.beginnersPackageModel.status == 0 && this.packageModel.startupPackage() != null;
        if (this.beginnersPackageModel.isBeginnerAvailable() || _local1) {
            this.beginnersPackageAvailable.dispatch(_local1);
        } else if (this.packageModel.hasPackages()) {
            this.packageAvailable.dispatch();
        }
    }
}
}
