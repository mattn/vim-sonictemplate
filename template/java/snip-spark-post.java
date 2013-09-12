post(new Route("/{{_cursor_}}") {
	@Override
	public Object handle(Request request, Response response) {
		String body = request.body();
		return body;
	}
});
