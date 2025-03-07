import random
import math
import requests
import csv
from datetime import datetime

def fetch_elo_ratings():
    today = datetime.today().date()
    iso_date = today.isoformat()  # This will give you the date in ISO format (YYYY-MM-DD)
    url = f"http://api.clubelo.com/{iso_date}"
    response = requests.get(url)
    
    if response.status_code == 200:
        # Since the API returns a CSV file, we need to parse it
        csv_reader = csv.reader(response.text.splitlines())
        teams = {}
        for row in csv_reader:
            if len(row) > 5 and row[2] == 'CRO':  # Check if country is Croatia
                teams[row[1]] = float(row[4])  # Assuming Club name is in the 2nd column and Elo in the 5th
        return teams
    else:
        print("Failed to fetch Elo ratings")
        return None

def simulate_match(home_team_elo, away_team_elo, home_advantage=50, k=20):
    adjusted_home_elo = home_team_elo + home_advantage
    elo_diff = adjusted_home_elo - away_team_elo
    home_win_probability = 1 / (1 + math.pow(10, -elo_diff / 400))
    
    result = random.random()
    if result < home_win_probability:
        outcome = 1  # Home team wins
        home_score, away_score = 3, 0
    elif result < home_win_probability + 0.25:  # Assuming 25% chance of draw
        outcome = 0.5  # Draw
        home_score, away_score = 1, 1
    else:
        outcome = 0  # Away team wins
        home_score, away_score = 0, 3
    
    # Update Elo ratings
    elo_change = k * (outcome - home_win_probability)
    new_home_elo = home_team_elo + elo_change
    new_away_elo = away_team_elo - elo_change
    
    return home_score, away_score, new_home_elo, new_away_elo

def simulate_league(teams, fixtures, initial_points, k=20):
    points = initial_points.copy()
    current_elos = teams.copy()
    
    for home_team, away_team in fixtures:
        home_points, away_points, new_home_elo, new_away_elo = simulate_match(
            current_elos[home_team], current_elos[away_team], k=k
        )
        points[home_team] += home_points
        points[away_team] += away_points
        current_elos[home_team] = new_home_elo
        current_elos[away_team] = new_away_elo
    
    return points, current_elos

def run_multiple_simulations(teams, fixtures, initial_points, num_simulations, k=20):
    num_teams = len(teams)
    position_counts = {team: [0] * num_teams for team in teams}
    total_points = {team: 0 for team in teams}
    
    for _ in range(num_simulations):
        final_points, _ = simulate_league(teams, fixtures, initial_points, k=k)
        sorted_results = sorted(final_points.items(), key=lambda x: x[1], reverse=True)
        
        for position, (team, points) in enumerate(sorted_results):
            position_counts[team][position] += 1
            total_points[team] += points
    
    position_probabilities = {team: [count / num_simulations * 100 for count in counts] 
                              for team, counts in position_counts.items()}
    average_points = {team: round(total / num_simulations) for team, total in total_points.items()}
    qualification_probabilities_top8 = {team: sum(probs[:1]) for team, probs in position_probabilities.items()}
    qualification_probabilities_top24 = {team: sum(probs[:4]) for team, probs in position_probabilities.items()}
    
    return position_probabilities, average_points, qualification_probabilities_top8, qualification_probabilities_top24

def print_results(position_probabilities, average_points, qualification_probabilities_top8, qualification_probabilities_top24):
    print("Šanse za osvajanje HNL-a i top 4")
    print("=" * 100)
    
    sorted_teams = sorted(average_points.items(), key=lambda x: x[1], reverse=True)
    
    print("Team".ljust(20) + "Proj. Points".ljust(15) + "Prvak (%)".ljust(20) + "Top 4 (%)")
    print("-" * 100)
    for team, points in sorted_teams:
        qual_prob_top8 = qualification_probabilities_top8[team]
        qual_prob_top24 = qualification_probabilities_top24[team]
        print(f"{team.ljust(20)}{points}".ljust(35) + f"{qual_prob_top8:.2f}".ljust(20) + f"{qual_prob_top24:.2f}")
    
    print("\nVjerojatnosti pozicija za svaki klub (%)")
    print("=" * 100)
    
    # Header
    print("Team".ljust(20) + "".join(f"{i:>8}" for i in range(1, 11)))
    print("-" * 100)
    
    # Data
    for team in sorted_teams:
        probs = position_probabilities[team[0]]
        print(f"{team[0].ljust(20)}" + "".join(f"{prob:>8.2f}" for prob in probs[:10]))
    
    print("=" * 100)

