import numpy as np


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
