# python:alpine is 3.{latest}
FROM python:alpine

LABEL maintainer="Moisés Guimarães de Medeiros <moguimar@redhat.com>"

COPY flask /flask/

RUN pip install -r /flask/requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "/flask/app.py"]