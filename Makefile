.PHONY: setup run test test-api test-e2e lint trace docker-test
setup:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements-dev.txt && playwright install --with-deps chromium
run:
	GRIDWATCH_ENABLE_RESET=1 uvicorn app.main:app --reload
test:
	pytest
test-api:
	pytest -m "api or data"
test-e2e:
	pytest -m e2e --headed --slowmo 300
lint:
	ruff check .
trace:
	python scripts/traceability.py
docker-test:
	docker compose up --build --abort-on-container-exit --exit-code-from tests
