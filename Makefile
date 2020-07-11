.PHONY: install-backend install-frontend deploy-backend deploy-frontend

install-backend:
	cd backend && npm install

install-frontend:
	cd frontend && npm install
build-frontend:
	cd frontend && npm run build

deploy-frontend:
	aws s3 sync frontend/build s3://{$BUCKET_NAME}

deploy-backend:
	cd backend && npm run deploy

