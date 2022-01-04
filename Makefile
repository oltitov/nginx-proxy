create-network:
	docker network create network

build-prod:
	docker-compose up -d --build