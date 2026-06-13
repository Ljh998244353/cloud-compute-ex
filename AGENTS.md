# Repository Guidelines

## Project Structure & Module Organization

This repository contains materials and editable scaffolds for a cloud computing course design. `docs/` holds task notes, plans, FAQs, and the report draft. `asst/` stores original assignment resources; treat these as reference inputs. `resources/` contains extracted offline packages for Helm, Spark Operator, MPI Operator, and monitoring. `scaffold/` is the main working area:

- `part1-app/`: containerized Flask backend, static frontend, and Docker Compose setup.
- `part1-k8s/`: Kubernetes manifests for workloads, Services, PVC, ConfigMap, Secret, and HPA.
- `part2-spark/`: PySpark scripts and `SparkApplication` manifest.
- `part2-mpi/`: MPI Python example and `MPIJob` manifest.

## Build, Test, and Development Commands

Run commands from the repository root unless noted.

- `cd scaffold/part1-app && docker compose up --build`: build and run the local frontend, backend, and Redis stack.
- `curl http://localhost:5000/api/ping`: verify the backend API.
- `curl http://localhost:5000/api/redis`: verify backend-to-Redis connectivity.
- `python3 -m py_compile scaffold/part1-app/backend/app.py scaffold/part2-spark/*.py scaffold/part2-mpi/*.py`: check Python syntax.
- `kubectl apply --dry-run=client -f scaffold/part1-k8s/`: validate Kubernetes YAML locally after replacing placeholders.

## Coding Style & Naming Conventions

Use 4-space indentation for Python and keep functions small. Prefer lowercase snake_case for Python functions and variables. Keep Kubernetes resource names lowercase with hyphens, matching files such as `backend-deployment.yaml` and `redis-pvc.yaml`. Preserve `part1-` and `part2-` prefixes so report sections and assets remain easy to map.

## Testing Guidelines

There is no formal test suite yet. Before committing, run Python syntax checks and validate changed YAML with `kubectl --dry-run=client`. For app changes, exercise both `/api/ping` and `/api/redis` through Docker Compose and capture any screenshots or terminal output needed for the course report. Do not submit manifests that still contain placeholders such as `<YOUR_STUDENT_ID>`, `<YOUR_ORG>`, or `<BUCKET>`.

## Commit & Pull Request Guidelines

The history only contains an initial commit, so use concise imperative commit messages, for example `Add Redis connectivity check` or `Update Spark analysis scaffold`. Keep each commit focused on one task section. Pull requests should include purpose, changed paths, validation commands, linked course task section, and screenshots for UI, CCE, Spark, MPI, or monitoring results when applicable.

## Security & Configuration Tips

Never commit real cloud credentials, SWR passwords, kubeconfig files, or plaintext Redis passwords. Use Kubernetes Secrets for sensitive values and generate base64 content with `echo -n "value" | base64`. Keep large vendor archives in `asst/` or `resources/`; avoid duplicating extracted packages unless required by the assignment.

## Course Experiment Guidance

When guiding the course design, work step by step according to `docs/course-design-taskbook.md`. At each experimental action, remind the user what screenshot or terminal output is needed for grading before moving on. Record confirmed results, commands, screenshot numbers, problems, and fixes in `docs/report.md` as the experiment progresses. Do not invent results; leave `TODO` where the user has not provided evidence yet.

The assistant is responsible for tracking report evidence and producing the final report draft. After each completed task, update the relevant report section with the real command, result summary, screenshot reference, and short analysis required by the rubric. Keep the user focused on one current action, and verify each result before starting the next step.
