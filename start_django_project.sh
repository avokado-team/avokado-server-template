#!/bin/bash

# 필요한 시스템 패키지 설치
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux의 경우
    sudo apt-get update
    sudo apt-get install -y gcc make libpq-dev python3-dev
    sudo apt-get install -y libsqlite3-dev
    sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev curl libbz2-dev
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS의 경우
    brew install postgresql
elif [[ "$OSTYPE" == "msys" ]]; then
    # Windows의 경우
    choco install python
    choco install postgresql
fi

# pyenv 또는 virtualenv 설치 및 설정
if [[ "$OSTYPE" == "msys" ]]; then
    # Windows의 경우 virtualenv 사용
    if ! command -v virtualenv &> /dev/null
    then
        echo "virtualenv 설치 중..."
        pip install virtualenv
    fi
else
    # macOS와 Linux의 경우 pyenv와 pyenv-virtualenv 사용
    if ! command -v pyenv &> /dev/null
    then
        echo "pyenv 설치 중..."
        curl https://pyenv.run | bash

        # 쉘 설정 파일 업데이트
        echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

        # 쉘 설정 파일 업데이트 적용
        source ~/.zshrc
    fi

    if ! pyenv commands | grep -q 'virtualenv'
    then
        echo "pyenv-virtualenv 설치 중..."
        git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
        source ~/.zshrc
    fi

    # 쉘 설정 파일 로드
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# 사용자로부터 Python 버전과 프로젝트 이름 입력 받기
read -p "설치할 Python 버전을 입력하세요 (예: 3.8.10): " python_version
read -p "프로젝트 이름을 입력하세요: " project_name

# 프로젝트 이름을 snake case로 변환
project_name=$(echo "$project_name" | tr '-' '_')

# Python 버전 설치 및 가상 환경 생성
if [[ "$OSTYPE" == "msys" ]]; then
    # Windows의 경우 virtualenv 사용
    if ! python -c "import sys; assert sys.version.startswith('$python_version')" &> /dev/null
    then
        echo "Python $python_version 설치 중..."
        pyenv install $python_version
    fi
    virtualenv -p python$python_version $project_name
    source $project_name/Scripts/activate
else
    # macOS와 Linux의 경우 pyenv와 pyenv-virtualenv 사용
    if pyenv versions --bare | grep -q "^$python_version\$"; then
        echo "Python $python_version already installed. Skipping installation."
    else
        pyenv install $python_version
    fi

    if ! pyenv virtualenvs --bare | grep -q "^$project_name\$"; then
        pyenv virtualenv $python_version $project_name
    else
        echo "Virtualenv $project_name already exists. Skipping creation."
    fi
    pyenv local $project_name
    pyenv activate $project_name
fi

# pipenv 설치
pip install pipenv

# 필요한 패키지 설치
pipenv install django djangorestframework gunicorn uvicorn psycopg2 factory_boy

# black과 isort 설치
pipenv install --dev black isort

# Django 프로젝트 생성
pipenv run django-admin startproject $project_name .

# Django 마이그레이션 실행
pipenv run python manage.py migrate

# black 설정 파일 생성
cat <<EOL > pyproject.toml
[tool.black]
line-length = 88
target-version = ['py38']
EOL

# isort 설정 파일 생성
cat <<EOL > .isort.cfg
[settings]
profile = black
EOL

echo "설치 및 설정이 완료되었습니다."

