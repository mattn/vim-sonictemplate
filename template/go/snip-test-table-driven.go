func Test{{_cursor_}}(t *testing.T) {
	tests := []struct{
		name string
		want int
	}{
		{
			name: "case1",
			want: 1,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T){
			got := 1
			if got != tt.want {
				t.Fatalf("want %v, but %v:", tt.want, got)
			}
		})
	}
}
