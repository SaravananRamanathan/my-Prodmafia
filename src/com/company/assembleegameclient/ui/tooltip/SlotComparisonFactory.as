package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.CloakComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GeneralProjectileComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GenericArmorComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.HelmetComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.OrbComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SealComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SlotComparison;
import com.company.assembleegameclient.ui.tooltip.slotcomparisons.TomeComparison;

public class SlotComparisonFactory {


    public function SlotComparisonFactory() {
        super();
        var _local1:GeneralProjectileComparison = new GeneralProjectileComparison();
        var _local2:GenericArmorComparison = new GenericArmorComparison();
        this.hash = {};
        this.hash[4] = new TomeComparison();
        this.hash[6] = _local2;
        this.hash[7] = _local2;
        this.hash[12] = new SealComparison();
        this.hash[13] = new CloakComparison();
        this.hash[14] = _local2;
        this.hash[16] = new HelmetComparison();
        this.hash[21] = new OrbComparison();
    }
    private var hash:Object;

    public function getComparisonResults(_arg_1:XML, _arg_2:XML):SlotComparisonResult {
        var _local5:int = _arg_1.SlotType;
        var _local4:SlotComparison = this.hash[_local5];
        var _local3:SlotComparisonResult = new SlotComparisonResult();
        if (_local4 != null) {
            _local4.compare(_arg_1, _arg_2);
            _local3.lineBuilder = _local4.comparisonStringBuilder;
            _local3.processedTags = _local4.processedTags;
        }
        return _local3;
    }
}
}
