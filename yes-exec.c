#define _XOPEN_SOURCE 500

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <wait.h>

int main(int argc, char *argv[]) {
	long i, count;

	if (argc <= 2) {
		fprintf(stderr, "usage: %s count /full/path/to-some/command\n", argv[0]);
		return 2;
	}

	count = atol(argv[1]);

	for (i = 0; i < count; ++i) {
		int status;
		pid_t forked = vfork();

		if (0 == forked) {
			execv(argv[2], argv + 1);
			perror("exec failed");
			_exit(1);
		}

		if (-1 == forked) {
			perror("vfork failed");
			return 2;
		}

		if (-1 == waitpid(forked, &status, 0)) {
			perror("waitpid failed");
			return 3;
		}

		if (0 != WEXITSTATUS(status)) {
			fprintf(stderr, "child failed, probably to exec\n");
			return 4;
		}
	}

	return 0;
}
