tmux new-session -s dev -n servers -d
tmux new-window -n vim -t dev
tmux new-window -n console -t dev
tmux new-window -n bside -t dev
tmux new-window -n rspec -t dev
tmux new-window -n qa1 -t dev
tmux split-window -v -t dev:3

tmux send-keys -t dev:1.0 'cd ~/Projects/tc-www; dstart' C-m
tmux send-keys -t dev:2.0 'cd ~/Projects/tc-www; master; vim' C-m
tmux send-keys -t dev:3.0 'cd ~/Projects/tc-www' C-m
tmux send-keys -t dev:4.0 'bside' C-m
tmux send-keys -t dev:5.0 'cd ~/Projects/tc-www' C-m
tmux send-keys -t dev:5.0 'cd ~/Projects/tc-www' C-m

tmux select-window -t dev:1
tmux attach -t dev
