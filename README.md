# 🥑 Avokado Server Template
## 📝 설명
이 템플릿은 **pyenv**, **pyenv-virtualenv**, **pipenv** 를 이용해 **Django** 환경을 쉽게 구축하고 빠르게 시작할 수 있습니다.

현재 제공하는 기능은 다음과 같습니다.
1. pyenv 설치 및 pyenv 로 특정 python 설치
2. pyenv-virtualenv 설치 및 가상환경 설정
3. 기본 패키지 설치 (django, psycopg2, gunicorn, uvicorn, factory_boy)
4. 기본 개발 패키지 설치 (black, isort)
5. django 프로젝트 활성화
6. 기본 db migrate
7. black, isort 설정파일 생성
## 🚀 사용법
```shell
$ ./start_django_project.sh
```
## 🚧 추가 예정 기능
1. docker file 생성
2. k8s 용 yaml resource 폴더 생성
3. secret manager 기능 추가 (vault)
4. django 셋업 시 db 선택, 선택한 db에 맞는 기본 패키지 설치 (mysql, psycopg2)
