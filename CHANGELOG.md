# Changelog

## v1.24.7 (2026-11-18)

- First release of the template: Alby Hub v1.24.7 (`ghcr.io/getalby/hub:v1.24.7@sha256:7e3de6dac330fb8a426c02a247d81ebaf07deece22634e97d8f20dd48c3a8e38`).
- One service built from this repo, volume at `/data` (`WORK_DIR=/data/albyhub`), health check `/api/info`.
- `SETUP_CODE` is generated per deploy, so only the deployer can run first-time setup.
