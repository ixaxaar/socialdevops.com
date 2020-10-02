.DEFAULT_GOAL := help
SHELL := /bin/bash

include .envrc

install: local.install ## Install

start: local.start ## Start

services: local.services ## Start services

include makefiles/local.mk
include makefiles/format.mk
include makefiles/test.mk
include makefiles/deploy.mk
include makefiles/database.mk
include makefiles/help.mk
