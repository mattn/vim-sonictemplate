void*  pbuf;
FormatMessageA(
	FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
	NULL,
	GetLastError(),
	MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
	(LPSTR) &pbuf,
	0,
	NULL
);

{{_cursor_}}
LocalFree(pbuf);
