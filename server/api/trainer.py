from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select
import numpy as np
from sklearn.neighbors import NearestNeighbors
import joblib
import math
from math import radians, cos, sin, asin, sqrt

from models.models import User, Seller, Address
from models.api_base_model import Login, Signup

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

    # res = []
    # for row in result:
    #     res.append(
    #         {
    #             "seller_id": row[0],
    #             "latitude": row[1],
    #             "longitude": row[2],
    #         }
    #     )

    return result


sellers = np.array(get_sellers_location())


# Function to train and save the KNN model
# def train_and_save_model(model_path):
#     X = sellers[:, :2]  # Extract latitude and longitude coordinates
#     seller_ids = sellers[:, 2]  # Extract seller IDs

#     nbrs = NearestNeighbors(algorithm="ball_tree").fit(X)
#     joblib.dump(nbrs, model_path)
#     print(f"Model saved to {model_path}")


# # Function to load the trained KNN model
# def load_model(model_path):
#     return joblib.load(model_path)


# # Function to find k nearest neighbors
# def find_nearest_neighbors(model, user_location, k):
#     distances, indices = model.kneighbors([user_location])
#     X = sellers[:, :2]  # Extract latitude and longitude coordinates
#     seller_ids = sellers[:, 2]  # Extract seller IDs

#     print(indices.squeeze())

#     nearest_seller_ids = seller_ids[indices.squeeze()][:k]
#     return nearest_seller_ids


# # Example usage
# model_path = "recommender.pkl"

# # # Train and save the model
# train_and_save_model(model_path)

# # Load the trained model
# knn_model = load_model(model_path)

# # Find nearest neighbors
# user_location = (51.5074, -0.1277)  # User's latitude and longitude
# k = 3  # Number of nearest neighbors to consider
# nearest_sellers = find_nearest_neighbors(knn_model, user_location, k)
# print(f"Recommended sellers for the user's location: {nearest_sellers}")


# Function to calculate Euclidean distance between two points
# def haversine_distance(point1, point2):
#     lat1, lon1 = map(radians, point1)
#     lat2, lon2 = map(radians, point2)

#     dlon = lon2 - lon1
#     dlat = lat2 - lat1

#     a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
#     c = 2 * asin(sqrt(a))
#     r = 6371  # Radius of the Earth in kilometers

#     return c * r


# # Function to find k nearest neighbors
# def find_nearest_neighbors(user_location, k):
#     distances = []
#     for seller in sellers:
#         lat, lon, seller_id = seller
#         distance = haversine_distance(user_location, (lat, lon))
#         distances.append((distance, seller_id))

#     print(distances)
#     distances.sort(key=lambda x: x[0])  # Sort by distance
#     nearest_neighbors = [seller_id for distance, seller_id in distances[:k]]
#     return nearest_neighbors


# # Example usage
# user_location = (16.772509, 120.346632)  # User's latitude and longitude
# k = 3  # Number of nearest neighbors to consider
# nearest_sellers = find_nearest_neighbors(user_location, k)
# print(f"Recommended sellers for the user's location: {nearest_sellers}")


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
    seller_ids = sellers[:, 2]  # Extract seller IDs

    nbrs = NearestNeighbors(metric=haversine_distance, algorithm="ball_tree").fit(X)
    joblib.dump(nbrs, model_file_path)


# Function to find sellers within a specified distance
def find_sellers_within_distance(user_location: tuple, distance_threshold):
    X = sellers[:, :2]  # Extract latitude and longitude coordinates
    seller_ids = sellers[:, 2]  # Extract seller IDs

    nbrs = NearestNeighbors(metric=haversine_distance, algorithm="ball_tree").fit(X)
    distances, indices = nbrs.radius_neighbors(
        [user_location], radius=distance_threshold
    )

    print(f"indices {indices}")

    nearest_sellers = [
        (seller_ids[idx], dist)
        for idx, dist in zip(indices.tolist()[0], distances.tolist()[0])
    ]
    nearest_sellers.sort(key=lambda x: x[1])

    sorted_seller_ids = [seller_id for seller_id, _ in nearest_sellers]

    return sorted_seller_ids


# Example usage
user_location = (16.772509, 120.346632)  # User's latitude and longitude
distance_threshold = 2  # Distance threshold in kilometers
nearby_sellers = find_sellers_within_distance(user_location, distance_threshold)
print(f"Recommended sellers within {distance_threshold} km: {nearby_sellers}")
