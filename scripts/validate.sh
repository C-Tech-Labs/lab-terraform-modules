#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

if ! command -v terraform >/dev/null 2>&1; then
  echo "[WARN] terraform not found on PATH. Install Terraform to run validation." >&2
  exit 1
fi

echo "Running terraform fmt check..."
terraform fmt -recursive -check

echo "Running terraform validate against examples..."
for dir in $(find examples -maxdepth 1 -mindepth 1 -type d); do
  echo "Validating ${dir}"
  (cd "$dir" && terraform init -backend=false >/dev/null && terraform validate)
done

echo "All validations completed."
