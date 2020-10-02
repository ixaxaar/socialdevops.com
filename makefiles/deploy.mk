### DEPLOYMENT
# ██████████████████████████████████████████████████████████████████████

deploy.test.api: ## Test api using payload in $API_PAYLOAD
	echo ${API_PAYLOAD} > ./event && python-lambda-local -f http_server -l ./venv/lib/python3.8/site-packages ./run_lambda.py event && rm -rf event

deploy.build.lambda: ## Build the zip file for deployment
	./bin/bundlelambda ${LAMBDA_ZIP}

deploy.lambda: deploy.build.lambda ## Deploy as an AWS lamdba (sererless)
	./bin/deployterraform

deploy.ecs: ## Deploy into AWS ECS
	./bin/deployecs

deploy.ecr: ## Build and deploy docker container to ECR, pass contianer id in $ECR_REPO
	@eval $$(aws ecr get-login --no-include-email)
	@sh -c "docker build -f docker/delivery/Dockerfile -t ${ECR_REPO} . && docker push ${ECR_REPO}"

deploy.package: ## Build a single binary for deployment (dist/server)
	pyinstaller \
		--onefile \
		--hidden-import gunicorn.glogging \
		--hidden-import gunicorn.workers.sync \
		--add-data "migrations:migrations" \
		--add-data "venv:venv" \
		--add-data "./venv/lib/python3.8/site-packages/flasgger/ui2/templates:templates" \
		--add-data "./venv/lib/python3.8/site-packages/flasgger/ui2/static:static" \
		--add-data "./src/swagger:swagger" \
		--paths ".:./src/:./test:./venv" \
		./src/server.py
