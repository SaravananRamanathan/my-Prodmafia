package kabam.rotmg.core.service {
import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.application.DynamicSettings;
import kabam.rotmg.core.signals.AppInitDataReceivedSignal;

import robotlegs.bender.framework.api.ILogger;

public class RequestAppInitTask extends BaseTask {


    public function RequestAppInitTask() {
        super();
    }
    [Inject]
    public var logger:ILogger;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var account:Account;
    [Inject]
    public var appInitConfigData:AppInitDataReceivedSignal;

    override protected function startTask():void {
        this.client.setMaxRetries(2);
        this.localComplete();
    }

    private function localComplete():void {
        var _local1:XML = XML("<AppSettings><UseExternalPayments>1</UseExternalPayments><MaxStackablePotions>6</MaxStackablePotions><PotionPurchaseCooldown>400</PotionPurchaseCooldown><PotionPurchaseCostCooldown>8000</PotionPurchaseCostCooldown><PotionPurchaseCosts><cost>5</cost><cost>10</cost><cost>20</cost><cost>40</cost><cost>80</cost><cost>120</cost><cost>200</cost><cost>300</cost><cost>450</cost><cost>600</cost></PotionPurchaseCosts><FilterList>[a4]mmysh[o0]p\n\"[i1|l].{0,15}p[o0]?ts.{0,15}c[o0]?\"\n[i1|l]nst[a4]ntd[e3][il1|][i1|l]v[e3]ry\n[i1|l]nst[a4]p[o0]ts\n[i1|l]p[o0]?tsc?[o0]?\n\"[il1|]nst[a4].{0,15}p[0o]ts\"\n\"[o0]ryx.{0,5}in\"\n\"[o0]ryx{0,10}?pr[0o]\"\n[o0]ryxs[e3]t[o0][e3]u\n[o0]ryxsh[o0]pru\n[o0]w[il1|]y\nb[il1|]tly\nbuyfr[o0]mus\nch[e3][a4]p[o0]ryx\nch[e3][a4]pestp[o0]t[i1|l][0o]ns\nch[e3][a4]pst[a4]tp[o0]ts\nd[o0]tc[o0]\nd[o0]tn[e3]t\nfr[e3][e3]mu[il1|][e3]\nfr[e3][e3]r[o0]tmg\ng[0o][0o]gl\n\"nst[a4].{0,15}p[0o]t[s5]\"\n\"p[o0]t[i1|l][o0]ns.{0,15}?r[e3][a4][il1|]?m?(net)?\"\n\"p[o0]t[i1|l][o0]ns.{0,15}?r[o0]tmg\"\n\"r[0o]?tmg.{0,15}[0o]ut\"\n\"r[0o]?tmg.{0,15}c[a40o]\"\n\"r[0o]?tmg.{0,15}gu[i1|l][i1|l]ds\"\n\"r[0o]?tmg.{0,15}p[0o]t[s5]\"\n\"r[0o]?tmg.{0,15}pr[0o]sh[0o]p\"\n\"r[0o]?tmg.{0,15}s[a4][i1|l][e3]\"\n\"r[0o]?tmg.{0,15}sh[0o]pn[i1|l]\"\n\"r[0o]?tmg.{0,15}v[a4]u[i1|l]tc[0o]m\"\n\"r[e3][a4][i1|l]m.{0,15}g[o0][o0]ds\"\n\"r[e3][a4][i1|l]m.{0,15}g[o0]d\"\n\"r[e3][a4][i1|l]m.{0,15}k[i1|l]ng\"\n\"r[e3][a4][i1|l]m.{0,15}p[0o]ts\"\n\"r[e3][a4][i1|l]m.{0,15}w[i1|l]nn[e3]r\"\n\"r[o0]?tmg.{0,15}[o0]ut[l1i]et.{0,15}c[0o]m\"\n\"r[o0]?tmg.{0,15}[s5][a4][l1i|][e3]\"\n\"r[o0]?tmg.{0,15}m[0o]dz\"\n\"r[o0]?tmg.{0,15}p[0o].{0,15}c[0o]m\"\n\"r[o0]?tmg.{0,15}w[s5]\"\nt[il1|]nyur[il1|]\n\"wh[i1|l]t[e3].{0,15}b[a4]g.{0,15}d[0o]t\"\n\"wh[i1|l]t[e3].{0,15}b[a4]g.{0,15}n[e3]t\"\n\"wh[il1|]t[e3].{0,15}b[a4]g.{0,15}c[0o]m\"\nMMMMM\nb[e3]rt\nhttp://\n</FilterList><DisableRegist>0</DisableRegist><MysteryBoxRefresh>180</MysteryBoxRefresh><SalesforceMobile>0</SalesforceMobile><UGDOpenSubmission>1</UGDOpenSubmission></AppSettings>");
        this.appInitConfigData.dispatch(_local1);
        this.initDynamicSettingsClass(_local1);
        completeTask(true, "<AppSettings><UseExternalPayments>1</UseExternalPayments><MaxStackablePotions>6</MaxStackablePotions><PotionPurchaseCooldown>400</PotionPurchaseCooldown><PotionPurchaseCostCooldown>8000</PotionPurchaseCostCooldown><PotionPurchaseCosts><cost>5</cost><cost>10</cost><cost>20</cost><cost>40</cost><cost>80</cost><cost>120</cost><cost>200</cost><cost>300</cost><cost>450</cost><cost>600</cost></PotionPurchaseCosts><FilterList>[a4]mmysh[o0]p\n\"[i1|l].{0,15}p[o0]?ts.{0,15}c[o0]?\"\n[i1|l]nst[a4]ntd[e3][il1|][i1|l]v[e3]ry\n[i1|l]nst[a4]p[o0]ts\n[i1|l]p[o0]?tsc?[o0]?\n\"[il1|]nst[a4].{0,15}p[0o]ts\"\n\"[o0]ryx.{0,5}in\"\n\"[o0]ryx{0,10}?pr[0o]\"\n[o0]ryxs[e3]t[o0][e3]u\n[o0]ryxsh[o0]pru\n[o0]w[il1|]y\nb[il1|]tly\nbuyfr[o0]mus\nch[e3][a4]p[o0]ryx\nch[e3][a4]pestp[o0]t[i1|l][0o]ns\nch[e3][a4]pst[a4]tp[o0]ts\nd[o0]tc[o0]\nd[o0]tn[e3]t\nfr[e3][e3]mu[il1|][e3]\nfr[e3][e3]r[o0]tmg\ng[0o][0o]gl\n\"nst[a4].{0,15}p[0o]t[s5]\"\n\"p[o0]t[i1|l][o0]ns.{0,15}?r[e3][a4][il1|]?m?(net)?\"\n\"p[o0]t[i1|l][o0]ns.{0,15}?r[o0]tmg\"\n\"r[0o]?tmg.{0,15}[0o]ut\"\n\"r[0o]?tmg.{0,15}c[a40o]\"\n\"r[0o]?tmg.{0,15}gu[i1|l][i1|l]ds\"\n\"r[0o]?tmg.{0,15}p[0o]t[s5]\"\n\"r[0o]?tmg.{0,15}pr[0o]sh[0o]p\"\n\"r[0o]?tmg.{0,15}s[a4][i1|l][e3]\"\n\"r[0o]?tmg.{0,15}sh[0o]pn[i1|l]\"\n\"r[0o]?tmg.{0,15}v[a4]u[i1|l]tc[0o]m\"\n\"r[e3][a4][i1|l]m.{0,15}g[o0][o0]ds\"\n\"r[e3][a4][i1|l]m.{0,15}g[o0]d\"\n\"r[e3][a4][i1|l]m.{0,15}k[i1|l]ng\"\n\"r[e3][a4][i1|l]m.{0,15}p[0o]ts\"\n\"r[e3][a4][i1|l]m.{0,15}w[i1|l]nn[e3]r\"\n\"r[o0]?tmg.{0,15}[o0]ut[l1i]et.{0,15}c[0o]m\"\n\"r[o0]?tmg.{0,15}[s5][a4][l1i|][e3]\"\n\"r[o0]?tmg.{0,15}m[0o]dz\"\n\"r[o0]?tmg.{0,15}p[0o].{0,15}c[0o]m\"\n\"r[o0]?tmg.{0,15}w[s5]\"\nt[il1|]nyur[il1|]\n\"wh[i1|l]t[e3].{0,15}b[a4]g.{0,15}d[0o]t\"\n\"wh[i1|l]t[e3].{0,15}b[a4]g.{0,15}n[e3]t\"\n\"wh[il1|]t[e3].{0,15}b[a4]g.{0,15}c[0o]m\"\nMMMMM\nb[e3]rt\nhttp://\n</FilterList><DisableRegist>0</DisableRegist><MysteryBoxRefresh>180</MysteryBoxRefresh><SalesforceMobile>0</SalesforceMobile><UGDOpenSubmission>1</UGDOpenSubmission></AppSettings>");
    }

    private function onComplete(_arg_1:Boolean, _arg_2:*):void {
        var _local3:XML = XML(_arg_2);
        _arg_1 && this.appInitConfigData.dispatch(_local3);
        this.initDynamicSettingsClass(_local3);
        completeTask(_arg_1, _arg_2);
    }

    private function initDynamicSettingsClass(_arg_1:XML):void {
        if (_arg_1 != null) {
            DynamicSettings.xml = _arg_1;
        }
    }
}
}
