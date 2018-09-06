from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template("index2.html")

if __name__ =='__main__':
    app.run(host='70.12.110.185',port=8000,debug=True)