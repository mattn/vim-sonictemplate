\(\S\+\)\.var$
	var {{$1}} = {{_cursor_}};

^\s*\zs\(\S.*\)\.throw$
	throw {{$1}};

