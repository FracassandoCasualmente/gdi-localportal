psql-kc:
	docker compose exec -it postgres psql keycloakdb -U keycloakuser
psql-molgenis:
	docker compose exec -it postgres psql molgenisdb -U molgenis
