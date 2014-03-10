#ifdef _WIN32
# include <ws2tcpip.h>
#else
# include <sys/fcntl.h>
# include <sys/types.h>
# include <sys/socket.h>
# include <netinet/in.h>
# include <netdb.h>
# include <stdio.h>
#define closesocket(fd) close(fd)
#endif

int
main(int argc, char* argv[]) {
	int server_fd;
	int client_fd;
	int writer_len;
	struct sockaddr_in reader_addr; 
	struct sockaddr_in writer_addr;

#ifdef _WIN32
	WSADATA wsa;
	WSAStartup(MAKEWORD(2, 0), &wsa);
#endif

	if ((server_fd = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
		perror("reader: socket");
		exit(1);
	}

	memset((char *) &reader_addr, 0, sizeof(reader_addr));
	reader_addr.sin_family = PF_INET;
	reader_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	//reader_addr.sin_port = htons(8000);
	reader_addr.sin_port = 0;

	if (bind(server_fd, (struct sockaddr *)&reader_addr, sizeof(reader_addr)) < 0) {
		perror("reader: bind");
		exit(1);
	}
	size_t socklen = sizeof(reader_addr);
	if (getsockname(server_fd, (struct sockaddr *)&reader_addr, &socklen) < 0) {
		perror("reader: bind");
		exit(1);
	}

	if (listen(server_fd, 5) < 0) {
		perror("reader: listen");
		close(server_fd);
		exit(1);
	}

	if ((client_fd = accept(server_fd,(struct sockaddr *)&writer_addr, &writer_len)) < 0) {
		perror("reader: accept");
		exit(1);
	}

	while (1) {
		char buf[256];
		size_t n = recv(client_fd, buf, sizeof(buf), 0);
		puts(buf);
		if (n == 0) {
			break;
		} else if (n == -1) {
			perror("recv");
			exit(EXIT_FAILURE);
		} else {
			send(client_fd, buf, n, 0);
		}
	}

	closesocket(server_fd);

#ifdef _WIN32
	WSACleanup();
#endif
}
