from flask import Flask
import requests

app = Flask(__name__)

@app.route("/")
def weather():

    city = "Washington"

    weather = requests.get(
        f"https://wttr.in/{city}?format=3"
    ).text

    return f"""
    <h1>Weather Report App</h1>
    <h2>{weather}</h2>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)