close all; clc;

% Definir los parámetros del controlador PI
Kp = 8.1; 
Ki = 42.25; 
Kd = 0;

% Definir la planta
numG = 1;
denG = [1 1];
G = tf(numG, denG);

% Definir el controlador PD
numC = [Kd Kp Ki];
denC = [1 0];
C = tf(numC, denC);

% Sistema en lazo cerrado
sys_open = series(C, G);
sys_closed = feedback(sys_open, 1);

% Simulación de la respuesta al escalón
t = 0:0.01:9.99; % tiempo de simulación
[y, t] = step(sys_closed, t);

% Generar el error (entrada de la red neuronal)
setpoint = ones(size(t)); % referencia
error = setpoint - y; % error de seguimiento

% Calcular la integral del error
dt = t(2) - t(1); % suponer que el paso de tiempo es constante
error_int = cumsum(error) * dt; % integral del error

u=out.simout;

% Normalización de datos
inputs = [error'; error_int']; % error en la primera fila, integral en la segunda
targets = u';

% Normalizar entradas y salidas
[input_norm, input_settings] = mapminmax(inputs);
[target_norm, target_settings] = mapminmax(targets);

% Definir la red neuronal
hiddenLayerSize = 3;
net = fitnet(hiddenLayerSize);

% Cambiar las funciones de activación
net.layers{1}.transferFcn = 'tansig';  % Capa oculta
net.layers{2}.transferFcn = 'purelin'; % Capa de salida

% Dividir los datos en conjuntos de entrenamiento, validación y prueba
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Entrenar la red neuronal
[net, tr] = train(net, input_norm, target_norm);

% Verificar el desempeño de la red
outputs_norm = net(input_norm);
outputs = mapminmax('reverse', outputs_norm, target_settings);
errors = gsubtract(targets, outputs);
performance = perform(net, targets, outputs);

% Mostrar las curvas de entrenamiento
figure;
plotperform(tr);

% Generar nuevas entradas para la red neuronal
inputs_nn = [error'; error_int'];
inputs_nn_norm = mapminmax('apply', inputs_nn, input_settings);

% Obtener la señal de control generada por la red neuronal
u_nn_norm = net(inputs_nn_norm);
u_nn = mapminmax('reverse', u_nn_norm, target_settings);

% Simulación de la planta con la señal de control de la red neuronal
[y_nn, t_nn] = lsim(G, u_nn, t);

% Comparar las respuestas del controlador PD y la red neuronal
figure;
plot(t, y, 'b', 'LineWidth', 2); hold on;
plot(t_nn, y_nn, 'r--', 'LineWidth', 2);
xlabel('Tiempo (s)');
ylabel('Respuesta al Escalón');
legend('Controlador PD', 'Red Neuronal');
title('Comparación de Respuestas al Escalón');
grid on;

% Pesos y sesgos de la capa oculta
hiddenLayerWeights = net.IW{1,1};
hiddenLayerBiases = net.b{1};

% Pesos y sesgos de la capa de salida
outputLayerWeights = net.LW{2,1};
outputLayerBiases = net.b{2};

% Mostrar los valores
disp('Pesos de la capa oculta:');
disp(hiddenLayerWeights);
disp('Sesgos de la capa oculta:');
disp(hiddenLayerBiases);

disp('Pesos de la capa de salida:');
disp(outputLayerWeights);
disp('Sesgos de la capa de salida:');
disp(outputLayerBiases);
