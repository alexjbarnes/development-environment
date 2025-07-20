cd /home/dev/
PORT=8080 HOST=0.0.0.0 vibe-kanban > /tmp/vibe-kanban.log 2>&1 &

cd /home/dev/claudecodeui
PORT=3008 VITE_PORT=3009 npm run dev > /tmp/claude-code-ui.log 2>&1 &

