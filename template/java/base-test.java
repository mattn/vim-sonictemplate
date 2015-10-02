{{_lang_util_:package}}

import static org.junit.Assert.*;

import org.junit.Test;

/**
 * {{_name_}}
 */
public class {{_name_}} {
	@Test
	public void test{{_input_:func}}() {
		{{_cursor_}}
	}

	@Before
	public void setup() {
	}

	@After
	public void tearDown() {
	}
}
{{_filter_:test}}
