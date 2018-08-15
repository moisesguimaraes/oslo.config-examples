from flask import Flask, request
from flask_pymongo import PyMongo

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://mongodb:27017/remote_file"
mongo = PyMongo(app)

user_id_template = "CN=Node {i:03d}{j:03d},OU=Engineering,O=OpenStack Common Libraries,L=Brno,ST=Jihomoravsky kraj,C=CZ"
secrets_template = "[DEFAULT]\n\nsuper_secret=super{i:03d}{j:03d}secret\n\n[db]\n\nusername=username_{i:03d}{j:03d}\npassword=dbpasswd_{i:03d}{j:03d}\n"

secrets_db = {
    user_id_template.format(i=i, j=j) : secrets_template.format(i=i, j=j)
    for i in range(1, 6)
    for j in range(1, 6)
}


@app.route('/secrets')
def secrets():
    return secrets_db[request.headers["Client-Subject-Domain-Name"]]


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
