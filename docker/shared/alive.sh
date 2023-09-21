kill_service() {
    echo "Docker is killing me!"
    exit 0
}

trap kill_service INT QUIT TERM

echo 'Starting alive script...'
sleep 1

echo 'Running application...'
bash $RUN_BASH_SCRIPT

if [ "$KEEP_CONTAINER_ALIVE" = "yes" ] ; then
  while true; do
    sleep 1
  done
fi