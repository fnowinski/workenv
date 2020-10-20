tmux new-session -s dev -n servers -d
tmux split-window -v -t dev:1
tmux split-window -v -t dev:1
tmux new-window -n vim -t dev
tmux new-window -n console -t dev
tmux new-window -n bside -t dev
tmux new-window -n sgraph -t dev
tmux new-window -n graph -t dev
tmux new-window -n sserver -t dev
tmux new-window -n studio -t dev

tmux send-keys -t dev:1.0 'cd ~/Projects/tc-www; rs' C-m
tmux send-keys -t dev:1.1 'react; yarn start' C-m
tmux send-keys -t dev:1.2 'cd ~/Projects/tc-www; rsd'

tmux send-keys -t dev:2.0 'cd ~/Projects/tc-www; master' C-m
tmux send-keys -t dev:3.0 'cd ~/Projects/tc-www' C-m
tmux send-keys -t dev:4.0 'bside' C-m
tmux send-keys -t dev:5.0 'cd ~/Projects/graph; npm run start-dev-server-tc-studio' C-m
tmux send-keys -t dev:6.0 'cd ~/Projects/graph' C-m
tmux send-keys -t dev:7.0 'cd ~/Projects/studio; npm start' C-m
tmux send-keys -t dev:8.0 'cd ~/Projects/studio' C-m

tmux select-window -t dev:1
tmux attach -t dev
