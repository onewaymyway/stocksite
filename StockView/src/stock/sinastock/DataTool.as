package stock.sinastock 
{
	/**
	 * ...
	 * @author ww
	 */
	public class DataTool 
	{
		
		public function DataTool() 
		{
			
		}
		public static const BStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		public static function c2b(e:String):int {
            e = e.replace(" ", "+");
            var t = BStr.indexOf(e);
            return t >= 0 ? t : 0
        }
		public static function db(e:String):Array {
            if (!e)
                return [];
            for (var t:int, a:int, r:Array = [], n:int = 0, i:int = 0, l:int = 0, s:int = e.length; s > l; l++)
                t = this.c2b(e.charAt(l)),
                a = 6 & i ? 7 & i ^ 7 : 5,
                n |= t >> 5 - a << (7 ^ i) - a,
                64767 == n && 63 == t && (n = 65535),
                i > 25 && (i -= 32,
                r[r.length] = n,
                n = 0),
                n |= (t & (1 << 5 - a) - 1) << (7 | i) + 4 + a,
                i += 6;
            return r;
        }
		public static function fB(t:Array):Array {
            t.splice(360, 3);
			var c:int = Math.floor(t.length/3)*3;
            for (var i:int, s:Array = [], p:int = 0, d:int = 0, u:int = 0; c > u; u += 3)
			{
				 d = Math.floor(u / 3);
				if (t[u + 1] <= 0) continue; 
                s[s.length] = {
                    //time: o[d],
                    avg_price: t[u] / 1e3,
                    price: t[u + 1] / 1e3,
                    volume: t[u + 2] / 100
                };
			}
               
            return s;
        }
		
		public static function parseMinutesData(dataStr:String):Array
		{
			return fB(db(dataStr));
		}
	}

}