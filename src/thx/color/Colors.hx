package thx.color;
import thx.error.Error;

using StringTools;
using Strings;
using Arrays;

/**
 * ...
 * @author Franco Ponticelli
 */

class Colors
{
	public static function interpolatef(a : String, b : String, ?interpolator : Float -> Float)
	{
		var ca = parse(a);
		var cb = parse(b);
		var f = Rgb.interpolatef(ca, cb, interpolator);
		return function(v) return f(v).toString();
	}
	
	public static function interpolate(v : Float, a : String, b : String, ?interpolator : Float -> Float)
	{
		return interpolatef(a, b, interpolator)(v);
	}
	
	static var _reParse = ~/^\s*(?:(hsl|rgb|cmyk)\(([^)]+)\))|(?:(?:0x|#)([a-f0-9]{3,6}))\s*$/i;
	// TODO: RGBA?
	public static function parse(s : String)
	{
		_reParse.match("");
		if (!_reParse.match(s))
		{
			var v = NamedColors.byName.get(s);
			if(null == v)
				return throw new Error("invalid color: '{0}'", s);
			else
				return v;
		}
		var type = _reParse.matched(1);
		if (!type.empty())
		{
			var values = _reParse.matched(2).split(",");
			switch(type.toLowerCase())
			{
				case "rgb":		return new Rgb(_c(values[0]), _c(values[1]), _c(values[2]));
				case "hsl": 	return new Hsl(_d(values[0]), _p(values[1]), _p(values[2]));
				case "cmyk":	return new Cmyk(_p(values[0]), _p(values[1]), _p(values[2]), _p(values[3]));
			}
		}
		var color = _reParse.matched(3);
		if (color.length == 3)
			color = color.split("").map(function(d, _) return d + d).join("");
		else if (color.length != 6)
			return throw new Error("invalid color: '{0}'", s);
		return Rgb.fromInt(Std.parseInt("0x" + color));
		// hsl(h,s,l)
		// rgb(r,g,b)
		// rgba(r,g,b,a)
		// hex 3
		// hex 6
		// named
	}
	
	static function _c(s : String) : Int
	{
		return Std.parseInt(s);
	}
	
	static function _d(s : String) : Float
	{
		var s = s.trim();
		if (s.substr( -3) == 'deg')
			s = s.substr(0, -3);
		else if (s.substr( -1) == 'º')
			s = s.substr(0, -1);
		return Std.parseFloat(s);
	}
	
	static function _p(s : String) : Float
	{
		var s = s.trim();
		if (s.substr( -1) == "%")
			return Std.parseFloat(s.substr(0, -1)) / 100;
		else
			return Std.parseFloat(s);
	}
}