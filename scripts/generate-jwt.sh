# scripts/generate-jwt.sh
#!/bin/bash
set -e
openssl rand -hex 32 > jwt.hex
echo "JWT secret generated and written to jwt.hex"
