set default-list := true

lint:
    ruff check .
    ty check .

fmt:
    ruff format .
