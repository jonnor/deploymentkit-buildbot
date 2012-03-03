# -*- makefile -*-

SSH_NAME = deploymentkit-buildbot
GIT_NAME = buildbot
BUILDBOT_DIR = ./buildbot

remote_cmd = ssh $(SSH_NAME)
target_branch = master

push-config:
	# Push the changes
	@$(remote_cmd) "cd $(BUILDBOT_DIR) && git checkout HEAD^"
	@git push -f $(GIT_NAME) HEAD:$(target_branch)
	@$(remote_cmd) "cd $(BUILDBOT_DIR) && git checkout $(target_branch)"

	# Check and restart the buildbot
	@$(remote_cmd) "cd $(BUILDBOT_DIR) && buildbot checkconfig && buildbot restart"

	# Sanity check
	@git diff-index --quiet HEAD || echo 'Warning: Uncommitted changes present'
