if [ -z "$(pgrep ssh-agent)" ]; then
    rm -rf /tmp/ssh-*;
    eval $(ssh-agent -s) > /dev/null;
else
    export SSH_AGENT_PID=$(pgrep ssh-agent);
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*");
fi


