# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- support multiple recipients

### Changed
- replaced environment variable `RECIPIENT_ADDRESS` with `MAIL_TO`
- recipients are inserted in `To:` header

### Fixed
- `docker-compose`: drop capabilities
- `Dockerfile`: add registry to base image specifier for `podman build`

### Removed
- sample ansible playbook to avoid duplication of container settings in `docker-compose.yml`

## [1.0.0] - 2020-01-04

[Unreleased]: https://github.com/fphammerle/docker-onion-service-status-mail/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/fphammerle/docker-onion-service-status-mail/tree/v1.0.0
