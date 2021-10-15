#!/bin/bash

read -p "enter your email:   " EMAIL

ssh-keygen -t ed25519 -C "$EMAIL"