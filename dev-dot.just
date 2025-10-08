set working-directory := '/Users/mrken/Documents/dev/github/hashicorp/tutorials'
set shell := ["bash", "-c"]
set positional-arguments

default: all
all: version build deploy status test clean
clean-all: clean

# version stuff
[group('dev-dot')]
@version:
   echo ">> running $0"
   echo "dev-dot version"

[group('dev-dot')]
@refresh: clean
   echo ">> running $0"
   just dev-dot build


[group('dev-dot')]
@build:
   echo ">> running $0"
   docker-compose build
   docker pull hashicorp/dev-portal:latest
   docker pull postgres:13.3
   docker pull public.ecr.aws/d4t3o3o7/hashicorp-learn-api:latest
   docker pull public.ecr.aws/d4t3o3o7/hashicorp-learn-api-content-sync:latest


[group('dev-dot')]
@run:
   echo ">> running $0"
   make preview

[group('dev-dot')]
@deploy:
   echo ">> running $0"
   

[group('dev-dot')]
@status:
   echo ">> running $0"
   docker container ls | grep "hashicorp"

[group('dev-dot')]
@test:
   echo ">> running $0"
   just dev-dot status

[group('dev-dot')]
clean:
   echo ">> running $0"
   docker container kill learn_api_database dev_portal_frontend content_sync learn_api learn_assets_server
   sleep 3
   docker image rm -f tutorials-learn_assets_server:latest
   docker image rm -f hashicorp/dev-portal:latest
   docker image rm -f postgres:13.3
   docker image rm -f public.ecr.aws/d4t3o3o7/hashicorp-learn-api:latest
