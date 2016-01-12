#! /bin/bash -e

RPMDIR=/Users/klibby/Work/rpmbuild

usage() {
  echo "Run a docker image from the given folder (and tag it)"
  echo
  echo "$0 <folder>"
  echo
}

run() {
  local folder=$1
  local folder_reg="$1/REGISTRY"
  local folder_ver="$1/VERSION"

  if [ "$folder" == "" ];
  then
    usage
    return
  fi

  test -d "$folder" || usage_err "Unknown folder: $folder"
  test -f "$folder_ver" || usage_err "$folder must contain VERSION file"

  # Fallback to default registry if one is not in the folder...
  if [ ! -f "$folder_reg" ]; then
    folder_reg=$PWD/REGISTRY
  fi

  local registry=$(cat $folder_reg)
  local version=$(cat $folder_ver)

  test -n "$registry" || usage_err "$folder_reg is empty aborting..."
  test -n "$version" || usage_err "$folder_ver is empty aborting..."

  local tag="$registry/$folder:$version"

  if ! docker images $tag > /dev/null; then
    echo "Docker image \"$tag\" not found; run build.sh?"
    exit 1
  fi

  if [ -f $folder/run.sh ]; then
    shift
    $folder/run.sh -t $tag $*
  else
    docker run --rm -t -i -u build -v $RPMDIR:/home/build/rpmbuild $tag
  fi

}

if ! which docker > /dev/null; then
  echo "Docker must be installed read installation instructions at docker.com"
  echo
  usage
  exit 1
fi

eval $(docker-machine env default) 

if ! docker version > /dev/null;
then
  echo "Docker server is unresponsive run 'docker ps' and check that docker is"
  echo "running"
  echo
  usage
  exit 1
fi

run $*

