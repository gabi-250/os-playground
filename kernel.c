void k_main(void) {
	const char *str = "kernel";
	char *video_memory = (char*)0xb8000;
	unsigned int i = 0;
	unsigned int j = 0;

	while(str[j] != '\0') {
		video_memory[i] = str[j++];
		video_memory[i+1] = 0x1f;
		i = i + 2;
	}
}
