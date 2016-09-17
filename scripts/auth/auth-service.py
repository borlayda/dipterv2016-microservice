#!/usr/bin/env python
from flask import Flask, abort
import MySQLdb as mdb
app = Flask(__name__)

@app.route("/auth/<username>/<password>")
def authenticate(username, password):
    try:
        con = mdb.connect('database', 'store', 'store', 'authenticate');
        cur = con.cursor()
        cur.execute("SELECT user_id FROM user_auth \
                     WHERE username='%s' AND password='%s'" %
                     (username, password))
        user_id = cur.fetchone()
        print user_id
        if not user_id:
            abort(401)
    except mdb.Error, e:
        print "Error %d: %s" % (e.args[0],e.args[1])
        abort(401)
    finally:
        if con:
            con.close()
    return "Successfully authenticated!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)
