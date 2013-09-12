get(new Route("{{_cursor_}}") {
	@Override
	public Object handle(Request request, Response response) {
		return "";
	}
});
