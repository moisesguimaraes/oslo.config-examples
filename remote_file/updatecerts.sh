#!/bin/bash
#
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

cp ../pki/certs/ca.cert.pem nginx/certs
cp ../pki/certs/ca.cert.pem ca_cert.pem

cp ../pki/certs/server.cert.pem nginx/certs
cp ../pki/private/server.key.pem nginx/certs

cp ../pki/intermediate_cas/001/certs/node001001.chain.pem client_cert.pem
cp ../pki/intermediate_cas/001/private/node001001.key.pem client_key.pem
