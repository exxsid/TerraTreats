from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select
import numpy as np
from sklearn.neighbors import NearestNeighbors
import joblib

from models.models import User, Seller, Address

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


def get_sellers_location():
    with Session(engine) as session:
        query = (
            select(
                Address.latitude,
                Address.longitude,
                Seller.id,
            )
            .select_from(Seller)
            .join(Address, Seller.user_id == Address.user_id)
        )

        result = session.execute(query).fetchall()

    return result


sellers = np.array(get_sellers_location())

# save the ndarray to a file for it to use in the recommender system
np.save("recommender_system/sellers.npy", sellers)


# Function to calculate the Haversine distance between two points (latitude, longitude)
def haversine_distance(point1, point2):
    lat1, lon1 = point1
    lat2, lon2 = point2

    lat1, lon1 = map(np.radians, [lat1, lon1])
    lat2, lon2 = map(np.radians, [lat2, lon2])

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = np.sin(dlat / 2) ** 2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon / 2) ** 2
    c = 2 * np.arcsin(np.sqrt(a))
    r = 6371  # Radius of the Earth in kilometers

    return c * r


def train_model(model_file_path: str):
    X = sellers[:, :2]  # Extract latitude and longitude coordinates

    nbrs = NearestNeighbors(metric=haversine_distance, algorithm="ball_tree").fit(X)
    joblib.dump(nbrs, model_file_path)


def main():
    # train the model
    train_model("recommender_system/recommender_model.pkl")


if __name__ == "__main__":
    main()
