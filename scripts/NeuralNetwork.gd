extends Node


class_name NeuralNetwork

const NUM_NEURONS = 52 # 26 from input to hidden and 26 from hidden to output

var learning_rate: float = 0.05
var weights = []
var biases = []

func _init():
	# initialize random weights
	for i in range(NUM_NEURONS):
		weights.append(randf())
	
	# initialize random biases
	for j in range((NUM_NEURONS / 2) + 1): # 26 for hidden layer and 1 for output
		biases.append(randf())
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _train(inputs, y_true):
	# feedforward, we will use these values later in partial derivatives
	
	var h1 = []
	for i in range(NUM_NEURONS / 2):
		var sum_h1 = weights[i] * inputs[0] + biases[i]
		h1.append(_sigmoid(sum_h1))
	
	# var sum_h2 = weights[2] * inputs[0] + weights[3] * inputs[1] + biases[1]
	# var h2 = _sigmoid(sum_h2)
	
	var sum_o1 = 0.0
	for i in range(NUM_NEURONS / 2):
		sum_o1 += weights[i + (NUM_NEURONS / 2)] * h1[i]
	sum_o1 += biases[NUM_NEURONS / 2]
	var o1 = _sigmoid(sum_o1)
	var y_pred = o1
	
	# calculate partial derivatives
	var d_L_d_y_pred = -2 * (y_true - y_pred)
	
	for i in range(NUM_NEURONS / 2, NUM_NEURONS):
		var d_ypred_d_cur_w = h1[i - (NUM_NEURONS / 2)] * _deriv_sigmoid(sum_o1)
		var d_ypred_d_cur_h = weights[i] * _deriv_sigmoid(sum_o1)
		var _d_ypred_b26 = _deriv_sigmoid(sum_o1)
		
		var d_h1_d_cur_w = inputs[0] * _deriv_sigmoid(h1[i - (NUM_NEURONS / 2)])
		var d_h1_d_cur_b = _deriv_sigmoid(h1[i - (NUM_NEURONS / 2)])
		
		weights[i] -= learning_rate * d_L_d_y_pred * d_ypred_d_cur_w
		biases[NUM_NEURONS / 2] -= learning_rate * d_L_d_y_pred * _d_ypred_b26
		
		weights[i - (NUM_NEURONS / 2)] -= learning_rate * d_L_d_y_pred * d_ypred_d_cur_h * d_h1_d_cur_w
		biases[i - (NUM_NEURONS / 2)] -= learning_rate * d_L_d_y_pred * d_ypred_d_cur_h * d_h1_d_cur_b
	
	# neuron o1
	# var d_ypred_d_w5 = h1 * _deriv_sigmoid(sum_o1)
	# var d_ypred_d_w6 = h2 * _deriv_sigmoid(sum_o1)
	# var d_ypred_d_b3 = _deriv_sigmoid(sum_o1)
	
	# var d_ypred_d_h1 = weights[1] * _deriv_sigmoid(sum_o1)
	# var d_ypred_d_h2 = weights[5] * _deriv_sigmoid(sum_o1)
	
	# neuron h1
	# var d_h1_d_w1 = inputs[0] * _deriv_sigmoid(sum_h1)
	# var d_h1_d_w2 = inputs[1] * _deriv_sigmoid(sum_h1)
	# var d_h1_d_b1 = _deriv_sigmoid(sum_h1)
	
	# neuron h2
	# var d_h2_d_w3 = inputs[0] * _deriv_sigmoid(sum_h2)
	# var d_h2_d_w4 = inputs[1] * _deriv_sigmoid(sum_h2)
	# var d_h2_d_b2 = _deriv_sigmoid(sum_h2)
	
	# update weights and biases
	# neuron h1
	# weights[0] -= learning_rate * d_L_d_y_pred * d_ypred_d_h1 * d_h1_d_w1
	# weights[1] -= learning_rate * d_L_d_y_pred * d_ypred_d_h1 * d_h1_d_w2
	# biases[0] -= learning_rate * d_L_d_y_pred * d_ypred_d_h1 * d_h1_d_b1
	
	# neuron h2
	# weights[2] -= learning_rate * d_L_d_y_pred * d_ypred_d_h2 * d_h2_d_w3
	# weights[3] -= learning_rate * d_L_d_y_pred * d_ypred_d_h2 * d_h2_d_w4
	# biases[1] -= learning_rate * d_L_d_y_pred * d_ypred_d_h2 * d_h2_d_b2
	
	# neuron o1
	# weights[1] -= learning_rate * d_L_d_y_pred * d_ypred_d_w5
	# weights[5] -= learning_rate * d_L_d_y_pred * d_ypred_d_w6
	# biases[1] -= learning_rate * d_L_d_y_pred * d_ypred_d_b3
	
	var loss = _mse_loss([y_true], [y_pred])
	print('Loss = ', loss, 'NN OUT = ', y_pred)

	return y_pred


func _feedforward(inputs):
	# inputs is a array with 2 inputs, the x and y position of the ball
	var h1 = _sigmoid(weights[0] * inputs[0] + weights[1] * inputs[1] + biases[0])
	var h2 = _sigmoid(weights[2] * inputs[0] + weights[3] * inputs[1] + biases[1])
	var o1 = _sigmoid(weights[4] * h1 + weights[5] * h2 + biases[2])
	
	return o1


func _sigmoid(x):
	# sigmoid activation function: f(x) = 1 / (1 + e^(-x))
	return 1 / (1 + exp(-x))
	
	
func _deriv_sigmoid(x):
	# derivative of sigmoid: f'(x) = f(x) * (1 - f(x))
	var fx = _sigmoid(x)
	return fx * (1 - fx)


func _mse_loss(y_true, y_pred):
	# mse formula in numpy: ((y_true - y_pred) ** 2).mean()
	# in gdscript we have to do it in parts
	var dim = []
	for i in range(len(y_true)):
		dim.append(y_true[i] - y_pred[i])
	
	var powered_dim = []
		
	for i in range(len(y_true)):
		powered_dim.append(pow(dim[i], 2))
		
	var sum = 0
	for i in range(len(y_true)):
		sum += powered_dim[i]
		
	var res = sum / len(y_true)
	
	return res
