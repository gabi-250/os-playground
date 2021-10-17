void k_main(void) {
	const char *str = "Hello from C";
	char *video_memory = (char *)0xb8000;
	unsigned int i = 0;
	unsigned int j = 0;
	while (str[j] != '\0') {
		// add 2 * 80 to make this appear on the second line of the
		// 80x25 display
		video_memory[i + 2 * 80] = str[j++];
		video_memory[i + 2 * 80 + 1] = 0x1f;
		i = i + 2;
	}
}
