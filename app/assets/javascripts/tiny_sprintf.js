/**
 * Created with JetBrains RubyMine.
 * User: ken
 * Date: 2013/06/23
 * Time: 17:01
 * To change this template use File | Settings | File Templates.
 */
if (!String.prototype.sprintf) {
    String.prototype.sprintf = function(args___) {
        var rv = [], i = 0, v, width, precision, sign, idx, argv = arguments, next = 0;
        var s = (this + "     ").split(""); // add dummy 5 chars.
        var unsign = function(val) { return (val >= 0) ? val : val % 0x100000000 + 0x100000000; };
        var getArg = function() { return argv[idx ? idx - 1 : next++]; };

        for (; i < s.length - 5; ++i) {
            if (s[i] !== "%") { rv.push(s[i]); continue; }

            ++i, idx = 0, precision = undefined;

            // arg-index-specifier
            if (!isNaN(parseInt(s[i])) && s[i + 1] === "$") { idx = parseInt(s[i]); i += 2; }
            // sign-specifier
            sign = (s[i] !== "#") ? false : ++i, true;
            // width-specifier
            width = (isNaN(parseInt(s[i]))) ? 0 : parseInt(s[i++]);
            // precision-specifier
            if (s[i] === "." && !isNaN(parseInt(s[i + 1]))) { precision = parseInt(s[i + 1]); i += 2; }

            switch (s[i]) {
                case "d": v = parseInt(getArg()).toString(); break;
                case "u": v = parseInt(getArg()); if (!isNaN(v)) { v = unsign(v).toString(); } break;
                case "o": v = parseInt(getArg()); if (!isNaN(v)) { v = (sign ? "0"  : "") + unsign(v).toString(8); } break;
                case "x": v = parseInt(getArg()); if (!isNaN(v)) { v = (sign ? "0x" : "") + unsign(v).toString(16); } break;
                case "X": v = parseInt(getArg()); if (!isNaN(v)) { v = (sign ? "0X" : "") + unsign(v).toString(16).toUpperCase(); } break;
                case "f": v = parseFloat(getArg()).toFixed(precision); break;
                case "c": width = 0; v = getArg(); v = (typeof v === "number") ? String.fromCharCode(v) : NaN; break;
                case "s": width = 0; v = getArg().toString(); if (precision) { v = v.substring(0, precision); } break;
                case "%": width = 0; v = s[i]; break;
                default:  width = 0; v = "%" + ((width) ? width.toString() : "") + s[i].toString(); break;
            }
            if (isNaN(v)) { v = v.toString(); }
            (v.length < width) ? rv.push(" ".repeat(width - v.length), v) : rv.push(v);
        }
        return rv.join("");
    };
}
if (!String.prototype.repeat) {
    String.prototype.repeat = function(n) {
        var rv = [], i = 0, sz = n || 1, s = this.toString();
        for (; i < sz; ++i) { rv.push(s); }
        return rv.join("");
    };
}