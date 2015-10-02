{{_lang_util_:package}}

import static spark.Spark.*;

import spark.*;

public class {{_expr_:substitute('{{_name_}}', '\w\+', '\u\0', '')}} {
	public static void main(String[] args) {
		get(new Route("/") {
			@Override
			public Object handle(Request request, Response response) {
				return "{{_cursor_}}";
			}
		});
	}
}
{{_filter_:spark}}
