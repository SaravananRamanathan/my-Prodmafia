package kabam.rotmg.chat.control {
import com.company.assembleegameclient.parameters.Parameters;

public class SpamFilter {


    private const filterTable:Array = createFilterTable();

    private const testPatterns:Array = returnTestPatterns();

    public function SpamFilter() {
        super();
    }
    private var newPatterns:Array;
    private var patterns:Array;
    private var regex:RegExp;

    public function setPatterns(_arg_1:Array):void {
        this.newPatterns = _arg_1;
        this.patterns = this.returnAppropriatePatterns();
        var _local2:String = this.patterns.join("|");
        this.regex = new RegExp(_local2, "g");
        this.evalAreValuesIdentical();
    }

    private function createFilterTable():Array {
        var _local1:* = null;
        var _local3:* = [];
        var _local2:* = ["Aa", "Bb", "Cc", "Dd", "Ee", "Ff", "Gg", "Hh", "Ii", "Jj", "Kk", "Ll", "Mm", "Nn", "Oo", "Pp", "Qq", "Rr", "Ss", "Tt", "Uu", "Vv", "Ww", "Xx", "Yy", "Zz", "00", "11", "22", "33", "44", "55", "66", "77", "88", "99"];
        for each(_local1 in _local2) {
            _local3[_local1.charCodeAt(0)] = _local1.charAt(1);
            _local3[_local1.charCodeAt(1)] = _local1.charAt(1);
        }
        return _local3;
    }

    private function evalAreValuesIdentical():void {
        var _local1:int = 0;
        while (_local1 < this.testPatterns.length) {
            _local1++;
        }
    }

    private function applyFilterOn(_arg_1:String):String {
        var _local3:* = null;
        var _local4:int = 0;
        var _local2:* = [];
        while (_local4 < _arg_1.length) {
            _local3 = this.filterTable[_arg_1.charCodeAt(_local4)];
            if (_local3 !== null) {
                _local2.push(_local3);
            }
            _local4++;
        }
        return _local2.join("");
    }

    private function returnAppropriatePatterns():Array {
        var startString:* = null;
        var counter:int = 0;
        var counter2:int = 0;
        while (counter2 < this.newPatterns.length) {
            startString = "";
            counter = 0;
            while (counter < this.newPatterns[counter2].length) {
                if (this.newPatterns[counter2].charAt(counter) != "\'" && this.newPatterns[counter2].charAt(counter) != "\"") {
                    startString = startString.concat(this.newPatterns[counter2].charAt(counter));
                }
                counter++;
            }
            this.newPatterns[counter2] = startString;
            counter2++;
        }
        var newPatterns:Array = this.newPatterns;
        newPatterns.sort();
        return newPatterns;
    }

    private function returnTestPatterns():Array {
        return ["[a4]mmysh[o0]p", "[i1|l]nst[a4]ntd[e3][il1|][i1|l]v[e3]ry", "[i1|l]nst[a4]p[o0]ts", "[i1|l]p[o0]?tsc?[o0]?",
            "[i1l].{0,15}p[o0]?ts.{0,15}c[o0]?", "[i1l].{0,15}p[o0]?ts.{0,15}c[o0]?", "[i1l].{0,15}p[o0]?ts.{0,15}c[o0]?",
            "[il1|]nst[a4].{0,15}p[0o]ts", "[o0]ryx.{0,5}in", "[o0]ryxs[e3]t[o0][e3]u", "[o0]ryxsho[o0]pru", "buyfr[o0]mus",
            "ch[e3][a4]p[o0]ryx", "ch[e3][a4]pestp[o0]t[i1|l][0o]ns", "ch[e3][a4]pst[a4]tp[o0]ts", "d[o0]tc[o0]", "d[o0]tn[e3]t",
            "fr[e3][e3]mu[il1|][e3]", "fr[e3][e3]r[o0]tmg", "nst[a4].{0,15}p[0o]t[s5]", "p[o0]t[i1|l][o0]ns.{0,15}r[o0]tmg",
            "r[0o]?tmg.{0,15}[0o]ut", "r[0o]?tmg.{0,15}c[a40o]", "r[0o]?tmg.{0,15}gu[i1|l][i1|l]ds", "r[0o]?tmg.{0,15}pr[0o]sh[0o]p",
            "r[0o]?tmg.{0,15}s[a4][i1|l][e3]", "r[0o]?tmg.{0,15}sh[0o]pn[i1|l]", "r[0o]?tmg.{0,15}v[a4]u[i1|l]tc[0o]m",
            "r[e3][a4][i1|l]mg[o0][o0]ds", "r[e3][a4][i1|l]mg[o0]d", "r[e3][a4][i1|l]mk[i1|l]ng", "r[e3][a4][i1|l]mki[il1|]ngs",
            "r[e3][a4][i1|l]mp[0o]ts", "r[e3][a4][i1|l]mw[i1|l]nn[e3]r", "r[o0]?tmg.{0,15}.{0,15}m[0o]dz", "r[o0]?tmg.{0,15}[9p][o0].{0,15}c[o0]m",
            "r[o0]?tmg.{0,15}[o0]ut[l1i]et.{0,15}c[0o]m", "r[o0]?tmg.{0,15}[s5][a4][l1i|][e3]", "r[o0]?tmg.{0,15}p[0o].{0,15}c[0o]m",
            "r[o0]?tmg.{0,15}w[s5]", "wh[i1|l]t[e3].{0,15}b[a4]gd[0o]t", "wh[i1|l]t[e3].{0,15}b[a4]gn[e3]t", "wh[il1|]t[e3].{0,15}b[a4]gc[0o]m",
            "atestingstring"];
    }
}
}
