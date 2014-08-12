"""
{{_name_}}
"""

import unittest


class {{_expr_:substitute('{{_input_:name}}', '\w\+', '\u\0', '')}}(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_something(self):
        {{_cursor_}}
