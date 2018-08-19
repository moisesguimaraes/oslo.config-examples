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

import os

from oslo_config import cfg

_CONFIG_FILES = [
    os.path.join(os.path.dirname(__file__), "remote_file_manager.conf"),
]

_CONFIG_OPTS = {
    "site": [
        cfg.StrOpt("title",
                   default="Oslo Config • Remote File Manager",
                   help='website title.'),
    ],
    "db": [
        cfg.URIOpt('mongo_uri',
                   default='mongodb://mongodb:27017/remote_file',
                   help='Connection string for MongoDB.'),
    ],
}


def set_config(app):
    conf = cfg.ConfigOpts()

    for group, opts in _CONFIG_OPTS.items():
        conf.register_opts(opts, group)

    conf(default_config_files=_CONFIG_FILES)

    app.config["site"] = conf.site
    app.config["MONGO_URI"] = conf.db.mongo_uri
