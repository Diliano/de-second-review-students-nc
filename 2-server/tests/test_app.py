from api.app import app
from fastapi.testclient import TestClient
import pytest


@pytest.fixture()
def client():
    return TestClient(app)


class TestGetHealthcheck:
    def test_200_handles_healthcheck(self, client):
        response = client.get("/healthcheck")
        assert response.status_code == 200
        assert response.json() == {"message": "Server is running!"}


class TestGetAllDoughnutsInfo:
    """
    With the basic endpoint and no query params, api should get info about all doughnuts
    """

    def test_200_gets_all_doughnuts_info(self, client):
        response = client.get("/doughnuts/info")
        doughnuts = response.json()["doughnuts"]
        assert response.status_code == 200
        assert len(doughnuts) == 10
        for doughnut in doughnuts:
            assert isinstance(doughnut["doughnut_type"], str)
            assert isinstance(doughnut["price"], float)
            assert isinstance(doughnut["calories"], int)
            assert isinstance(doughnut["contains_nuts"], bool)

    def test_200_gets_doughnuts_info_with_specified_max_calories_or_under(self, client):
        response = client.get("/doughnuts/info?max_calories=700")
        doughnuts = response.json()["doughnuts"]
        assert response.status_code == 200
        assert len(doughnuts) == 4
        for doughnut in doughnuts:
            assert isinstance(doughnut["doughnut_type"], str)
            assert isinstance(doughnut["price"], float)
            assert isinstance(doughnut["calories"], int)
            assert isinstance(doughnut["contains_nuts"], bool)
        assert all(doughnut["calories"] <= 700 for doughnut in doughnuts)

        response = client.get("/doughnuts/info?max_calories=600")
        doughnuts = response.json()["doughnuts"]
        assert response.status_code == 200
        assert len(doughnuts) == 2
        assert all(doughnut["calories"] <= 600 for doughnut in doughnuts)

    def test_200_gets_doughnuts_info_with_specified_nuts_or_without(self, client):
        response = client.get("/doughnuts/info?allow_nuts=True")
        doughnuts = response.json()["doughnuts"]
        assert response.status_code == 200
        assert len(doughnuts) == 5
        for doughnut in doughnuts:
            assert isinstance(doughnut["doughnut_type"], str)
            assert isinstance(doughnut["price"], float)
            assert isinstance(doughnut["calories"], int)
            assert isinstance(doughnut["contains_nuts"], bool)
        assert all(doughnut["contains_nuts"] is True for doughnut in doughnuts)

        response = client.get("/doughnuts/info?allow_nuts=False")
        doughnuts = response.json()["doughnuts"]
        assert response.status_code == 200
        assert len(doughnuts) == 5
        assert all(doughnut["contains_nuts"] is False for doughnut in doughnuts)

    def test_200_gets_doughnuts_info_with_both_specified_queries(self, client):
        response = client.get("/doughnuts/info?max_calories=700&allow_nuts=false")
        doughnuts = response.json()["doughnuts"]
        assert response.status_code == 200
        assert len(doughnuts) == 4
        assert all(doughnut["contains_nuts"] is False for doughnut in doughnuts)

        """
        The below combination of query params results in no doughnuts that meet the criteria
        """
        response = client.get("/doughnuts/info?max_calories=700&allow_nuts=true")
        assert response.status_code == 200
        assert response.json() == {"doughnuts": []}


class TestExceptions:
    """
    - Exception handling for GET "/healthcheck"
    - Handled by FastAPI
    """

    def test_404_if_healthcheck_path_is_incorrect(self, client):
        response = client.get("/health")
        assert response.status_code == 404
        assert response.json() == {"detail": "Not Found"}

    def test_405_if_healthcheck_method_does_not_exist(self, client):
        response = client.patch("/healthcheck")
        assert response.status_code == 405
        assert response.json() == {"detail": "Method Not Allowed"}

    """
    - Exception handling for GET "/doughnuts/info" (with or without query params)
    - Handled by FastAPI
    """

    def test_404_if_doughnuts_info_path_is_incorrect(self, client):
        response = client.get("/doughnut/info")
        assert response.status_code == 404
        assert response.json() == {"detail": "Not Found"}

    def test_405_if_doughnuts_info_method_does_not_exist(self, client):
        response = client.patch("/doughnuts/info")
        assert response.status_code == 405
        assert response.json() == {"detail": "Method Not Allowed"}

    def test_422_if_query_param_empty(self, client):
        response = client.get("/doughnuts/info?max_calories=")
        assert response.status_code == 422

        response = client.get("/doughnuts/info?allow_nuts=")
        assert response.status_code == 422

    def test_422_if_query_param_invalid(self, client):
        response = client.get("/doughnuts/info?max_calories=sevenhundreed")
        assert response.status_code == 422

        response = client.get("/doughnuts/info?allow_nuts=sureallowthem")
        assert response.status_code == 422
