from flask import Flask, request, render_template, redirect, url_for, abort
from flask_pymongo import PyMongo

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://mongodb:27017/remote_file"
mongo = PyMongo(app)


@app.route('/')
def index():
    configs = mongo.db.configs.find({})

    return render_template('config_list.html', configs=configs)


@app.route('/config/new', methods=["GET", "POST"])
def config_new():
    if request.method == "GET":
        return render_template('config_new.html')

    if request.method == "POST":
        config = {
            "id" : request.form["id"],
            "dn" : request.form["dn"]
        }

        mongo.db.configs.insert_one(config)

        return redirect(url_for('index'))


@app.route('/config/edit/<id>', methods=["GET", "POST"])
def config_edit(id):
    config = mongo.db.configs.find_one({"id":id})

    if request.method == "GET":
        return render_template('config_edit.html', config=config)

    if request.method == "POST":
        config["id"] = request.form["id"]
        config["dn"] = request.form["dn"]

        mongo.db.configs.replace_one({"id":id}, config)

        return redirect(url_for('index'))


@app.route('/config/delete/<id>', methods=["POST"])
def config_delete(id):
    mongo.db.configs.delete_one({"id":id})

    return redirect(url_for('index'))


@app.route('/remote_file')
def remote_file():
    if request.headers["Client-Verify"] != "SUCCESS":
        abort(404)

    sdn = request.headers["Client-Subject-Domain-Name"]
    cfg = mongo.db.configs.find_one({"dn":sdn})
    return str(cfg)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
