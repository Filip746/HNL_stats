from flask import Flask, render_template, jsonify
import probability_calculator as pc
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    num_simulations = 10000
    k = 20
    position_probabilities, average_points, qualification_probabilities_top8, qualification_probabilities_top24 = pc.run_multiple_simulations(pc.teams, pc.fixtures, pc.initial_points, num_simulations, k=k)
    
    return render_template('index.html', 
                           position_probabilities=position_probabilities, 
                           average_points=average_points, 
                           qualification_probabilities_top8=qualification_probabilities_top8, 
                           qualification_probabilities_top24=qualification_probabilities_top24)

@app.route('/probabilities')
def probabilities():
    num_simulations = 10000
    k = 20
    position_probabilities, average_points, qualification_probabilities_top8, qualification_probabilities_top24 = pc.run_multiple_simulations(pc.teams, pc.fixtures, pc.initial_points, num_simulations, k=k)
    
    return jsonify({
        "position_probabilities": position_probabilities,
        "average_points": average_points,
        "qualification_probabilities_top8": qualification_probabilities_top8,
        "qualification_probabilities_top24": qualification_probabilities_top24
    })

if __name__ == '__main__':
    app.run(debug=True)