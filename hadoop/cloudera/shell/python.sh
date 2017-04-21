#!/usr/bin/env bash
PYENV_INSTALL=/opt/pyenv

rm -rf $PYENV_INSTALL
git clone https://github.com/yyuu/pyenv.git $PYENV_INSTALL
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git $PYENV_INSTALL/plugins/pyenv-virtualenvwrapper
echo "export PYENV_ROOT=\"$PYENV_INSTALL\"" >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo "export PYENV_ROOT=\"$PYENV_INSTALL\"" >> /home/vagrant/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(pyenv init -)"' >> /home/vagrant/.bashrc

source ~/.bashrc
echo $PATH
pyenv install 2.7.9
pyenv global 2.7.9
pyenv rehash
pyenv virtualenvwrapper
