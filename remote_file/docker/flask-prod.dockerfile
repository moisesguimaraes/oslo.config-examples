# Copyright 2018 Red Hat, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

# python:alpine is 3.{latest}
FROM python:alpine

LABEL maintainer="Moisés Guimarães de Medeiros <moguimar@redhat.com>"

COPY . /flask/

RUN pip install -r /flask/requirements.txt

EXPOSE 5000

ENTRYPOINT ["python", "/flask/app.py"]