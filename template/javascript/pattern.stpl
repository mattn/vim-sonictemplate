\(\S\+\)\.var$
	var {{$1}} = {{_cursor_}};

^\s*\zs\(\S.*\)\.throw$
	throw {{$1}};

\(\S\+\)\.notif$
	if ({{$1}} != null) {
		{{_cursor_}}
	}

