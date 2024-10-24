from fastapi import FastAPI
import json


app = FastAPI()


@app.get("/healthcheck")
def handle_healthcheck():
    return {"message": "Server is running!"}


@app.get("/doughnuts/info")
def get_doughnuts_info(max_calories: int = None, allow_nuts: bool = None):
    with open("data/doughnuts.json") as f:
        data = json.load(f)["doughnut_data"]

    if max_calories:
        data = [doughnut for doughnut in data if doughnut["calories"] <= max_calories]

    if allow_nuts is not None:
        data = [
            doughnut for doughnut in data if doughnut["contains_nuts"] is allow_nuts
        ]

    return {"doughnuts": data}
