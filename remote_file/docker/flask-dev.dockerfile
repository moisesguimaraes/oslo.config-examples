# python:alpine is 3.{latest}
FROM python:alpine

LABEL maintainer="Moisés Guimarães de Medeiros <moguimar@redhat.com>"

COPY requirements.txt /

RUN pip install -r /requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "/flask/app.py"]