# Fetch Elo ratings from API
elo_ratings = fetch_elo_ratings()
if elo_ratings is not None:
    teams = elo_ratings
    initial_points = {
        "Dinamo Zagreb": 39,
        "Rijeka": 46,
        "Hajduk": 45,
        "Osijek": 30,
        "Lok Zagreb": 28,
        "Varazdin": 33,
        "Istra 1961": 28,
        "Slaven Belupo": 32,
        "HNK Gorica": 24,
        "Sibenik": 18
    }
else:
    teams = {
        "Dinamo Zagreb": 1527,
        "Rijeka": 1473,
        "Hajduk": 1468,
        "Osijek": 1385,
        "Lok Zagreb": 1359,
        "Varazdin": 1321,
        "Istra 1961": 1312,
        "Slaven Belupo": 1303,
        "HNK Gorica": 1268,
        "Sibenik": 1187
    }
    initial_points = {
        "Dinamo Zagreb": 39,
        "Rijeka": 46,
        "Hajduk": 45,
        "Osijek": 30,
        "Lok Zagreb": 28,
        "Varazdin": 33,
        "Istra 1961": 28,
        "Slaven Belupo": 32,
        "HNK Gorica": 24,
        "Sibenik": 18
    }

fixtures = [
    ("Rijeka", "Sibenik"), ("Varazdin", "Istra 1961"), ("Lok Zagreb", "Osijek"),
    ("Hajduk", "HNK Gorica"), ("Slaven Belupo", "Dinamo Zagreb"), ("HNK Gorica", "Slaven Belupo"),
    ("Sibenik", "Istra 1961"), ("Dinamo Zagreb", "Lok Zagreb"), ("Osijek", "Varazdin"),
    ("Rijeka", "Hajduk"), ("Hajduk", "Sibenik"), ("Istra 1961", "Osijek"),
    ("Lok Zagreb", "HNK Gorica"), ("Slaven Belupo", "Rijeka"), ("Varazdin", "Dinamo Zagreb"),
    ("Istra 1961", "Dinamo Zagreb"), ("Lok Zagreb", "Rijeka"), ("Sibenik", "Osijek"),
    ("Slaven Belupo", "Hajduk"), ("Varazdin", "HNK Gorica"), ("Dinamo Zagreb", "Osijek"),
    ("HNK Gorica", "Istra 1961"), ("Hajduk", "Lok Zagreb"), ("Rijeka", "Varazdin"),
    ("Slaven Belupo", "Sibenik"), ("Istra 1961", "Rijeka"), ("Lok Zagreb", "Slaven Belupo"),
    ("Osijek", "HNK Gorica"), ("Sibenik", "Dinamo Zagreb"), ("Varazdin", "Hajduk"),
    ("HNK Gorica", "Dinamo Zagreb"), ("Hajduk", "Istra 1961"), ("Lok Zagreb", "Sibenik"),
    ("Rijeka", "Osijek"), ("Slaven Belupo", "Varazdin"), ("Dinamo Zagreb", "Rijeka"),
    ("Istra 1961", "Slaven Belupo"), ("Osijek", "Hajduk"), ("Sibenik", "HNK Gorica"),
    ("Varazdin", "Lok Zagreb"), ("Hajduk", "Dinamo Zagreb"), ("Lok Zagreb", "Istra 1961"),
    ("Rijeka", "HNK Gorica"), ("Slaven Belupo", "Osijek"), ("Varazdin", "Sibenik"),
    ("Dinamo Zagreb", "Slaven Belupo"), ("HNK Gorica", "Hajduk"), ("Istra 1961", "Varazdin"),
    ("Osijek", "Lok Zagreb"), ("Sibenik", "Rijeka"), ("Hajduk", "Rijeka"),
    ("Istra 1961", "Sibenik"), ("Lok Zagreb", "Dinamo Zagreb"), ("Slaven Belupo", "HNK Gorica"),
    ("Varazdin", "Osijek"), ("Dinamo Zagreb", "Varazdin"), ("HNK Gorica", "Lok Zagreb"),
    ("Osijek", "Istra 1961"), ("Rijeka", "Slaven Belupo"), ("Sibenik", "Hajduk")
]

num_simulations = 10000
k = 20
position_probabilities, average_points, qualification_probabilities_top8, qualification_probabilities_top24 = run_multiple_simulations(teams, fixtures, initial_points, num_simulations, k=k)

print_results(position_probabilities, average_points, qualification_probabilities_top8, qualification_probabilities_top24)