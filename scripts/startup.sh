#!/usr/bin/env bash

source_keymaps
firefox --start-debugger-server %u &
co &
telegram-desktop &
yakuake &
