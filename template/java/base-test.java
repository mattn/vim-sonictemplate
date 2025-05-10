{{_lang_util_:package}}

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/**
 * {{_name_}}
 */
public class {{_name_}} {
	@Test
	public void test{{_input_:func}}() {
		{{_cursor_}}
	}

	@BeforeEach
	public void setup() {
	}

	@AfterEach
	public void tearDown() {
	}
}
{{_filter_:test}}
