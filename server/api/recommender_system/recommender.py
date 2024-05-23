from sklearn.neighbors import NearestNeighbors
import numpy as np
import joblib


# to calculate the Haversine distance between two points (latitude, longitude)
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


# to find sellers within a specified distance
def find_sellers_within_distance(
    user_location: tuple,
    distance_threshold: float = 10,
):
    sellers = np.load("recommender_system/sellers.npy")
    model = joblib.load("recommender_system/recommender_model.pkl")

    seller_ids = sellers[:, 2]  # Extract seller IDs

    distances, indices = model.radius_neighbors(
        [user_location], radius=distance_threshold
    )

    # Check if indices array is empty or contains negative values
    if indices.size < 0:
        # Handle the case when no sellers are within the specified distance
        return []

    nearest_sellers = [
        (seller_ids[idx], dist)
        for idx, dist in zip(indices.tolist()[0], distances.tolist()[0])
    ]
    nearest_sellers.sort(key=lambda x: x[1])

    sorted_seller_ids = [seller_id for seller_id, _ in nearest_sellers]

    return sorted_seller_ids


# user_location = (16.772509, 120.346632)  # User's latitude and longitude
# distance_threshold = 5  # Distance threshold in kilometers
# nearby_sellers = find_sellers_within_distance(user_location)
# print(f"Recommended sellers within {distance_threshold} km: {nearby_sellers}")
