#!/bin/bash

install_dir="${HOME}/.ptpython"
case "${OSTYPE}" in
    freebsd*|darwin*)
        install_dir="${HOME}/Library/Application Support/ptpython"
    ;;
esac

if [ ! -e "${install_dir}" ]; then
    mkdir -p "${install_dir}"
fi

ln -sf ~/dotfiles/.ptpython/config.py "${install_dir}/config.py"
